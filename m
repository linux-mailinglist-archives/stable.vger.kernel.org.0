Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1082AACD85
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732094AbfIHMuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732084AbfIHMuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:50:22 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8874021A49;
        Sun,  8 Sep 2019 12:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947022;
        bh=5P2vYLW9yNgQm5/Lp/2chgu9C1k0IkkpVYigawtSh4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqwzxGtdj/eIX9Wm8YPcQDV7XX4oYG2RSWzdGWr9u9Mr3Oc7EfU0xUAG6j+dqvct0
         n88PDbWFqcVauIN6fwLtbOOEEzzDV+wj8uGAawElXh1niYvSdaWs0LLDTRlobQ5YTT
         E1AO2rdQKmIz5the+wgKhmzxGIUBdKORK2sHS/kY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 31/94] netfilter: nf_flow_table: teardown flow timeout race
Date:   Sun,  8 Sep 2019 13:41:27 +0100
Message-Id: <20190908121151.330655724@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1e5b2471bcc4838df298080ae1ec042c2cbc9ce9 ]

Flows that are in teardown state (due to RST / FIN TCP packet) still
have their offload flag set on. Hence, the conntrack garbage collector
may race to undo the timeout adjustment that the fixup routine performs,
leaving the conntrack entry in place with the internal offload timeout
(one day).

Update teardown flow state to ESTABLISHED and set tracking to liberal,
then once the offload bit is cleared, adjust timeout if it is more than
the default fixup timeout (conntrack might already have set a lower
timeout from the packet path).

Fixes: da5984e51063 ("netfilter: nf_flow_table: add support for sending flows back to the slow path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 34 ++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 4254e42605135..49248fe5847a1 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -112,15 +112,16 @@ static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 #define NF_FLOWTABLE_TCP_PICKUP_TIMEOUT	(120 * HZ)
 #define NF_FLOWTABLE_UDP_PICKUP_TIMEOUT	(30 * HZ)
 
-static void flow_offload_fixup_ct(struct nf_conn *ct)
+static inline __s32 nf_flow_timeout_delta(unsigned int timeout)
+{
+	return (__s32)(timeout - (u32)jiffies);
+}
+
+static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 {
 	const struct nf_conntrack_l4proto *l4proto;
+	int l4num = nf_ct_protonum(ct);
 	unsigned int timeout;
-	int l4num;
-
-	l4num = nf_ct_protonum(ct);
-	if (l4num == IPPROTO_TCP)
-		flow_offload_fixup_tcp(&ct->proto.tcp);
 
 	l4proto = nf_ct_l4proto_find(l4num);
 	if (!l4proto)
@@ -133,7 +134,20 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 	else
 		return;
 
-	ct->timeout = nfct_time_stamp + timeout;
+	if (nf_flow_timeout_delta(ct->timeout) > (__s32)timeout)
+		ct->timeout = nfct_time_stamp + timeout;
+}
+
+static void flow_offload_fixup_ct_state(struct nf_conn *ct)
+{
+	if (nf_ct_protonum(ct) == IPPROTO_TCP)
+		flow_offload_fixup_tcp(&ct->proto.tcp);
+}
+
+static void flow_offload_fixup_ct(struct nf_conn *ct)
+{
+	flow_offload_fixup_ct_state(ct);
+	flow_offload_fixup_ct_timeout(ct);
 }
 
 void flow_offload_free(struct flow_offload *flow)
@@ -211,7 +225,7 @@ EXPORT_SYMBOL_GPL(flow_offload_add);
 
 static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 {
-	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
+	return nf_flow_timeout_delta(flow->timeout) <= 0;
 }
 
 static void flow_offload_del(struct nf_flowtable *flow_table,
@@ -231,6 +245,8 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 
 	if (nf_flow_has_expired(flow))
 		flow_offload_fixup_ct(e->ct);
+	else if (flow->flags & FLOW_OFFLOAD_TEARDOWN)
+		flow_offload_fixup_ct_timeout(e->ct);
 
 	flow_offload_free(flow);
 }
@@ -242,7 +258,7 @@ void flow_offload_teardown(struct flow_offload *flow)
 	flow->flags |= FLOW_OFFLOAD_TEARDOWN;
 
 	e = container_of(flow, struct flow_offload_entry, flow);
-	flow_offload_fixup_ct(e->ct);
+	flow_offload_fixup_ct_state(e->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
-- 
2.20.1




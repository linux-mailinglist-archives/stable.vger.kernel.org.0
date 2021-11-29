Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04ACC461DB5
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhK2S2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:28:16 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47968 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352061AbhK2S0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:26:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E1F39CE13E0;
        Mon, 29 Nov 2021 18:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1D7C53FC7;
        Mon, 29 Nov 2021 18:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210166;
        bh=vsyv97+wxPgk1+sgTcJkMXCjOqicQMlEY113z7aefYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkQhxG7odT6wvRFHQT+oFf33lWF+mR4eiEGt5rPc9UQJiMPk0Nlp03DtP0Tc7Q0gS
         pB5JfQqMoSrZXZfswWGSsPTBFLDyATOnBjMhWeF+PICOKXxz+689vHXjaQd8y9WD25
         iQTqwE+NS+nAgAclRWQNl7bAR0TrnS/mZSlV07vY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuanqi Liu <legend050709@qq.com>,
        yangxingwu <xingwu.yang@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 37/69] netfilter: ipvs: Fix reuse connection if RS weight is 0
Date:   Mon, 29 Nov 2021 19:18:19 +0100
Message-Id: <20211129181704.879968692@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangxingwu <xingwu.yang@gmail.com>

[ Upstream commit c95c07836fa4c1767ed11d8eca0769c652760e32 ]

We are changing expire_nodest_conn to work even for reused connections when
conn_reuse_mode=0, just as what was done with commit dc7b3eb900aa ("ipvs:
Fix reuse connection if real server is dead").

For controlled and persistent connections, the new connection will get the
needed real server depending on the rules in ip_vs_check_template().

Fixes: d752c3645717 ("ipvs: allow rescheduling of new connections when port reuse is detected")
Co-developed-by: Chuanqi Liu <legend050709@qq.com>
Signed-off-by: Chuanqi Liu <legend050709@qq.com>
Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
Acked-by: Simon Horman <horms@verge.net.au>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ipvs-sysctl.txt | 3 +--
 net/netfilter/ipvs/ip_vs_core.c          | 8 ++++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/ipvs-sysctl.txt b/Documentation/networking/ipvs-sysctl.txt
index 056898685d408..fc531c29a2e83 100644
--- a/Documentation/networking/ipvs-sysctl.txt
+++ b/Documentation/networking/ipvs-sysctl.txt
@@ -30,8 +30,7 @@ conn_reuse_mode - INTEGER
 
 	0: disable any special handling on port reuse. The new
 	connection will be delivered to the same real server that was
-	servicing the previous connection. This will effectively
-	disable expire_nodest_conn.
+	servicing the previous connection.
 
 	bit 1: enable rescheduling of new connections when it is safe.
 	That is, whenever expire_nodest_conn and for TCP sockets, when
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index acaeeaf814415..f20b08db9fe91 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1850,7 +1850,6 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 	struct ip_vs_proto_data *pd;
 	struct ip_vs_conn *cp;
 	int ret, pkts;
-	int conn_reuse_mode;
 	struct sock *sk;
 
 	/* Already marked as IPVS request or reply? */
@@ -1926,15 +1925,16 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 	 */
 	cp = pp->conn_in_get(ipvs, af, skb, &iph);
 
-	conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
-	if (conn_reuse_mode && !iph.fragoffs && is_new_conn(skb, &iph) && cp) {
+	if (!iph.fragoffs && is_new_conn(skb, &iph) && cp) {
+		int conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
 		bool old_ct = false, resched = false;
 
 		if (unlikely(sysctl_expire_nodest_conn(ipvs)) && cp->dest &&
 		    unlikely(!atomic_read(&cp->dest->weight))) {
 			resched = true;
 			old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
-		} else if (is_new_conn_expected(cp, conn_reuse_mode)) {
+		} else if (conn_reuse_mode &&
+			   is_new_conn_expected(cp, conn_reuse_mode)) {
 			old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
 			if (!atomic_read(&cp->n_control)) {
 				resched = true;
-- 
2.33.0




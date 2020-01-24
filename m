Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0766148097
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387877AbgAXLMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:12:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389108AbgAXLMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:12:34 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F040D20708;
        Fri, 24 Jan 2020 11:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864353;
        bh=PRre1CFoy2C0hUmy5x4Sjndj1tqnXyWuxtvvMwgByYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etXvjxEDmUzRNM6x1ggK/GQa4kxBp1Cv8nmIx4pVEYc9Fr8UBNiPz8qQ6TVT7SJUs
         15JCphCcqbRHO6V7JTbLZaKJJKDI4TH0I7L2jKOhJ4Xlzj2IchamfOMo1MPxGBCpB9
         DCURR/8lTTIDBd+lKd7qSecaEASlWiYmfYmhVH60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Britstein <elibr@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 243/639] net: sched: act_csum: Fix csum calc for tagged packets
Date:   Fri, 24 Jan 2020 10:26:53 +0100
Message-Id: <20200124093117.237870764@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

[ Upstream commit 2ecba2d1e45b24620a7c3df9531895cf68d5dec6 ]

The csum calculation is different for IPv4/6. For VLAN packets,
tc_skb_protocol returns the VLAN protocol rather than the packet's one
(e.g. IPv4/6), so csum is not calculated. Furthermore, VLAN may not be
stripped so csum is not calculated in this case too. Calculate the
csum for those cases.

Fixes: d8b9605d2697 ("net: sched: fix skb->protocol use in case of accelerated vlan path")
Signed-off-by: Eli Britstein <elibr@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_csum.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 1e269441065a6..9ecbf8edcf390 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -560,8 +560,11 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
 			struct tcf_result *res)
 {
 	struct tcf_csum *p = to_tcf_csum(a);
+	bool orig_vlan_tag_present = false;
+	unsigned int vlan_hdr_count = 0;
 	struct tcf_csum_params *params;
 	u32 update_flags;
+	__be16 protocol;
 	int action;
 
 	params = rcu_dereference_bh(p->params);
@@ -574,7 +577,9 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
 		goto drop;
 
 	update_flags = params->update_flags;
-	switch (tc_skb_protocol(skb)) {
+	protocol = tc_skb_protocol(skb);
+again:
+	switch (protocol) {
 	case cpu_to_be16(ETH_P_IP):
 		if (!tcf_csum_ipv4(skb, update_flags))
 			goto drop;
@@ -583,13 +588,35 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
 		if (!tcf_csum_ipv6(skb, update_flags))
 			goto drop;
 		break;
+	case cpu_to_be16(ETH_P_8021AD): /* fall through */
+	case cpu_to_be16(ETH_P_8021Q):
+		if (skb_vlan_tag_present(skb) && !orig_vlan_tag_present) {
+			protocol = skb->protocol;
+			orig_vlan_tag_present = true;
+		} else {
+			struct vlan_hdr *vlan = (struct vlan_hdr *)skb->data;
+
+			protocol = vlan->h_vlan_encapsulated_proto;
+			skb_pull(skb, VLAN_HLEN);
+			skb_reset_network_header(skb);
+			vlan_hdr_count++;
+		}
+		goto again;
+	}
+
+out:
+	/* Restore the skb for the pulled VLAN tags */
+	while (vlan_hdr_count--) {
+		skb_push(skb, VLAN_HLEN);
+		skb_reset_network_header(skb);
 	}
 
 	return action;
 
 drop:
 	qstats_drop_inc(this_cpu_ptr(p->common.cpu_qstats));
-	return TC_ACT_SHOT;
+	action = TC_ACT_SHOT;
+	goto out;
 }
 
 static int tcf_csum_dump(struct sk_buff *skb, struct tc_action *a, int bind,
-- 
2.20.1




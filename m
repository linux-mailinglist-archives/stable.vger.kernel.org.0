Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F73449A2BC
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365971AbiAXXwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843483AbiAXXED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:04:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0714EC061A7D;
        Mon, 24 Jan 2022 13:15:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 995CB61484;
        Mon, 24 Jan 2022 21:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E609C340E5;
        Mon, 24 Jan 2022 21:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058902;
        bh=NoDvo/YxdOUEGYfupMkbOcp1Kt4K78zDsvMM0GHU8sQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqJJ6NRAYw/o4+4TBKEzuP54M07BHVA4GKBGFQVGmpyqDJs4jEt976ICmD9z6XbSd
         ye/67VpIiMkxqRYvOJ557wEEJtu8f9XHCV+28RrsT3Iz+BxHkPdxUV3nIXNKgB3W3d
         PYnAgR/mMFFm4z8siU5sqj6GecywtOuQfSHquCYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0438/1039] net: openvswitch: Fix ct_state nat flags for conns arriving from tc
Date:   Mon, 24 Jan 2022 19:37:07 +0100
Message-Id: <20220124184140.017948811@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit 6f022c2ddbcefaee79502ce5386dfe351d457070 ]

Netfilter conntrack maintains NAT flags per connection indicating
whether NAT was configured for the connection. Openvswitch maintains
NAT flags on the per packet flow key ct_state field, indicating
whether NAT was actually executed on the packet.

When a packet misses from tc to ovs the conntrack NAT flags are set.
However, NAT was not necessarily executed on the packet because the
connection's state might still be in NEW state. As such, openvswitch
wrongly assumes that NAT was executed and sets an incorrect flow key
NAT flags.

Fix this, by flagging to openvswitch which NAT was actually done in
act_ct via tc_skb_ext and tc_skb_cb to the openvswitch module, so
the packet flow key NAT flags will be correctly set.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20220106153804.26451-1-paulb@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h  |  4 +++-
 include/net/pkt_sched.h |  4 +++-
 net/openvswitch/flow.c  | 16 +++++++++++++---
 net/sched/act_ct.c      |  6 ++++++
 net/sched/cls_api.c     |  2 ++
 5 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4507d77d6941f..60ab0c2fe5674 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -287,7 +287,9 @@ struct tc_skb_ext {
 	__u32 chain;
 	__u16 mru;
 	__u16 zone;
-	bool post_ct;
+	u8 post_ct:1;
+	u8 post_ct_snat:1;
+	u8 post_ct_dnat:1;
 };
 #endif
 
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 9e71691c491b7..9e7b21c0b3a6d 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -197,7 +197,9 @@ struct tc_skb_cb {
 	struct qdisc_skb_cb qdisc_cb;
 
 	u16 mru;
-	bool post_ct;
+	u8 post_ct:1;
+	u8 post_ct_snat:1;
+	u8 post_ct_dnat:1;
 	u16 zone; /* Only valid if post_ct = true */
 };
 
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 6d262d9aa10ea..02096f2ec6784 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -859,7 +859,7 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	struct tc_skb_ext *tc_ext;
 #endif
-	bool post_ct = false;
+	bool post_ct = false, post_ct_snat = false, post_ct_dnat = false;
 	int res, err;
 	u16 zone = 0;
 
@@ -900,6 +900,8 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 		key->recirc_id = tc_ext ? tc_ext->chain : 0;
 		OVS_CB(skb)->mru = tc_ext ? tc_ext->mru : 0;
 		post_ct = tc_ext ? tc_ext->post_ct : false;
+		post_ct_snat = post_ct ? tc_ext->post_ct_snat : false;
+		post_ct_dnat = post_ct ? tc_ext->post_ct_dnat : false;
 		zone = post_ct ? tc_ext->zone : 0;
 	} else {
 		key->recirc_id = 0;
@@ -911,8 +913,16 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 	err = key_extract(skb, key);
 	if (!err) {
 		ovs_ct_fill_key(skb, key, post_ct);   /* Must be after key_extract(). */
-		if (post_ct && !skb_get_nfct(skb))
-			key->ct_zone = zone;
+		if (post_ct) {
+			if (!skb_get_nfct(skb)) {
+				key->ct_zone = zone;
+			} else {
+				if (!post_ct_dnat)
+					key->ct_state &= ~OVS_CS_F_DST_NAT;
+				if (!post_ct_snat)
+					key->ct_state &= ~OVS_CS_F_SRC_NAT;
+			}
+		}
 	}
 	return err;
 }
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index ab3591408419f..2a17eb77c9049 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -839,6 +839,12 @@ static int ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 	}
 
 	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
+	if (err == NF_ACCEPT) {
+		if (maniptype == NF_NAT_MANIP_SRC)
+			tc_skb_cb(skb)->post_ct_snat = 1;
+		if (maniptype == NF_NAT_MANIP_DST)
+			tc_skb_cb(skb)->post_ct_dnat = 1;
+	}
 out:
 	return err;
 }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 35c74bdde848e..cc9409aa755eb 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1625,6 +1625,8 @@ int tcf_classify(struct sk_buff *skb,
 		ext->chain = last_executed_chain;
 		ext->mru = cb->mru;
 		ext->post_ct = cb->post_ct;
+		ext->post_ct_snat = cb->post_ct_snat;
+		ext->post_ct_dnat = cb->post_ct_dnat;
 		ext->zone = cb->zone;
 	}
 
-- 
2.34.1




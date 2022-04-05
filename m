Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809D54F307B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242124AbiDEIgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239225AbiDEITz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BDA7CB20;
        Tue,  5 Apr 2022 01:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADE24B81B18;
        Tue,  5 Apr 2022 08:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A077C385A1;
        Tue,  5 Apr 2022 08:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146233;
        bh=ada5tzx97r3YKFk4SPojZhTvMWtXHqK1h8S4CuvuLIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxaRXxCQrsREAjfJhuLUO5ylf/rroo1jezIC0aBm2Zp1OgHEqg34ZQD/3ZqAJsvAc
         VQdx2VTgQDg21lR/jVACbk5IRiCT4gx33hWZhI6wtyPj4CJ8tdEsVD/+qmOB4NNOfC
         yQJOBoQLCHbUEBUcaver1O9vwUw1MDD+U34WNhAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0673/1126] netfilter: flowtable: Fix QinQ and pppoe support for inet table
Date:   Tue,  5 Apr 2022 09:23:40 +0200
Message-Id: <20220405070427.380082672@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 0492d857636e1c52cd71594a723c4b26a7b31978 ]

nf_flow_offload_inet_hook() does not check for 802.1q and PPPoE.
Fetch inner ethertype from these encapsulation protocols.

Fixes: 72efd585f714 ("netfilter: flowtable: add pppoe support")
Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_flow_table.h | 18 ++++++++++++++++++
 net/netfilter/nf_flow_table_inet.c    | 17 +++++++++++++++++
 net/netfilter/nf_flow_table_ip.c      | 18 ------------------
 3 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index bd59e950f4d6..64daafd1fc41 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -10,6 +10,8 @@
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 #include <net/flow_offload.h>
 #include <net/dst.h>
+#include <linux/if_pppox.h>
+#include <linux/ppp_defs.h>
 
 struct nf_flowtable;
 struct nf_flow_rule;
@@ -317,4 +319,20 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 int nf_flow_table_offload_init(void);
 void nf_flow_table_offload_exit(void);
 
+static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
+{
+	__be16 proto;
+
+	proto = *((__be16 *)(skb_mac_header(skb) + ETH_HLEN +
+			     sizeof(struct pppoe_hdr)));
+	switch (proto) {
+	case htons(PPP_IP):
+		return htons(ETH_P_IP);
+	case htons(PPP_IPV6):
+		return htons(ETH_P_IPV6);
+	}
+
+	return 0;
+}
+
 #endif /* _NF_FLOW_TABLE_H */
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 5c57ade6bd05..0ccabf3fa6aa 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -6,12 +6,29 @@
 #include <linux/rhashtable.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_tables.h>
+#include <linux/if_vlan.h>
 
 static unsigned int
 nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
 			  const struct nf_hook_state *state)
 {
+	struct vlan_ethhdr *veth;
+	__be16 proto;
+
 	switch (skb->protocol) {
+	case htons(ETH_P_8021Q):
+		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
+		proto = veth->h_vlan_encapsulated_proto;
+		break;
+	case htons(ETH_P_PPP_SES):
+		proto = nf_flow_pppoe_proto(skb);
+		break;
+	default:
+		proto = skb->protocol;
+		break;
+	}
+
+	switch (proto) {
 	case htons(ETH_P_IP):
 		return nf_flow_offload_ip_hook(priv, skb, state);
 	case htons(ETH_P_IPV6):
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 889cf88d3dba..6257d87c3a56 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -8,8 +8,6 @@
 #include <linux/ipv6.h>
 #include <linux/netdevice.h>
 #include <linux/if_ether.h>
-#include <linux/if_pppox.h>
-#include <linux/ppp_defs.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
@@ -239,22 +237,6 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
-static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
-{
-	__be16 proto;
-
-	proto = *((__be16 *)(skb_mac_header(skb) + ETH_HLEN +
-			     sizeof(struct pppoe_hdr)));
-	switch (proto) {
-	case htons(PPP_IP):
-		return htons(ETH_P_IP);
-	case htons(PPP_IPV6):
-		return htons(ETH_P_IPV6);
-	}
-
-	return 0;
-}
-
 static bool nf_flow_skb_encap_protocol(const struct sk_buff *skb, __be16 proto,
 				       u32 *offset)
 {
-- 
2.34.1




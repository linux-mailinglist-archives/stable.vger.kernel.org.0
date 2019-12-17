Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 113B3123707
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfLQURJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:17:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728685AbfLQURI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:17:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 493C421775;
        Tue, 17 Dec 2019 20:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613827;
        bh=zvdxBgIxG7PU9VL9++0kqYYYnnf5zXzEdQnUf4j1fPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZL7ZvTHKRD0jNtSa92viy0P0Fc7i//xynV+bMMs1ODn3pFaMonTb0cj2WzcmUhHR8
         X2sQqQjq9sBYhdgHjaO0FZyBjWnSGcJ3C1mNPDGiH3GhM0Ha5v2NVel+D2Tw4QJJb7
         K7CR+/7Qv74e1AD/6GP7gZKYNLld3/ubb8S2E1RE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 22/25] net: Fixed updating of ethertype in skb_mpls_push()
Date:   Tue, 17 Dec 2019 21:16:21 +0100
Message-Id: <20191217200912.280804604@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200903.179327435@linuxfoundation.org>
References: <20191217200903.179327435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

[ Upstream commit d04ac224b1688f005a84f764cfe29844f8e9da08 ]

The skb_mpls_push was not updating ethertype of an ethernet packet if
the packet was originally received from a non ARPHRD_ETHER device.

In the below OVS data path flow, since the device corresponding to
port 7 is an l3 device (ARPHRD_NONE) the skb_mpls_push function does
not update the ethertype of the packet even though the previous
push_eth action had added an ethernet header to the packet.

recirc_id(0),in_port(7),eth_type(0x0800),ipv4(tos=0/0xfc,ttl=64,frag=no),
actions:push_eth(src=00:00:00:00:00:00,dst=00:00:00:00:00:00),
push_mpls(label=13,tc=0,ttl=64,bos=1,eth_type=0x8847),4

Fixes: 8822e270d697 ("net: core: move push MPLS functionality from OvS to core helper")
Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h    |    2 +-
 net/core/skbuff.c         |    4 ++--
 net/openvswitch/actions.c |    3 ++-
 net/sched/act_mpls.c      |    3 ++-
 4 files changed, 7 insertions(+), 5 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3482,7 +3482,7 @@ int __skb_vlan_pop(struct sk_buff *skb,
 int skb_vlan_pop(struct sk_buff *skb);
 int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
 int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
-		  int mac_len);
+		  int mac_len, bool ethernet);
 int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
 		 bool ethernet);
 int skb_mpls_update_lse(struct sk_buff *skb, __be32 mpls_lse);
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5472,7 +5472,7 @@ static void skb_mod_eth_type(struct sk_b
  * Returns 0 on success, -errno otherwise.
  */
 int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
-		  int mac_len)
+		  int mac_len, bool ethernet)
 {
 	struct mpls_shim_hdr *lse;
 	int err;
@@ -5503,7 +5503,7 @@ int skb_mpls_push(struct sk_buff *skb, _
 	lse->label_stack_entry = mpls_lse;
 	skb_postpush_rcsum(skb, lse, MPLS_HLEN);
 
-	if (skb->dev && skb->dev->type == ARPHRD_ETHER)
+	if (ethernet)
 		skb_mod_eth_type(skb, eth_hdr(skb), mpls_proto);
 	skb->protocol = mpls_proto;
 
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -166,7 +166,8 @@ static int push_mpls(struct sk_buff *skb
 	int err;
 
 	err = skb_mpls_push(skb, mpls->mpls_lse, mpls->mpls_ethertype,
-			    skb->mac_len);
+			    skb->mac_len,
+			    ovs_key_mac_proto(key) == MAC_PROTO_ETHERNET);
 	if (err)
 		return err;
 
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -83,7 +83,8 @@ static int tcf_mpls_act(struct sk_buff *
 		break;
 	case TCA_MPLS_ACT_PUSH:
 		new_lse = tcf_mpls_get_lse(NULL, p, !eth_p_mpls(skb->protocol));
-		if (skb_mpls_push(skb, new_lse, p->tcfm_proto, mac_len))
+		if (skb_mpls_push(skb, new_lse, p->tcfm_proto, mac_len,
+				  skb->dev && skb->dev->type == ARPHRD_ETHER))
 			goto drop;
 		break;
 	case TCA_MPLS_ACT_MODIFY:



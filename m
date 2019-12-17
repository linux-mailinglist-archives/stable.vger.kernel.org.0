Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8328123712
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfLQUSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:18:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728635AbfLQURD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:17:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DB652465E;
        Tue, 17 Dec 2019 20:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613822;
        bh=kEzd6Eru2VH38W+se05bRAU9NDzKkuX0IcMfRBl0caQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYJM5E6CnLFW4bq1eF4BwltwiYpt1/XXsC0oIaXsogz7Vc1TEB4hl6yDD8a/tNlLZ
         iFx1iDu3S/gMim1T+7Sopl82eA1wa+BdkSFU5D6Xj47dEY5IX3MBR/Kp8wotXc0arD
         +f5AoOFgVClOfkzxL53B/j11LWL1D7dZTXYeRTGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 20/25] Fixed updating of ethertype in function skb_mpls_pop
Date:   Tue, 17 Dec 2019 21:16:19 +0100
Message-Id: <20191217200910.968496971@linuxfoundation.org>
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

[ Upstream commit 040b5cfbcefa263ccf2c118c4938308606bb7ed8 ]

The skb_mpls_pop was not updating ethertype of an ethernet packet if the
packet was originally received from a non ARPHRD_ETHER device.

In the below OVS data path flow, since the device corresponding to port 7
is an l3 device (ARPHRD_NONE) the skb_mpls_pop function does not update
the ethertype of the packet even though the previous push_eth action had
added an ethernet header to the packet.

recirc_id(0),in_port(7),eth_type(0x8847),
mpls(label=12/0xfffff,tc=0/0,ttl=0/0x0,bos=1/1),
actions:push_eth(src=00:00:00:00:00:00,dst=00:00:00:00:00:00),
pop_mpls(eth_type=0x800),4

Fixes: ed246cee09b9 ("net: core: move pop MPLS functionality from OvS to core helper")
Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h    |    3 ++-
 net/core/skbuff.c         |    6 ++++--
 net/openvswitch/actions.c |    3 ++-
 net/sched/act_mpls.c      |    4 +++-
 4 files changed, 11 insertions(+), 5 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3483,7 +3483,8 @@ int skb_vlan_pop(struct sk_buff *skb);
 int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
 int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
 		  int mac_len);
-int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len);
+int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
+		 bool ethernet);
 int skb_mpls_update_lse(struct sk_buff *skb, __be32 mpls_lse);
 int skb_mpls_dec_ttl(struct sk_buff *skb);
 struct sk_buff *pskb_extract(struct sk_buff *skb, int off, int to_copy,
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5517,12 +5517,14 @@ EXPORT_SYMBOL_GPL(skb_mpls_push);
  * @skb: buffer
  * @next_proto: ethertype of header after popped MPLS header
  * @mac_len: length of the MAC header
+ * @ethernet: flag to indicate if ethernet header is present in packet
  *
  * Expects skb->data at mac header.
  *
  * Returns 0 on success, -errno otherwise.
  */
-int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
+int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
+		 bool ethernet)
 {
 	int err;
 
@@ -5541,7 +5543,7 @@ int skb_mpls_pop(struct sk_buff *skb, __
 	skb_reset_mac_header(skb);
 	skb_set_network_header(skb, mac_len);
 
-	if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
+	if (ethernet) {
 		struct ethhdr *hdr;
 
 		/* use mpls_hdr() to get ethertype to account for VLANs. */
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -179,7 +179,8 @@ static int pop_mpls(struct sk_buff *skb,
 {
 	int err;
 
-	err = skb_mpls_pop(skb, ethertype, skb->mac_len);
+	err = skb_mpls_pop(skb, ethertype, skb->mac_len,
+			   ovs_key_mac_proto(key) == MAC_PROTO_ETHERNET);
 	if (err)
 		return err;
 
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 /* Copyright (C) 2019 Netronome Systems, Inc. */
 
+#include <linux/if_arp.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -76,7 +77,8 @@ static int tcf_mpls_act(struct sk_buff *
 
 	switch (p->tcfm_action) {
 	case TCA_MPLS_ACT_POP:
-		if (skb_mpls_pop(skb, p->tcfm_proto, mac_len))
+		if (skb_mpls_pop(skb, p->tcfm_proto, mac_len,
+				 skb->dev && skb->dev->type == ARPHRD_ETHER))
 			goto drop;
 		break;
 	case TCA_MPLS_ACT_PUSH:



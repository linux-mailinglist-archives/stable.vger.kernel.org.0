Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1A05E9F60
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbiIZKZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235369AbiIZKXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:23:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E47DE0;
        Mon, 26 Sep 2022 03:17:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF62760B4A;
        Mon, 26 Sep 2022 10:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75B6C433C1;
        Mon, 26 Sep 2022 10:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187417;
        bh=+kacTAPyAuoJ1m3Aw+Yz05GgnNpHRo1QtKQBjhD/dak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMDv00mOEWIJGxzndujCVvwy9S+9miENCBwp9ZzMD+Val9BeQsfHsN6WqV3eypaOd
         izOh2lJ0KxhHKMzj0Lpx4w1707SHMff06GaUQYG/l5LqF96EKH05JVczoR7FQ7XDi8
         CAnynY1CCoJYMSh8fuxnCacTp/3q6rYxyCDLUk1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Wei <luwei32@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 27/40] ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header
Date:   Mon, 26 Sep 2022 12:11:55 +0200
Message-Id: <20220926100739.320576624@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100738.148626940@linuxfoundation.org>
References: <20220926100738.148626940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Wei <luwei32@huawei.com>

[ Upstream commit 81225b2ea161af48e093f58e8dfee6d705b16af4 ]

If an AF_PACKET socket is used to send packets through ipvlan and the
default xmit function of the AF_PACKET socket is changed from
dev_queue_xmit() to packet_direct_xmit() via setsockopt() with the option
name of PACKET_QDISC_BYPASS, the skb->mac_header may not be reset and
remains as the initial value of 65535, this may trigger slab-out-of-bounds
bugs as following:

=================================================================
UG: KASAN: slab-out-of-bounds in ipvlan_xmit_mode_l2+0xdb/0x330 [ipvlan]
PU: 2 PID: 1768 Comm: raw_send Kdump: loaded Not tainted 6.0.0-rc4+ #6
ardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33
all Trace:
print_address_description.constprop.0+0x1d/0x160
print_report.cold+0x4f/0x112
kasan_report+0xa3/0x130
ipvlan_xmit_mode_l2+0xdb/0x330 [ipvlan]
ipvlan_start_xmit+0x29/0xa0 [ipvlan]
__dev_direct_xmit+0x2e2/0x380
packet_direct_xmit+0x22/0x60
packet_snd+0x7c9/0xc40
sock_sendmsg+0x9a/0xa0
__sys_sendto+0x18a/0x230
__x64_sys_sendto+0x74/0x90
do_syscall_64+0x3b/0x90
entry_SYSCALL_64_after_hwframe+0x63/0xcd

The root cause is:
  1. packet_snd() only reset skb->mac_header when sock->type is SOCK_RAW
     and skb->protocol is not specified as in packet_parse_headers()

  2. packet_direct_xmit() doesn't reset skb->mac_header as dev_queue_xmit()

In this case, skb->mac_header is 65535 when ipvlan_xmit_mode_l2() is
called. So when ipvlan_xmit_mode_l2() gets mac header with eth_hdr() which
use "skb->head + skb->mac_header", out-of-bound access occurs.

This patch replaces eth_hdr() with skb_eth_hdr() in ipvlan_xmit_mode_l2()
and reset mac header in multicast to solve this out-of-bound bug.

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
Signed-off-by: Lu Wei <luwei32@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index baf8aab59f82..71fd45137ee4 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -446,7 +446,6 @@ static int ipvlan_process_v6_outbound(struct sk_buff *skb)
 
 static int ipvlan_process_outbound(struct sk_buff *skb)
 {
-	struct ethhdr *ethh = eth_hdr(skb);
 	int ret = NET_XMIT_DROP;
 
 	/* The ipvlan is a pseudo-L2 device, so the packets that we receive
@@ -456,6 +455,8 @@ static int ipvlan_process_outbound(struct sk_buff *skb)
 	if (skb_mac_header_was_set(skb)) {
 		/* In this mode we dont care about
 		 * multicast and broadcast traffic */
+		struct ethhdr *ethh = eth_hdr(skb);
+
 		if (is_multicast_ether_addr(ethh->h_dest)) {
 			pr_debug_ratelimited(
 				"Dropped {multi|broad}cast of type=[%x]\n",
@@ -534,7 +535,7 @@ static int ipvlan_xmit_mode_l3(struct sk_buff *skb, struct net_device *dev)
 static int ipvlan_xmit_mode_l2(struct sk_buff *skb, struct net_device *dev)
 {
 	const struct ipvl_dev *ipvlan = netdev_priv(dev);
-	struct ethhdr *eth = eth_hdr(skb);
+	struct ethhdr *eth = skb_eth_hdr(skb);
 	struct ipvl_addr *addr;
 	void *lyr3h;
 	int addr_type;
@@ -558,6 +559,7 @@ static int ipvlan_xmit_mode_l2(struct sk_buff *skb, struct net_device *dev)
 		return dev_forward_skb(ipvlan->phy_dev, skb);
 
 	} else if (is_multicast_ether_addr(eth->h_dest)) {
+		skb_reset_mac_header(skb);
 		ipvlan_skb_crossing_ns(skb, NULL);
 		ipvlan_multicast_enqueue(ipvlan->port, skb, true);
 		return NET_XMIT_SUCCESS;
-- 
2.35.1




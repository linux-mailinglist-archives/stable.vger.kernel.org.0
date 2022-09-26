Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94ABA5EA21F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237146AbiIZLC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237079AbiIZLAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:00:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF3E5E304;
        Mon, 26 Sep 2022 03:31:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58A14B8094B;
        Mon, 26 Sep 2022 10:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C19EC433D6;
        Mon, 26 Sep 2022 10:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188196;
        bh=aeSD6Yc3XFkZs9sGQ7ngJnxWev9+a35ax/I+fVl36jY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVdf8y9tq7Enq7L2TMfug60oOj2Q7oEu0jyt2X6pF/b+DMvmwfAQvBfh87Rn3N2sk
         /WB/qyNp4oOkUdf3BFIN31dZ1RJlb9ly96/xivAiCFs7QeaDjC9MxUb5rb/j1CZf0u
         p2XRfmwbH70aAN9ceOp1/LB5q3FIKY3lps77/VN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Wei <luwei32@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/141] ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header
Date:   Mon, 26 Sep 2022 12:11:38 +0200
Message-Id: <20220926100757.056961977@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
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
index 8801d093135c..a33149ee0ddc 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -496,7 +496,6 @@ static int ipvlan_process_v6_outbound(struct sk_buff *skb)
 
 static int ipvlan_process_outbound(struct sk_buff *skb)
 {
-	struct ethhdr *ethh = eth_hdr(skb);
 	int ret = NET_XMIT_DROP;
 
 	/* The ipvlan is a pseudo-L2 device, so the packets that we receive
@@ -506,6 +505,8 @@ static int ipvlan_process_outbound(struct sk_buff *skb)
 	if (skb_mac_header_was_set(skb)) {
 		/* In this mode we dont care about
 		 * multicast and broadcast traffic */
+		struct ethhdr *ethh = eth_hdr(skb);
+
 		if (is_multicast_ether_addr(ethh->h_dest)) {
 			pr_debug_ratelimited(
 				"Dropped {multi|broad}cast of type=[%x]\n",
@@ -590,7 +591,7 @@ static int ipvlan_xmit_mode_l3(struct sk_buff *skb, struct net_device *dev)
 static int ipvlan_xmit_mode_l2(struct sk_buff *skb, struct net_device *dev)
 {
 	const struct ipvl_dev *ipvlan = netdev_priv(dev);
-	struct ethhdr *eth = eth_hdr(skb);
+	struct ethhdr *eth = skb_eth_hdr(skb);
 	struct ipvl_addr *addr;
 	void *lyr3h;
 	int addr_type;
@@ -620,6 +621,7 @@ static int ipvlan_xmit_mode_l2(struct sk_buff *skb, struct net_device *dev)
 		return dev_forward_skb(ipvlan->phy_dev, skb);
 
 	} else if (is_multicast_ether_addr(eth->h_dest)) {
+		skb_reset_mac_header(skb);
 		ipvlan_skb_crossing_ns(skb, NULL);
 		ipvlan_multicast_enqueue(ipvlan->port, skb, true);
 		return NET_XMIT_SUCCESS;
-- 
2.35.1




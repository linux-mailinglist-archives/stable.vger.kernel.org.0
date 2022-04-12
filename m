Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080574FD1F1
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346981AbiDLHJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352560AbiDLHFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:05:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE9647AFF;
        Mon, 11 Apr 2022 23:48:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9F1B61045;
        Tue, 12 Apr 2022 06:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB91C385A8;
        Tue, 12 Apr 2022 06:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746096;
        bh=KATIwZicvNr90IGaZXN1HDWS0h1x5A7R1dmMW/o73O4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKQygT9K93mEs8cF7/KIGf33y1TnIpafLcMDaHCuXupmimEkcXgHfhYS0eMmfl6Yd
         4CNGK2ZxiKj1vu3bB1BhkMc6CSEOlw+e9Ny+Op66JmNRjTS1os29F8XFP6im3c2T5q
         NIM4DklCEX+6yPBJ+6K/wi7IWY6IhoUo5fmx8anU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/277] vrf: fix packet sniffing for traffic originating from ip tunnels
Date:   Tue, 12 Apr 2022 08:29:22 +0200
Message-Id: <20220412062946.640808096@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Eyal Birger <eyal.birger@gmail.com>

[ Upstream commit 012d69fbfcc739f846766c1da56ef8b493b803b5 ]

in commit 048939088220
("vrf: add mac header for tunneled packets when sniffer is attached")
an Ethernet header was cooked for traffic originating from tunnel devices.

However, the header is added based on whether the mac_header is unset
and ignores cases where the device doesn't expose a mac header to upper
layers, such as in ip tunnels like ipip and gre.

Traffic originating from such devices still appears garbled when capturing
on the vrf device.

Fix by observing whether the original device exposes a header to upper
layers, similar to the logic done in af_packet.

In addition, skb->mac_len needs to be adjusted after adding the Ethernet
header for the skb_push/pull() surrounding dev_queue_xmit_nit() to work
on these packets.

Fixes: 048939088220 ("vrf: add mac header for tunneled packets when sniffer is attached")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index b2242a082431..091dd7caf10c 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1265,6 +1265,7 @@ static int vrf_prepare_mac_header(struct sk_buff *skb,
 	eth = (struct ethhdr *)skb->data;
 
 	skb_reset_mac_header(skb);
+	skb_reset_mac_len(skb);
 
 	/* we set the ethernet destination and the source addresses to the
 	 * address of the VRF device.
@@ -1294,9 +1295,9 @@ static int vrf_prepare_mac_header(struct sk_buff *skb,
  */
 static int vrf_add_mac_header_if_unset(struct sk_buff *skb,
 				       struct net_device *vrf_dev,
-				       u16 proto)
+				       u16 proto, struct net_device *orig_dev)
 {
-	if (skb_mac_header_was_set(skb))
+	if (skb_mac_header_was_set(skb) && dev_has_header(orig_dev))
 		return 0;
 
 	return vrf_prepare_mac_header(skb, vrf_dev, proto);
@@ -1402,6 +1403,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 
 	/* if packet is NDISC then keep the ingress interface */
 	if (!is_ndisc) {
+		struct net_device *orig_dev = skb->dev;
+
 		vrf_rx_stats(vrf_dev, skb->len);
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
@@ -1410,7 +1413,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 			int err;
 
 			err = vrf_add_mac_header_if_unset(skb, vrf_dev,
-							  ETH_P_IPV6);
+							  ETH_P_IPV6,
+							  orig_dev);
 			if (likely(!err)) {
 				skb_push(skb, skb->mac_len);
 				dev_queue_xmit_nit(skb, vrf_dev);
@@ -1440,6 +1444,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 static struct sk_buff *vrf_ip_rcv(struct net_device *vrf_dev,
 				  struct sk_buff *skb)
 {
+	struct net_device *orig_dev = skb->dev;
+
 	skb->dev = vrf_dev;
 	skb->skb_iif = vrf_dev->ifindex;
 	IPCB(skb)->flags |= IPSKB_L3SLAVE;
@@ -1460,7 +1466,8 @@ static struct sk_buff *vrf_ip_rcv(struct net_device *vrf_dev,
 	if (!list_empty(&vrf_dev->ptype_all)) {
 		int err;
 
-		err = vrf_add_mac_header_if_unset(skb, vrf_dev, ETH_P_IP);
+		err = vrf_add_mac_header_if_unset(skb, vrf_dev, ETH_P_IP,
+						  orig_dev);
 		if (likely(!err)) {
 			skb_push(skb, skb->mac_len);
 			dev_queue_xmit_nit(skb, vrf_dev);
-- 
2.35.1




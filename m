Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F574FDB35
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354031AbiDLIKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357672AbiDLHkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:40:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097A7FEA;
        Tue, 12 Apr 2022 00:16:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3D47B81A8F;
        Tue, 12 Apr 2022 07:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F99C385A5;
        Tue, 12 Apr 2022 07:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747786;
        bh=7n1CUTwVxEhRYCfm68ufa+KXWYtqErl01OICdME7qFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+vou0Wf3pqvGoELB6cdmWFqqpCShFUh0gkU9Xhc2sO7YqpifOFHcYZt1wgnnbyz6
         6pjUimfGZnbmSWxmaGvFvRQ51ISmoIgy5Pvdr2bxs1FUm0+VGxw+7nVCHMXc9S3fei
         4lw74+8YW1XZxX0FGjA6Twmi5laQ7sTTWq3bvLwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 206/343] vrf: fix packet sniffing for traffic originating from ip tunnels
Date:   Tue, 12 Apr 2022 08:30:24 +0200
Message-Id: <20220412062957.296361838@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
index e0b1ab99a359..f37adcef4bef 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1266,6 +1266,7 @@ static int vrf_prepare_mac_header(struct sk_buff *skb,
 	eth = (struct ethhdr *)skb->data;
 
 	skb_reset_mac_header(skb);
+	skb_reset_mac_len(skb);
 
 	/* we set the ethernet destination and the source addresses to the
 	 * address of the VRF device.
@@ -1295,9 +1296,9 @@ static int vrf_prepare_mac_header(struct sk_buff *skb,
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
@@ -1403,6 +1404,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 
 	/* if packet is NDISC then keep the ingress interface */
 	if (!is_ndisc) {
+		struct net_device *orig_dev = skb->dev;
+
 		vrf_rx_stats(vrf_dev, skb->len);
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
@@ -1411,7 +1414,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 			int err;
 
 			err = vrf_add_mac_header_if_unset(skb, vrf_dev,
-							  ETH_P_IPV6);
+							  ETH_P_IPV6,
+							  orig_dev);
 			if (likely(!err)) {
 				skb_push(skb, skb->mac_len);
 				dev_queue_xmit_nit(skb, vrf_dev);
@@ -1441,6 +1445,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 static struct sk_buff *vrf_ip_rcv(struct net_device *vrf_dev,
 				  struct sk_buff *skb)
 {
+	struct net_device *orig_dev = skb->dev;
+
 	skb->dev = vrf_dev;
 	skb->skb_iif = vrf_dev->ifindex;
 	IPCB(skb)->flags |= IPSKB_L3SLAVE;
@@ -1461,7 +1467,8 @@ static struct sk_buff *vrf_ip_rcv(struct net_device *vrf_dev,
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




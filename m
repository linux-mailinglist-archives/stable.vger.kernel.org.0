Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6EA6C1675
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbjCTPGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbjCTPFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:05:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C912F051
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:01:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 296DF615A7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39060C433D2;
        Mon, 20 Mar 2023 15:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324453;
        bh=6EoWyeeDGyfjG+9u+nP8fVvAqfNmH2YhWmmzBNUT3Zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHQK4lc1yBy4zTlXj/biBmIgNZLUPgOi4WuYxV6kp3wD1IXNZKMueUCyaN3dv2Vj0
         1LTlP8cVJYiKlp+g3agUBEZKWqIKXGCPyCNP8F4yzLEVAwe9OFtaTNp2ncT9b6OS+b
         JwSiBsIzrFTsog4f9f/zgZ4paLbNJlbiRIZN4on4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Szymon Heidrich <szymon.heidrich@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/60] net: usb: smsc75xx: Move packet length check to prevent kernel panic in skb_pull
Date:   Mon, 20 Mar 2023 15:54:38 +0100
Message-Id: <20230320145432.136271649@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Szymon Heidrich <szymon.heidrich@gmail.com>

[ Upstream commit 43ffe6caccc7a1bb9d7442fbab521efbf6c1378c ]

Packet length check needs to be located after size and align_count
calculation to prevent kernel panic in skb_pull() in case
rx_cmd_a & RX_CMD_A_RED evaluates to true.

Fixes: d8b228318935 ("net: usb: smsc75xx: Limit packet length to skb->len")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Link: https://lore.kernel.org/r/20230316110540.77531-1-szymon.heidrich@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc75xx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 229ff92e41cd9..bd533827af8b1 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -2198,6 +2198,13 @@ static int smsc75xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		size = (rx_cmd_a & RX_CMD_A_LEN) - RXW_PADDING;
 		align_count = (4 - ((size + RXW_PADDING) % 4)) % 4;
 
+		if (unlikely(size > skb->len)) {
+			netif_dbg(dev, rx_err, dev->net,
+				  "size err rx_cmd_a=0x%08x\n",
+				  rx_cmd_a);
+			return 0;
+		}
+
 		if (unlikely(rx_cmd_a & RX_CMD_A_RED)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error rx_cmd_a=0x%08x\n", rx_cmd_a);
@@ -2210,8 +2217,7 @@ static int smsc75xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 				dev->net->stats.rx_frame_errors++;
 		} else {
 			/* MAX_SINGLE_PACKET_SIZE + 4(CRC) + 2(COE) + 4(Vlan) */
-			if (unlikely(size > (MAX_SINGLE_PACKET_SIZE + ETH_HLEN + 12) ||
-				     size > skb->len)) {
+			if (unlikely(size > (MAX_SINGLE_PACKET_SIZE + ETH_HLEN + 12))) {
 				netif_dbg(dev, rx_err, dev->net,
 					  "size err rx_cmd_a=0x%08x\n",
 					  rx_cmd_a);
-- 
2.39.2




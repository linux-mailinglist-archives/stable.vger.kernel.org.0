Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8AD443000
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 15:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhKBOQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 10:16:28 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:31737 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhKBOQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 10:16:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635862431; x=1667398431;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MrjphouK4yTzS4b/q0GRyAK/WldzTgPfvH5PQfxg6Bo=;
  b=E+46yxHSlmNvW4uXeN0+Cc4/rqIXaGeeIzksMb/5TUN2aWt0jFG0+tI2
   CnwmnYOoB0PnpOVz6SmHvfOQlAz229SQLWQMqd9MFY39r/ZW5Rurqe9ZC
   6433lwhHxZzovEhe1UeOwbvQisUdND/tt7TF9KdKFfGzF4hylYxXk4zYd
   Zfx4xgQK6fah8pUYgVaMDk54wJA0kEDdn8LJNsA6SEeZCYDGszuFULWdJ
   D7Rur0hAmSwcebBDahlG3GJq69mJCugNisJcxPEndvqpgs9u2SwE08W2A
   RTeNk7+meZ85LamSaB0XM7luNpkno0/3m4ELJTAKU1MAEApuVHlTJoKWV
   Q==;
IronPort-SDR: SBqXi9ukQh6jZkdlz67k7dIF63Z+ySGzVIohC5b186I4+Dby026JVZtUm8iTVYApwRhpk/C9dX
 3ZW4VBfxQbWfHYyAsQ5Mb7kFHqGmrncel4PZVjZWyWdyApv+mkgZF5aWmfzw7iAi8Hq80bCv5W
 HDj2hx4Rwr+WpVbREEQ5Uhl8PeG0FOj7aew4aRg8e467xcOB2a3YMemkagUHYsfsWfB11IAhdb
 zg+mu2oKEb7rJDp/AiezSD309VS0leG43SSgW9xJ81TC+eCXp7yZlS2IUqnBD0f/gIYnnOvJCu
 UMlvmDuqFCkZCZXG2cB85IFM
X-IronPort-AV: E=Sophos;i="5.87,203,1631602800"; 
   d="scan'208";a="75094382"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Nov 2021 07:13:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 2 Nov 2021 07:13:38 -0700
Received: from validation1-XPS-8900.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 2 Nov 2021 07:13:38 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <stable@vger.kernel.org>
CC:     Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: [PATCH net] net: ethernet: microchip: lan743x: Fix skb allocation failure
Date:   Tue, 2 Nov 2021 10:14:27 -0400
Message-ID: <20211102141427.11272-1-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e8684db191e4164f3f5f3ad7dec04a6734c25f1c upstream.

The driver allocates skb during ndo_open with GFP_ATOMIC which has high chance of failure when there are multiple instances.
GFP_KERNEL is enough while open and use GFP_ATOMIC only from interrupt context.

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
cc: <stable@vger.kernel.org> # 5.4.x
---
 drivers/net/ethernet/microchip/lan743x_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index dfa0ded169ee..d335fad34dd3 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1888,13 +1888,13 @@ static int lan743x_rx_next_index(struct lan743x_rx *rx, int index)
 	return ((++index) % rx->ring_size);
 }
 
-static struct sk_buff *lan743x_rx_allocate_skb(struct lan743x_rx *rx)
+static struct sk_buff *lan743x_rx_allocate_skb(struct lan743x_rx *rx, gfp_t gfp)
 {
 	int length = 0;
 
 	length = (LAN743X_MAX_FRAME_SIZE + ETH_HLEN + 4 + RX_HEAD_PADDING);
 	return __netdev_alloc_skb(rx->adapter->netdev,
-				  length, GFP_ATOMIC | GFP_DMA);
+				  length, gfp);
 }
 
 static void lan743x_rx_update_tail(struct lan743x_rx *rx, int index)
@@ -2067,7 +2067,8 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 			struct sk_buff *new_skb = NULL;
 			int packet_length;
 
-			new_skb = lan743x_rx_allocate_skb(rx);
+			new_skb = lan743x_rx_allocate_skb(rx,
+							  GFP_ATOMIC | GFP_DMA);
 			if (!new_skb) {
 				/* failed to allocate next skb.
 				 * Memory is very low.
@@ -2294,7 +2295,8 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
 
 	rx->last_head = 0;
 	for (index = 0; index < rx->ring_size; index++) {
-		struct sk_buff *new_skb = lan743x_rx_allocate_skb(rx);
+		struct sk_buff *new_skb = lan743x_rx_allocate_skb(rx,
+								   GFP_KERNEL);
 
 		ret = lan743x_rx_init_ring_element(rx, index, new_skb);
 		if (ret)
-- 
2.25.1


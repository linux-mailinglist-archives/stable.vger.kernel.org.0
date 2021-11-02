Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EB7442FE2
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 15:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhKBOMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 10:12:10 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:38673 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhKBOMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 10:12:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635862173; x=1667398173;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MrjphouK4yTzS4b/q0GRyAK/WldzTgPfvH5PQfxg6Bo=;
  b=wQYVhHt/LpKmDJxAe6zvcOgiFyb+3EB32vFGe3Li4ZcXGEnDKM/er4e6
   LTzAniQOYuEme37kNMCgBDiJqqaYSVMidv+Q9mhDRhYf7ie9IYBcZzwXY
   7M11eq4jFNN5lfQ6FIcgYDHxinQeaHmHOHuwU+iyshA0nyzWIIupTJwkS
   9dq+XbzXT/2KPSbpgeLpF/c32AUYm93txPwv8jFEZdckEHG7s07v0c10m
   PK7MNsJcIfgrb7BEGUO3vWIH0Xdiyu04FxCJLX4DinACkugSNywiRUK9Y
   kJBhwciXQtZ6ZFMVMjyn+kCbKvjvwy2r0H7caaeMyqz4RaGzbaKV28URU
   g==;
IronPort-SDR: emSz6blT7/usHcszzGW0FftthICRfqMe60SzLziaHoZQOT1MPVXjBMLmoVzNYE1Su7DOkhgyVr
 UZAYIh0PegF8TYbS8KjimZ2E/kSIytK6yZbi/BtnxAP8M1E2i/3BgRhYalGbbyxiNWVvaqVS2Z
 clqiI1l4MIq1Xa/0Vxo+RCdgsDxb2Utt24vSKHnzfCzFae/DfjricVEPtTm9Wubn9bimkV/v0W
 AsCbntNylP4BPc1CyAPFvZ5dtbvOZ0iF3M0N0lNoptuP3TDjJ/8XSmeIBcUBM7e2F0Xq4+3FUX
 zO+ylWMs3uDSLoFTDpOmI8WL
X-IronPort-AV: E=Sophos;i="5.87,203,1631602800"; 
   d="scan'208";a="137735132"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Nov 2021 07:09:15 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 2 Nov 2021 07:09:15 -0700
Received: from validation1-XPS-8900.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 2 Nov 2021 07:09:15 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <yuiko.oshino@microchip.com>
CC:     <stable@vger.kernel.org>
Subject: [PATCH net] net: ethernet: microchip: lan743x: Fix skb allocation failure
Date:   Tue, 2 Nov 2021 10:10:20 -0400
Message-ID: <20211102141020.11179-1-yuiko.oshino@microchip.com>
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


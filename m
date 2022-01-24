Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FCF498F2B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344415AbiAXTvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:51:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58588 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348601AbiAXTjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:39:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24E12B8122C;
        Mon, 24 Jan 2022 19:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C5BC340E5;
        Mon, 24 Jan 2022 19:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053158;
        bh=VKXK7kYTQZvVjzGQS4SN8dhAG6nk9/Iz3tYU1sWarK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BX5S4btgBgMbukpo/LIj5ujx8TxZyNSKjmsJbSvJYKAWr2bvDnwy4y1tzin3AGtGH
         s9VYrVQ0gvmYGNabyuqD7YZz5K4gT3DUW3Um2Kx88AApWP0+Cw8FLC3dx7WZe1cbxF
         w1Kf5Wi20c7ImpUAjVVJN08IRsvE3K2yCPhHof3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 295/320] net: axienet: limit minimum TX ring size
Date:   Mon, 24 Jan 2022 19:44:39 +0100
Message-Id: <20220124184003.977026219@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit 70f5817deddbc6ef3faa35841cab83c280cc653a upstream.

The driver will not work properly if the TX ring size is set to below
MAX_SKB_FRAGS + 1 since it needs to hold at least one full maximally
fragmented packet in the TX ring. Limit setting the ring size to below
this value.

Fixes: 8b09ca823ffb4 ("net: axienet: Make RX/TX ring sizes configurable")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -43,6 +43,7 @@
 /* Descriptors defines for Tx and Rx DMA */
 #define TX_BD_NUM_DEFAULT		64
 #define RX_BD_NUM_DEFAULT		1024
+#define TX_BD_NUM_MIN			(MAX_SKB_FRAGS + 1)
 #define TX_BD_NUM_MAX			4096
 #define RX_BD_NUM_MAX			4096
 
@@ -1223,7 +1224,8 @@ static int axienet_ethtools_set_ringpara
 	if (ering->rx_pending > RX_BD_NUM_MAX ||
 	    ering->rx_mini_pending ||
 	    ering->rx_jumbo_pending ||
-	    ering->rx_pending > TX_BD_NUM_MAX)
+	    ering->tx_pending < TX_BD_NUM_MIN ||
+	    ering->tx_pending > TX_BD_NUM_MAX)
 		return -EINVAL;
 
 	if (netif_running(ndev))



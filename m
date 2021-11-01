Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351194417A8
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbhKAJiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233361AbhKAJgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:36:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 055496128E;
        Mon,  1 Nov 2021 09:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758786;
        bh=/HvOc+x8TAj/3rog/AyJk1V73CEVmRyYwJ8FdF82/3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/5FJGJBD85Nu8F3h4sCdVEtoe0t6SsJ8eeI9cbFqOT0WiVTbeNKLL0K2A/AUNG9Q
         faN+cv8yi301BOZKScWGx5U9sSNogFGJHi8QYP6Ff2brr1dAsxLd9v8xWevYDI7d8N
         MN5xR4iLmaQGHLlxEhE1i3A/ySSkbk/N2bRq0odw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuiko Oshino <yuiko.oshino@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 58/77] net: ethernet: microchip: lan743x: Fix dma allocation failure by using dma_set_mask_and_coherent
Date:   Mon,  1 Nov 2021 10:17:46 +0100
Message-Id: <20211101082523.850785119@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuiko Oshino <yuiko.oshino@microchip.com>

commit 95a359c9553342d36d408d35331ff0bfce75272f upstream.

The dma failure was reported in the raspberry pi github (issue #4117).
https://github.com/raspberrypi/linux/issues/4117
The use of dma_set_mask_and_coherent fixes the issue.
Tested on 32/64-bit raspberry pi CM4 and 64-bit ubuntu x86 PC with EVB-LAN7430.

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1770,6 +1770,16 @@ static int lan743x_tx_ring_init(struct l
 		ret = -EINVAL;
 		goto cleanup;
 	}
+	if (dma_set_mask_and_coherent(&tx->adapter->pdev->dev,
+				      DMA_BIT_MASK(64))) {
+		if (dma_set_mask_and_coherent(&tx->adapter->pdev->dev,
+					      DMA_BIT_MASK(32))) {
+			dev_warn(&tx->adapter->pdev->dev,
+				 "lan743x_: No suitable DMA available\n");
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+	}
 	ring_allocation_size = ALIGN(tx->ring_size *
 				     sizeof(struct lan743x_tx_descriptor),
 				     PAGE_SIZE);
@@ -2318,6 +2328,16 @@ static int lan743x_rx_ring_init(struct l
 		ret = -EINVAL;
 		goto cleanup;
 	}
+	if (dma_set_mask_and_coherent(&rx->adapter->pdev->dev,
+				      DMA_BIT_MASK(64))) {
+		if (dma_set_mask_and_coherent(&rx->adapter->pdev->dev,
+					      DMA_BIT_MASK(32))) {
+			dev_warn(&rx->adapter->pdev->dev,
+				 "lan743x_: No suitable DMA available\n");
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+	}
 	ring_allocation_size = ALIGN(rx->ring_size *
 				     sizeof(struct lan743x_rx_descriptor),
 				     PAGE_SIZE);



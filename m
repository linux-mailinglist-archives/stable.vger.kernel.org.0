Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D994A95E1
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353790AbiBDJUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357343AbiBDJUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:20:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5A0C061714;
        Fri,  4 Feb 2022 01:20:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 814A4B836EA;
        Fri,  4 Feb 2022 09:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB9AC004E1;
        Fri,  4 Feb 2022 09:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966442;
        bh=iaE1IqOh0EjTj9ysylMCuepe6iN/kPDrrbFWOLuRBw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qo+2Kf7zZWDbp1xkPDzJLHZarC74zzG2KeXhXZTtZ71JQizn50eImg6kXbHUJBEfB
         hjBPV7XuPjoEmCQurAnckQlLuY1Bn0U5G/XVh50OYObqxVHcT2A9oA3fcKSanpqHVN
         +1lXGjpdqvl29fyWdZDLuMXaAUxp7cktwJ5P8jlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Georgi Valkov <gvalkov@abv.bg>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 04/10] ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
Date:   Fri,  4 Feb 2022 10:20:17 +0100
Message-Id: <20220204091912.471614654@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091912.329106021@linuxfoundation.org>
References: <20220204091912.329106021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Georgi Valkov <gvalkov@abv.bg>

commit 63e4b45c82ed1bde979da7052229a4229ce9cabf upstream.

When rx_buf is allocated we need to account for IPHETH_IP_ALIGN,
which reduces the usable size by 2 bytes. Otherwise we have 1512
bytes usable instead of 1514, and if we receive more than 1512
bytes, ipheth_rcvbulk_callback is called with status -EOVERFLOW,
after which the driver malfunctiones and all communication stops.

Resolves ipheth 2-1:4.2: ipheth_rcvbulk_callback: urb status: -75

Fixes: f33d9e2b48a3 ("usbnet: ipheth: fix connectivity with iOS 14")
Signed-off-by: Georgi Valkov <gvalkov@abv.bg>
Tested-by: Jan Kiszka <jan.kiszka@siemens.com>
Link: https://lore.kernel.org/all/B60B8A4B-92A0-49B3-805D-809A2433B46C@abv.bg/
Link: https://lore.kernel.org/all/24851bd2769434a5fc24730dce8e8a984c5a4505.1643699778.git.jan.kiszka@siemens.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ipheth.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -121,7 +121,7 @@ static int ipheth_alloc_urbs(struct iphe
 	if (tx_buf == NULL)
 		goto free_rx_urb;
 
-	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,
+	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
 				    GFP_KERNEL, &rx_urb->transfer_dma);
 	if (rx_buf == NULL)
 		goto free_tx_buf;
@@ -146,7 +146,7 @@ error_nomem:
 
 static void ipheth_free_urbs(struct ipheth_device *iphone)
 {
-	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->rx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN, iphone->rx_buf,
 			  iphone->rx_urb->transfer_dma);
 	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
 			  iphone->tx_urb->transfer_dma);
@@ -317,7 +317,7 @@ static int ipheth_rx_submit(struct iphet
 
 	usb_fill_bulk_urb(dev->rx_urb, udev,
 			  usb_rcvbulkpipe(udev, dev->bulk_in),
-			  dev->rx_buf, IPHETH_BUF_SIZE,
+			  dev->rx_buf, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
 			  ipheth_rcvbulk_callback,
 			  dev);
 	dev->rx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;



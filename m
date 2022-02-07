Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356514ABA78
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383784AbiBGLXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379105AbiBGLQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:16:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A9EC0401C3;
        Mon,  7 Feb 2022 03:16:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77A9F6113B;
        Mon,  7 Feb 2022 11:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46104C004E1;
        Mon,  7 Feb 2022 11:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232560;
        bh=X4zAEnAPt4ZfgCA3lUjOmtemiVM22+id6pT04M2vi+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0lr4Rlt1D76g+dfsVFFWtOsze2qx5ORuNwov2Rh5DzJrR1EPbgzFiBW6jfyOlkdWT
         vvxoUbwE4RsLJH6/FomoMrU4Jd1IPcGvNOv6o31lD9i/soUma452IIJ3gRMF66QPtt
         Jnn21bnt45SCJedxwh6/jNKb+VooaPvyNrAJDFGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Georgi Valkov <gvalkov@abv.bg>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 49/86] ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
Date:   Mon,  7 Feb 2022 12:06:12 +0100
Message-Id: <20220207103759.163650408@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
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
@@ -173,7 +173,7 @@ static int ipheth_alloc_urbs(struct iphe
 	if (tx_buf == NULL)
 		goto free_rx_urb;
 
-	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,
+	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
 				    GFP_KERNEL, &rx_urb->transfer_dma);
 	if (rx_buf == NULL)
 		goto free_tx_buf;
@@ -198,7 +198,7 @@ error_nomem:
 
 static void ipheth_free_urbs(struct ipheth_device *iphone)
 {
-	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->rx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN, iphone->rx_buf,
 			  iphone->rx_urb->transfer_dma);
 	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
 			  iphone->tx_urb->transfer_dma);
@@ -371,7 +371,7 @@ static int ipheth_rx_submit(struct iphet
 
 	usb_fill_bulk_urb(dev->rx_urb, udev,
 			  usb_rcvbulkpipe(udev, dev->bulk_in),
-			  dev->rx_buf, IPHETH_BUF_SIZE,
+			  dev->rx_buf, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
 			  ipheth_rcvbulk_callback,
 			  dev);
 	dev->rx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;



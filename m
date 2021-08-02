Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6053DD829
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbhHBNuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234599AbhHBNsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:48:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20E9A60555;
        Mon,  2 Aug 2021 13:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912110;
        bh=tkkSI88kQPQWaYqDavHKIDe2QK26mEXf/Cak9DdlHAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiQXKSWoqpkfFYhOTVvk58B7Erq8HlBXMVpbRyFgkv8muhte9ELW+vxbEm86QhaDs
         gf6fWEuYB+YNOSEGYa7XQO76PaqRPxwdlHIPgMHpQz5lVuw5y5gK4c/e+VCOEUKHh+
         kjuWpc+2RcGSeBKQQK6+8qTwojcWhCgK+l2oBLpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yasushi SHOJI <yasushi.shoji@gmail.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Yasushi SHOJI <yashi@spacecubics.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.14 20/38] can: mcba_usb_start(): add missing urb->transfer_dma initialization
Date:   Mon,  2 Aug 2021 15:44:42 +0200
Message-Id: <20210802134335.469474670@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134334.835358048@linuxfoundation.org>
References: <20210802134334.835358048@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit fc43fb69a7af92839551f99c1a96a37b77b3ae7a upstream.

Yasushi reported, that his Microchip CAN Analyzer stopped working
since commit 91c02557174b ("can: mcba_usb: fix memory leak in
mcba_usb"). The problem was in missing urb->transfer_dma
initialization.

In my previous patch to this driver I refactored mcba_usb_start() code
to avoid leaking usb coherent buffers. To archive it, I passed local
stack variable to usb_alloc_coherent() and then saved it to private
array to correctly free all coherent buffers on ->close() call. But I
forgot to initialize urb->transfer_dma with variable passed to
usb_alloc_coherent().

All of this was causing device to not work, since dma addr 0 is not
valid and following log can be found on bug report page, which points
exactly to problem described above.

| DMAR: [DMA Write] Request device [00:14.0] PASID ffffffff fault addr 0 [fault reason 05] PTE Write access is not set

Fixes: 91c02557174b ("can: mcba_usb: fix memory leak in mcba_usb")
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=990850
Link: https://lore.kernel.org/r/20210725103630.23864-1-paskripkin@gmail.com
Cc: linux-stable <stable@vger.kernel.org>
Reported-by: Yasushi SHOJI <yasushi.shoji@gmail.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Tested-by: Yasushi SHOJI <yashi@spacecubics.com>
[mkl: fixed typos in commit message - thanks Yasushi SHOJI]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/mcba_usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -664,6 +664,8 @@ static int mcba_usb_start(struct mcba_pr
 			break;
 		}
 
+		urb->transfer_dma = buf_dma;
+
 		usb_fill_bulk_urb(urb, priv->udev,
 				  usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_IN),
 				  buf, MCBA_USB_RX_BUFF_SIZE,



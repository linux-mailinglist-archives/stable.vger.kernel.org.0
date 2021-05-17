Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFCE3835AF
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242983AbhEQPYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244427AbhEQPUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD5FC61C88;
        Mon, 17 May 2021 14:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262061;
        bh=sVFnVSZ/6fdfB41yv0+eSarSSZo9WQXQoHoeZlTjde8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWdK6Kwj2M1S2dJpKPhe1t7jV9X8CdBM/2T0lQ4IWrBKaJ1PiI5c07yMW7mJWURie
         7f8TTyCNUHxTsmgnJNSDGzWHQjE1xN6oRxBSu36GoUKf9k+z24lsV5c8h9PLrw6xhS
         BJjNnuV+fTQ0hrITVuNm1hcULc6CJ4G9Tt7lNBfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Phil Elwell <phil@raspberrypi.com>
Subject: [PATCH 5.4 116/141] usb: dwc2: Fix gadget DMA unmap direction
Date:   Mon, 17 May 2021 16:02:48 +0200
Message-Id: <20210517140246.702936517@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.com>

commit 75a41ce46bae6cbe7d3bb2584eb844291d642874 upstream.

The dwc2 gadget support maps and unmaps DMA buffers as necessary. When
mapping and unmapping it uses the direction of the endpoint to select
the direction of the DMA transfer, but this fails for Control OUT
transfers because the unmap occurs after the endpoint direction has
been reversed for the status phase.

A possible solution would be to unmap the buffer before the direction
is changed, but a safer, less invasive fix is to remember the buffer
direction independently of the endpoint direction.

Fixes: fe0b94abcdf6 ("usb: dwc2: gadget: manage ep0 state in software")
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Link: https://lore.kernel.org/r/20210506112200.2893922-1-phil@raspberrypi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/core.h   |    2 ++
 drivers/usb/dwc2/gadget.c |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -112,6 +112,7 @@ struct dwc2_hsotg_req;
  * @debugfs: File entry for debugfs file for this endpoint.
  * @dir_in: Set to true if this endpoint is of the IN direction, which
  *          means that it is sending data to the Host.
+ * @map_dir: Set to the value of dir_in when the DMA buffer is mapped.
  * @index: The index for the endpoint registers.
  * @mc: Multi Count - number of transactions per microframe
  * @interval: Interval for periodic endpoints, in frames or microframes.
@@ -161,6 +162,7 @@ struct dwc2_hsotg_ep {
 	unsigned short		fifo_index;
 
 	unsigned char           dir_in;
+	unsigned char           map_dir;
 	unsigned char           index;
 	unsigned char           mc;
 	u16                     interval;
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -421,7 +421,7 @@ static void dwc2_hsotg_unmap_dma(struct
 {
 	struct usb_request *req = &hs_req->req;
 
-	usb_gadget_unmap_request(&hsotg->gadget, req, hs_ep->dir_in);
+	usb_gadget_unmap_request(&hsotg->gadget, req, hs_ep->map_dir);
 }
 
 /*
@@ -1242,6 +1242,7 @@ static int dwc2_hsotg_map_dma(struct dwc
 {
 	int ret;
 
+	hs_ep->map_dir = hs_ep->dir_in;
 	ret = usb_gadget_map_request(&hsotg->gadget, req, hs_ep->dir_in);
 	if (ret)
 		goto dma_error;



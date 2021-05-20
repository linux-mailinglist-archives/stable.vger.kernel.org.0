Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B99038AB86
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238862AbhETLZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240268AbhETLW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:22:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2856E61D8C;
        Thu, 20 May 2021 10:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505509;
        bh=H6MZjVASwCtguj2dAO7EkdaGVNKf0ux6U6hRtsvLc+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sSlepIdcOesIkvVc0aA/1N3ggvn26lT/ejCVfRtEtU/o1AL8UrXPPC0To/6/W2Rem
         9wpo5h1tEllWpJN7zFEiL12cjEt9QAlVFhMQjfTezMyLoQB+cKGDqZVMK+a9CK27RC
         +4GEtgTBxKNsKW60cE53eNX7HIVLhWBdL9/nDQQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Phil Elwell <phil@raspberrypi.com>
Subject: [PATCH 4.4 167/190] usb: dwc2: Fix gadget DMA unmap direction
Date:   Thu, 20 May 2021 11:23:51 +0200
Message-Id: <20210520092107.693295769@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
@@ -144,6 +144,7 @@ struct dwc2_hsotg_req;
  * @lock: State lock to protect contents of endpoint.
  * @dir_in: Set to true if this endpoint is of the IN direction, which
  *          means that it is sending data to the Host.
+ * @map_dir: Set to the value of dir_in when the DMA buffer is mapped.
  * @index: The index for the endpoint registers.
  * @mc: Multi Count - number of transactions per microframe
  * @interval - Interval for periodic endpoints
@@ -185,6 +186,7 @@ struct dwc2_hsotg_ep {
 	unsigned short		fifo_index;
 
 	unsigned char           dir_in;
+	unsigned char           map_dir;
 	unsigned char           index;
 	unsigned char           mc;
 	u16                     interval;
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -289,7 +289,7 @@ static void dwc2_hsotg_unmap_dma(struct
 	if (hs_req->req.length == 0)
 		return;
 
-	usb_gadget_unmap_request(&hsotg->gadget, req, hs_ep->dir_in);
+	usb_gadget_unmap_request(&hsotg->gadget, req, hs_ep->map_dir);
 }
 
 /**
@@ -707,6 +707,7 @@ static int dwc2_hsotg_map_dma(struct dwc
 	if (hs_req->req.length == 0)
 		return 0;
 
+	hs_ep->map_dir = hs_ep->dir_in;
 	ret = usb_gadget_map_request(&hsotg->gadget, req, hs_ep->dir_in);
 	if (ret)
 		goto dma_error;



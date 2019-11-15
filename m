Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4101FFD637
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfKOGWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:22:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727734AbfKOGWa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:30 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BDDD2053B;
        Fri, 15 Nov 2019 06:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798949;
        bh=acL8ZUaE2aeTjwaN9MdvXUywSSnyKB1q0nlaYzlUDWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JTqUGDSb8TmFxUC3ynzMqYg66GfiAmfwav26mE74Zc0BDoT6c09sCB7CjDiUdg51q
         2rsu7PHnKLeDlLFcD8BknhCj3hwuNwAc8vgEUg1M4smhLxrQpSguyaKgZbLT8NTc+F
         ED37ryh2kRcjxTpBEOaBiligxEawLhISfzwztNSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Pham <jackp@codeaurora.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 4.9 04/31] usb: gadget: core: unmap request from DMA only if previously mapped
Date:   Fri, 15 Nov 2019 14:20:33 +0800
Message-Id: <20191115062011.038703072@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
References: <20191115062009.813108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Pham <jackp@codeaurora.org>

commit 31fe084ffaaf8abece14f8ca28e5e3b4e2bf97b6 upstream.

In the SG case this is already handled since a non-zero
request->num_mapped_sgs is a clear indicator that dma_map_sg()
had been called. While it would be nice to do the same for the
singly mapped case by simply checking for non-zero request->dma,
it's conceivable that 0 is a valid dma_addr_t handle. Hence add
a flag 'dma_mapped' to struct usb_request and use this to
determine the need to call dma_unmap_single(). Otherwise, if a
request is not DMA mapped then the result of calling
usb_request_unmap_request() would safely be a no-op.

Signed-off-by: Jack Pham <jackp@codeaurora.org>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/core.c |    5 ++++-
 include/linux/usb/gadget.h    |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -817,6 +817,8 @@ int usb_gadget_map_request_by_dev(struct
 			dev_err(dev, "failed to map buffer\n");
 			return -EFAULT;
 		}
+
+		req->dma_mapped = 1;
 	}
 
 	return 0;
@@ -841,9 +843,10 @@ void usb_gadget_unmap_request_by_dev(str
 				is_in ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 
 		req->num_mapped_sgs = 0;
-	} else {
+	} else if (req->dma_mapped) {
 		dma_unmap_single(dev, req->dma, req->length,
 				is_in ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+		req->dma_mapped = 0;
 	}
 }
 EXPORT_SYMBOL_GPL(usb_gadget_unmap_request_by_dev);
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -48,6 +48,7 @@ struct usb_ep;
  *     by adding a zero length packet as needed;
  * @short_not_ok: When reading data, makes short packets be
  *     treated as errors (queue stops advancing till cleanup).
+ * @dma_mapped: Indicates if request has been mapped to DMA (internal)
  * @complete: Function called when request completes, so this request and
  *	its buffer may be re-used.  The function will always be called with
  *	interrupts disabled, and it must not sleep.
@@ -103,6 +104,7 @@ struct usb_request {
 	unsigned		no_interrupt:1;
 	unsigned		zero:1;
 	unsigned		short_not_ok:1;
+	unsigned		dma_mapped:1;
 
 	void			(*complete)(struct usb_ep *ep,
 					struct usb_request *req);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642B3171FCA
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731505AbgB0Oih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:38:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731787AbgB0N4F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:56:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15ECC21D7E;
        Thu, 27 Feb 2020 13:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811764;
        bh=xHtMxxoPF/hZUvPjSzLSqsgIEzYTBbxy7+bvmauwNsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyGJVUi2BZpxMi/4glxGKN5RA5rWxsu0cVTTBQA/krJYhMKQmDl0SNJm2Mi9Ji+L/
         AgUwXrqjOcfwjU9Yu+JnYVCSNBKSgMk6uMK36Rycn1APnZyRMgivfThfDW0YFxDI6X
         FTXe8wVAXVoMMoZb3++wCpcOTO+klqITFIom0efE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 092/237] dmaengine: Store module owner in dma_device struct
Date:   Thu, 27 Feb 2020 14:35:06 +0100
Message-Id: <20200227132303.789587508@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit dae7a589c18a4d979d5f14b09374e871b995ceb1 ]

dma_chan_to_owner() dereferences the driver from the struct device to
obtain the owner and call module_[get|put](). However, if the backing
device is unbound before the dma_device is unregistered, the driver
will be cleared and this will cause a NULL pointer dereference.

Instead, store a pointer to the owner module in the dma_device struct
so the module reference can be properly put when the channel is put, even
if the backing device was destroyed first.

This change helps to support a safer unbind of DMA engines.
If the dma_device is unregistered in the driver's remove function,
there's no guarantee that there are no existing clients and a users
action may trigger the WARN_ONCE in dma_async_device_unregister()
which is unlikely to leave the system in a consistent state.
Instead, a better approach is to allow the backing driver to go away
and fail any subsequent requests to it.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Link: https://lore.kernel.org/r/20191216190120.21374-2-logang@deltatee.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmaengine.c   | 4 +++-
 include/linux/dmaengine.h | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index b451354735d3d..faaaf10311ec0 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -192,7 +192,7 @@ __dma_device_satisfies_mask(struct dma_device *device,
 
 static struct module *dma_chan_to_owner(struct dma_chan *chan)
 {
-	return chan->device->dev->driver->owner;
+	return chan->device->owner;
 }
 
 /**
@@ -928,6 +928,8 @@ int dma_async_device_register(struct dma_device *device)
 		return -EIO;
 	}
 
+	device->owner = device->dev->driver->owner;
+
 	if (dma_has_cap(DMA_MEMCPY, device->cap_mask) && !device->device_prep_dma_memcpy) {
 		dev_err(device->dev,
 			"Device claims capability %s, but op is not defined\n",
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 087cbe7768680..8089e28539f16 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -677,6 +677,7 @@ struct dma_filter {
  * @fill_align: alignment shift for memset operations
  * @dev_id: unique device ID
  * @dev: struct device reference for dma mapping api
+ * @owner: owner module (automatically set based on the provided dev)
  * @src_addr_widths: bit mask of src addr widths the device supports
  * @dst_addr_widths: bit mask of dst addr widths the device supports
  * @directions: bit mask of slave direction the device supports since
@@ -738,6 +739,7 @@ struct dma_device {
 
 	int dev_id;
 	struct device *dev;
+	struct module *owner;
 
 	u32 src_addr_widths;
 	u32 dst_addr_widths;
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA0415E739
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404948AbgBNQTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:19:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392781AbgBNQTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:19:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9CB72470B;
        Fri, 14 Feb 2020 16:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697151;
        bh=xHtMxxoPF/hZUvPjSzLSqsgIEzYTBbxy7+bvmauwNsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kiilyk5p2rZO/LoYXBnJLXZAlkbpKv7VyR0+GbOlZOKNe8ScQLAWkZzRwLxZzK4Uy
         qc8xVGey48yVgyY3NIVLhuCKdBkxNBpQWv0RlEhlkIvXcKx0aW4S2tzwqTjUeRe1gz
         xPYVrCdRVebsO8VyOHBRYOeYdDGLWn0Cl10YlxjA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 090/186] dmaengine: Store module owner in dma_device struct
Date:   Fri, 14 Feb 2020 11:15:39 -0500
Message-Id: <20200214161715.18113-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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


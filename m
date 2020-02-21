Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69870167613
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732121AbgBUIIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:08:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:42356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732104AbgBUIH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:07:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E24B2073A;
        Fri, 21 Feb 2020 08:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272478;
        bh=Aa4LQc/fQ6MQQpm24YQGRNw2rQxRYku0iwSvM44nrAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvGYT+lJGn3AUpUcdaOhN3fPOPog/RHNQpd5FhXtIygPN+BVVdRHztA1gw4BuTNEb
         eX2BObH/MR0hJVxW8QVFALOIu7LHUCLZuZJGKB4exnKRTqGiSMSN7yzNZB4oxc91mT
         px0u0qfBYUS0ITYRzuRhLOJI0T9Ut4LSTXgShNBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 159/344] dmaengine: Store module owner in dma_device struct
Date:   Fri, 21 Feb 2020 08:39:18 +0100
Message-Id: <20200221072403.249875551@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
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
index 03ac4b96117cd..4b604086b1b3a 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -179,7 +179,7 @@ __dma_device_satisfies_mask(struct dma_device *device,
 
 static struct module *dma_chan_to_owner(struct dma_chan *chan)
 {
-	return chan->device->dev->driver->owner;
+	return chan->device->owner;
 }
 
 /**
@@ -919,6 +919,8 @@ int dma_async_device_register(struct dma_device *device)
 		return -EIO;
 	}
 
+	device->owner = device->dev->driver->owner;
+
 	if (dma_has_cap(DMA_MEMCPY, device->cap_mask) && !device->device_prep_dma_memcpy) {
 		dev_err(device->dev,
 			"Device claims capability %s, but op is not defined\n",
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index dad4a68fa0094..8013562751a50 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -674,6 +674,7 @@ struct dma_filter {
  * @fill_align: alignment shift for memset operations
  * @dev_id: unique device ID
  * @dev: struct device reference for dma mapping api
+ * @owner: owner module (automatically set based on the provided dev)
  * @src_addr_widths: bit mask of src addr widths the device supports
  *	Width is specified in bytes, e.g. for a device supporting
  *	a width of 4 the mask should have BIT(4) set.
@@ -737,6 +738,7 @@ struct dma_device {
 
 	int dev_id;
 	struct device *dev;
+	struct module *owner;
 
 	u32 src_addr_widths;
 	u32 dst_addr_widths;
-- 
2.20.1




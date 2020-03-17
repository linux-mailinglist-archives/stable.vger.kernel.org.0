Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3782C188195
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgCQLFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726947AbgCQLFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:05:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4BB520719;
        Tue, 17 Mar 2020 11:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443130;
        bh=CRAiRsPj69C9ETgEGNxuhbb4Z/h1iywmuW62uuQ1YmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJZId0tjesQMR5VZNQefo8lrDS7qXutk05m4oCor70322EeRnHatE2hC9aJCEBSG/
         QHKJ3sTPtsa5yOoaNapR36MT17NdYKjPra0oO0j0DdWSddEYMCm6YJr1MioBAH80Ru
         etG+5U2dCZhN2kZOksdddid0ibnDzAzCx4uPH7fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Artem S . Tashkinov" <aros@gmx.com>
Subject: [PATCH 5.4 105/123] driver code: clarify and fix platform device DMA mask allocation
Date:   Tue, 17 Mar 2020 11:55:32 +0100
Message-Id: <20200317103318.293514324@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit e3a36eb6dfaeea8175c05d5915dcf0b939be6dab upstream.

This does three inter-related things to clarify the usage of the
platform device dma_mask field. In the process, fix the bug introduced
by cdfee5623290 ("driver core: initialize a default DMA mask for
platform device") that caused Artem Tashkinov's laptop to not boot with
newer Fedora kernels.

This does:

 - First off, rename the field to "platform_dma_mask" to make it
   greppable.

   We have way too many different random fields called "dma_mask" in
   various data structures, where some of them are actual masks, and
   some of them are just pointers to the mask. And the structures all
   have pointers to each other, or embed each other inside themselves,
   and "pdev" sometimes means "platform device" and sometimes it means
   "PCI device".

   So to make it clear in the code when you actually use this new field,
   give it a unique name (it really should be something even more unique
   like "platform_device_dma_mask", since it's per platform device, not
   per platform, but that gets old really fast, and this is unique
   enough in context).

   To further clarify when the field gets used, initialize it when we
   actually start using it with the default value.

 - Then, use this field instead of the random one-off allocation in
   platform_device_register_full() that is now unnecessary since we now
   already have a perfectly fine allocation for it in the platform
   device structure.

 - The above then allows us to fix the actual bug, where the error path
   of platform_device_register_full() would unconditionally free the
   platform device DMA allocation with 'kfree()'.

   That kfree() was dont regardless of whether the allocation had been
   done earlier with the (now removed) kmalloc, or whether
   setup_pdev_dma_masks() had already been used and the dma_mask pointer
   pointed to the mask that was part of the platform device.

It seems most people never triggered the error path, or only triggered
it from a call chain that set an explicit pdevinfo->dma_mask value (and
thus caused the unnecessary allocation that was "cleaned up" in the
error path) before calling platform_device_register_full().

Robin Murphy points out that in Artem's case the wdat_wdt driver failed
in platform_device_add(), and that was the one that had called
platform_device_register_full() with pdevinfo.dma_mask = 0, and would
have caused that kfree() of pdev.dma_mask corrupting the heap.

A later unrelated kmalloc() then oopsed due to the heap corruption.

Fixes: cdfee5623290 ("driver core: initialize a default DMA mask for platform device")
Reported-bisected-and-tested-by:  Artem S. Tashkinov <aros@gmx.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/platform.c         |   25 ++++++-------------------
 include/linux/platform_device.h |    2 +-
 2 files changed, 7 insertions(+), 20 deletions(-)

--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -335,10 +335,10 @@ static void setup_pdev_dma_masks(struct
 {
 	if (!pdev->dev.coherent_dma_mask)
 		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	if (!pdev->dma_mask)
-		pdev->dma_mask = DMA_BIT_MASK(32);
-	if (!pdev->dev.dma_mask)
-		pdev->dev.dma_mask = &pdev->dma_mask;
+	if (!pdev->dev.dma_mask) {
+		pdev->platform_dma_mask = DMA_BIT_MASK(32);
+		pdev->dev.dma_mask = &pdev->platform_dma_mask;
+	}
 };
 
 /**
@@ -634,20 +634,8 @@ struct platform_device *platform_device_
 	pdev->dev.of_node_reused = pdevinfo->of_node_reused;
 
 	if (pdevinfo->dma_mask) {
-		/*
-		 * This memory isn't freed when the device is put,
-		 * I don't have a nice idea for that though.  Conceptually
-		 * dma_mask in struct device should not be a pointer.
-		 * See http://thread.gmane.org/gmane.linux.kernel.pci/9081
-		 */
-		pdev->dev.dma_mask =
-			kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
-		if (!pdev->dev.dma_mask)
-			goto err;
-
-		kmemleak_ignore(pdev->dev.dma_mask);
-
-		*pdev->dev.dma_mask = pdevinfo->dma_mask;
+		pdev->platform_dma_mask = pdevinfo->dma_mask;
+		pdev->dev.dma_mask = &pdev->platform_dma_mask;
 		pdev->dev.coherent_dma_mask = pdevinfo->dma_mask;
 	}
 
@@ -672,7 +660,6 @@ struct platform_device *platform_device_
 	if (ret) {
 err:
 		ACPI_COMPANION_SET(&pdev->dev, NULL);
-		kfree(pdev->dev.dma_mask);
 		platform_device_put(pdev);
 		return ERR_PTR(ret);
 	}
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -24,7 +24,7 @@ struct platform_device {
 	int		id;
 	bool		id_auto;
 	struct device	dev;
-	u64		dma_mask;
+	u64		platform_dma_mask;
 	u32		num_resources;
 	struct resource	*resource;
 



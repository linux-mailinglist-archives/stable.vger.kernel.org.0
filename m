Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28D73114AF
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhBEWMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:12:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232718AbhBEOld (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:41:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D606464FD0;
        Fri,  5 Feb 2021 14:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534160;
        bh=ePV3E3Q2N8Cym8wCMus8yYv56jQDOqHPC0gGL7Ap4to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4l+R8/m3O05FxM20NaY8kxuzzJyhF0tN1PAGm0PSs0YhDnGtTYM2mzycEoYFMwLH
         HeTFZVhcJzg9bThqqsDsctHDgGnEd4f7sR2HsuCE+22rxBqBKA37VRj3Y3sUEzLAIo
         du70f5LxmXs4B3/zfyTDVILj10oauoR3jTrb88Jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH 5.10 11/57] drm/panfrost: Support cache-coherent integrations
Date:   Fri,  5 Feb 2021 15:06:37 +0100
Message-Id: <20210205140656.464052816@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit 268af50f38b1f2199a2e85e38073d7a25c20190c upstream.

When the GPU's ACE-Lite interface is fully wired up and capable of
snooping CPU caches, it may be described as "dma-coherent" in
devicetree, which will already inform the DMA layer not to perform
unnecessary cache maintenance. However, we still need to ensure that
the GPU uses the appropriate cacheable outer-shareable attributes in
order to generate the requisite snoop signals, and that CPU mappings
don't create a mismatch by using a non-cacheable type either.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/7024ce18c1cb1a226e918037d49175571db0b436.1600780574.git.robin.murphy@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_device.h |    1 +
 drivers/gpu/drm/panfrost/panfrost_drv.c    |    2 ++
 drivers/gpu/drm/panfrost/panfrost_gem.c    |    2 ++
 drivers/gpu/drm/panfrost/panfrost_mmu.c    |    1 +
 4 files changed, 6 insertions(+)

--- a/drivers/gpu/drm/panfrost/panfrost_device.h
+++ b/drivers/gpu/drm/panfrost/panfrost_device.h
@@ -88,6 +88,7 @@ struct panfrost_device {
 	/* pm_domains for devices with more than one. */
 	struct device *pm_domain_devs[MAX_PM_DOMAINS];
 	struct device_link *pm_domain_links[MAX_PM_DOMAINS];
+	bool coherent;
 
 	struct panfrost_features features;
 	const struct panfrost_compatible *comp;
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -587,6 +587,8 @@ static int panfrost_probe(struct platfor
 	if (!pfdev->comp)
 		return -ENODEV;
 
+	pfdev->coherent = device_get_dma_attr(&pdev->dev) == DEV_DMA_COHERENT;
+
 	/* Allocate and initialze the DRM device. */
 	ddev = drm_dev_alloc(&panfrost_drm_driver, &pdev->dev);
 	if (IS_ERR(ddev))
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -218,6 +218,7 @@ static const struct drm_gem_object_funcs
  */
 struct drm_gem_object *panfrost_gem_create_object(struct drm_device *dev, size_t size)
 {
+	struct panfrost_device *pfdev = dev->dev_private;
 	struct panfrost_gem_object *obj;
 
 	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
@@ -227,6 +228,7 @@ struct drm_gem_object *panfrost_gem_crea
 	INIT_LIST_HEAD(&obj->mappings.list);
 	mutex_init(&obj->mappings.lock);
 	obj->base.base.funcs = &panfrost_gem_funcs;
+	obj->base.map_cached = pfdev->coherent;
 
 	return &obj->base.base;
 }
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -371,6 +371,7 @@ int panfrost_mmu_pgtable_alloc(struct pa
 		.pgsize_bitmap	= SZ_4K | SZ_2M,
 		.ias		= FIELD_GET(0xff, pfdev->features.mmu_features),
 		.oas		= FIELD_GET(0xff00, pfdev->features.mmu_features),
+		.coherent_walk	= pfdev->coherent,
 		.tlb		= &mmu_tlb_ops,
 		.iommu_dev	= pfdev->dev,
 	};



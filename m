Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E30849721A
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbiAWO1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:27:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38304 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiAWO1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:27:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E281860C97
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9119C340E2;
        Sun, 23 Jan 2022 14:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642948040;
        bh=4mPHJADAV8kbFcRs8GnMPA5wPep4OizT+Hi2r2DHSqM=;
        h=Subject:To:Cc:From:Date:From;
        b=PWdUdiPdWCdu72tnySdgCh64KdsjOOLER8vl4p5ggTFbKPEGQlZQBjXQr5rxo8TaE
         kTmHnEYCOskiRbByUGJMQdK1rH4PHifv3pK0tDD/+2bwx9r0B6JMhle8SWP75ZDVMQ
         00+B8o8ANQyKURZHPQqa38kODjpd/0E3YxKq2bVU=
Subject: FAILED: patch "[PATCH] drm/tegra: Add back arm_iommu_detach_device()" failed to apply to 5.10-stable tree
To:     digetx@gmail.com, treding@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:27:17 +0100
Message-ID: <1642948037215200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d210919dbdc8a82c676cc3e3c370b1802be63124 Mon Sep 17 00:00:00 2001
From: Dmitry Osipenko <digetx@gmail.com>
Date: Sat, 4 Dec 2021 17:58:49 +0300
Subject: [PATCH] drm/tegra: Add back arm_iommu_detach_device()

DMA buffers of 2D/3D engines aren't mapped properly when
CONFIG_ARM_DMA_USE_IOMMU=y. The memory management code of Tegra DRM driver
has a longstanding overhaul overdue and it's not obvious where the problem
is in this case. Hence let's add back the old workaround which we already
had sometime before. It explicitly detaches DRM devices from the offending
implicit IOMMU domain. This fixes a completely broken 2d/3d drivers in
case of ARM32 multiplatform kernel config.

Cc: stable@vger.kernel.org
Fixes: fa6661b7aa0b ("drm/tegra: Optionally attach clients to the IOMMU")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>

diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index dc04ce329be3..e9de91a4e7e8 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -22,6 +22,10 @@
 #include <drm/drm_prime.h>
 #include <drm/drm_vblank.h>
 
+#if IS_ENABLED(CONFIG_ARM_DMA_USE_IOMMU)
+#include <asm/dma-iommu.h>
+#endif
+
 #include "dc.h"
 #include "drm.h"
 #include "gem.h"
@@ -945,6 +949,17 @@ int host1x_client_iommu_attach(struct host1x_client *client)
 	struct iommu_group *group = NULL;
 	int err;
 
+#if IS_ENABLED(CONFIG_ARM_DMA_USE_IOMMU)
+	if (client->dev->archdata.mapping) {
+		struct dma_iommu_mapping *mapping =
+				to_dma_iommu_mapping(client->dev);
+		arm_iommu_detach_device(client->dev);
+		arm_iommu_release_mapping(mapping);
+
+		domain = iommu_get_domain_for_dev(client->dev);
+	}
+#endif
+
 	/*
 	 * If the host1x client is already attached to an IOMMU domain that is
 	 * not the shared IOMMU domain, don't try to attach it to a different


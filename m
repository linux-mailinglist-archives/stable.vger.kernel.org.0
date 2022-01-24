Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0904998C1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450546AbiAXV3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351988AbiAXVTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:19:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B1BC06F8CB;
        Mon, 24 Jan 2022 12:12:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A0EB61375;
        Mon, 24 Jan 2022 20:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FCAC340E7;
        Mon, 24 Jan 2022 20:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055177;
        bh=RHR1IXkcIgk2HJtIz0MhPowxjEOro65WsiGHJqwdpCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVcLS4MlqI9lBDZAkRptHIUKQq26FuWR9YmaM8shZek6anmde8LOyBz9DefcdSf4l
         plZzyVbPbSa2vHv5fkBQLusP0IY0BqcfF6BIcmG15yAk3bk7C6h+gWK50W/7hY+sA4
         jbzv1atBlFIVOlm7jEbSlOrXeOSpnFQGeL1ea4co=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.15 066/846] drm/tegra: Add back arm_iommu_detach_device()
Date:   Mon, 24 Jan 2022 19:33:03 +0100
Message-Id: <20220124184103.245035526@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit d210919dbdc8a82c676cc3e3c370b1802be63124 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tegra/drm.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -21,6 +21,10 @@
 #include <drm/drm_prime.h>
 #include <drm/drm_vblank.h>
 
+#if IS_ENABLED(CONFIG_ARM_DMA_USE_IOMMU)
+#include <asm/dma-iommu.h>
+#endif
+
 #include "dc.h"
 #include "drm.h"
 #include "gem.h"
@@ -936,6 +940,17 @@ int host1x_client_iommu_attach(struct ho
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



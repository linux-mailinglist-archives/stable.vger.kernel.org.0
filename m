Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89317157581
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbgBJMl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729341AbgBJMl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:27 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C2F324673;
        Mon, 10 Feb 2020 12:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338486;
        bh=hkEnUfo3gIpI5UsuahEaHjobKSwSY8s5EkNKN2Bpjmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXN67tDFDVTvpmIW1Oyw/F2ttVozmlqXxq7PnQEtCECh46vEyzWgW6CeWm+B7uPlt
         C0bxc21JP/89jcu0mW754UZSmyG5fqCDWcx2hTEcusyc39Kp9TBG7ahm14SuyBZeG8
         MOtre9u6FJOMuXyE3Mbhr8sFByfZHYzNGfnM75cY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>
Subject: [PATCH 5.5 267/367] drm/tegra: Relax IOMMU usage criteria on old Tegra
Date:   Mon, 10 Feb 2020 04:33:00 -0800
Message-Id: <20200210122449.054834658@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

commit 2d9384ff91770a71bd1ff24c25952ef1187a0e9c upstream.

Older Tegra devices only allow addressing 32 bits of memory, so whether
or not the host1x is attached to an IOMMU doesn't matter. host1x IOMMU
attachment is only needed on devices that can address memory beyond the
32-bit boundary and where the host1x doesn't support the wide GATHER
opcode that allows it to access buffers at higher addresses.

Cc: <stable@vger.kernel.org> # v5.5
Signed-off-by: Thierry Reding <treding@nvidia.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/tegra/drm.c |   49 ++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -1037,23 +1037,9 @@ void tegra_drm_free(struct tegra_drm *te
 	free_pages((unsigned long)virt, get_order(size));
 }
 
-static int host1x_drm_probe(struct host1x_device *dev)
+static bool host1x_drm_wants_iommu(struct host1x_device *dev)
 {
-	struct drm_driver *driver = &tegra_drm_driver;
 	struct iommu_domain *domain;
-	struct tegra_drm *tegra;
-	struct drm_device *drm;
-	int err;
-
-	drm = drm_dev_alloc(driver, &dev->dev);
-	if (IS_ERR(drm))
-		return PTR_ERR(drm);
-
-	tegra = kzalloc(sizeof(*tegra), GFP_KERNEL);
-	if (!tegra) {
-		err = -ENOMEM;
-		goto put;
-	}
 
 	/*
 	 * If the Tegra DRM clients are backed by an IOMMU, push buffers are
@@ -1082,9 +1068,38 @@ static int host1x_drm_probe(struct host1
 	 * up the device tree appropriately. This is considered an problem
 	 * of integration, so care must be taken for the DT to be consistent.
 	 */
-	domain = iommu_get_domain_for_dev(drm->dev->parent);
+	domain = iommu_get_domain_for_dev(dev->dev.parent);
+
+	/*
+	 * Tegra20 and Tegra30 don't support addressing memory beyond the
+	 * 32-bit boundary, so the regular GATHER opcodes will always be
+	 * sufficient and whether or not the host1x is attached to an IOMMU
+	 * doesn't matter.
+	 */
+	if (!domain && dma_get_mask(dev->dev.parent) <= DMA_BIT_MASK(32))
+		return true;
+
+	return domain != NULL;
+}
+
+static int host1x_drm_probe(struct host1x_device *dev)
+{
+	struct drm_driver *driver = &tegra_drm_driver;
+	struct tegra_drm *tegra;
+	struct drm_device *drm;
+	int err;
+
+	drm = drm_dev_alloc(driver, &dev->dev);
+	if (IS_ERR(drm))
+		return PTR_ERR(drm);
+
+	tegra = kzalloc(sizeof(*tegra), GFP_KERNEL);
+	if (!tegra) {
+		err = -ENOMEM;
+		goto put;
+	}
 
-	if (domain && iommu_present(&platform_bus_type)) {
+	if (host1x_drm_wants_iommu(dev) && iommu_present(&platform_bus_type)) {
 		tegra->domain = iommu_domain_alloc(&platform_bus_type);
 		if (!tegra->domain) {
 			err = -ENOMEM;



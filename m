Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A39D1D8340
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732624AbgERSDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732089AbgERSDN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:03:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 049CA2087D;
        Mon, 18 May 2020 18:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824993;
        bh=diiVx+TMqGWpq3wIlg8bfWNg67/JwJNk0HLJd5akJTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BuDj5h6YoB6qIqXs0JbvCJ1b2JBtFEr3Gk2ckopmDOnl0w9BeXzLozoX9dVSyNd9O
         206h7cTiBrU8NW/pNXW2ZNb/GGRwJMuLf6dwIUMeRbSbeXezaeR+rlZI4Hs4wDe1qC
         Y4HYM+JQhO8Obm0ZZpKtYrTXwHv25izOsSM94+Mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 079/194] drm/tegra: Fix SMMU support on Tegra124 and Tegra210
Date:   Mon, 18 May 2020 19:36:09 +0200
Message-Id: <20200518173538.361802898@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 501be6c1c72417eab05e7413671a38ea991a8ebc ]

When testing whether or not to enable the use of the SMMU, consult the
supported DMA mask rather than the actually configured DMA mask, since
the latter might already have been restricted.

Fixes: 2d9384ff9177 ("drm/tegra: Relax IOMMU usage criteria on old Tegra")
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/drm.c |  3 ++-
 drivers/gpu/host1x/dev.c    | 13 +++++++++++++
 include/linux/host1x.h      |  3 +++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index bd268028fb3d6..583cd6e0ae27f 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -1039,6 +1039,7 @@ void tegra_drm_free(struct tegra_drm *tegra, size_t size, void *virt,
 
 static bool host1x_drm_wants_iommu(struct host1x_device *dev)
 {
+	struct host1x *host1x = dev_get_drvdata(dev->dev.parent);
 	struct iommu_domain *domain;
 
 	/*
@@ -1076,7 +1077,7 @@ static bool host1x_drm_wants_iommu(struct host1x_device *dev)
 	 * sufficient and whether or not the host1x is attached to an IOMMU
 	 * doesn't matter.
 	 */
-	if (!domain && dma_get_mask(dev->dev.parent) <= DMA_BIT_MASK(32))
+	if (!domain && host1x_get_dma_mask(host1x) <= DMA_BIT_MASK(32))
 		return true;
 
 	return domain != NULL;
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 388bcc2889aaf..40a4b9f8b861a 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -502,6 +502,19 @@ static void __exit tegra_host1x_exit(void)
 }
 module_exit(tegra_host1x_exit);
 
+/**
+ * host1x_get_dma_mask() - query the supported DMA mask for host1x
+ * @host1x: host1x instance
+ *
+ * Note that this returns the supported DMA mask for host1x, which can be
+ * different from the applicable DMA mask under certain circumstances.
+ */
+u64 host1x_get_dma_mask(struct host1x *host1x)
+{
+	return host1x->info->dma_mask;
+}
+EXPORT_SYMBOL(host1x_get_dma_mask);
+
 MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
 MODULE_AUTHOR("Terje Bergstrom <tbergstrom@nvidia.com>");
 MODULE_DESCRIPTION("Host1x driver for Tegra products");
diff --git a/include/linux/host1x.h b/include/linux/host1x.h
index 62d216ff10979..c230b4e70d759 100644
--- a/include/linux/host1x.h
+++ b/include/linux/host1x.h
@@ -17,9 +17,12 @@ enum host1x_class {
 	HOST1X_CLASS_GR3D = 0x60,
 };
 
+struct host1x;
 struct host1x_client;
 struct iommu_group;
 
+u64 host1x_get_dma_mask(struct host1x *host1x);
+
 /**
  * struct host1x_client_ops - host1x client operations
  * @init: host1x client initialization code
-- 
2.20.1




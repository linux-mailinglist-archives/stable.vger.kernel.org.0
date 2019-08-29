Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842AFA25CF
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbfH2Scg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728684AbfH2SN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:13:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AA2C233FF;
        Thu, 29 Aug 2019 18:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102438;
        bh=E2I92oP8BJAkr+Nu768x0W5VL/Hqr9oH52PC4aG07Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZHpuzumNpDIc6TRB9qj+dzCAmbjKQTQsC32nE6kxP9TUa6if+T79B+rkjR2ET7Wm
         yDseUt60jWk5YDcF3pRCavuptDqedHyJfsnLvCw1deJhoHsZy9D+LV9DHl488e0zqc
         HNmsfktU9n/haVHuCUHSrEjqauEQ1itheJX9KXzU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        CK Hu <ck.hu@mediatek.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 27/76] drm/mediatek: use correct device to import PRIME buffers
Date:   Thu, 29 Aug 2019 14:12:22 -0400
Message-Id: <20190829181311.7562-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Courbot <acourbot@chromium.org>

[ Upstream commit 4c6f3196e6ea111c456c6086dc3f57d4706b0b2d ]

PRIME buffers should be imported using the DMA device. To this end, use
a custom import function that mimics drm_gem_prime_import_dev(), but
passes the correct device.

Fixes: 119f5173628aa ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
Signed-off-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index 95fdbd0fbcace..8b18a00a58c7e 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -320,6 +320,18 @@ static const struct file_operations mtk_drm_fops = {
 	.compat_ioctl = drm_compat_ioctl,
 };
 
+/*
+ * We need to override this because the device used to import the memory is
+ * not dev->dev, as drm_gem_prime_import() expects.
+ */
+struct drm_gem_object *mtk_drm_gem_prime_import(struct drm_device *dev,
+						struct dma_buf *dma_buf)
+{
+	struct mtk_drm_private *private = dev->dev_private;
+
+	return drm_gem_prime_import_dev(dev, dma_buf, private->dma_dev);
+}
+
 static struct drm_driver mtk_drm_driver = {
 	.driver_features = DRIVER_MODESET | DRIVER_GEM | DRIVER_PRIME |
 			   DRIVER_ATOMIC,
@@ -331,7 +343,7 @@ static struct drm_driver mtk_drm_driver = {
 	.prime_handle_to_fd = drm_gem_prime_handle_to_fd,
 	.prime_fd_to_handle = drm_gem_prime_fd_to_handle,
 	.gem_prime_export = drm_gem_prime_export,
-	.gem_prime_import = drm_gem_prime_import,
+	.gem_prime_import = mtk_drm_gem_prime_import,
 	.gem_prime_get_sg_table = mtk_gem_prime_get_sg_table,
 	.gem_prime_import_sg_table = mtk_gem_prime_import_sg_table,
 	.gem_prime_mmap = mtk_drm_gem_mmap_buf,
-- 
2.20.1


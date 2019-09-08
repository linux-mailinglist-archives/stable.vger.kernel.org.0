Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC45CACE62
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbfIHMrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:47:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730694AbfIHMra (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:47:30 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7038C218AF;
        Sun,  8 Sep 2019 12:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946850;
        bh=nwkRrgxWKfz0mUWoAEQETgxxEmFC+2XRWGejen9Xk1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXQe9hrDbDeEqIqOixZKcopyy8RVc7OCNZmYOtgoLE5pqeqyKNGNCEald9gudq5jz
         zWp990Ud0gZPX01EUliwBzDFx9VIoVwVvGKhIMsShGVh4mIpRKrX9q/9CEd5UTarmO
         PDmpEmC9Aedh9Aec+M/7L4TxncbyDAjogZ8ul8ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandre Courbot <acourbot@chromium.org>,
        CK Hu <ck.hu@mediatek.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/57] drm/mediatek: use correct device to import PRIME buffers
Date:   Sun,  8 Sep 2019 13:41:47 +0100
Message-Id: <20190908121134.861158277@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index fd83046d8376b..ffb997440851d 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -327,6 +327,18 @@ static const struct file_operations mtk_drm_fops = {
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
@@ -338,7 +350,7 @@ static struct drm_driver mtk_drm_driver = {
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




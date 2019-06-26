Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A739756088
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfFZDl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726940AbfFZDl5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:41:57 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E780920659;
        Wed, 26 Jun 2019 03:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520516;
        bh=CrgPhh6NVXQkJspXilHsLzt07uvH4FlYJ3HLALbyZL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHyIvMx8WoE3KkjTMgFZjgy9XTaB6hTGI0tUlVYlziAGT/KkBbahSX96R2et/NBX7
         y3kM2dtbdlkimM4oSy5HYsgHuv/bfFL4Hw0xgEWlC0tN17g3nErX80h9FBgLPYMlqX
         LrqHoUAwYcz0SU9Hhg4NskA2KSfMl5Z/98kYPWZA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hsin-Yi Wang <hsinyi@chromium.org>, CK Hu <ck.hu@mediatek.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 16/51] drm/mediatek: unbind components in mtk_drm_unbind()
Date:   Tue, 25 Jun 2019 23:40:32 -0400
Message-Id: <20190626034117.23247-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit f0fd848342802bc0f74620d387eead53e8905804 ]

Unbinding components (i.e. mtk_dsi and mtk_disp_ovl/rdma/color) will
trigger master(mtk_drm)'s .unbind(), and currently mtk_drm's unbind
won't actually unbind components. During the next bind,
mtk_drm_kms_init() is called, and the components are added back.

.unbind() should call mtk_drm_kms_deinit() to unbind components.

And since component_master_del() in .remove() will trigger .unbind(),
which will also unregister device, it's fine to remove original functions
called here.

Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Signed-off-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index 57ce4708ef1b..e7362bdafa82 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -397,6 +397,7 @@ static void mtk_drm_unbind(struct device *dev)
 	struct mtk_drm_private *private = dev_get_drvdata(dev);
 
 	drm_dev_unregister(private->drm);
+	mtk_drm_kms_deinit(private->drm);
 	drm_dev_put(private->drm);
 	private->drm = NULL;
 }
@@ -568,13 +569,8 @@ static int mtk_drm_probe(struct platform_device *pdev)
 static int mtk_drm_remove(struct platform_device *pdev)
 {
 	struct mtk_drm_private *private = platform_get_drvdata(pdev);
-	struct drm_device *drm = private->drm;
 	int i;
 
-	drm_dev_unregister(drm);
-	mtk_drm_kms_deinit(drm);
-	drm_dev_put(drm);
-
 	component_master_del(&pdev->dev, &mtk_drm_ops);
 	pm_runtime_disable(&pdev->dev);
 	of_node_put(private->mutex_node);
-- 
2.20.1


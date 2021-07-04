Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551213BB0EF
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhGDXJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231768AbhGDXJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:09:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30BF6611ED;
        Sun,  4 Jul 2021 23:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439990;
        bh=c5RGKMO/Iij/OF/EMGrK9bgD+2TCuXmHaKdi0NSsXx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5E/5sojpdRZPuxteqBfJ6FRfBy+hYZZz+D0CBiEiPICeN+Vlyxr9X2UEMqMueCAM
         iaC7kZ6PI2RnrkHdoggCoOF/6V9gBBWPGRThn0PErA0x0cHrLVTtelc/CJcZG0e4pm
         0B4pk4BiK88dEqFE+NvKh61gRFXQazRNtD+gxCJjRvoLUs4YM7aHEuITEWKglsDVwb
         lM3ztyW+djVUtot+8NIHr56Z4JwGFpIBCRj2pM3aj+oNowPxVQOR3uzMn5FUtcuZ5/
         Oa3BpVNrEMf6rXH3EEfkNCJLvoUz4ZCA+RAKH3k9b1Zpd7G/DLCUijAt5x9hOGlJNm
         wCQfy6Mc2c62g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 10/80] media: mtk-vcodec: fix PM runtime get logic
Date:   Sun,  4 Jul 2021 19:05:06 -0400
Message-Id: <20210704230616.1489200-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 908711f542c17fe61e5d653da1beb8e5ab5c7b50 ]

Currently, the driver just assumes that PM runtime logic
succeded resuming the device.

That may not be the case, as pm_runtime_get_sync()
can fail (but keeping the usage count incremented).

Replace the code to use pm_runtime_resume_and_get(),
and letting it return the error code.

This way, if mtk_vcodec_dec_pw_on() fails, the logic
under fops_vcodec_open() will do the right thing and
return an error, instead of just assuming that the
device is ready to be used.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c | 4 +++-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c  | 8 +++++---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h  | 2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
index 147dfef1638d..f87dc47d9e63 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
@@ -126,7 +126,9 @@ static int fops_vcodec_open(struct file *file)
 	mtk_vcodec_dec_set_default_params(ctx);
 
 	if (v4l2_fh_is_singular(&ctx->fh)) {
-		mtk_vcodec_dec_pw_on(&dev->pm);
+		ret = mtk_vcodec_dec_pw_on(&dev->pm);
+		if (ret < 0)
+			goto err_load_fw;
 		/*
 		 * Does nothing if firmware was already loaded.
 		 */
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
index ddee7046ce42..6038db96f71c 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
@@ -88,13 +88,15 @@ void mtk_vcodec_release_dec_pm(struct mtk_vcodec_dev *dev)
 	put_device(dev->pm.larbvdec);
 }
 
-void mtk_vcodec_dec_pw_on(struct mtk_vcodec_pm *pm)
+int mtk_vcodec_dec_pw_on(struct mtk_vcodec_pm *pm)
 {
 	int ret;
 
-	ret = pm_runtime_get_sync(pm->dev);
+	ret = pm_runtime_resume_and_get(pm->dev);
 	if (ret)
-		mtk_v4l2_err("pm_runtime_get_sync fail %d", ret);
+		mtk_v4l2_err("pm_runtime_resume_and_get fail %d", ret);
+
+	return ret;
 }
 
 void mtk_vcodec_dec_pw_off(struct mtk_vcodec_pm *pm)
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h
index 872d8bf8cfaf..280aeaefdb65 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h
@@ -12,7 +12,7 @@
 int mtk_vcodec_init_dec_pm(struct mtk_vcodec_dev *dev);
 void mtk_vcodec_release_dec_pm(struct mtk_vcodec_dev *dev);
 
-void mtk_vcodec_dec_pw_on(struct mtk_vcodec_pm *pm);
+int mtk_vcodec_dec_pw_on(struct mtk_vcodec_pm *pm);
 void mtk_vcodec_dec_pw_off(struct mtk_vcodec_pm *pm);
 void mtk_vcodec_dec_clock_on(struct mtk_vcodec_pm *pm);
 void mtk_vcodec_dec_clock_off(struct mtk_vcodec_pm *pm);
-- 
2.30.2


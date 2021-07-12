Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644593C4825
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235522AbhGLGgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236582AbhGLGfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:35:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAFC661151;
        Mon, 12 Jul 2021 06:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071543;
        bh=uAPpcxsYPuPDVvfQ114HosmJn/2knSHCbfPiPY2r8DQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hp3TBouqexL12AFmF89z7qjC4pbfXE9gpqijhRlrfRrMZuhosjkgmYetQlAxn8B20
         6xNNVC189MciO/djdJXQ9t0U5Qi3BfvUFaibmsf87dfgRarJSxktaNVnhOM6dhaSvC
         8svHzlHVcr0kJVeYzlkj9ozpCiOD0vpj90jPTGYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/593] media: mtk-vcodec: fix PM runtime get logic
Date:   Mon, 12 Jul 2021 08:04:28 +0200
Message-Id: <20210712060855.092608032@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 145686d2c219..f59ef8c8c9db 100644
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




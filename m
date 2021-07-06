Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9013BD4C8
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbhGFMRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:17:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235196AbhGFLb2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:31:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F20561CCB;
        Tue,  6 Jul 2021 11:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570547;
        bh=UTqXKaW6JbYoJqpVG9EU8rB4wX9Lk/dAbhbGsvYNTr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJgCyJvE+BfGl3gwmEHluFs7t4IRt5djLdQMeiLDWLWr5RD3LpNeatBkJze9D2qxH
         irhSHAl8q7GHeZKOUUXkK3q4RchjcA4UXCvP3JvhKY/h+G1t+ecoCF0EVykSaUDhv8
         0lgJHh+JS5NKK+eB8K4W9+icCUIxgbZ4sB5CnPWjy3OcW5xYke5RNcrKmXA06lHeMV
         hJGUKpUbju0nG4Gtu5s4f5pJnM/MHWTFdErOirZp1/9YFOwu9+psWt1wtAeSuQjHmE
         EZOArg9M4MHs2At2r+36xMkV/BT6QuK6xYYfZVyvnsV13MhLLeSUs2wi+7v6zXzr22
         Gzk4G5yddQ3kg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Li <wangli74@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 017/137] drm/mediatek: Fix PM reference leak in mtk_crtc_ddp_hw_init()
Date:   Tue,  6 Jul 2021 07:20:03 -0400
Message-Id: <20210706112203.2062605-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Li <wangli74@huawei.com>

[ Upstream commit 69777e6ca396f0a7e1baff40fcad4a9d3d445b7a ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Li <wangli74@huawei.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index ac038572164d..dfd5ed15a7f4 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -274,7 +274,7 @@ static int mtk_crtc_ddp_hw_init(struct mtk_drm_crtc *mtk_crtc)
 		drm_connector_list_iter_end(&conn_iter);
 	}
 
-	ret = pm_runtime_get_sync(crtc->dev->dev);
+	ret = pm_runtime_resume_and_get(crtc->dev->dev);
 	if (ret < 0) {
 		DRM_ERROR("Failed to enable power domain: %d\n", ret);
 		return ret;
-- 
2.30.2


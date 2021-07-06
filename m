Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477A53BD16F
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbhGFLjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237055AbhGFLfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2980A61CAF;
        Tue,  6 Jul 2021 11:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570720;
        bh=dSmWd6JDaIXsyNmO6nukxpLK2YjQpLaYW/+Aqz8eNic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JnhtvgpNmzBtdNU3I8ZaM6oWiGqxIVshZOQcks4ayFK2NFt1NeQ+rGs8Yi9tRMR51
         09MvhxjGFrsgrLorR+fqU5iEtXR/C6tRe4z8ovLjeQnQ+0CO56bE3nUawXusI1kcUq
         fo78xXNaQPkwro+McbPvYtse2iRMFzd2f3i0e6k9n8Tcgn3ozsGzOww0YX2uiNWrpd
         ZYnqMmNoETAsKUrBPlwk9/hpqD9GF9rYzLx036rMlMrJJyQ7RLwQDzwAUlF3QLT57A
         lXUAjdvUcx6iovu7uxp7UuRdILmxvf8zWR92Eb/3/FGr1arOR6ag93TMSU7opA9PtW
         hX1v4bJS/XsAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Li <wangli74@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 13/74] drm/mediatek: Fix PM reference leak in mtk_crtc_ddp_hw_init()
Date:   Tue,  6 Jul 2021 07:24:01 -0400
Message-Id: <20210706112502.2064236-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index f9455f2724d2..f370d41b3d04 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -240,7 +240,7 @@ static int mtk_crtc_ddp_hw_init(struct mtk_drm_crtc *mtk_crtc)
 		drm_connector_list_iter_end(&conn_iter);
 	}
 
-	ret = pm_runtime_get_sync(crtc->dev->dev);
+	ret = pm_runtime_resume_and_get(crtc->dev->dev);
 	if (ret < 0) {
 		DRM_ERROR("Failed to enable power domain: %d\n", ret);
 		return ret;
-- 
2.30.2


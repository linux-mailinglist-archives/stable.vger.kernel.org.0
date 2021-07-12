Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863C43C542C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347650AbhGLH5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245745AbhGLHxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:53:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3575661158;
        Mon, 12 Jul 2021 07:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076223;
        bh=kIZ60M1nZfkEOjXB8kpvTant4ngMp9YGmo5D06dDtss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFiuyQcksQOlrFF9wlCj7cihb9NKjzEDk/DrimXHfF1xxt6TG20m2dU05G0y0+yXe
         KHd4SKAZrWqJPnEVkKnCn0R0n87P9rVS3S4UcEvLDBq0HzQD96Bo/3vXHLVN8xwGlS
         O6wTL/u7cHVbxnldvF20y0zlt24HYuLXlsAaxKFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 550/800] drm/msm: Fix error return code in msm_drm_init()
Date:   Mon, 12 Jul 2021 08:09:33 +0200
Message-Id: <20210712061025.889215075@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit a1c9b1e3bdd6d8dc43c18699772fb6cf4497d45a ]

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Fixes: 7f9743abaa79 ("drm/msm: validate display and event threads")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210508022836.1777-1-thunder.leizhen@huawei.com
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index fe7d17cd35ec..afd555b0c105 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -523,6 +523,7 @@ static int msm_drm_init(struct device *dev, const struct drm_driver *drv)
 		priv->event_thread[i].worker = kthread_create_worker(0,
 			"crtc_event:%d", priv->event_thread[i].crtc_id);
 		if (IS_ERR(priv->event_thread[i].worker)) {
+			ret = PTR_ERR(priv->event_thread[i].worker);
 			DRM_DEV_ERROR(dev, "failed to create crtc_event kthread\n");
 			goto err_msm_uninit;
 		}
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28029409504
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344571AbhIMOg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346311AbhIMOco (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 091CD6138E;
        Mon, 13 Sep 2021 13:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541148;
        bh=Ldj1SLwndHIjnKF0qvU9F06ohzlde54h5E1UUZ80w8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0wUKJvihdQ10jirBuIlMFY5KO136gxE7+Kzud+EODOahp3094b+6eRb6s01BIWk+8
         /Kdvi0PiEtoE7/VFSiR9SJppdb7ggpR1AHLIIOzjFcsbkbT9WdG2Vr1btWsHofpE3Y
         m450cGomaRiFLUYmm11Ccr+ZNX/k6S2QKuvCEpec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Li <liwei391@huawei.com>,
        Abhinav Kumar <abhinavk@codeaurora.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 183/334] drm/msm: Fix error return code in msm_drm_init()
Date:   Mon, 13 Sep 2021 15:13:57 +0200
Message-Id: <20210913131119.533213401@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Li <liwei391@huawei.com>

[ Upstream commit bfddcfe155a2fe448fee0169c5cbc82c7fa73491 ]

When it fail to create crtc_event kthread, it just jump to err_msm_uninit,
while the 'ret' is not updated. So assign the return code before that.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Li <liwei391@huawei.com>
Reviewed-by: Abhinav Kumar <abhinavk@codeaurora.org>
Link: https://lore.kernel.org/r/20210705134302.315813-1-liwei391@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 9b8fa2ad0d84..729ab68d0203 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -539,6 +539,7 @@ static int msm_drm_init(struct device *dev, const struct drm_driver *drv)
 		if (IS_ERR(priv->event_thread[i].worker)) {
 			ret = PTR_ERR(priv->event_thread[i].worker);
 			DRM_DEV_ERROR(dev, "failed to create crtc_event kthread\n");
+			ret = PTR_ERR(priv->event_thread[i].worker);
 			goto err_msm_uninit;
 		}
 
-- 
2.30.2




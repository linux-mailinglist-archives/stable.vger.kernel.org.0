Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3770364FFA5
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiLRQFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiLRQEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:04:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8224AB7F6;
        Sun, 18 Dec 2022 08:03:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B7DBB80BA5;
        Sun, 18 Dec 2022 16:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A44CC433D2;
        Sun, 18 Dec 2022 16:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379378;
        bh=9dKbZvUDMKixS1oltFPcGWQS3eAbwlZIq8VkoEF3F68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4CMRK54T5jMemx8bUIcA+TjAuYImRqVqGNafeI4B2MAVa98bUpONJSCCt0hKfmzn
         2PK4LRpjrFJsBD1uQ27JEnJ+Izj7fkkrrKFGwW2WXohOzcExLXSChDt10yRx42CZiX
         joKCsnLR8u0tCCXhQMVREuxnaTzAgh4ttyTO9gjWaM80jrLR0Q9O4ogSxDBSnFdgDK
         qDJJv8p5wbyaKyX6Pz+XS9zJoxYLt0tT2oe1CdkT8I37RpBYrF5dSJSbs65rkzOjCm
         4UQnrb3PLjRlFjeJpgDL7mzZ+1ydCjKBp/t5AUtBzrnga0j13yqD0jNLvmrtX2txXN
         1vpxgKIXHmUpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuan Can <yuancan@huawei.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, hjc@rock-chips.com,
        airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 16/85] drm/rockchip: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
Date:   Sun, 18 Dec 2022 11:00:33 -0500
Message-Id: <20221218160142.925394-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit e3558747ebe15306e6d0b75bd6d211436be4a7d5 ]

Replace pm_runtime_get_sync() with pm_runtime_resume_and_get() to avoid
device usage counter leak.

Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220615062644.96837-1-yuancan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c | 2 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c     | 4 ++--
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
index f4df9820b295..912eb4e94c59 100644
--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -1221,7 +1221,7 @@ static int dw_mipi_dsi_dphy_power_on(struct phy *phy)
 		return i;
 	}
 
-	ret = pm_runtime_get_sync(dsi->dev);
+	ret = pm_runtime_resume_and_get(dsi->dev);
 	if (ret < 0) {
 		DRM_DEV_ERROR(dsi->dev, "failed to enable device: %d\n", ret);
 		return ret;
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index c356de5dd220..fa1f4ee6d195 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -602,7 +602,7 @@ static int vop_enable(struct drm_crtc *crtc, struct drm_crtc_state *old_state)
 	struct vop *vop = to_vop(crtc);
 	int ret, i;
 
-	ret = pm_runtime_get_sync(vop->dev);
+	ret = pm_runtime_resume_and_get(vop->dev);
 	if (ret < 0) {
 		DRM_DEV_ERROR(vop->dev, "failed to get pm runtime: %d\n", ret);
 		return ret;
@@ -1983,7 +1983,7 @@ static int vop_initial(struct vop *vop)
 		return PTR_ERR(vop->dclk);
 	}
 
-	ret = pm_runtime_get_sync(vop->dev);
+	ret = pm_runtime_resume_and_get(vop->dev);
 	if (ret < 0) {
 		DRM_DEV_ERROR(vop->dev, "failed to get pm runtime: %d\n", ret);
 		return ret;
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 105a548d0abe..8cecf81a5ae0 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -822,7 +822,7 @@ static void vop2_enable(struct vop2 *vop2)
 {
 	int ret;
 
-	ret = pm_runtime_get_sync(vop2->dev);
+	ret = pm_runtime_resume_and_get(vop2->dev);
 	if (ret < 0) {
 		drm_err(vop2->drm, "failed to get pm runtime: %d\n", ret);
 		return;
-- 
2.35.1


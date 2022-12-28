Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3986578E0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbiL1Oz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233316AbiL1OzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:55:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDF512AAD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:55:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94A3BB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A0AC433F0;
        Wed, 28 Dec 2022 14:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239308;
        bh=Uzfdm5yFBsdYJxD9ZIaa1o9q2or1/R0r8GVgE3X1HRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jMDanLpD6yOTyWI9Hxf50vPI89xvMf/0+Wsfj31LxsNjzzuNUNAiDeBtGrZaAi/DJ
         HvE9OylS5dNpChYlVpNTE+Xux93wsYIkOA6oEA7SKC054fo4VFCLHx75EG8BdM6eSi
         hDJzo7z1+958cTG4J9gKqzpx0EU1k3JmhD8vtFdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Qilong <zhangqilong3@huawei.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 172/731] drm/rockchip: lvds: fix PM usage counter unbalance in poweron
Date:   Wed, 28 Dec 2022 15:34:39 +0100
Message-Id: <20221228144301.551156457@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 4dba27f1a14592ac4cf71c3bc1cc1fd05dea8015 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
We fix it by replacing it with the newest pm_runtime_resume_and_get
to keep usage counter balanced.

Fixes: 34cc0aa25456 ("drm/rockchip: Add support for Rockchip Soc LVDS")
Fixes: cca1705c3d89 ("drm/rockchip: lvds: Add PX30 support")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220922132107.105419-3-zhangqilong3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_lvds.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_lvds.c b/drivers/gpu/drm/rockchip/rockchip_lvds.c
index 551653940e39..2550429df49f 100644
--- a/drivers/gpu/drm/rockchip/rockchip_lvds.c
+++ b/drivers/gpu/drm/rockchip/rockchip_lvds.c
@@ -145,7 +145,7 @@ static int rk3288_lvds_poweron(struct rockchip_lvds *lvds)
 		DRM_DEV_ERROR(lvds->dev, "failed to enable lvds pclk %d\n", ret);
 		return ret;
 	}
-	ret = pm_runtime_get_sync(lvds->dev);
+	ret = pm_runtime_resume_and_get(lvds->dev);
 	if (ret < 0) {
 		DRM_DEV_ERROR(lvds->dev, "failed to get pm runtime: %d\n", ret);
 		clk_disable(lvds->pclk);
@@ -329,16 +329,20 @@ static int px30_lvds_poweron(struct rockchip_lvds *lvds)
 {
 	int ret;
 
-	ret = pm_runtime_get_sync(lvds->dev);
+	ret = pm_runtime_resume_and_get(lvds->dev);
 	if (ret < 0) {
 		DRM_DEV_ERROR(lvds->dev, "failed to get pm runtime: %d\n", ret);
 		return ret;
 	}
 
 	/* Enable LVDS mode */
-	return regmap_update_bits(lvds->grf, PX30_LVDS_GRF_PD_VO_CON1,
+	ret = regmap_update_bits(lvds->grf, PX30_LVDS_GRF_PD_VO_CON1,
 				  PX30_LVDS_MODE_EN(1) | PX30_LVDS_P2S_EN(1),
 				  PX30_LVDS_MODE_EN(1) | PX30_LVDS_P2S_EN(1));
+	if (ret)
+		pm_runtime_put(lvds->dev);
+
+	return ret;
 }
 
 static void px30_lvds_poweroff(struct rockchip_lvds *lvds)
-- 
2.35.1




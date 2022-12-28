Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD71658327
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbiL1Qoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234968AbiL1QoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:44:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8BD1C434
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:39:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF8316157D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E609BC433D2;
        Wed, 28 Dec 2022 16:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245585;
        bh=ic71UI3Iq3QBhbl9IBsyk7r3/Jf1+iWnxsPPPgm89vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=viR2aFeY06aoj5kx0EPibJaRiHbWENgWsGejb2Sr1dfD4ldUyXHm/IPMpjfvAEwCJ
         NJmgLBlBd1qkYqB7ynQFDC4SG8B6e9LahQYDJpXCo3DTIL2tPPPNxGYJnPRf8Ezy6e
         QIHYyh22+qA+cj5ek+ddZISAlNZmoCJlPX1bBWMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0918/1073] drm/rockchip: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
Date:   Wed, 28 Dec 2022 15:41:46 +0100
Message-Id: <20221228144352.963570506@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 1aa3700551f4..1e1a8bc6c856 100644
--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -1201,7 +1201,7 @@ static int dw_mipi_dsi_dphy_power_on(struct phy *phy)
 		return i;
 	}
 
-	ret = pm_runtime_get_sync(dsi->dev);
+	ret = pm_runtime_resume_and_get(dsi->dev);
 	if (ret < 0) {
 		DRM_DEV_ERROR(dsi->dev, "failed to enable device: %d\n", ret);
 		return ret;
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index ad3958b6f8bf..9a039a31fe48 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -605,7 +605,7 @@ static int vop_enable(struct drm_crtc *crtc, struct drm_crtc_state *old_state)
 	struct vop *vop = to_vop(crtc);
 	int ret, i;
 
-	ret = pm_runtime_get_sync(vop->dev);
+	ret = pm_runtime_resume_and_get(vop->dev);
 	if (ret < 0) {
 		DRM_DEV_ERROR(vop->dev, "failed to get pm runtime: %d\n", ret);
 		return ret;
@@ -1953,7 +1953,7 @@ static int vop_initial(struct vop *vop)
 		return PTR_ERR(vop->dclk);
 	}
 
-	ret = pm_runtime_get_sync(vop->dev);
+	ret = pm_runtime_resume_and_get(vop->dev);
 	if (ret < 0) {
 		DRM_DEV_ERROR(vop->dev, "failed to get pm runtime: %d\n", ret);
 		return ret;
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 1fc04019dfd8..6dc14ea7f6fc 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -823,7 +823,7 @@ static void vop2_enable(struct vop2 *vop2)
 {
 	int ret;
 
-	ret = pm_runtime_get_sync(vop2->dev);
+	ret = pm_runtime_resume_and_get(vop2->dev);
 	if (ret < 0) {
 		drm_err(vop2->drm, "failed to get pm runtime: %d\n", ret);
 		return;
-- 
2.35.1




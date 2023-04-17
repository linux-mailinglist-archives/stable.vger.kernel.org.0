Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142B56E47F3
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 14:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjDQMin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 08:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjDQMin (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 08:38:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2966E8C
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 05:38:27 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1poO7b-0006Br-ME; Mon, 17 Apr 2023 14:38:15 +0200
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1poO7T-00BseC-Rd; Mon, 17 Apr 2023 14:38:07 +0200
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1poO7T-00993Y-4i; Mon, 17 Apr 2023 14:38:07 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     dri-devel@lists.freedesktop.org
Cc:     Sandy Huang <hjc@rock-chips.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org, kernel@pengutronix.de,
        Chris Morgan <macroalpha82@gmail.com>,
        =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org
Subject: [PATCH] drm/rockchip: vop2: Use regcache_sync() to fix suspend/resume
Date:   Mon, 17 Apr 2023 14:37:47 +0200
Message-Id: <20230417123747.2179695-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

afa965a45e01 ("drm/rockchip: vop2: fix suspend/resume") uses
regmap_reinit_cache() to fix the suspend/resume issue with the VOP2
driver. During discussion it came up that we should rather use
regcache_sync() instead. As the original patch is already applied
fix this up in this follow-up patch.

Fixes: afa965a45e01 ("drm/rockchip: vop2: fix suspend/resume")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230417094215.2049231-1-s.hauer@pengutronix.de
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index d9daa686b014d..293c228a83f90 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -215,8 +215,6 @@ struct vop2 {
 	struct vop2_win win[];
 };
 
-static const struct regmap_config vop2_regmap_config;
-
 static struct vop2_video_port *to_vop2_video_port(struct drm_crtc *crtc)
 {
 	return container_of(crtc, struct vop2_video_port, crtc);
@@ -841,11 +839,7 @@ static void vop2_enable(struct vop2 *vop2)
 		return;
 	}
 
-	ret = regmap_reinit_cache(vop2->map, &vop2_regmap_config);
-	if (ret) {
-		drm_err(vop2->drm, "failed to reinit cache: %d\n", ret);
-		return;
-	}
+	regcache_sync(vop2->map);
 
 	if (vop2->data->soc_id == 3566)
 		vop2_writel(vop2, RK3568_OTP_WIN_EN, 1);
@@ -875,6 +869,8 @@ static void vop2_disable(struct vop2 *vop2)
 
 	pm_runtime_put_sync(vop2->dev);
 
+	regcache_mark_dirty(vop2->map);
+
 	clk_disable_unprepare(vop2->aclk);
 	clk_disable_unprepare(vop2->hclk);
 }
-- 
2.39.2


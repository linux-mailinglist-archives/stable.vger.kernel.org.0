Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86AF259A182
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351114AbiHSQDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351522AbiHSQBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:01:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551CB10AE39;
        Fri, 19 Aug 2022 08:53:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E7066174A;
        Fri, 19 Aug 2022 15:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1075EC433C1;
        Fri, 19 Aug 2022 15:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924429;
        bh=Fe2xvqF00PLRopeHXplDF/j9rwU7NVQeQA+xBB6pBvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wPvuxIZdgHVdz3JdayGkHprDZoH9EklwY2m8Jr0BA6rE/XEEDMeY4ZHp30o7iTQDR
         eI4ZT87yypT0xJUS8MR09/yR174LlvpGUqLkMfNIpp+DaOqZ7If6XMF/FixrPzZBIA
         f5j0bdNJNyvDuqhZfHVCi4+M7i+N+ZWKXT3Eg6O4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jitao Shi <jitao.shi@mediatek.com>,
        Xinlei Lee <xinlei.lee@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Rex-BC Chen <rex-bc.chen@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/545] drm/mediatek: Separate poweron/poweroff from enable/disable and define new funcs
Date:   Fri, 19 Aug 2022 17:38:57 +0200
Message-Id: <20220819153836.832711193@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jitao Shi <jitao.shi@mediatek.com>

[ Upstream commit cde7e2e35c2866d22a3a012e72a41052dfcc255d ]

In order to match the changes of "Use the drm_panel_bridge API",
the poweron/poweroff of dsi is extracted from enable/disable and
defined as new funcs (atomic_pre_enable/atomic_post_disable).

Since dsi_poweron is moved from dsi_enable to pre_enable function, in
order to avoid poweron failure, the operation of dsi register fails to
cause bus hang. Therefore, the protection mechanism is added to the
dsi_enable function.

Fixes: 2dd8075d2185 ("drm/mediatek: mtk_dsi: Use the drm_panel_bridge API")

Link: https://patchwork.kernel.org/project/linux-mediatek/patch/1653012007-11854-3-git-send-email-xinlei.lee@mediatek.com/
Signed-off-by: Jitao Shi <jitao.shi@mediatek.com>
Signed-off-by: Xinlei Lee <xinlei.lee@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Rex-BC Chen <rex-bc.chen@mediatek.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c | 53 +++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index 2c09b43705ef..1b13e429e9d9 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -674,16 +674,6 @@ static void mtk_dsi_poweroff(struct mtk_dsi *dsi)
 	if (--dsi->refcount != 0)
 		return;
 
-	/*
-	 * mtk_dsi_stop() and mtk_dsi_start() is asymmetric, since
-	 * mtk_dsi_stop() should be called after mtk_drm_crtc_atomic_disable(),
-	 * which needs irq for vblank, and mtk_dsi_stop() will disable irq.
-	 * mtk_dsi_start() needs to be called in mtk_output_dsi_enable(),
-	 * after dsi is fully set.
-	 */
-	mtk_dsi_stop(dsi);
-
-	mtk_dsi_switch_to_cmd_mode(dsi, VM_DONE_INT_FLAG, 500);
 	mtk_dsi_reset_engine(dsi);
 	mtk_dsi_lane0_ulp_mode_enter(dsi);
 	mtk_dsi_clk_ulp_mode_enter(dsi);
@@ -698,17 +688,9 @@ static void mtk_dsi_poweroff(struct mtk_dsi *dsi)
 
 static void mtk_output_dsi_enable(struct mtk_dsi *dsi)
 {
-	int ret;
-
 	if (dsi->enabled)
 		return;
 
-	ret = mtk_dsi_poweron(dsi);
-	if (ret < 0) {
-		DRM_ERROR("failed to power on dsi\n");
-		return;
-	}
-
 	mtk_dsi_set_mode(dsi);
 	mtk_dsi_clk_hs_mode(dsi, 1);
 
@@ -722,7 +704,16 @@ static void mtk_output_dsi_disable(struct mtk_dsi *dsi)
 	if (!dsi->enabled)
 		return;
 
-	mtk_dsi_poweroff(dsi);
+	/*
+	 * mtk_dsi_stop() and mtk_dsi_start() is asymmetric, since
+	 * mtk_dsi_stop() should be called after mtk_drm_crtc_atomic_disable(),
+	 * which needs irq for vblank, and mtk_dsi_stop() will disable irq.
+	 * mtk_dsi_start() needs to be called in mtk_output_dsi_enable(),
+	 * after dsi is fully set.
+	 */
+	mtk_dsi_stop(dsi);
+
+	mtk_dsi_switch_to_cmd_mode(dsi, VM_DONE_INT_FLAG, 500);
 
 	dsi->enabled = false;
 }
@@ -759,13 +750,37 @@ static void mtk_dsi_bridge_atomic_enable(struct drm_bridge *bridge,
 {
 	struct mtk_dsi *dsi = bridge_to_dsi(bridge);
 
+	if (dsi->refcount == 0)
+		return;
+
 	mtk_output_dsi_enable(dsi);
 }
 
+static void mtk_dsi_bridge_atomic_pre_enable(struct drm_bridge *bridge,
+					     struct drm_bridge_state *old_bridge_state)
+{
+	struct mtk_dsi *dsi = bridge_to_dsi(bridge);
+	int ret;
+
+	ret = mtk_dsi_poweron(dsi);
+	if (ret < 0)
+		DRM_ERROR("failed to power on dsi\n");
+}
+
+static void mtk_dsi_bridge_atomic_post_disable(struct drm_bridge *bridge,
+					       struct drm_bridge_state *old_bridge_state)
+{
+	struct mtk_dsi *dsi = bridge_to_dsi(bridge);
+
+	mtk_dsi_poweroff(dsi);
+}
+
 static const struct drm_bridge_funcs mtk_dsi_bridge_funcs = {
 	.attach = mtk_dsi_bridge_attach,
 	.atomic_disable = mtk_dsi_bridge_atomic_disable,
 	.atomic_enable = mtk_dsi_bridge_atomic_enable,
+	.atomic_pre_enable = mtk_dsi_bridge_atomic_pre_enable,
+	.atomic_post_disable = mtk_dsi_bridge_atomic_post_disable,
 	.mode_set = mtk_dsi_bridge_mode_set,
 };
 
-- 
2.35.1




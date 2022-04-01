Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573B94EF3DA
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349383AbiDAOz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347889AbiDAOln (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:41:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C33B292B87;
        Fri,  1 Apr 2022 07:34:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 863D8B82500;
        Fri,  1 Apr 2022 14:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E69C2BBE4;
        Fri,  1 Apr 2022 14:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823639;
        bh=BRK+9JeOfueA1hXgfeqN+d3kw7Pcf0cfVeiYcuNNvxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/d4scHo9Bn+nDDbXvNrxR+XO29pQyG+GuAeLJCG9ouNi/j00aySbMyF0F27V42Ap
         TgE0YeJ/+NETDHw8hy+8K43zVQXQ0u7pKbrUp0V/Fljq/NvEXRbeVEndgZ4hmIRoTe
         lyViFx7WD6vr75IF55RV/SGEdqkO/1wqV7QiqTiQT5A+m0axMel/G7jlnN6JHxhyMR
         snGScyq1Y1+pWiSSVbD8dgMCXnFO4tgMTFBdDe8nOVs5nE/qpcP/xrX1PYimd9LykD
         PffMtGuutf9F7JDsNKKBO5nw5nHidL+zlspE8umxtseHKHtRNv8J84YNg5zWN0xCUD
         reSi8uLvFQgVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongzhi Liu <lyz_cs@pku.edu.cn>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>, andrzej.hajda@intel.com,
        narmstrong@baylibre.com, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 023/109] drm/bridge: Add missing pm_runtime_put_sync
Date:   Fri,  1 Apr 2022 10:31:30 -0400
Message-Id: <20220401143256.1950537-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Yongzhi Liu <lyz_cs@pku.edu.cn>

[ Upstream commit 46f47807738441e354873546dde0b000106c068a ]

pm_runtime_get_sync() will increase the rumtime PM counter
even when it returns an error. Thus a pairing decrement is needed
to prevent refcount leak. Fix this by replacing this API with
pm_runtime_resume_and_get(), which will not change the runtime
PM counter on error. Besides, a matching decrement is needed
on the error handling path to keep the counter balanced.

Signed-off-by: Yongzhi Liu <lyz_cs@pku.edu.cn>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1643008835-73961-1-git-send-email-lyz_cs@pku.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/nwl-dsi.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/bridge/nwl-dsi.c b/drivers/gpu/drm/bridge/nwl-dsi.c
index af07eeb47ca0..1529b9e3d576 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -861,18 +861,19 @@ nwl_dsi_bridge_mode_set(struct drm_bridge *bridge,
 	memcpy(&dsi->mode, adjusted_mode, sizeof(dsi->mode));
 	drm_mode_debug_printmodeline(adjusted_mode);
 
-	pm_runtime_get_sync(dev);
+	if (pm_runtime_resume_and_get(dev) < 0)
+		return;
 
 	if (clk_prepare_enable(dsi->lcdif_clk) < 0)
-		return;
+		goto runtime_put;
 	if (clk_prepare_enable(dsi->core_clk) < 0)
-		return;
+		goto runtime_put;
 
 	/* Step 1 from DSI reset-out instructions */
 	ret = reset_control_deassert(dsi->rst_pclk);
 	if (ret < 0) {
 		DRM_DEV_ERROR(dev, "Failed to deassert PCLK: %d\n", ret);
-		return;
+		goto runtime_put;
 	}
 
 	/* Step 2 from DSI reset-out instructions */
@@ -882,13 +883,18 @@ nwl_dsi_bridge_mode_set(struct drm_bridge *bridge,
 	ret = reset_control_deassert(dsi->rst_esc);
 	if (ret < 0) {
 		DRM_DEV_ERROR(dev, "Failed to deassert ESC: %d\n", ret);
-		return;
+		goto runtime_put;
 	}
 	ret = reset_control_deassert(dsi->rst_byte);
 	if (ret < 0) {
 		DRM_DEV_ERROR(dev, "Failed to deassert BYTE: %d\n", ret);
-		return;
+		goto runtime_put;
 	}
+
+	return;
+
+runtime_put:
+	pm_runtime_put_sync(dev);
 }
 
 static void
-- 
2.34.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC696AF117
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbjCGSjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjCGSir (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:38:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F23ABCFDA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D099961543
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77E3C4339B;
        Tue,  7 Mar 2023 18:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213770;
        bh=259BU0aR50K2kGvxwxmG/OldUG0ZAqQD/drm9J1ALLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttA1n3CyIkwfumjmwzeAN7YNSanR6O9wAPtcmtgXwCh4buM5KhsOmIXSoK9R3BFqi
         8Dx6kBn9I8/thza3Vc0b6clYdH2KJb3ATws3EonDtuFHLBNFlyV2vSgAeqAkjcsmuA
         JEvl/HxTaoT3eQzMd5RZLHMkNjLr5LuIEb9g2n5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 614/885] drm: rcar-du: Add quirk for H3 ES1.x pclk workaround
Date:   Tue,  7 Mar 2023 17:59:08 +0100
Message-Id: <20230307170028.975043828@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>

[ Upstream commit 4f548bc48a2b4c4e54eecfddb6f7d24aa1b98768 ]

rcar_du_crtc.c does a soc_device_match() in
rcar_du_crtc_set_display_timing() to find out if the SoC is H3 ES1.x, and
if so, apply a workaround.

We will need another H3 ES1.x check in the following patch, so rather than
adding more soc_device_match() calls, let's add a rcar_du_device_info
entry for the ES1, and a quirk flag,
RCAR_DU_QUIRK_H3_ES1_PCLK_STABILITY, for the workaround.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c |  8 +----
 drivers/gpu/drm/rcar-du/rcar_du_drv.c  | 48 ++++++++++++++++++++++++++
 drivers/gpu/drm/rcar-du/rcar_du_drv.h  |  1 +
 3 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 3619e1ddeb620..f2d3266509cc1 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -10,7 +10,6 @@
 #include <linux/clk.h>
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
-#include <linux/sys_soc.h>
 
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
@@ -204,11 +203,6 @@ static void rcar_du_escr_divider(struct clk *clk, unsigned long target,
 	}
 }
 
-static const struct soc_device_attribute rcar_du_r8a7795_es1[] = {
-	{ .soc_id = "r8a7795", .revision = "ES1.*" },
-	{ /* sentinel */ }
-};
-
 static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
 {
 	const struct drm_display_mode *mode = &rcrtc->crtc.state->adjusted_mode;
@@ -238,7 +232,7 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
 		 * no post-divider when a display PLL is present (as shown by
 		 * the workaround breaking HDMI output on M3-W during testing).
 		 */
-		if (soc_device_match(rcar_du_r8a7795_es1)) {
+		if (rcdu->info->quirks & RCAR_DU_QUIRK_H3_ES1_PCLK_STABILITY) {
 			target *= 2;
 			div = 1;
 		}
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.c b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
index a2776f1d6f2c2..0dada0646b2eb 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
@@ -16,6 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
+#include <linux/sys_soc.h>
 #include <linux/wait.h>
 
 #include <drm/drm_atomic_helper.h>
@@ -386,6 +387,42 @@ static const struct rcar_du_device_info rcar_du_r8a7795_info = {
 	.dpll_mask =  BIT(2) | BIT(1),
 };
 
+static const struct rcar_du_device_info rcar_du_r8a7795_es1_info = {
+	.gen = 3,
+	.features = RCAR_DU_FEATURE_CRTC_IRQ
+		  | RCAR_DU_FEATURE_CRTC_CLOCK
+		  | RCAR_DU_FEATURE_VSP1_SOURCE
+		  | RCAR_DU_FEATURE_INTERLACED
+		  | RCAR_DU_FEATURE_TVM_SYNC,
+	.quirks = RCAR_DU_QUIRK_H3_ES1_PCLK_STABILITY,
+	.channels_mask = BIT(3) | BIT(2) | BIT(1) | BIT(0),
+	.routes = {
+		/*
+		 * R8A7795 has one RGB output, two HDMI outputs and one
+		 * LVDS output.
+		 */
+		[RCAR_DU_OUTPUT_DPAD0] = {
+			.possible_crtcs = BIT(3),
+			.port = 0,
+		},
+		[RCAR_DU_OUTPUT_HDMI0] = {
+			.possible_crtcs = BIT(1),
+			.port = 1,
+		},
+		[RCAR_DU_OUTPUT_HDMI1] = {
+			.possible_crtcs = BIT(2),
+			.port = 2,
+		},
+		[RCAR_DU_OUTPUT_LVDS0] = {
+			.possible_crtcs = BIT(0),
+			.port = 3,
+		},
+	},
+	.num_lvds = 1,
+	.num_rpf = 5,
+	.dpll_mask =  BIT(2) | BIT(1),
+};
+
 static const struct rcar_du_device_info rcar_du_r8a7796_info = {
 	.gen = 3,
 	.features = RCAR_DU_FEATURE_CRTC_IRQ
@@ -554,6 +591,11 @@ static const struct of_device_id rcar_du_of_table[] = {
 
 MODULE_DEVICE_TABLE(of, rcar_du_of_table);
 
+static const struct soc_device_attribute rcar_du_soc_table[] = {
+	{ .soc_id = "r8a7795", .revision = "ES1.*", .data = &rcar_du_r8a7795_es1_info },
+	{ /* sentinel */ }
+};
+
 const char *rcar_du_output_name(enum rcar_du_output output)
 {
 	static const char * const names[] = {
@@ -645,6 +687,7 @@ static void rcar_du_shutdown(struct platform_device *pdev)
 
 static int rcar_du_probe(struct platform_device *pdev)
 {
+	const struct soc_device_attribute *soc_attr;
 	struct rcar_du_device *rcdu;
 	unsigned int mask;
 	int ret;
@@ -659,8 +702,13 @@ static int rcar_du_probe(struct platform_device *pdev)
 		return PTR_ERR(rcdu);
 
 	rcdu->dev = &pdev->dev;
+
 	rcdu->info = of_device_get_match_data(rcdu->dev);
 
+	soc_attr = soc_device_match(rcar_du_soc_table);
+	if (soc_attr)
+		rcdu->info = soc_attr->data;
+
 	platform_set_drvdata(pdev, rcdu);
 
 	/* I/O resources */
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.h b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
index 5cfa2bb7ad93d..df87ccab146f4 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
@@ -34,6 +34,7 @@ struct rcar_du_device;
 #define RCAR_DU_FEATURE_NO_BLENDING	BIT(5)	/* PnMR.SPIM does not have ALP nor EOR bits */
 
 #define RCAR_DU_QUIRK_ALIGN_128B	BIT(0)	/* Align pitches to 128 bytes */
+#define RCAR_DU_QUIRK_H3_ES1_PCLK_STABILITY BIT(1)	/* H3 ES1 has pclk stability issue */
 
 enum rcar_du_output {
 	RCAR_DU_OUTPUT_DPAD0,
-- 
2.39.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD55657C82
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbiL1PdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiL1PdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:33:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A193115FC9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:33:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A5B2B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852C7C433EF;
        Wed, 28 Dec 2022 15:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241588;
        bh=MDPtYajtsMpDG9DZRarNrfDfmSZtFlqNR+AYwqaQTUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UzhxXI97gWYeQj1iKaawHn758u0nQj/kcfERNxDueklKXKxHfD1uH+VH6oJPinxEn
         RhZaYbqVvqZjesGTopepz7Bcmap5LY54wjB2Bdyg4Ke9OECA30Xp0Ca6L0GCngO4Yw
         Z3tWONF+efyPMM2OeTLInnRMrWM210Ufhds/Smqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Liu Ying <victor.liu@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0301/1073] drm: lcdif: Set and enable FIFO Panic threshold
Date:   Wed, 28 Dec 2022 15:31:29 +0100
Message-Id: <20221228144336.187221698@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit e3cac8f7749f78dacdf19c00ed5862a1db52239f ]

In case the LCDIFv3 is used to drive a 4k panel via i.MX8MP HDMI bridge,
the LCDIFv3 becomes susceptible to FIFO underflows, these lead to nasty
flicker of the image on the panel, or image being shifted by half frame
horizontally every second frame. The flicker can be easily triggered by
running 3D application on top of weston compositor, like neverball or
chromium. Surprisingly glmark2-es2-wayland or glmark2-es2-drm does not
trigger this effect so easily.

Configure the FIFO Panic threshold register and enable the FIFO Panic
mode, which internally boosts the NoC interconnect priority for LCDIFv3
transactions in case of possible underflow. This mitigates the flicker
effect on 4k panels as well.

Fixes: 9db35bb349a0 ("drm: lcdif: Add support for i.MX8MP LCDIF variant")
Signed-off-by: Marek Vasut <marex@denx.de>
Tested-by: Liu Ying <victor.liu@nxp.com> # i.MX8mp EVK
Reviewed-by: Liu Ying <victor.liu@nxp.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221101152629.21768-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/lcdif_kms.c  | 16 ++++++++++++++++
 drivers/gpu/drm/mxsfb/lcdif_regs.h |  1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/mxsfb/lcdif_kms.c b/drivers/gpu/drm/mxsfb/lcdif_kms.c
index 713b0d756f2a..d419c61c3407 100644
--- a/drivers/gpu/drm/mxsfb/lcdif_kms.c
+++ b/drivers/gpu/drm/mxsfb/lcdif_kms.c
@@ -5,6 +5,7 @@
  * This code is based on drivers/gpu/drm/mxsfb/mxsfb*
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
@@ -167,6 +168,18 @@ static void lcdif_enable_controller(struct lcdif_drm_private *lcdif)
 {
 	u32 reg;
 
+	/* Set FIFO Panic watermarks, low 1/3, high 2/3 . */
+	writel(FIELD_PREP(PANIC0_THRES_LOW_MASK, 1 * PANIC0_THRES_MAX / 3) |
+	       FIELD_PREP(PANIC0_THRES_HIGH_MASK, 2 * PANIC0_THRES_MAX / 3),
+	       lcdif->base + LCDC_V8_PANIC0_THRES);
+
+	/*
+	 * Enable FIFO Panic, this does not generate interrupt, but
+	 * boosts NoC priority based on FIFO Panic watermarks.
+	 */
+	writel(INT_ENABLE_D1_PLANE_PANIC_EN,
+	       lcdif->base + LCDC_V8_INT_ENABLE_D1);
+
 	reg = readl(lcdif->base + LCDC_V8_DISP_PARA);
 	reg |= DISP_PARA_DISP_ON;
 	writel(reg, lcdif->base + LCDC_V8_DISP_PARA);
@@ -194,6 +207,9 @@ static void lcdif_disable_controller(struct lcdif_drm_private *lcdif)
 	reg = readl(lcdif->base + LCDC_V8_DISP_PARA);
 	reg &= ~DISP_PARA_DISP_ON;
 	writel(reg, lcdif->base + LCDC_V8_DISP_PARA);
+
+	/* Disable FIFO Panic NoC priority booster. */
+	writel(0, lcdif->base + LCDC_V8_INT_ENABLE_D1);
 }
 
 static void lcdif_reset_block(struct lcdif_drm_private *lcdif)
diff --git a/drivers/gpu/drm/mxsfb/lcdif_regs.h b/drivers/gpu/drm/mxsfb/lcdif_regs.h
index 8e8bef175bf2..37f0d9a06b10 100644
--- a/drivers/gpu/drm/mxsfb/lcdif_regs.h
+++ b/drivers/gpu/drm/mxsfb/lcdif_regs.h
@@ -252,6 +252,7 @@
 
 #define PANIC0_THRES_LOW_MASK		GENMASK(24, 16)
 #define PANIC0_THRES_HIGH_MASK		GENMASK(8, 0)
+#define PANIC0_THRES_MAX		511
 
 #define LCDIF_MIN_XRES			120
 #define LCDIF_MIN_YRES			120
-- 
2.35.1




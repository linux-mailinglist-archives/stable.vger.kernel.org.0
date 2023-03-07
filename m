Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734176AF155
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbjCGSm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjCGSmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:42:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF03A0B0A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:32:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1A7F4CE1C8C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23FAC433D2;
        Tue,  7 Mar 2023 18:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213773;
        bh=RfJ7zhBNlfLKvAEqmB7zionVyR+2H9D4eBTQ8wY+WUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLRc+0uqrlQ9hTctdf2ciFSRuYbD/gS0KPbAoVCkvnD083ssZZXqdjR9plgGkz79i
         wyNjLwC0SkOd+ZZwIHIwOm48upCkuGwCI0bRFeQbYnPDNeYSMwahW90VjdI3VFROdV
         75yvO9hjfSsd1ayjSkDitXisW9GOiq932MbqTLhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 615/885] drm: rcar-du: Fix setting a reserved bit in DPLLCR
Date:   Tue,  7 Mar 2023 17:59:09 +0100
Message-Id: <20230307170029.026352051@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>

[ Upstream commit 5fbc2f3b91d27e12b614947048764099570cbb55 ]

On H3 ES1.x two bits in DPLLCR are used to select the DU input dot clock
source. These are bits 20 and 21 for DU2, and bits 22 and 23 for DU1. On
non-ES1.x, only the higher bits are used (bits 21 and 23), and the lower
bits are reserved and should be set to 0.

The current code always sets the lower bits, even on non-ES1.x.

For both DU1 and DU2, on all SoC versions, when writing zeroes to those
bits the input clock is DCLKIN, and thus there's no difference between
ES1.x and non-ES1.x.

For DU1, writing 0b10 to the bits (or only writing the higher bit)
results in using PLL0 as the input clock, so in this case there's also
no difference between ES1.x and non-ES1.x.

However, for DU2, writing 0b10 to the bits results in using PLL0 as the
input clock on ES1.x, whereas on non-ES1.x it results in using PLL1. On
ES1.x you need to write 0b11 to select PLL1.

The current code always writes 0b11 to PLCS0 field to select PLL1 on all
SoC versions, which works but causes an illegal (in the sense of not
allowed by the documentation) write to a reserved bit field.

To remove the illegal bit write on PLSC0 we need to handle the input dot
clock selection differently for ES1.x and non-ES1.x.

Add a new quirk, RCAR_DU_QUIRK_H3_ES1_PLL, for this. This way we can
always set the bit 21 on PLSC0 when choosing the PLL as the source
clock, and additionally set the bit 20 when on ES1.x.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 23 ++++++++++++++++++++---
 drivers/gpu/drm/rcar-du/rcar_du_drv.c  |  3 ++-
 drivers/gpu/drm/rcar-du/rcar_du_drv.h  |  1 +
 drivers/gpu/drm/rcar-du/rcar_du_regs.h |  8 ++------
 4 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index f2d3266509cc1..b7dd59fe119e6 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -245,13 +245,30 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
 		       | DPLLCR_N(dpll.n) | DPLLCR_M(dpll.m)
 		       | DPLLCR_STBY;
 
-		if (rcrtc->index == 1)
+		if (rcrtc->index == 1) {
 			dpllcr |= DPLLCR_PLCS1
 			       |  DPLLCR_INCS_DOTCLKIN1;
-		else
-			dpllcr |= DPLLCR_PLCS0
+		} else {
+			dpllcr |= DPLLCR_PLCS0_PLL
 			       |  DPLLCR_INCS_DOTCLKIN0;
 
+			/*
+			 * On ES2.x we have a single mux controlled via bit 21,
+			 * which selects between DCLKIN source (bit 21 = 0) and
+			 * a PLL source (bit 21 = 1), where the PLL is always
+			 * PLL1.
+			 *
+			 * On ES1.x we have an additional mux, controlled
+			 * via bit 20, for choosing between PLL0 (bit 20 = 0)
+			 * and PLL1 (bit 20 = 1). We always want to use PLL1,
+			 * so on ES1.x, in addition to setting bit 21, we need
+			 * to set the bit 20.
+			 */
+
+			if (rcdu->info->quirks & RCAR_DU_QUIRK_H3_ES1_PLL)
+				dpllcr |= DPLLCR_PLCS0_H3ES1X_PLL1;
+		}
+
 		rcar_du_group_write(rcrtc->group, DPLLCR, dpllcr);
 
 		escr = ESCR_DCLKSEL_DCLKIN | div;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.c b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
index 0dada0646b2eb..6381578c4db58 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
@@ -394,7 +394,8 @@ static const struct rcar_du_device_info rcar_du_r8a7795_es1_info = {
 		  | RCAR_DU_FEATURE_VSP1_SOURCE
 		  | RCAR_DU_FEATURE_INTERLACED
 		  | RCAR_DU_FEATURE_TVM_SYNC,
-	.quirks = RCAR_DU_QUIRK_H3_ES1_PCLK_STABILITY,
+	.quirks = RCAR_DU_QUIRK_H3_ES1_PCLK_STABILITY
+		| RCAR_DU_QUIRK_H3_ES1_PLL,
 	.channels_mask = BIT(3) | BIT(2) | BIT(1) | BIT(0),
 	.routes = {
 		/*
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.h b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
index df87ccab146f4..acc3673fefe18 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
@@ -35,6 +35,7 @@ struct rcar_du_device;
 
 #define RCAR_DU_QUIRK_ALIGN_128B	BIT(0)	/* Align pitches to 128 bytes */
 #define RCAR_DU_QUIRK_H3_ES1_PCLK_STABILITY BIT(1)	/* H3 ES1 has pclk stability issue */
+#define RCAR_DU_QUIRK_H3_ES1_PLL	BIT(2)	/* H3 ES1 PLL setup differs from non-ES1 */
 
 enum rcar_du_output {
 	RCAR_DU_OUTPUT_DPAD0,
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_regs.h b/drivers/gpu/drm/rcar-du/rcar_du_regs.h
index c1bcb0e8b5b4e..789ae9285108e 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_regs.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_regs.h
@@ -283,12 +283,8 @@
 #define DPLLCR			0x20044
 #define DPLLCR_CODE		(0x95 << 24)
 #define DPLLCR_PLCS1		(1 << 23)
-/*
- * PLCS0 is bit 21, but H3 ES1.x requires bit 20 to be set as well. As bit 20
- * isn't implemented by other SoC in the Gen3 family it can safely be set
- * unconditionally.
- */
-#define DPLLCR_PLCS0		(3 << 20)
+#define DPLLCR_PLCS0_PLL	(1 << 21)
+#define DPLLCR_PLCS0_H3ES1X_PLL1	(1 << 20)
 #define DPLLCR_CLKE		(1 << 18)
 #define DPLLCR_FDPLL(n)		((n) << 12)
 #define DPLLCR_N(n)		((n) << 5)
-- 
2.39.2




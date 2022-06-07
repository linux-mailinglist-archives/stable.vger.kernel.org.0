Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9155419E8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378244AbiFGV1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378639AbiFGVX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:23:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0292227374;
        Tue,  7 Jun 2022 12:00:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C52DFB8239A;
        Tue,  7 Jun 2022 19:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349C6C385A5;
        Tue,  7 Jun 2022 19:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628437;
        bh=ebJ6XbULYIuzkx/sQhTnfexOueAaNi58VR+qf5B58co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DK8xEOItIrOjp/bI1zcz/DVH0gSskJDvbWzVMgoDlqLgHEM4jmvCZeB/b04l+jS7E
         LZcYJzxMEWoKxp2QeM4JtY+zXye1yHGWp7XD4hyEeGsEOBAme3Z1sdPl1+TGvMGTJ1
         Giq93AURoDWEWVN/nK5E0Yc4z+ruymo1zbpMz/Co=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 289/879] drm/vc4: hvs: Fix frame count register readout
Date:   Tue,  7 Jun 2022 18:56:47 +0200
Message-Id: <20220607165011.236020211@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit b51cd7ad143d2eb31a6df81c2183128920e47c2b ]

In order to get the field currently being output, the driver has been
using the display FIFO frame count in the HVS, reading a 6-bit field at
the offset 12 in the DISPSTATx register.

While that field is indeed at that location for the FIFO 1 and 2, the
one for the FIFO0 is actually in the DISPSTAT1 register, at the offset
18.

Fixes: e538092cb15c ("drm/vc4: Enable precise vblank timestamping for interlaced modes.")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20220331143744.777652-3-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c |  2 +-
 drivers/gpu/drm/vc4/vc4_drv.h  |  1 +
 drivers/gpu/drm/vc4/vc4_hvs.c  | 23 +++++++++++++++++++++++
 drivers/gpu/drm/vc4/vc4_regs.h | 12 ++++++++++--
 4 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_crtc.c b/drivers/gpu/drm/vc4/vc4_crtc.c
index 783890e8d43a..477b3c5ad089 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -123,7 +123,7 @@ static bool vc4_crtc_get_scanout_position(struct drm_crtc *crtc,
 		*vpos /= 2;
 
 		/* Use hpos to correct for field offset in interlaced mode. */
-		if (VC4_GET_FIELD(val, SCALER_DISPSTATX_FRAME_COUNT) % 2)
+		if (vc4_hvs_get_fifo_frame_count(dev, vc4_crtc_state->assigned_channel) % 2)
 			*hpos += mode->crtc_htotal / 2;
 	}
 
diff --git a/drivers/gpu/drm/vc4/vc4_drv.h b/drivers/gpu/drm/vc4/vc4_drv.h
index 4329e09d357c..801da3e8ebdb 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.h
+++ b/drivers/gpu/drm/vc4/vc4_drv.h
@@ -935,6 +935,7 @@ void vc4_irq_reset(struct drm_device *dev);
 extern struct platform_driver vc4_hvs_driver;
 void vc4_hvs_stop_channel(struct drm_device *dev, unsigned int output);
 int vc4_hvs_get_fifo_from_output(struct drm_device *dev, unsigned int output);
+u8 vc4_hvs_get_fifo_frame_count(struct drm_device *dev, unsigned int fifo);
 int vc4_hvs_atomic_check(struct drm_crtc *crtc, struct drm_atomic_state *state);
 void vc4_hvs_atomic_begin(struct drm_crtc *crtc, struct drm_atomic_state *state);
 void vc4_hvs_atomic_enable(struct drm_crtc *crtc, struct drm_atomic_state *state);
diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 604933e20e6a..c8cae10500b9 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -197,6 +197,29 @@ static void vc4_hvs_update_gamma_lut(struct drm_crtc *crtc)
 	vc4_hvs_lut_load(crtc);
 }
 
+u8 vc4_hvs_get_fifo_frame_count(struct drm_device *dev, unsigned int fifo)
+{
+	struct vc4_dev *vc4 = to_vc4_dev(dev);
+	u8 field = 0;
+
+	switch (fifo) {
+	case 0:
+		field = VC4_GET_FIELD(HVS_READ(SCALER_DISPSTAT1),
+				      SCALER_DISPSTAT1_FRCNT0);
+		break;
+	case 1:
+		field = VC4_GET_FIELD(HVS_READ(SCALER_DISPSTAT1),
+				      SCALER_DISPSTAT1_FRCNT1);
+		break;
+	case 2:
+		field = VC4_GET_FIELD(HVS_READ(SCALER_DISPSTAT2),
+				      SCALER_DISPSTAT2_FRCNT2);
+		break;
+	}
+
+	return field;
+}
+
 int vc4_hvs_get_fifo_from_output(struct drm_device *dev, unsigned int output)
 {
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
diff --git a/drivers/gpu/drm/vc4/vc4_regs.h b/drivers/gpu/drm/vc4/vc4_regs.h
index 33410718089e..bae8c9cd6f7c 100644
--- a/drivers/gpu/drm/vc4/vc4_regs.h
+++ b/drivers/gpu/drm/vc4/vc4_regs.h
@@ -379,8 +379,6 @@
 # define SCALER_DISPSTATX_MODE_EOF		3
 # define SCALER_DISPSTATX_FULL			BIT(29)
 # define SCALER_DISPSTATX_EMPTY			BIT(28)
-# define SCALER_DISPSTATX_FRAME_COUNT_MASK	VC4_MASK(17, 12)
-# define SCALER_DISPSTATX_FRAME_COUNT_SHIFT	12
 # define SCALER_DISPSTATX_LINE_MASK		VC4_MASK(11, 0)
 # define SCALER_DISPSTATX_LINE_SHIFT		0
 
@@ -403,9 +401,15 @@
 						 (x) * (SCALER_DISPBKGND1 - \
 							SCALER_DISPBKGND0))
 #define SCALER_DISPSTAT1                        0x00000058
+# define SCALER_DISPSTAT1_FRCNT0_MASK		VC4_MASK(23, 18)
+# define SCALER_DISPSTAT1_FRCNT0_SHIFT		18
+# define SCALER_DISPSTAT1_FRCNT1_MASK		VC4_MASK(17, 12)
+# define SCALER_DISPSTAT1_FRCNT1_SHIFT		12
+
 #define SCALER_DISPSTATX(x)			(SCALER_DISPSTAT0 +        \
 						 (x) * (SCALER_DISPSTAT1 - \
 							SCALER_DISPSTAT0))
+
 #define SCALER_DISPBASE1                        0x0000005c
 #define SCALER_DISPBASEX(x)			(SCALER_DISPBASE0 +        \
 						 (x) * (SCALER_DISPBASE1 - \
@@ -415,7 +419,11 @@
 						 (x) * (SCALER_DISPCTRL1 - \
 							SCALER_DISPCTRL0))
 #define SCALER_DISPBKGND2                       0x00000064
+
 #define SCALER_DISPSTAT2                        0x00000068
+# define SCALER_DISPSTAT2_FRCNT2_MASK		VC4_MASK(17, 12)
+# define SCALER_DISPSTAT2_FRCNT2_SHIFT		12
+
 #define SCALER_DISPBASE2                        0x0000006c
 #define SCALER_DISPALPHA2                       0x00000070
 #define SCALER_GAMADDR                          0x00000078
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1B83ED692
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239323AbhHPNWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238894AbhHPNQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:16:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B71F8632ED;
        Mon, 16 Aug 2021 13:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119602;
        bh=DmvCyg3+GaFmW/1KXTkP3Udlm3T9LTw6aydB4yoyp6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQtTxxI8RQjIfinTh2UeQ/Zh26C7CdUNmoExL7XNxuBG79sbFFXrtM9nPiS6dmid4
         LBWnke7QXKiIqiOnGe628VHQ73Ewz4U9sXeOvkKXtXJE2SdZqgSmsM4pabhTFTtMCA
         2vzmEZcYHhe/Fv3njES3B8m0pNx/j7HxEsD3I5Ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Steiger <mathias.steiger@googlemail.com>,
        Christian Hewitt <christianshewitt@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philip Milev <milev.philip@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 088/151] drm/meson: fix colour distortion from HDR set during vendor u-boot
Date:   Mon, 16 Aug 2021 15:01:58 +0200
Message-Id: <20210816125446.981911556@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit bf33677a3c394bb8fddd48d3bbc97adf0262e045 ]

Add support for the OSD1 HDR registers so meson DRM can handle the HDR
properties set by Amlogic u-boot on G12A and newer devices which result
in blue/green/pink colour distortion to display output.

This takes the original patch submissions from Mathias [0] and [1] with
corrections for formatting and the missing description and attribution
needed for merge.

[0] https://lore.kernel.org/linux-amlogic/59dfd7e6-fc91-3d61-04c4-94e078a3188c@baylibre.com/T/
[1] https://lore.kernel.org/linux-amlogic/CAOKfEHBx_fboUqkENEMd-OC-NSrf46nto+vDLgvgttzPe99kXg@mail.gmail.com/T/#u

Fixes: 728883948b0d ("drm/meson: Add G12A Support for VIU setup")
Suggested-by: Mathias Steiger <mathias.steiger@googlemail.com>
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Tested-by: Neil Armstrong <narmstrong@baylibre.com>
Tested-by: Philip Milev <milev.philip@gmail.com>
[narmsrong: adding missing space on second tested-by tag]
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210806094005.7136-1-christianshewitt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_registers.h | 5 +++++
 drivers/gpu/drm/meson/meson_viu.c       | 7 ++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/meson/meson_registers.h b/drivers/gpu/drm/meson/meson_registers.h
index 446e7961da48..0f3cafab8860 100644
--- a/drivers/gpu/drm/meson/meson_registers.h
+++ b/drivers/gpu/drm/meson/meson_registers.h
@@ -634,6 +634,11 @@
 #define VPP_WRAP_OSD3_MATRIX_PRE_OFFSET2 0x3dbc
 #define VPP_WRAP_OSD3_MATRIX_EN_CTRL 0x3dbd
 
+/* osd1 HDR */
+#define OSD1_HDR2_CTRL 0x38a0
+#define OSD1_HDR2_CTRL_VDIN0_HDR2_TOP_EN       BIT(13)
+#define OSD1_HDR2_CTRL_REG_ONLY_MAT            BIT(16)
+
 /* osd2 scaler */
 #define OSD2_VSC_PHASE_STEP 0x3d00
 #define OSD2_VSC_INI_PHASE 0x3d01
diff --git a/drivers/gpu/drm/meson/meson_viu.c b/drivers/gpu/drm/meson/meson_viu.c
index aede0c67a57f..259f3e6bec90 100644
--- a/drivers/gpu/drm/meson/meson_viu.c
+++ b/drivers/gpu/drm/meson/meson_viu.c
@@ -425,9 +425,14 @@ void meson_viu_init(struct meson_drm *priv)
 	if (meson_vpu_is_compatible(priv, VPU_COMPATIBLE_GXM) ||
 	    meson_vpu_is_compatible(priv, VPU_COMPATIBLE_GXL))
 		meson_viu_load_matrix(priv);
-	else if (meson_vpu_is_compatible(priv, VPU_COMPATIBLE_G12A))
+	else if (meson_vpu_is_compatible(priv, VPU_COMPATIBLE_G12A)) {
 		meson_viu_set_g12a_osd1_matrix(priv, RGB709_to_YUV709l_coeff,
 					       true);
+		/* fix green/pink color distortion from vendor u-boot */
+		writel_bits_relaxed(OSD1_HDR2_CTRL_REG_ONLY_MAT |
+				OSD1_HDR2_CTRL_VDIN0_HDR2_TOP_EN, 0,
+				priv->io_base + _REG(OSD1_HDR2_CTRL));
+	}
 
 	/* Initialize OSD1 fifo control register */
 	reg = VIU_OSD_DDR_PRIORITY_URGENT |
-- 
2.30.2




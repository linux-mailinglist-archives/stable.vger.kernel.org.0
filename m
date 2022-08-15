Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C2A593F1C
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239853AbiHOVJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347591AbiHOVHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FFEBB003;
        Mon, 15 Aug 2022 12:15:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87CCD60FB5;
        Mon, 15 Aug 2022 19:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912D9C433C1;
        Mon, 15 Aug 2022 19:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590956;
        bh=DznJc7TWENctD5//IBiKoAflqIB7T8sPH+IxLgYWjFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tave9I4R8XKAFoBgYJx2gpt6McCdL7fu9pLaDzBd6AlnwKal6r2l9B9QJYLeJ+jaT
         4tLX7LYjJIvMvT9sHwnFvGXR6mdA1OnZStDJu7CCqiavykGxpTpuknCkRJX7zCpiSd
         6HKMHx7Pq2HwfaXqAIdgdk22IO00xnh48oAKy/Io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0398/1095] drm/vc4: hdmi: Fix timings for interlaced modes
Date:   Mon, 15 Aug 2022 19:56:37 +0200
Message-Id: <20220815180446.152833393@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>

[ Upstream commit 0ee5a40152b15f200ed3a0d51e8aa782ea979c6a ]

Increase the number of post-sync blanking lines on odd fields instead of
decreasing it on even fields. This makes the total number of lines
properly match the modelines.

Additionally fix the value of PV_VCONTROL_ODD_DELAY, which did not take
pixels_per_clock into account, causing some displays to invert the
fields when driven by bcm2711.

Fixes: 682e62c45406 ("drm/vc4: Fix support for interlaced modes on HDMI.")
Signed-off-by: Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>
Link: https://lore.kernel.org/r/20220613144800.326124-31-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c |  7 ++++---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 12 ++++++------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_crtc.c b/drivers/gpu/drm/vc4/vc4_crtc.c
index 0a5f58cdd781..2810b0d9e78c 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -344,7 +344,8 @@ static void vc4_crtc_config_pv(struct drm_crtc *crtc, struct drm_encoder *encode
 				 PV_HORZB_HACTIVE));
 
 	CRTC_WRITE(PV_VERTA,
-		   VC4_SET_FIELD(mode->crtc_vtotal - mode->crtc_vsync_end,
+		   VC4_SET_FIELD(mode->crtc_vtotal - mode->crtc_vsync_end +
+				 interlace,
 				 PV_VERTA_VBP) |
 		   VC4_SET_FIELD(mode->crtc_vsync_end - mode->crtc_vsync_start,
 				 PV_VERTA_VSYNC));
@@ -356,7 +357,7 @@ static void vc4_crtc_config_pv(struct drm_crtc *crtc, struct drm_encoder *encode
 	if (interlace) {
 		CRTC_WRITE(PV_VERTA_EVEN,
 			   VC4_SET_FIELD(mode->crtc_vtotal -
-					 mode->crtc_vsync_end - 1,
+					 mode->crtc_vsync_end,
 					 PV_VERTA_VBP) |
 			   VC4_SET_FIELD(mode->crtc_vsync_end -
 					 mode->crtc_vsync_start,
@@ -376,7 +377,7 @@ static void vc4_crtc_config_pv(struct drm_crtc *crtc, struct drm_encoder *encode
 			   PV_VCONTROL_CONTINUOUS |
 			   (is_dsi ? PV_VCONTROL_DSI : 0) |
 			   PV_VCONTROL_INTERLACE |
-			   VC4_SET_FIELD(mode->htotal * pixel_rep / 2,
+			   VC4_SET_FIELD(mode->htotal * pixel_rep / (2 * ppc),
 					 PV_VCONTROL_ODD_DELAY));
 		CRTC_WRITE(PV_VSYNCD_EVEN, 0);
 	} else {
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 55a965120a77..da3622f34dba 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -870,12 +870,12 @@ static void vc4_hdmi_set_timings(struct vc4_hdmi *vc4_hdmi,
 				   VC4_HDMI_VERTA_VFP) |
 		     VC4_SET_FIELD(mode->crtc_vdisplay, VC4_HDMI_VERTA_VAL));
 	u32 vertb = (VC4_SET_FIELD(0, VC4_HDMI_VERTB_VSPO) |
-		     VC4_SET_FIELD(mode->crtc_vtotal - mode->crtc_vsync_end,
+		     VC4_SET_FIELD(mode->crtc_vtotal - mode->crtc_vsync_end +
+				   interlaced,
 				   VC4_HDMI_VERTB_VBP));
 	u32 vertb_even = (VC4_SET_FIELD(0, VC4_HDMI_VERTB_VSPO) |
 			  VC4_SET_FIELD(mode->crtc_vtotal -
-					mode->crtc_vsync_end -
-					interlaced,
+					mode->crtc_vsync_end,
 					VC4_HDMI_VERTB_VBP));
 	unsigned long flags;
 
@@ -921,12 +921,12 @@ static void vc5_hdmi_set_timings(struct vc4_hdmi *vc4_hdmi,
 				   VC5_HDMI_VERTA_VFP) |
 		     VC4_SET_FIELD(mode->crtc_vdisplay, VC5_HDMI_VERTA_VAL));
 	u32 vertb = (VC4_SET_FIELD(0, VC5_HDMI_VERTB_VSPO) |
-		     VC4_SET_FIELD(mode->crtc_vtotal - mode->crtc_vsync_end,
+		     VC4_SET_FIELD(mode->crtc_vtotal - mode->crtc_vsync_end +
+				   interlaced,
 				   VC4_HDMI_VERTB_VBP));
 	u32 vertb_even = (VC4_SET_FIELD(0, VC5_HDMI_VERTB_VSPO) |
 			  VC4_SET_FIELD(mode->crtc_vtotal -
-					mode->crtc_vsync_end -
-					interlaced,
+					mode->crtc_vsync_end,
 					VC4_HDMI_VERTB_VBP));
 	unsigned long flags;
 	unsigned char gcp;
-- 
2.35.1




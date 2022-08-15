Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C972593668
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243140AbiHOSwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244378AbiHOSvD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:51:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E8F4505A;
        Mon, 15 Aug 2022 11:29:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5542B81062;
        Mon, 15 Aug 2022 18:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31808C433C1;
        Mon, 15 Aug 2022 18:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588139;
        bh=aBr/68DQJz7Js4ul47klddeDM95zLeJBjJAEtr6IZcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4x4FexZfnuaQ1y+Jq1IzfV6Tp6ty6gFQaw/plNiR6J7xA/UPrVzU/Zopux8WQvma
         PP3kPdysJup2q7CWbwcVCahtcT4t8UXRgCI5cSxJcJcqx0emyrfH2x76vt2qN65Ru1
         E6OM+jZ75n46cnRpWU9nKz6rrRXhOIx6fxw4YtUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 308/779] drm/vc4: hdmi: Fix timings for interlaced modes
Date:   Mon, 15 Aug 2022 19:59:12 +0200
Message-Id: <20220815180350.457921293@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 5a8c3c6c91af..3b8576f19321 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -357,7 +357,8 @@ static void vc4_crtc_config_pv(struct drm_crtc *crtc, struct drm_atomic_state *s
 				 PV_HORZB_HACTIVE));
 
 	CRTC_WRITE(PV_VERTA,
-		   VC4_SET_FIELD(mode->crtc_vtotal - mode->crtc_vsync_end,
+		   VC4_SET_FIELD(mode->crtc_vtotal - mode->crtc_vsync_end +
+				 interlace,
 				 PV_VERTA_VBP) |
 		   VC4_SET_FIELD(mode->crtc_vsync_end - mode->crtc_vsync_start,
 				 PV_VERTA_VSYNC));
@@ -369,7 +370,7 @@ static void vc4_crtc_config_pv(struct drm_crtc *crtc, struct drm_atomic_state *s
 	if (interlace) {
 		CRTC_WRITE(PV_VERTA_EVEN,
 			   VC4_SET_FIELD(mode->crtc_vtotal -
-					 mode->crtc_vsync_end - 1,
+					 mode->crtc_vsync_end,
 					 PV_VERTA_VBP) |
 			   VC4_SET_FIELD(mode->crtc_vsync_end -
 					 mode->crtc_vsync_start,
@@ -389,7 +390,7 @@ static void vc4_crtc_config_pv(struct drm_crtc *crtc, struct drm_atomic_state *s
 			   PV_VCONTROL_CONTINUOUS |
 			   (is_dsi ? PV_VCONTROL_DSI : 0) |
 			   PV_VCONTROL_INTERLACE |
-			   VC4_SET_FIELD(mode->htotal * pixel_rep / 2,
+			   VC4_SET_FIELD(mode->htotal * pixel_rep / (2 * ppc),
 					 PV_VCONTROL_ODD_DELAY));
 		CRTC_WRITE(PV_VSYNCD_EVEN, 0);
 	} else {
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index e16fece541da..ddcead896fe8 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -738,12 +738,12 @@ static void vc4_hdmi_set_timings(struct vc4_hdmi *vc4_hdmi,
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
 
 	HDMI_WRITE(HDMI_HORZA,
@@ -784,12 +784,12 @@ static void vc5_hdmi_set_timings(struct vc4_hdmi *vc4_hdmi,
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
 	unsigned char gcp;
 	bool gcp_en;
-- 
2.35.1




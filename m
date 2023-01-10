Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2ED664B1A
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239543AbjAJSix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239596AbjAJSiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:38:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C9F1C93B
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:33:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F22AA61846
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08853C433F0;
        Tue, 10 Jan 2023 18:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375624;
        bh=zlMEINmUzMcpS0zn0qksfCGqV40JBQ8O1BJk4ZA6Vhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UI0I5+W4rPhsXe6PFWCl65OjeoJjCR18Ep7XFPXL78FQ4dNqwESvmutVP0ajMWQXU
         G5mD0YzEMh/fVRYiyPaGVmfWQ3OdPKwDJaPI5uYTtA5S2HvJtaPPkYQfKcaRGP4Whn
         b9S/mr2it+7Q0ruNjak0qhggnEaWN1TKROrB//14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ian Ray <ian.ray@ge.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 250/290] drm/imx: ipuv3-plane: Fix overlay plane width
Date:   Tue, 10 Jan 2023 19:05:42 +0100
Message-Id: <20230110180040.630685156@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 92d43bd3bc9728c1fb114d7011d46f5ea9489e28 ]

ipu_src_rect_width() was introduced to support odd screen resolutions
such as 1366x768 by internally rounding up primary plane width to a
multiple of 8 and compensating with reduced horizontal blanking.
This also caused overlay plane width to be rounded up, which was not
intended. Fix overlay plane width by limiting the rounding up to the
primary plane.

drm_rect_width(&new_state->src) >> 16 is the same value as
drm_rect_width(dst) because there is no plane scaling support.

Fixes: 94dfec48fca7 ("drm/imx: Add 8 pixel alignment fix")
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://lore.kernel.org/r/20221108141420.176696-1-p.zabel@pengutronix.de
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221108141420.176696-1-p.zabel@pengutronix.de
Tested-by: Ian Ray <ian.ray@ge.com>
(cherry picked from commit 4333472f8d7befe62359fecb1083cd57a6e07bfc)
Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3-plane.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3-plane.c b/drivers/gpu/drm/imx/ipuv3-plane.c
index 846c1aae69c8..924a66f53951 100644
--- a/drivers/gpu/drm/imx/ipuv3-plane.c
+++ b/drivers/gpu/drm/imx/ipuv3-plane.c
@@ -619,6 +619,11 @@ static void ipu_plane_atomic_update(struct drm_plane *plane,
 		break;
 	}
 
+	if (ipu_plane->dp_flow == IPU_DP_FLOW_SYNC_BG)
+		width = ipu_src_rect_width(new_state);
+	else
+		width = drm_rect_width(&new_state->src) >> 16;
+
 	eba = drm_plane_state_to_eba(new_state, 0);
 
 	/*
@@ -627,8 +632,7 @@ static void ipu_plane_atomic_update(struct drm_plane *plane,
 	 */
 	if (ipu_state->use_pre) {
 		axi_id = ipu_chan_assign_axi_id(ipu_plane->dma);
-		ipu_prg_channel_configure(ipu_plane->ipu_ch, axi_id,
-					  ipu_src_rect_width(new_state),
+		ipu_prg_channel_configure(ipu_plane->ipu_ch, axi_id, width,
 					  drm_rect_height(&new_state->src) >> 16,
 					  fb->pitches[0], fb->format->format,
 					  fb->modifier, &eba);
@@ -683,9 +687,8 @@ static void ipu_plane_atomic_update(struct drm_plane *plane,
 		break;
 	}
 
-	ipu_dmfc_config_wait4eot(ipu_plane->dmfc, ALIGN(drm_rect_width(dst), 8));
+	ipu_dmfc_config_wait4eot(ipu_plane->dmfc, width);
 
-	width = ipu_src_rect_width(new_state);
 	height = drm_rect_height(&new_state->src) >> 16;
 	info = drm_format_info(fb->format->format);
 	ipu_calculate_bursts(width, info->cpp[0], fb->pitches[0],
@@ -749,8 +752,7 @@ static void ipu_plane_atomic_update(struct drm_plane *plane,
 		ipu_cpmem_set_burstsize(ipu_plane->ipu_ch, 16);
 
 		ipu_cpmem_zero(ipu_plane->alpha_ch);
-		ipu_cpmem_set_resolution(ipu_plane->alpha_ch,
-					 ipu_src_rect_width(new_state),
+		ipu_cpmem_set_resolution(ipu_plane->alpha_ch, width,
 					 drm_rect_height(&new_state->src) >> 16);
 		ipu_cpmem_set_format_passthrough(ipu_plane->alpha_ch, 8);
 		ipu_cpmem_set_high_priority(ipu_plane->alpha_ch);
-- 
2.35.1




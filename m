Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D75378866
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbhEJLVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237107AbhEJLLV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0417616E8;
        Mon, 10 May 2021 11:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644827;
        bh=iP8Xl5cIV0qr7oBh+yfEjl1AhKiBKCLTrvuWfKZd+bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFJ7/20ij8PdMuaJAhuWuTguUYZ652fDx8n/OveMRJVoCMfxKFjKT7MWACIdpZ+fj
         MGaqn/Ys58PrpMcE5e7ws4I/1Y8xvLS/L5kM7gjAD23vqKfBQqgAu2Bct9U1Vl2+WL
         zjJPsqYxRZYtSFIdGtyrcl1HUVzVcpJtv8t+AHh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 241/384] drm/msm/mdp5: Do not multiply vclk line count by 100
Date:   Mon, 10 May 2021 12:20:30 +0200
Message-Id: <20210510102022.828210283@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 377569f82ea8228c421cef4da33e056a900b58ca ]

Neither vtotal nor drm_mode_vrefresh contain a value that is
premultiplied by 100 making the x100 variable name incorrect and
resulting in vclks_line to become 100 times larger than it is supposed
to be.  The hardware counts 100 clockticks too many before tearcheck,
leading to severe panel issues on at least the Sony Xperia lineup.

This is likely an artifact from the original MDSS DSI panel driver where
the calculation [1] corrected for a premultiplied reference framerate by
100 [2].  It does not appear that the above values were ever
premultiplied in the history of the DRM MDP5 driver.

With this change applied the value written to the SYNC_CONFIG_VSYNC
register is now identical to downstream kernels.

[1]: https://source.codeaurora.org/quic/la/kernel/msm-3.18/tree/drivers/video/msm/mdss/mdss_mdp_intf_cmd.c?h=LA.UM.8.6.c26-02400-89xx.0#n288
[2]: https://source.codeaurora.org/quic/la/kernel/msm-3.18/tree/drivers/video/msm/mdss/mdss_dsi_panel.c?h=LA.UM.8.6.c26-02400-89xx.0#n1648

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Link: https://lore.kernel.org/r/20210406214726.131534-3-marijn.suijten@somainline.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c
index f6df4d3b1406..0392d4dfe270 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c
@@ -20,7 +20,7 @@ static int pingpong_tearcheck_setup(struct drm_encoder *encoder,
 {
 	struct mdp5_kms *mdp5_kms = get_kms(encoder);
 	struct device *dev = encoder->dev->dev;
-	u32 total_lines_x100, vclks_line, cfg;
+	u32 total_lines, vclks_line, cfg;
 	long vsync_clk_speed;
 	struct mdp5_hw_mixer *mixer = mdp5_crtc_get_mixer(encoder->crtc);
 	int pp_id = mixer->pp;
@@ -30,8 +30,8 @@ static int pingpong_tearcheck_setup(struct drm_encoder *encoder,
 		return -EINVAL;
 	}
 
-	total_lines_x100 = mode->vtotal * drm_mode_vrefresh(mode);
-	if (!total_lines_x100) {
+	total_lines = mode->vtotal * drm_mode_vrefresh(mode);
+	if (!total_lines) {
 		DRM_DEV_ERROR(dev, "%s: vtotal(%d) or vrefresh(%d) is 0\n",
 			      __func__, mode->vtotal, drm_mode_vrefresh(mode));
 		return -EINVAL;
@@ -43,7 +43,7 @@ static int pingpong_tearcheck_setup(struct drm_encoder *encoder,
 							vsync_clk_speed);
 		return -EINVAL;
 	}
-	vclks_line = vsync_clk_speed * 100 / total_lines_x100;
+	vclks_line = vsync_clk_speed / total_lines;
 
 	cfg = MDP5_PP_SYNC_CONFIG_VSYNC_COUNTER_EN
 		| MDP5_PP_SYNC_CONFIG_VSYNC_IN_EN;
-- 
2.30.2




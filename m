Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68644371C4A
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhECQvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:32838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234554AbhECQu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD70461923;
        Mon,  3 May 2021 16:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060054;
        bh=BCOE47gw0we5L3WlvPJTxVG0irZDJI/+FHR8ebkLFQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOGrYxTxUV+zS2ZfbOpYSRYiUe+jsrQd29qwhRLTwe9tCeW2BgC31t01Btc0LxION
         M81Vw/v8tRXbhf+f4e7yoCMsYKUzJ8ZL7v3d4Z05FEgprwLOFWmWKatOH6HKQnXXzM
         OLeupUXeJGcT/oGNfp84SRwKtkIJGXc9lTIxfYkaLzTdZFgOp6OxidcnQPTdAljbAo
         XlupOl7ftUN8d4jRYsPr9fltqnE/A6xI+WUSwKaApo9P4NmA1f6hrbV+MZIPzPQyTF
         5AXtAC83VfpvoOkR3BKNMA+XB10h/SKFn9TSAXV7o/gTZf4s0gH3L5BYx3WULCRqKR
         cEhl+kR+7HBmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marijn Suijten <marijn.suijten@somainline.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 48/57] drm/msm/mdp5: Do not multiply vclk line count by 100
Date:   Mon,  3 May 2021 12:39:32 -0400
Message-Id: <20210503163941.2853291-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 288f18cbf62d..0425400f44db 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c
@@ -41,7 +41,7 @@ static int pingpong_tearcheck_setup(struct drm_encoder *encoder,
 {
 	struct mdp5_kms *mdp5_kms = get_kms(encoder);
 	struct device *dev = encoder->dev->dev;
-	u32 total_lines_x100, vclks_line, cfg;
+	u32 total_lines, vclks_line, cfg;
 	long vsync_clk_speed;
 	struct mdp5_hw_mixer *mixer = mdp5_crtc_get_mixer(encoder->crtc);
 	int pp_id = mixer->pp;
@@ -51,8 +51,8 @@ static int pingpong_tearcheck_setup(struct drm_encoder *encoder,
 		return -EINVAL;
 	}
 
-	total_lines_x100 = mode->vtotal * drm_mode_vrefresh(mode);
-	if (!total_lines_x100) {
+	total_lines = mode->vtotal * drm_mode_vrefresh(mode);
+	if (!total_lines) {
 		DRM_DEV_ERROR(dev, "%s: vtotal(%d) or vrefresh(%d) is 0\n",
 			      __func__, mode->vtotal, drm_mode_vrefresh(mode));
 		return -EINVAL;
@@ -64,7 +64,7 @@ static int pingpong_tearcheck_setup(struct drm_encoder *encoder,
 							vsync_clk_speed);
 		return -EINVAL;
 	}
-	vclks_line = vsync_clk_speed * 100 / total_lines_x100;
+	vclks_line = vsync_clk_speed / total_lines;
 
 	cfg = MDP5_PP_SYNC_CONFIG_VSYNC_COUNTER_EN
 		| MDP5_PP_SYNC_CONFIG_VSYNC_IN_EN;
-- 
2.30.2


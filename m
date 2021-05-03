Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC085371D9C
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhECRBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 13:01:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232013AbhECQ5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:57:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C317606A5;
        Mon,  3 May 2021 16:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060229;
        bh=CUa6fDlJdtOnkrgQq1DKHgdCRYF4uXoisvo2HPBjMs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUQQyI5aGoZmvXaSuIUawWKok5ybUQpIQAVyRFPvEhsy1vT5Xz3dhup3Fp+Gf1fJB
         ocq2cqR56dcIsXM+ELDc+2Cg8GRiKZJF/RLc6tbqA5HlUeiKtIk/oMfbFQuDJLDSFU
         ki8Cr5qnKqUpcjSDe+bW5npQVOp1PH/ZFZwZQN8kspVEOEgqlRCy5BW1X1e+sEM1Ei
         cZAf1UutwXcqnSyQBdF/NCLkdIj/VKc6pVR4oMdGAjwrLLK/gGBDqkiRWXH293IFl9
         aakGF9ZFdRj1fcjFyc76iiyjTwtcE+oT90nNi/mIPEG+l37S1kBCFHslExBnwleLnr
         VLs9pkTfhmeAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marijn Suijten <marijn.suijten@somainline.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 13/16] drm/msm/mdp5: Configure PP_SYNC_HEIGHT to double the vtotal
Date:   Mon,  3 May 2021 12:43:26 -0400
Message-Id: <20210503164329.2854739-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164329.2854739-1-sashal@kernel.org>
References: <20210503164329.2854739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 2ad52bdb220de5ab348098e3482b01235d15a842 ]

Leaving this at a close-to-maximum register value 0xFFF0 means it takes
very long for the MDSS to generate a software vsync interrupt when the
hardware TE interrupt doesn't arrive.  Configuring this to double the
vtotal (like some downstream kernels) leads to a frame to take at most
twice before the vsync signal, until hardware TE comes up.

In this case the hardware interrupt responsible for providing this
signal - "disp-te" gpio - is not hooked up to the mdp5 vsync/pp logic at
all.  This solves severe panel update issues observed on at least the
Xperia Loire and Tone series, until said gpio is properly hooked up to
an irq.

Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Link: https://lore.kernel.org/r/20210406214726.131534-2-marijn.suijten@somainline.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cmd_encoder.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cmd_encoder.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cmd_encoder.c
index 8e6c9b598a57..d8c7b8a6a418 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cmd_encoder.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cmd_encoder.c
@@ -128,9 +128,17 @@ static int pingpong_tearcheck_setup(struct drm_encoder *encoder,
 		| MDP5_PP_SYNC_CONFIG_VSYNC_IN_EN;
 	cfg |= MDP5_PP_SYNC_CONFIG_VSYNC_COUNT(vclks_line);
 
+	/*
+	 * Tearcheck emits a blanking signal every vclks_line * vtotal * 2 ticks on
+	 * the vsync_clk equating to roughly half the desired panel refresh rate.
+	 * This is only necessary as stability fallback if interrupts from the
+	 * panel arrive too late or not at all, but is currently used by default
+	 * because these panel interrupts are not wired up yet.
+	 */
 	mdp5_write(mdp5_kms, REG_MDP5_PP_SYNC_CONFIG_VSYNC(pp_id), cfg);
 	mdp5_write(mdp5_kms,
-		REG_MDP5_PP_SYNC_CONFIG_HEIGHT(pp_id), 0xfff0);
+		REG_MDP5_PP_SYNC_CONFIG_HEIGHT(pp_id), (2 * mode->vtotal));
+
 	mdp5_write(mdp5_kms,
 		REG_MDP5_PP_VSYNC_INIT_VAL(pp_id), mode->vdisplay);
 	mdp5_write(mdp5_kms, REG_MDP5_PP_RD_PTR_IRQ(pp_id), mode->vdisplay + 1);
-- 
2.30.2


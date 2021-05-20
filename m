Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C6738A5F2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236053AbhETKVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236492AbhETKTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:19:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F5646145F;
        Thu, 20 May 2021 09:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504040;
        bh=qmsD5qUUJyw98XkWtIT0ula+AfFy+NCvsgRg8vdj1+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwFAJkC+fRHK1QIeNeJk6Jnq6cdau3Gn7zINvrUiCvePybDo0Ui1Nf+Un1H5RUJdP
         mJjZo/yM8J8EOihis8rO+g+wYInthH7wDbzZoT9gEFXQsHWaMIVGb+ezsO0p5+sqJy
         9tn+CTmSMvARyXlnYcy5JZNhiwcooLeCKqhjz2iM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 068/323] drm/msm/mdp5: Configure PP_SYNC_HEIGHT to double the vtotal
Date:   Thu, 20 May 2021 11:19:20 +0200
Message-Id: <20210520092122.433277334@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 60790df91bfa..397e71481129 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cmd_encoder.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cmd_encoder.c
@@ -78,9 +78,17 @@ static int pingpong_tearcheck_setup(struct drm_encoder *encoder,
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




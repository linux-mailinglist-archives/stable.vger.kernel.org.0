Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D495C37869C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbhEJLJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:09:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235375AbhEJLAt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:00:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB87E61A2D;
        Mon, 10 May 2021 10:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644003;
        bh=6L+UN9HNWtK4MTQO6xqBHLL8BwK5sHu8Y0fdOskqV+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djsc1TJpT/+UOalHVh2P1Z4FFd8d4AGwZHZNeyN1wV+Ed5WCL+bQGHOiqal8aFavg
         u3cA71g89s/K5o+8SThvqGHBlm9UXwu/fDOnnyrayJ1xvqm3OiC6efCqTTj0YISE5v
         DG244h8XeBZCvb1nTWUAQt4t4qpV4muoMd5w/nJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 213/342] drm/msm/mdp5: Configure PP_SYNC_HEIGHT to double the vtotal
Date:   Mon, 10 May 2021 12:20:03 +0200
Message-Id: <20210510102017.128817775@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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
 drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c
index ff2c1d583c79..f6df4d3b1406 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c
@@ -49,9 +49,17 @@ static int pingpong_tearcheck_setup(struct drm_encoder *encoder,
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




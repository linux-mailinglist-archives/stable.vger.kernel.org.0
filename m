Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A354057B7
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349031AbhIINlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351801AbhIIMrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:47:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 026BF613D0;
        Thu,  9 Sep 2021 11:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188580;
        bh=6sB9V2TH2YXKggSm4ORmhaVpFYlE+jF8nGZ2tX7oayk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C37/nFb8NQvJIw7Chtpb6dP33LMvufkhlvmlA3pdcTRkfOkWYY5amuOgWdqGZBnnw
         ktNxYB/ZaMtSgldW9w22waXoHPL4l+ZhUh/6iLoJrn5/1az0hCExr5Dcv9wYDTKuln
         cEMuvEkO7QXztlrbXrDwC5GQD9/mV0a/rznJoeOP12DYZSSO9SZkZuX1h6irqeQH+3
         FGUG+JChBMfFNZ0tgyWwYf2hGiX7BgD1v4rnLSh5Gr+vZkhC+3jwpy7C38Ze0Z+PFZ
         WjC3i0FhnZwc0aFyXIIDrTUimAevRInI6GhryJe7AAIztRogpGVGtav5Zcf31gEb8f
         8XrW2ur7j12Aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Heidelberg <david@ixit.cz>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 057/109] drm/msm: mdp4: drop vblank get/put from prepare/complete_commit
Date:   Thu,  9 Sep 2021 07:54:14 -0400
Message-Id: <20210909115507.147917-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 56bd931ae506730c9ab1e4cc4bfefa43fc2d18fa ]

msm_atomic is doing vblank get/put's already,
currently there no need to duplicate the effort in MDP4

Fix warning:
...
WARNING: CPU: 3 PID: 79 at drivers/gpu/drm/drm_vblank.c:1194 drm_vblank_put+0x1cc/0x1d4
...
and multiple vblank time-outs:
...
msm 5100000.mdp: vblank time out, crtc=1
...

Tested on Nexus 7 2013 (deb), LTS 5.10.50.

Introduced by: 119ecb7fd3b5 ("drm/msm/mdp4: request vblank during modeset")

Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://lore.kernel.org/r/20210715060925.7880-1-david@ixit.cz
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
index 20194d86d033..5d50e93efe36 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
@@ -108,13 +108,6 @@ static void mdp4_disable_commit(struct msm_kms *kms)
 
 static void mdp4_prepare_commit(struct msm_kms *kms, struct drm_atomic_state *state)
 {
-	int i;
-	struct drm_crtc *crtc;
-	struct drm_crtc_state *crtc_state;
-
-	/* see 119ecb7fd */
-	for_each_new_crtc_in_state(state, crtc, crtc_state, i)
-		drm_crtc_vblank_get(crtc);
 }
 
 static void mdp4_flush_commit(struct msm_kms *kms, unsigned crtc_mask)
@@ -133,12 +126,6 @@ static void mdp4_wait_flush(struct msm_kms *kms, unsigned crtc_mask)
 
 static void mdp4_complete_commit(struct msm_kms *kms, unsigned crtc_mask)
 {
-	struct mdp4_kms *mdp4_kms = to_mdp4_kms(to_mdp_kms(kms));
-	struct drm_crtc *crtc;
-
-	/* see 119ecb7fd */
-	for_each_crtc_mask(mdp4_kms->dev, crtc, crtc_mask)
-		drm_crtc_vblank_put(crtc);
 }
 
 static long mdp4_round_pixclk(struct msm_kms *kms, unsigned long rate,
-- 
2.30.2


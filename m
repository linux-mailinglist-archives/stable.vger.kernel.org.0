Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1477C257C56
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgHaP3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:29:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbgHaP3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:29:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 383BA20936;
        Mon, 31 Aug 2020 15:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887783;
        bh=VJ0G36w4AwGdWcGN89VVM6vkew7+G4ceTdRs1y5VBhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTCYaOD+E4TXIVTHBLu3t6ghmtVmEeDFVu50klulLG0fmuUDdJeMpI58nLps2uphO
         x2VwfoaSmunnDvKDcfhCg1QDd47ykD9l/R0yc0fB8Jn/T1GyMRlgHpi70Zmrz/BJg6
         PiFtARASpyRr4tWffLj3gRqEIketWh+ia6voXvd4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kalyan Thota <kalyan_t@codeaurora.org>,
        "Kristian H . Kristensen" <hoegsberg@google.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 05/42] drm/msm/dpu: Fix scale params in plane validation
Date:   Mon, 31 Aug 2020 11:28:57 -0400
Message-Id: <20200831152934.1023912-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kalyan Thota <kalyan_t@codeaurora.org>

[ Upstream commit 4c978caf08aa155bdeadd9e2d4b026d4ce97ebd0 ]

Plane validation uses an API drm_calc_scale which will
return src/dst value as a scale ratio.

when viewing the range on a scale the values should fall in as

Upscale ratio < Unity scale < Downscale ratio for src/dst formula

Fix the min and max scale ratios to suit the API accordingly.

Signed-off-by: Kalyan Thota <kalyan_t@codeaurora.org>
Tested-by: Kristian H. Kristensen <hoegsberg@google.com>
Reviewed-by: Kristian H. Kristensen <hoegsberg@google.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
index 3b9c33e694bf4..994d23bad3870 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
@@ -866,9 +866,9 @@ static int dpu_plane_atomic_check(struct drm_plane *plane,
 		crtc_state = drm_atomic_get_new_crtc_state(state->state,
 							   state->crtc);
 
-	min_scale = FRAC_16_16(1, pdpu->pipe_sblk->maxdwnscale);
+	min_scale = FRAC_16_16(1, pdpu->pipe_sblk->maxupscale);
 	ret = drm_atomic_helper_check_plane_state(state, crtc_state, min_scale,
-					  pdpu->pipe_sblk->maxupscale << 16,
+					  pdpu->pipe_sblk->maxdwnscale << 16,
 					  true, true);
 	if (ret) {
 		DPU_DEBUG_PLANE(pdpu, "Check plane state failed (%d)\n", ret);
-- 
2.25.1


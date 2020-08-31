Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FAD257C9D
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgHaPar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:30:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728722AbgHaPaq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:30:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A815C20FC3;
        Mon, 31 Aug 2020 15:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887845;
        bh=ijrS9uIpRTrtNJTAMLV8xe4MQCKKTbmb4xcnDYux+Kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uIxZ2erkqhi9rY5fyzP9oiUVhNilSgEjeW7MTfY2ln3MXfIvecmeOid+23EoOhBZZ
         SmqSf1NUYponITpWRXWs8i6DtUS++3/ms97xvw8RhKjPc57+1X2xoJOKL4Yapjw9RY
         Y9NGOHyOkqQnRmKDgaXAUEfxeBVheOJIVKVL+6P0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kalyan Thota <kalyan_t@codeaurora.org>,
        "Kristian H . Kristensen" <hoegsberg@google.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 03/23] drm/msm/dpu: Fix scale params in plane validation
Date:   Mon, 31 Aug 2020 11:30:19 -0400
Message-Id: <20200831153039.1024302-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831153039.1024302-1-sashal@kernel.org>
References: <20200831153039.1024302-1-sashal@kernel.org>
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
index 58d5acbcfc5c2..b984bafd27e25 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
@@ -853,9 +853,9 @@ static int dpu_plane_atomic_check(struct drm_plane *plane,
 		crtc_state = drm_atomic_get_new_crtc_state(state->state,
 							   state->crtc);
 
-	min_scale = FRAC_16_16(1, pdpu->pipe_sblk->maxdwnscale);
+	min_scale = FRAC_16_16(1, pdpu->pipe_sblk->maxupscale);
 	ret = drm_atomic_helper_check_plane_state(state, crtc_state, min_scale,
-					  pdpu->pipe_sblk->maxupscale << 16,
+					  pdpu->pipe_sblk->maxdwnscale << 16,
 					  true, true);
 	if (ret) {
 		DPU_ERROR_PLANE(pdpu, "Check plane state failed (%d)\n", ret);
-- 
2.25.1


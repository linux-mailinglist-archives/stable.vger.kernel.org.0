Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6643226194F
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731896AbgIHSMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:12:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731495AbgIHQLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE7EE2478A;
        Tue,  8 Sep 2020 15:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579727;
        bh=ijrS9uIpRTrtNJTAMLV8xe4MQCKKTbmb4xcnDYux+Kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzquW525RBBXUCzDnTjUx2RYZAHoYzM6DVtNvNCbF0fOxFFvbvEE5Z04byS7Ikwz0
         gVSM1m5XzYJVd37NXmBwkHow/Qu8ZB+UyZObsNpeypY7YtshKA/ZVOtspF8JYjTbpq
         V9hEk+W1dKtfBVCUoRv3TnfCz3dgSV/PLQE+GfZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalyan Thota <kalyan_t@codeaurora.org>,
        "Kristian H. Kristensen" <hoegsberg@google.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/129] drm/msm/dpu: Fix scale params in plane validation
Date:   Tue,  8 Sep 2020 17:24:03 +0200
Message-Id: <20200908152229.815875995@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




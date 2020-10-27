Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B55F29B1D1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760529AbgJ0Oey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:34:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760116AbgJ0Oem (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:34:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22B272225E;
        Tue, 27 Oct 2020 14:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809281;
        bh=FDE0hqvUMIcEX+UOoX7iVp3RYulH01N1fwI4rgtH+cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=du/h1/ix2hPXYnKZzqtPH38QQwmUc9OZUJOoKzz6uha7BWTz6Nifx4cvvCaemTx2u
         WzBp3K7RPL8uYWGyp/NPZL/XJgu2R754+pgcrlBXVNDOnU9qvwMwGneagH+ml2I6/c
         0D+sSGeqTv2sB7tzqWcNoRFlpX8rBj8w/Rjn1GOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhinav Kumar <abhinavk@codeaurora.org>,
        Jeykumar Sankaran <jsanka@codeaurora.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Sean Paul <seanpaul@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 140/408] drm/msm: Avoid div-by-zero in dpu_crtc_atomic_check()
Date:   Tue, 27 Oct 2020 14:51:18 +0100
Message-Id: <20201027135501.591813165@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 22f760941844dbcee6ee446e1896532f6dff01ef ]

The cstate->num_mixers member is only set to a non-zero value once
dpu_encoder_virt_mode_set() is called, but the atomic check function can
be called by userspace before that. Let's avoid the div-by-zero here and
inside _dpu_crtc_setup_lm_bounds() by skipping this part of the atomic
check if dpu_encoder_virt_mode_set() hasn't been called yet. This fixes
an UBSAN warning:

 UBSAN: Undefined behaviour in drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c:860:31
 division by zero
 CPU: 7 PID: 409 Comm: frecon Tainted: G S                5.4.31 #128
 Hardware name: Google Trogdor (rev0) (DT)
 Call trace:
  dump_backtrace+0x0/0x14c
  show_stack+0x20/0x2c
  dump_stack+0xa0/0xd8
  __ubsan_handle_divrem_overflow+0xec/0x110
  dpu_crtc_atomic_check+0x97c/0x9d4
  drm_atomic_helper_check_planes+0x160/0x1c8
  drm_atomic_helper_check+0x54/0xbc
  drm_atomic_check_only+0x6a8/0x880
  drm_atomic_commit+0x20/0x5c
  drm_atomic_helper_set_config+0x98/0xa0
  drm_mode_setcrtc+0x308/0x5dc
  drm_ioctl_kernel+0x9c/0x114
  drm_ioctl+0x2ac/0x4b0
  drm_compat_ioctl+0xe8/0x13c
  __arm64_compat_sys_ioctl+0x184/0x324
  el0_svc_common+0xa4/0x154
  el0_svc_compat_handler+0x

Cc: Abhinav Kumar <abhinavk@codeaurora.org>
Cc: Jeykumar Sankaran <jsanka@codeaurora.org>
Cc: Jordan Crouse <jcrouse@codeaurora.org>
Cc: Sean Paul <seanpaul@chromium.org>
Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Abhinav Kumar <abhinavk@codeaurora.org>
Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index 36c85c05b7cf7..4aed5e9a84a45 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -819,7 +819,7 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
 	struct drm_plane *plane;
 	struct drm_display_mode *mode;
 
-	int cnt = 0, rc = 0, mixer_width, i, z_pos;
+	int cnt = 0, rc = 0, mixer_width = 0, i, z_pos;
 
 	struct dpu_multirect_plane_states multirect_plane[DPU_STAGE_MAX * 2];
 	int multirect_count = 0;
@@ -852,9 +852,11 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
 
 	memset(pipe_staged, 0, sizeof(pipe_staged));
 
-	mixer_width = mode->hdisplay / cstate->num_mixers;
+	if (cstate->num_mixers) {
+		mixer_width = mode->hdisplay / cstate->num_mixers;
 
-	_dpu_crtc_setup_lm_bounds(crtc, state);
+		_dpu_crtc_setup_lm_bounds(crtc, state);
+	}
 
 	crtc_rect.x2 = mode->hdisplay;
 	crtc_rect.y2 = mode->vdisplay;
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B2C2E4238
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436977AbgL1OCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:02:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436986AbgL1OCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6F0A205CB;
        Mon, 28 Dec 2020 14:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164152;
        bh=XR9cIeqq/RFKUEc4fpvdJ82X3kRBbJhJ1vrZ4LhHatc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RpuSyaYmJdR4Pj7w+XuRnMFmLyZQed+kQt4XIlAZvN+zy8YYpFmY1CYIxbJyhDwl0
         NY9DIXlboj8PPDNjoajQWlZ/QR8grutTUpHERti6Xk0OtSFXW2Pv9GGRK9w22qlT3q
         CiuQs28H0iBXbPJeMvjgoxUACqkyILe3dANOAjfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <abhinavk@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/717] drm/msm/dpu: fix clock scaling on non-sc7180 board
Date:   Mon, 28 Dec 2020 13:40:47 +0100
Message-Id: <20201228125023.340705799@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit cccdeda362fafd0613b571affe7199eb7d8f3fba ]

c33b7c0389e1 ("drm/msm/dpu: add support for clk and bw scaling for
display") has added support for handling bandwidth voting in kms path in
addition to old mdss path. However this broke all other platforms since
_dpu_core_perf_crtc_update_bus() will now error out instead of properly
calculating bandwidth and core clocks. Fix
_dpu_core_perf_crtc_update_bus() to just skip bandwidth setting instead
of returning an error in case kms->num_paths == 0 (MDSS is used for
bandwidth management).

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: c33b7c0389e1 ("drm/msm/dpu: add support for clk and bw scaling for display")
Reviewed-by: Abhinav Kumar <abhinavk@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
index 393858ef8a832..37c8270681c23 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -219,9 +219,6 @@ static int _dpu_core_perf_crtc_update_bus(struct dpu_kms *kms,
 	int i, ret = 0;
 	u64 avg_bw;
 
-	if (!kms->num_paths)
-		return -EINVAL;
-
 	drm_for_each_crtc(tmp_crtc, crtc->dev) {
 		if (tmp_crtc->enabled &&
 			curr_client_type ==
@@ -239,6 +236,9 @@ static int _dpu_core_perf_crtc_update_bus(struct dpu_kms *kms,
 		}
 	}
 
+	if (!kms->num_paths)
+		return 0;
+
 	avg_bw = perf.bw_ctl;
 	do_div(avg_bw, (kms->num_paths * 1000)); /*Bps_to_icc*/
 
-- 
2.27.0




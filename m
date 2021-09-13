Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12F3408F86
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241581AbhIMNoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242650AbhIMNmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:42:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6909B61354;
        Mon, 13 Sep 2021 13:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539792;
        bh=n1fzEh8BglQyvMQT+P5Pol8uCH4i0Nhg/xP7DY9oYuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3+P0QH3liXIgXHxCjsTPpORiZ9SCanefXfSi2GzcsbfySOZJvbwxDQtYZ5tyQX2T
         BOs45eZyl8ZZC1bpV+d/Kgtyk2Tf5Ha3HdeaDrk/kKn+MckvCWAdPw7csnksZSUDsI
         7VGgemjfBQ/vXDMDigxwQUUPA7lQrCfD1XSEeFIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/236] drm/msm/dpu: make dpu_hw_ctl_clear_all_blendstages clear necessary LMs
Date:   Mon, 13 Sep 2021 15:14:00 +0200
Message-Id: <20210913131104.957159343@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a41cdb693595ae1904dd793fc15d6954f4295e27 ]

dpu_hw_ctl_clear_all_blendstages() clears settings for the few first LMs
instead of mixers actually used for the CTL. Change it to clear
necessary data, using provided mixer ids.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20210704230519.4081467-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
index 758c355b4fd8..f8c7100a8acb 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
@@ -340,10 +340,12 @@ static void dpu_hw_ctl_clear_all_blendstages(struct dpu_hw_ctl *ctx)
 	int i;
 
 	for (i = 0; i < ctx->mixer_count; i++) {
-		DPU_REG_WRITE(c, CTL_LAYER(LM_0 + i), 0);
-		DPU_REG_WRITE(c, CTL_LAYER_EXT(LM_0 + i), 0);
-		DPU_REG_WRITE(c, CTL_LAYER_EXT2(LM_0 + i), 0);
-		DPU_REG_WRITE(c, CTL_LAYER_EXT3(LM_0 + i), 0);
+		enum dpu_lm mixer_id = ctx->mixer_hw_caps[i].id;
+
+		DPU_REG_WRITE(c, CTL_LAYER(mixer_id), 0);
+		DPU_REG_WRITE(c, CTL_LAYER_EXT(mixer_id), 0);
+		DPU_REG_WRITE(c, CTL_LAYER_EXT2(mixer_id), 0);
+		DPU_REG_WRITE(c, CTL_LAYER_EXT3(mixer_id), 0);
 	}
 }
 
-- 
2.30.2




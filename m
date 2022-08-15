Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93BD5948A4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354248AbiHOXoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354467AbiHOXmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:42:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B685491CA;
        Mon, 15 Aug 2022 13:13:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95B27B81154;
        Mon, 15 Aug 2022 20:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2224C433D7;
        Mon, 15 Aug 2022 20:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594409;
        bh=NyLGZrmkN/d+RhugtN39rrIWi6Tif1siwmp5jXnzoNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BemnqsKAMlgCeEgbnJJ1IRFp47bqjHgDoDOlrDpgonvmSaWB5XsML47Tn7t3azKFq
         x770NlOx+WlSRbaUp7ousj6wv2KRdk7WWw6whjvGYLdIfdrVpV+0CkWT7od+99RvZm
         1srwhaZWa3L0yqzL0TKdIZBGZGYP+feq8ti7IxZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0436/1157] drm/msm/dpu: move intf and wb assignment to dpu_encoder_setup_display()
Date:   Mon, 15 Aug 2022 19:56:32 +0200
Message-Id: <20220815180457.083799772@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit b4a624acabe99f2ea912e895529b8b37d1fa909d ]

intf and wb resources are not dependent on the rm global
state so need not be allocated during dpu_encoder_virt_atomic_mode_set().

Move the allocation of intf and wb resources to dpu_encoder_setup_display()
so that we can utilize the hw caps even during atomic_check() phase.

Since dpu_encoder_setup_display() already has protection against
setting invalid intf_idx and wb_idx, these checks can now
be dropped as well.

changes in v2:
	- add phys->hw_intf and phys->hw_wb checks back

changes in v3:
	- correct the Fixes tag

Fixes: e02a559a720f ("drm/msm/dpu: make changes to dpu_encoder to support virtual encoder")
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/489885/
Link: https://lore.kernel.org/r/1655406084-17407-1-git-send-email-quic_abhinavk@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 36 ++++++++++-----------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index a1b8c4592943..9b4df3084366 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1048,24 +1048,6 @@ static void dpu_encoder_virt_atomic_mode_set(struct drm_encoder *drm_enc,
 		phys->hw_pp = dpu_enc->hw_pp[i];
 		phys->hw_ctl = to_dpu_hw_ctl(hw_ctl[i]);
 
-		if (phys->intf_idx >= INTF_0 && phys->intf_idx < INTF_MAX)
-			phys->hw_intf = dpu_rm_get_intf(&dpu_kms->rm, phys->intf_idx);
-
-		if (phys->wb_idx >= WB_0 && phys->wb_idx < WB_MAX)
-			phys->hw_wb = dpu_rm_get_wb(&dpu_kms->rm, phys->wb_idx);
-
-		if (!phys->hw_intf && !phys->hw_wb) {
-			DPU_ERROR_ENC(dpu_enc,
-				      "no intf or wb block assigned at idx: %d\n", i);
-			return;
-		}
-
-		if (phys->hw_intf && phys->hw_wb) {
-			DPU_ERROR_ENC(dpu_enc,
-					"invalid phys both intf and wb block at idx: %d\n", i);
-			return;
-		}
-
 		phys->cached_mode = crtc_state->adjusted_mode;
 		if (phys->ops.atomic_mode_set)
 			phys->ops.atomic_mode_set(phys, crtc_state, conn_state);
@@ -2294,7 +2276,25 @@ static int dpu_encoder_setup_display(struct dpu_encoder_virt *dpu_enc,
 		struct dpu_encoder_phys *phys = dpu_enc->phys_encs[i];
 		atomic_set(&phys->vsync_cnt, 0);
 		atomic_set(&phys->underrun_cnt, 0);
+
+		if (phys->intf_idx >= INTF_0 && phys->intf_idx < INTF_MAX)
+			phys->hw_intf = dpu_rm_get_intf(&dpu_kms->rm, phys->intf_idx);
+
+		if (phys->wb_idx >= WB_0 && phys->wb_idx < WB_MAX)
+			phys->hw_wb = dpu_rm_get_wb(&dpu_kms->rm, phys->wb_idx);
+
+		if (!phys->hw_intf && !phys->hw_wb) {
+			DPU_ERROR_ENC(dpu_enc, "no intf or wb block assigned at idx: %d\n", i);
+			ret = -EINVAL;
+		}
+
+		if (phys->hw_intf && phys->hw_wb) {
+			DPU_ERROR_ENC(dpu_enc,
+					"invalid phys both intf and wb block at idx: %d\n", i);
+			ret = -EINVAL;
+		}
 	}
+
 	mutex_unlock(&dpu_enc->enc_lock);
 
 	return ret;
-- 
2.35.1




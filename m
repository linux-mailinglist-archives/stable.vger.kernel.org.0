Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9683C5948E7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354023AbiHOXrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354541AbiHOXpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:45:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3928C01E;
        Mon, 15 Aug 2022 13:14:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F0ADB80EAB;
        Mon, 15 Aug 2022 20:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12ECC433D6;
        Mon, 15 Aug 2022 20:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594463;
        bh=nXZeYBp97SFK8kYhMdUs3YHMALM+8suLMoNuom0wygM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LETnqG12cz8MOZahEPVgqMc8+otiiKFkl83GRJ3fWfIOEDTLCfEI+EtCubt7/CgcR
         lLvOSG7zqr33gmUpMD5fPm/eSUOG37R2Qy2nOEJRyTa9NT5S6tenfc3yrIm8q83syo
         su3bKgvw91wwGC+OUjwO2UYJ45cz/pvV5S+kOe/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0456/1157] drm/msm/dpu: Fix for non-visible planes
Date:   Mon, 15 Aug 2022 19:56:52 +0200
Message-Id: <20220815180457.836986086@linuxfoundation.org>
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit cb77085b1f0a86ef9dfba86b5f3ed6c3340c2ea3 ]

Fixes `kms_cursor_crc --run-subtest cursor-offscreen`.. when the cursor
moves offscreen the plane becomes non-visible, so we need to skip over
it in crtc atomic test and mixer setup.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/492819/
Link: https://lore.kernel.org/r/20220707212003.1710163-1-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index b56f777dbd0e..4c5c1f627cb8 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -361,6 +361,9 @@ static void _dpu_crtc_blend_setup_mixer(struct drm_crtc *crtc,
 		if (!state)
 			continue;
 
+		if (!state->visible)
+			continue;
+
 		pstate = to_dpu_plane_state(state);
 		fb = state->fb;
 
@@ -1134,6 +1137,9 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
 		if (cnt >= DPU_STAGE_MAX * 4)
 			continue;
 
+		if (!pstate->visible)
+			continue;
+
 		pstates[cnt].dpu_pstate = dpu_pstate;
 		pstates[cnt].drm_pstate = pstate;
 		pstates[cnt].stage = pstate->normalized_zpos;
-- 
2.35.1




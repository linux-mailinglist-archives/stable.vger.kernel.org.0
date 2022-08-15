Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE8D593722
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244482AbiHOS5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244944AbiHOS4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:56:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09B53207D;
        Mon, 15 Aug 2022 11:30:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 790B4B8106E;
        Mon, 15 Aug 2022 18:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78B1C433D7;
        Mon, 15 Aug 2022 18:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588249;
        bh=0r83TGpcAX7q/Cw7qOMQx30enfCYni4wKmfou4vNh/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TklbjKTtiFP9nY/y7iygYB6QalvVeN94EDyPnf3sjd7eooFAUuMkCrTd3x343dudC
         cJChAegqi33PzwSGCaRlgc2DwdFuVcS/ZRn2wuaZ+chgPalnwqpWbujZORe7QMGLM9
         VeSCUy564HfDG//dOHHuY567GDTKDwXj65NQV+PM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 325/779] drm/msm/dpu: Fix for non-visible planes
Date:   Mon, 15 Aug 2022 19:59:29 +0200
Message-Id: <20220815180351.184909912@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 7706a7106122..2186fc947e5b 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -230,6 +230,9 @@ static void _dpu_crtc_blend_setup_mixer(struct drm_crtc *crtc,
 		if (!state)
 			continue;
 
+		if (!state->visible)
+			continue;
+
 		pstate = to_dpu_plane_state(state);
 		fb = state->fb;
 
@@ -976,6 +979,9 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
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




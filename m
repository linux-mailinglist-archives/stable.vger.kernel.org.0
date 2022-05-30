Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860FD53807E
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238438AbiE3NwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237801AbiE3Nrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:47:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E70CA774A;
        Mon, 30 May 2022 06:34:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2510960DD5;
        Mon, 30 May 2022 13:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75561C3411A;
        Mon, 30 May 2022 13:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917676;
        bh=4gfnBQ3XOz9VePixJCdNt32X4yT6vHAJVKBKYUU2f0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmI3H31UTplcV2iWzP92w+JqEqnojGRWNrzL07Fh8g7zQzjW2tLEjVmoS+95LrXb4
         vZJ3aCJiaWkzT/pIxIYc94UzP3HEBCSiKHenr7x03O8oRJpbK+oU3XLkGAv63U6scC
         iKwZMY2EkbTn7hdZOOBt5Yv3XPPiqiwbmvlxu8Rv0nFpDWHaq9ts99m6kKLHFo7QGY
         Qp7SXMOvavAdso9ryYB3RiaDviiA1W+MENreStdMj+GO540y5LpRIBPn81+SBpN6A8
         5rOzwAxC5opkROXQP8UP1KAyUgN0m/801Vi1taDMxPBNLbU/bAF9bGXMZ8pIKyzgpW
         QfOQp3q7UDumw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jessica Zhang <quic_jesszhan@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        quic_abhinavk@quicinc.com, airlied@linux.ie, daniel@ffwll.ch,
        swboyd@chromium.org, nathan@kernel.org, yang.lee@linux.alibaba.com,
        seanpaul@chromium.org, markyacoub@google.com,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 059/135] drm/msm/dpu: Clean up CRC debug logs
Date:   Mon, 30 May 2022 09:30:17 -0400
Message-Id: <20220530133133.1931716-59-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jessica Zhang <quic_jesszhan@quicinc.com>

[ Upstream commit 3ce8bdca394fc606b55e7c5ed779d171aaae5d09 ]

Currently, dpu_hw_lm_collect_misr returns EINVAL if CRC is disabled.
This causes a lot of spam in the DRM debug logs as it's called for every
vblank.

Instead of returning EINVAL when CRC is disabled in
dpu_hw_lm_collect_misr, let's return ENODATA and add an extra ENODATA check
before the debug log in dpu_crtc_get_crc.

Changes since V1:
- Added reported-by and suggested-by tags

Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Suggested-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Tested-by: Jessica Zhang <quic_jesszhan@quicinc.com> # RB5  (qrb5165)
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/484274/
Link: https://lore.kernel.org/r/20220430005210.339-1-quic_jesszhan@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c  | 3 ++-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index e7c9fe1a250f..0a857f222982 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -204,7 +204,8 @@ static int dpu_crtc_get_crc(struct drm_crtc *crtc)
 		rc = m->hw_lm->ops.collect_misr(m->hw_lm, &crcs[i]);
 
 		if (rc) {
-			DRM_DEBUG_DRIVER("MISR read failed\n");
+			if (rc != -ENODATA)
+				DRM_DEBUG_DRIVER("MISR read failed\n");
 			return rc;
 		}
 	}
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c
index 86363c0ec834..462f5082099e 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c
@@ -138,7 +138,7 @@ static int dpu_hw_lm_collect_misr(struct dpu_hw_mixer *ctx, u32 *misr_value)
 	ctrl = DPU_REG_READ(c, LM_MISR_CTRL);
 
 	if (!(ctrl & LM_MISR_CTRL_ENABLE))
-		return -EINVAL;
+		return -ENODATA;
 
 	if (!(ctrl & LM_MISR_CTRL_STATUS))
 		return -EINVAL;
-- 
2.35.1


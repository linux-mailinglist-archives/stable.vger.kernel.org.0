Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6554A4E868A
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 09:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbiC0Hek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 03:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235092AbiC0Hej (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 03:34:39 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A4F1B7AB;
        Sun, 27 Mar 2022 00:33:01 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id v4so11257411pjh.2;
        Sun, 27 Mar 2022 00:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=YKubZFE6bM+QSkBsG+9QO1RxuSxqs+5gFlfSVbQQPZM=;
        b=VZ4ulUcfcPskQTm+VP+1tNFGk9rxfIjmMpkWEYsSvkdG8F0oPCs5b2j+Ayxot6MhTY
         sIM1zO7pvPXr5csmHmxug3yU8T450E66bZa5PM+UuyTrhahCi0J2x7zs20c5uNpWDEuS
         2u2N/5dr8tpEwfrho4YZuhqrVZxQnX/9dIdWW9C+rp2SxaWzPFpAyVsTSw4odFx6+yaV
         FSCc40Sy0WVQl/2T0zNgitx5om5ds0AE41dxr6Ebah7IdMOL5ZnHulfneOygKC9kmivs
         /r/CwCmM0C2nB5zyeH5ZpDG3Ja1/VcfegeGPnV2xbjA76xO0jczW9+GI0EIQjXLnhVbN
         PSjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YKubZFE6bM+QSkBsG+9QO1RxuSxqs+5gFlfSVbQQPZM=;
        b=PXeNGO7U4/rPEYRaBDkecv+E6pQr1vDLAr1MbgXj6+DDYIBkDMfxqVr+nQRbJLG1dU
         lChijgyu6or5GFbuF7Hvq0ZZx0zovFg9kcyj1f8FQlFko3xpfAlUMA/WkLyC7HLhBN59
         AkrCuUfGeIBV0daAjcPJYH2bBqEbrlerWDnXFOdp+Y2WPct4xceGzj3LX5x8ecKLQ/kJ
         QtgCERnHUAKuBHmswWLEg2ublipwMfTZiGwo5vc49hkN9cUcqVF2zw9gmjqn6j0gBxnr
         xsI7giA5/iW8SEuBNhdnnvwYHag+Gb1iwzD/CBTlEnBrlCvXGiFYQXz9eFsT3V8DuOqv
         pi+g==
X-Gm-Message-State: AOAM531UZ9wpuh3hrQEXkKmedcLEelz3BBgPIjuPw5/acro3KHR6v7Dj
        LpKuDkMH2pzKDxXfAKAxPi0=
X-Google-Smtp-Source: ABdhPJzze9ezzNVHssEARN6KgfiGzfb3NOY5VDH6d7E2Cd06YEKl1rpHROxsCkMbscLIKv1rf2DGqQ==
X-Received: by 2002:a17:90a:4897:b0:1c7:5fce:cbcd with SMTP id b23-20020a17090a489700b001c75fcecbcdmr32747388pjh.45.1648366381225;
        Sun, 27 Mar 2022 00:33:01 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id h14-20020a63384e000000b00366ba5335e7sm9528888pgn.72.2022.03.27.00.33.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 00:33:00 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     robdclark@gmail.com, sean@poorly.run, airlied@linux.ie,
        daniel@ffwll.ch
Cc:     quic_abhinavk@quicinc.com, dmitry.baryshkov@linaro.org,
        swboyd@chromium.org, bjorn.andersson@linaro.org,
        quic_khsieh@quicinc.com, quic_kalyant@quicinc.com,
        markyacoub@google.com, jsanka@codeaurora.org,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] dpu1: dpu_encoder: fix a missing check on list iterator
Date:   Sun, 27 Mar 2022 15:32:52 +0800
Message-Id: <20220327073252.10871-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	 cstate = to_dpu_crtc_state(drm_crtc->state);

For the drm_for_each_crtc(), just like list_for_each_entry(),
the list iterator 'drm_crtc' will point to a bogus position
containing HEAD if the list is empty or no element is found.
This case must be checked before any use of the iterator,
otherwise it will lead to a invalid memory access.

To fix this bug, use a new variable 'iter' as the list iterator,
while use the origin variable 'drm_crtc' as a dedicated pointer
to point to the found element.

Cc: stable@vger.kernel.org
Fixes: b107603b4ad0f ("drm/msm/dpu: map mixer/ctl hw blocks in encoder modeset")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 1e648db439f9..d3fdb18e96f9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -965,7 +965,7 @@ static void dpu_encoder_virt_mode_set(struct drm_encoder *drm_enc,
 	struct dpu_kms *dpu_kms;
 	struct list_head *connector_list;
 	struct drm_connector *conn = NULL, *conn_iter;
-	struct drm_crtc *drm_crtc;
+	struct drm_crtc *drm_crtc = NULL, *iter;
 	struct dpu_crtc_state *cstate;
 	struct dpu_global_state *global_state;
 	struct dpu_hw_blk *hw_pp[MAX_CHANNELS_PER_ENC];
@@ -1007,9 +1007,14 @@ static void dpu_encoder_virt_mode_set(struct drm_encoder *drm_enc,
 		return;
 	}
 
-	drm_for_each_crtc(drm_crtc, drm_enc->dev)
-		if (drm_crtc->state->encoder_mask & drm_encoder_mask(drm_enc))
+	drm_for_each_crtc(iter, drm_enc->dev)
+		if (iter->state->encoder_mask & drm_encoder_mask(drm_enc)) {
+			drm_crtc = iter;
 			break;
+		}
+
+	if (!drm_crtc)
+		return;
 
 	/* Query resource that have been reserved in atomic check step. */
 	num_pp = dpu_rm_get_assigned_resources(&dpu_kms->rm, global_state,
-- 
2.17.1


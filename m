Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C3C5948B1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354256AbiHOXoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354539AbiHOXmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:42:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F4A49B7B;
        Mon, 15 Aug 2022 13:13:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C1F07CE1262;
        Mon, 15 Aug 2022 20:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5208C433C1;
        Mon, 15 Aug 2022 20:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594416;
        bh=ltOldmr4MWN325/ydtP+kHo/ym5G4Awzre5cMSNIyXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mP2NhYVC8yzrk/iieuJrKKSYc4CLxs85/Hu2Z5YKIMFg6QDHrEYUGDNiRETQmBNn5
         aKfkvxMqri9uVU9zOwLn3EJHfQnjCSSiiTgAobNsdR04XGh7vXq7YD5SfzKZcUAFZr
         y0nrPu0I1rGvqkMGdUCT/+pJdycnXuLk4WrED0vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0438/1157] drm/msm/dpu: remove hard-coded linewidth limit for writeback
Date:   Mon, 15 Aug 2022 19:56:34 +0200
Message-Id: <20220815180457.156506873@linuxfoundation.org>
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

[ Upstream commit 4edea8d305873336a626c5f4ce17cb8751059054 ]

Remove the hard-coded limit for writeback and lets start using
the one from catalog instead.

changes in v3:
	- correct the Fixes tag

Fixes: d7d0e73f7de3 ("drm/msm/dpu: introduce the dpu_encoder_phys_* for writeback")
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/489888/
Link: https://lore.kernel.org/r/1655406084-17407-3-git-send-email-quic_abhinavk@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
index 0ec809ab06e7..15919e1a8dc3 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
@@ -20,8 +20,6 @@
 #include "dpu_crtc.h"
 #include "disp/msm_disp_snapshot.h"
 
-#define DEFAULT_MAX_WRITEBACK_WIDTH 2048
-
 #define to_dpu_encoder_phys_wb(x) \
 	container_of(x, struct dpu_encoder_phys_wb, base)
 
@@ -278,9 +276,9 @@ static int dpu_encoder_phys_wb_atomic_check(
 		DPU_ERROR("invalid fb h=%d, mode h=%d\n", fb->height,
 				  mode->vdisplay);
 		return -EINVAL;
-	} else if (fb->width > DEFAULT_MAX_WRITEBACK_WIDTH) {
+	} else if (fb->width > phys_enc->hw_wb->caps->maxlinewidth) {
 		DPU_ERROR("invalid fb w=%d, maxlinewidth=%u\n",
-				  fb->width, DEFAULT_MAX_WRITEBACK_WIDTH);
+				  fb->width, phys_enc->hw_wb->caps->maxlinewidth);
 		return -EINVAL;
 	}
 
-- 
2.35.1




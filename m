Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00E64F2D39
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236887AbiDEJDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237095AbiDEIRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47D7B0A72;
        Tue,  5 Apr 2022 01:05:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9891EB81A32;
        Tue,  5 Apr 2022 08:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D810C385A2;
        Tue,  5 Apr 2022 08:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145908;
        bh=DtgPalVCccaATQj0jaFNcsMve7obrls4FSjEP7bN7aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNj8EJHpiFEkpB/DiqxzEJAtN835LJA6lZ9qNCb1JKco1v4hDDRpFv/kqN/mJMoHP
         AO3szRo2Tk0ShYXAajVgKwoid41z09/i0nlKgZ1oA/p4hZJyit4VNb8KgyshWPQF/K
         dBYwHm/ciuKmp62YfXcFhl/vSuCZeHGg8CoRxQZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0573/1126] drm/msm/dpu: fix dp audio condition
Date:   Tue,  5 Apr 2022 09:22:00 +0200
Message-Id: <20220405070424.452243006@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 1e0505a5a7a2fea243f8e6d7e13fcde65f9e41bc ]

DP audio enablement code which is comparing intf_type,
DRM_MODE_ENCODER_TMDS (= 2) with DRM_MODE_CONNECTOR_DisplayPort (= 10).
Which would never succeed. Fix it to check for DRM_MODE_ENCODER_TMDS.

Fixes: d13e36d7d222 ("drm/msm/dp: add audio support for Display Port on MSM")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220217035358.465904-2-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 1e648db439f9..02d0fae1c6dc 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1099,7 +1099,7 @@ static void _dpu_encoder_virt_enable_helper(struct drm_encoder *drm_enc)
 	}
 
 
-	if (dpu_enc->disp_info.intf_type == DRM_MODE_CONNECTOR_DisplayPort &&
+	if (dpu_enc->disp_info.intf_type == DRM_MODE_ENCODER_TMDS &&
 		dpu_enc->cur_master->hw_mdptop &&
 		dpu_enc->cur_master->hw_mdptop->ops.intf_audio_select)
 		dpu_enc->cur_master->hw_mdptop->ops.intf_audio_select(
-- 
2.34.1




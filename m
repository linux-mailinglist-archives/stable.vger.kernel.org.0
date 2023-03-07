Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D216AF3E1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbjCGTKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbjCGTKS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:10:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1816AF295
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:55:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EACA5B8117B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDDDC433EF;
        Tue,  7 Mar 2023 18:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215261;
        bh=dyd+RTkp3UE8bcQn84oizEyigVOorDkT3BRk+Vo0nWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQDzzr4yW04Av5SX5mlmRKxjcV17I65RuBwtYbkvdqohNJ9Bkq93J3yvyAowcDW1E
         aCqvao73J7fmhVZWiqyc5uSNdcDYYeIhXBkHf6IirEp2VV3FxkRZ/hSad/ZbUcBbLN
         xJDqSaBK6s7i+d5Wu7UQYPyjqsISxXEhqbkdxZgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/567] drm/msm/dpu: Add check for pstates
Date:   Tue,  7 Mar 2023 17:59:00 +0100
Message-Id: <20230307165914.762788503@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 93340e10b9c5fc86730d149636e0aa8b47bb5a34 ]

As kzalloc may fail and return NULL pointer,
it should be better to check pstates
in order to avoid the NULL pointer dereference.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/514160/
Link: https://lore.kernel.org/r/20221206080236.43687-1-jiasheng@iscas.ac.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index c76305beff6e5..4194689b6b35d 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -941,6 +941,8 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
 	bool needs_dirtyfb = dpu_crtc_needs_dirtyfb(crtc_state);
 
 	pstates = kzalloc(sizeof(*pstates) * DPU_STAGE_MAX * 4, GFP_KERNEL);
+	if (!pstates)
+		return -ENOMEM;
 
 	if (!crtc_state->enable || !crtc_state->active) {
 		DRM_DEBUG_ATOMIC("crtc%d -> enable %d, active %d, skip atomic_check\n",
-- 
2.39.2




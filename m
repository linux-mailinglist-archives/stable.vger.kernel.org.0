Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457596B4861
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbjCJPB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbjCJPBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:01:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E4512C72E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:54:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B05A0B82312
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFBFC4339C;
        Fri, 10 Mar 2023 14:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459971;
        bh=4nk1RLPlCUfRSZiH4m3uyta3EiBTFHkW7f5lXOV2rec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyqAs4GFt5SCKQSw6D1CM7WogIEeKjeU0IYGL2nrN96m5MYs0A5i5vL2U9PGXbcgq
         KVOZK0kOG02uqbSuBUbd53lUOEBKcW2V6QC+J8kWxoE+terh7OGBVC3DK6aoDkNtZF
         X/Gx2rG/x9rK34QCzM9kJaEOBNBFp3yvP5SV3i98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/529] drm/msm/dpu: Add check for pstates
Date:   Fri, 10 Mar 2023 14:35:22 +0100
Message-Id: <20230310133813.237711932@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index d6e9efed8b6a3..5afb3c544653c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -834,6 +834,8 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
 	struct drm_rect crtc_rect = { 0 };
 
 	pstates = kzalloc(sizeof(*pstates) * DPU_STAGE_MAX * 4, GFP_KERNEL);
+	if (!pstates)
+		return -ENOMEM;
 
 	if (!state->enable || !state->active) {
 		DPU_DEBUG("crtc%d -> enable %d, active %d, skip atomic_check\n",
-- 
2.39.2




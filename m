Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7695C6A395A
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 04:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjB0DNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 22:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjB0DNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 22:13:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E26FBB88;
        Sun, 26 Feb 2023 19:13:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0257DCE0F24;
        Mon, 27 Feb 2023 02:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BA1C433EF;
        Mon, 27 Feb 2023 02:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463624;
        bh=d/og2jOEKeOdpeh3qI0txklsSvU7ptQycygyiomEzhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gh5kLjHN2L52F4gNILhcz/W59NIkbTrdJSYcR+nfWB3kUX6O336/xTkBl2FLgjx3D
         b3jVtrdqVSsaWULUFssYYDBWY2NidpV+4CuKtm5lJ93pLs9OLGSlxU4PQvZLq6l8Zc
         SZ6Qgn0ceaEkv8bHatsYkX+lviUelnJ7/cyCAv58NH4Xs1qQPx9mGJ/kKVM2fLPZCt
         RABGcILURs718QHONWnikriIAuvFZtq4HJzCRMjFL/OsdXE9xSO2dC9pmbTUlOdJGe
         RSiDpbKfOkkHoDM9RkGjEbASXs+MKcr5yBkhYDYi2qQ5P82aGMiY++sylud/+5Jbsa
         DBW20i3XabPJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marijn Suijten <marijn.suijten@somainline.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        airlied@gmail.com, daniel@ffwll.ch, swboyd@chromium.org,
        konrad.dybcio@linaro.org, quic_vpolimer@quicinc.com,
        dianders@chromium.org, liushixin2@huawei.com,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 32/58] drm/msm/dpu: Add DSC hardware blocks to register snapshot
Date:   Sun, 26 Feb 2023 21:04:30 -0500
Message-Id: <20230227020457.1048737-32-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit a7efe60e36b9c0e966d7f82ac90a89b591d984e9 ]

Add missing DSC hardware block register ranges to the snapshot utility
to include them in dmesg (on MSM_DISP_SNAPSHOT_DUMP_IN_CONSOLE) and the
kms debugfs file.

Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/520175/
Link: https://lore.kernel.org/r/20230125101412.216924-1-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
index 5e6e2626151e8..b7901b666612a 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -942,6 +942,11 @@ static void dpu_kms_mdp_snapshot(struct msm_disp_state *disp_state, struct msm_k
 	msm_disp_snapshot_add_block(disp_state, cat->mdp[0].len,
 			dpu_kms->mmio + cat->mdp[0].base, "top");
 
+	/* dump DSC sub-blocks HW regs info */
+	for (i = 0; i < cat->dsc_count; i++)
+		msm_disp_snapshot_add_block(disp_state, cat->dsc[i].len,
+				dpu_kms->mmio + cat->dsc[i].base, "dsc_%d", i);
+
 	pm_runtime_put_sync(&dpu_kms->pdev->dev);
 }
 
-- 
2.39.0


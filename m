Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83680657CB1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbiL1PfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbiL1PfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:35:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD4C164B2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:35:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EE5361560
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CABBC433EF;
        Wed, 28 Dec 2022 15:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241705;
        bh=UG08ZJZ/SGMkz4T2u/XEXW+kYA5et+5MvE1A2TuVIUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vr+xuFP2e1L3Shq6ER/LSsFPocGf5CQ9g/Yyy1FFP4Sn1WF511ZlfcwrbOj8IDCgI
         UVUFHqnlv2xMHAyVM8p4XDy9Z7c3XBojfNl55shii8rCtCN3kU3aCd2z0R7xM5soFF
         /ttP29quOuOO32uO0+VYitJH6XCjOsWDb7iLV3aQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Vinod Koul <vkoul@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0279/1146] drm/msm/dsi: Remove repeated calculation of slice_per_intf
Date:   Wed, 28 Dec 2022 15:30:18 +0100
Message-Id: <20221228144337.716331765@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 170ffca836dd9f1a0219c4f67554d408fa2b5912 ]

slice_per_intf is already computed for intf_width, which holds the same
value as hdisplay.

Fixes: 08802f515c3c ("drm/msm/dsi: Add support for DSC configuration")
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/508933/
Link: https://lore.kernel.org/r/20221026182824.876933-3-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 8026fe65bff6..d94832504d0f 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -842,7 +842,7 @@ static void dsi_ctrl_config(struct msm_dsi_host *msm_host, bool enable,
 static void dsi_update_dsc_timing(struct msm_dsi_host *msm_host, bool is_cmd_mode, u32 hdisplay)
 {
 	struct drm_dsc_config *dsc = msm_host->dsc;
-	u32 reg, intf_width, reg_ctrl, reg_ctrl2;
+	u32 reg, reg_ctrl, reg_ctrl2;
 	u32 slice_per_intf, total_bytes_per_intf;
 	u32 pkt_per_line;
 	u32 bytes_in_slice;
@@ -851,8 +851,7 @@ static void dsi_update_dsc_timing(struct msm_dsi_host *msm_host, bool is_cmd_mod
 	/* first calculate dsc parameters and then program
 	 * compress mode registers
 	 */
-	intf_width = hdisplay;
-	slice_per_intf = DIV_ROUND_UP(intf_width, dsc->slice_width);
+	slice_per_intf = DIV_ROUND_UP(hdisplay, dsc->slice_width);
 
 	/* If slice_per_pkt is greater than slice_per_intf
 	 * then default to 1. This can happen during partial
@@ -861,7 +860,6 @@ static void dsi_update_dsc_timing(struct msm_dsi_host *msm_host, bool is_cmd_mod
 	if (slice_per_intf > dsc->slice_count)
 		dsc->slice_count = 1;
 
-	slice_per_intf = DIV_ROUND_UP(hdisplay, dsc->slice_width);
 	bytes_in_slice = DIV_ROUND_UP(dsc->slice_width * dsc->bits_per_pixel, 8);
 
 	dsc->slice_chunk_size = bytes_in_slice;
-- 
2.35.1




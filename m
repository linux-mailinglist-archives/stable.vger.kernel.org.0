Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E03657CC4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbiL1Pfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbiL1Pfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:35:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77C2C3C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:35:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80B1761553
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6D5C433D2;
        Wed, 28 Dec 2022 15:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241745;
        bh=7qlYgUHab7YmcaUIaWkbTomdn02aVWKwREbTdA2DH3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKZJhwlgCYCv0Utn6ld2ZlTBUyoBBPxthgiIITaK1W7b+da4HttgEZ8fwXwz54G4p
         f5Kei5Fu9mxzdi5ji0c8uZloeuv/0Bxq3VDKHF8wmyjhlCEfOegy+7HKuRHd6jJ3en
         7Pj+I/VDgEtdLjb7FRDHAYGzFBeBN9MIP6IoRbis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0284/1146] drm/msm/dsi: Account for DSCs bits_per_pixel having 4 fractional bits
Date:   Wed, 28 Dec 2022 15:30:23 +0100
Message-Id: <20221228144337.854646141@linuxfoundation.org>
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

[ Upstream commit d2c277c61986942e99680cb67ce26423d0f42f11 ]

drm_dsc_config's bits_per_pixel field holds a fractional value with 4
bits, which all panel drivers should adhere to for
drm_dsc_pps_payload_pack() to generate a valid payload.  All code in the
DSI driver here seems to assume that this field doesn't contain any
fractional bits, hence resulting in the wrong values being computed.
Since none of the calculations leave any room for fractional bits or
seem to indicate any possible area of support, disallow such values
altogether.  calculate_rc_params() in intel_vdsc.c performs an identical
bitshift to get at this integer value.

Fixes: b9080324d6ca ("drm/msm/dsi: add support for dsc data")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/508938/
Link: https://lore.kernel.org/r/20221026182824.876933-8-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 36d42f17331d..de00925c94e8 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -34,7 +34,7 @@
 
 #define DSI_RESET_TOGGLE_DELAY_MS 20
 
-static int dsi_populate_dsc_params(struct drm_dsc_config *dsc);
+static int dsi_populate_dsc_params(struct msm_dsi_host *msm_host, struct drm_dsc_config *dsc);
 
 static int dsi_get_version(const void __iomem *base, u32 *major, u32 *minor)
 {
@@ -909,6 +909,7 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 	u32 va_end = va_start + mode->vdisplay;
 	u32 hdisplay = mode->hdisplay;
 	u32 wc;
+	int ret;
 
 	DBG("");
 
@@ -944,7 +945,9 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 		/* we do the calculations for dsc parameters here so that
 		 * panel can use these parameters
 		 */
-		dsi_populate_dsc_params(dsc);
+		ret = dsi_populate_dsc_params(msm_host, dsc);
+		if (ret)
+			return;
 
 		/* Divide the display by 3 but keep back/font porch and
 		 * pulse width same
@@ -1748,9 +1751,15 @@ static char bpg_offset[DSC_NUM_BUF_RANGES] = {
 	2, 0, 0, -2, -4, -6, -8, -8, -8, -10, -10, -12, -12, -12, -12
 };
 
-static int dsi_populate_dsc_params(struct drm_dsc_config *dsc)
+static int dsi_populate_dsc_params(struct msm_dsi_host *msm_host, struct drm_dsc_config *dsc)
 {
 	int i;
+	u16 bpp = dsc->bits_per_pixel >> 4;
+
+	if (dsc->bits_per_pixel & 0xf) {
+		DRM_DEV_ERROR(&msm_host->pdev->dev, "DSI does not support fractional bits_per_pixel\n");
+		return -EINVAL;
+	}
 
 	dsc->rc_model_size = 8192;
 	dsc->first_line_bpg_offset = 12;
@@ -1771,8 +1780,8 @@ static int dsi_populate_dsc_params(struct drm_dsc_config *dsc)
 		dsc->rc_range_params[i].range_bpg_offset = bpg_offset[i];
 	}
 
-	dsc->initial_offset = 6144; /* Not bpp 12 */
-	if (dsc->bits_per_pixel != 8)
+	dsc->initial_offset = 6144;		/* Not bpp 12 */
+	if (bpp != 8)
 		dsc->initial_offset = 2048;	/* bpp = 12 */
 
 	if (dsc->bits_per_component <= 10)
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82A6657CC1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiL1Pfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbiL1Pfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:35:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF128164B0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:35:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DE7AB81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD7AC433D2;
        Wed, 28 Dec 2022 15:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241737;
        bh=1TjtFbsIZv5NGqDHCzpNDsVKhY55ko3BCqipYKiYS64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HxSI2kPnaiwq0qLTtsyNqTuEnx11arVPsLv2wf3jGCwlFdiRgJVcIkCCHR2VmaWlD
         kOVoR+CezcaanpLwPFdSPJ447Vf+ZoAyfQw0wO9j6RoZaTZeFQ3bJriTHfoezH6l8k
         YpxZ46n+T5Hy9eNKarll/es2amd4VDOMRcCxCpqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0283/1146] drm/msm/dsi: Migrate to drm_dsc_compute_rc_parameters()
Date:   Wed, 28 Dec 2022 15:30:22 +0100
Message-Id: <20221228144337.827453477@linuxfoundation.org>
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

[ Upstream commit c3a1aabce2d4087255de90100c3dad492e7d925c ]

As per the FIXME this code is entirely duplicate with what is already
provided inside drm_dsc_compute_rc_parameters(), supposedly because that
function was yielding "incorrect" results while in reality the panel
driver(s?) used for testing were providing incorrect parameters.

For example, this code from downstream assumed dsc->bits_per_pixel to
contain an integer value, whereas the upstream drm_dsc_config struct
stores it with 4 fractional bits.  drm_dsc_compute_rc_parameters()
already accounts for this feat while the panel driver used for testing
[1] wasn't, hence making drm_dsc_compute_rc_parameters() seem like it
was returning an incorrect result.
Other users of dsc->bits_per_pixel inside dsi_populate_dsc_params() also
treat it in the same erroneous way, and will be addressed in a separate
patch.
In the end, using drm_dsc_compute_rc_parameters() spares both a lot of
duplicate code and erratic behaviour.

[1]: https://git.linaro.org/people/vinod.koul/kernel.git/commit/?h=topic/pixel3_5.18-rc1&id=1d7d98ad564f1ec69e7525e07418918d90f247a1

Fixes: b9080324d6ca ("drm/msm/dsi: add support for dsc data")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/508939/
Link: https://lore.kernel.org/r/20221026182824.876933-7-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 64 +++---------------------------
 1 file changed, 6 insertions(+), 58 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 906ee38133c1..36d42f17331d 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -21,6 +21,7 @@
 
 #include <video/mipi_display.h>
 
+#include <drm/display/drm_dsc_helper.h>
 #include <drm/drm_of.h>
 
 #include "dsi.h"
@@ -1749,14 +1750,6 @@ static char bpg_offset[DSC_NUM_BUF_RANGES] = {
 
 static int dsi_populate_dsc_params(struct drm_dsc_config *dsc)
 {
-	int mux_words_size;
-	int groups_per_line, groups_total;
-	int min_rate_buffer_size;
-	int hrd_delay;
-	int pre_num_extra_mux_bits, num_extra_mux_bits;
-	int slice_bits;
-	int data;
-	int final_value, final_scale;
 	int i;
 
 	dsc->rc_model_size = 8192;
@@ -1782,11 +1775,11 @@ static int dsi_populate_dsc_params(struct drm_dsc_config *dsc)
 	if (dsc->bits_per_pixel != 8)
 		dsc->initial_offset = 2048;	/* bpp = 12 */
 
-	mux_words_size = 48;		/* bpc == 8/10 */
-	if (dsc->bits_per_component == 12)
-		mux_words_size = 64;
+	if (dsc->bits_per_component <= 10)
+		dsc->mux_word_size = DSC_MUX_WORD_SIZE_8_10_BPC;
+	else
+		dsc->mux_word_size = DSC_MUX_WORD_SIZE_12_BPC;
 
-	dsc->mux_word_size = mux_words_size;
 	dsc->initial_xmit_delay = 512;
 	dsc->initial_scale_value = 32;
 	dsc->first_line_bpg_offset = 12;
@@ -1798,52 +1791,7 @@ static int dsi_populate_dsc_params(struct drm_dsc_config *dsc)
 	dsc->rc_quant_incr_limit0 = 11;
 	dsc->rc_quant_incr_limit1 = 11;
 
-	/* FIXME: need to call drm_dsc_compute_rc_parameters() so that rest of
-	 * params are calculated
-	 */
-	groups_per_line = DIV_ROUND_UP(dsc->slice_width, 3);
-	dsc->slice_chunk_size = DIV_ROUND_UP(dsc->slice_width * dsc->bits_per_pixel, 8);
-
-	/* rbs-min */
-	min_rate_buffer_size =  dsc->rc_model_size - dsc->initial_offset +
-				dsc->initial_xmit_delay * dsc->bits_per_pixel +
-				groups_per_line * dsc->first_line_bpg_offset;
-
-	hrd_delay = DIV_ROUND_UP(min_rate_buffer_size, dsc->bits_per_pixel);
-
-	dsc->initial_dec_delay = hrd_delay - dsc->initial_xmit_delay;
-
-	dsc->initial_scale_value = 8 * dsc->rc_model_size /
-				       (dsc->rc_model_size - dsc->initial_offset);
-
-	slice_bits = 8 * dsc->slice_chunk_size * dsc->slice_height;
-
-	groups_total = groups_per_line * dsc->slice_height;
-
-	data = dsc->first_line_bpg_offset * 2048;
-
-	dsc->nfl_bpg_offset = DIV_ROUND_UP(data, (dsc->slice_height - 1));
-
-	pre_num_extra_mux_bits = 3 * (mux_words_size + (4 * dsc->bits_per_component + 4) - 2);
-
-	num_extra_mux_bits = pre_num_extra_mux_bits - (mux_words_size -
-			     ((slice_bits - pre_num_extra_mux_bits) % mux_words_size));
-
-	data = 2048 * (dsc->rc_model_size - dsc->initial_offset + num_extra_mux_bits);
-	dsc->slice_bpg_offset = DIV_ROUND_UP(data, groups_total);
-
-	data = dsc->initial_xmit_delay * dsc->bits_per_pixel;
-	final_value =  dsc->rc_model_size - data + num_extra_mux_bits;
-	dsc->final_offset = final_value;
-
-	final_scale = 8 * dsc->rc_model_size / (dsc->rc_model_size - final_value);
-
-	data = (final_scale - 9) * (dsc->nfl_bpg_offset + dsc->slice_bpg_offset);
-	dsc->scale_increment_interval = (2048 * dsc->final_offset) / data;
-
-	dsc->scale_decrement_interval = groups_per_line / (dsc->initial_scale_value - 8);
-
-	return 0;
+	return drm_dsc_compute_rc_parameters(dsc);
 }
 
 static int dsi_host_parse_dt(struct msm_dsi_host *msm_host)
-- 
2.35.1




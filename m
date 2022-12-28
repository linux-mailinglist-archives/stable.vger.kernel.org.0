Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695E7657C2E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbiL1P3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbiL1P3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:29:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8111570B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:29:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EAF2B81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E08C433EF;
        Wed, 28 Dec 2022 15:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241381;
        bh=yXGtZAZTiudI3zguMuMC+V8jji17qGcI593z3QFmBAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7FmwaDnoh8AlDJBOI/H4pJPqEXhfLPxlklbZTjrQyuhRlD3Yj3t+qNxNsYu2OoAS
         BXhIynjxnFI7z+HEAP2KNPdsQEzv9paBVzttQzbqqueJy+Zb94wNL/59CGLZU705ZW
         A+u3UN6gxym9vC9U61JtUSIE45Ia7C7gh93cDAVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0277/1073] drm/msm/dsi: Appropriately set dsc->mux_word_size based on bpc
Date:   Wed, 28 Dec 2022 15:31:05 +0100
Message-Id: <20221228144335.544636705@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 0ca870ca304d3449b2ccdc3f0bad9843ff1519f0 ]

This field is currently unread but will come into effect when duplicated
code below is migrated to call drm_dsc_compute_rc_parameters(), which
uses the bpc-dependent value of the local variable mux_words_size in
much the same way.

The hardcoded constant seems to be a remnant from the `/* bpc 8 */`
comment right above, indicating that this group of field assignments is
applicable to bpc = 8 exclusively and should probably bail out on
different bpc values, until constants for other bpc values are added (or
the current ones are confirmed to be correct across multiple bpc's).

Fixes: b9080324d6ca ("drm/msm/dsi: add support for dsc data")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/508943/
Link: https://lore.kernel.org/r/20221026182824.876933-6-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index a99c54556f51..5e5eb1a10f94 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1873,6 +1873,7 @@ static int dsi_populate_dsc_params(struct drm_dsc_config *dsc)
 	if (dsc->bits_per_component == 12)
 		mux_words_size = 64;
 
+	dsc->mux_word_size = mux_words_size;
 	dsc->initial_xmit_delay = 512;
 	dsc->initial_scale_value = 32;
 	dsc->first_line_bpg_offset = 12;
@@ -1883,7 +1884,6 @@ static int dsi_populate_dsc_params(struct drm_dsc_config *dsc)
 	dsc->flatness_max_qp = 12;
 	dsc->rc_quant_incr_limit0 = 11;
 	dsc->rc_quant_incr_limit1 = 11;
-	dsc->mux_word_size = DSC_MUX_WORD_SIZE_8_10_BPC;
 
 	/* FIXME: need to call drm_dsc_compute_rc_parameters() so that rest of
 	 * params are calculated
-- 
2.35.1




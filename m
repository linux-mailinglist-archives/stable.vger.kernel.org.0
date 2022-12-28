Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0222657CAA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbiL1Peu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbiL1Pet (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:34:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB681649D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:34:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9EC361560
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD95C433D2;
        Wed, 28 Dec 2022 15:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241687;
        bh=Ahna/NP30srCdrx7nAND2cBio79OnK2NRZyRY2pwK7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AwATHLHvpKZH7qucfYOHBg3oeHz3x22ltLii9XlJiuHJoZoGrCp4Zae+RiJbGJ7Dx
         uPpFAlIGcqOji9u0T3FmEtJrXJ1cl6SFyhN0lJxsBs+Bt3JhYq7arxPAKg0m9mgWGn
         bQVul2J9rexzQujS8WgrSX5fdDn8LbdGBHdBfWYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0277/1146] drm/msm/dpu1: Account for DSCs bits_per_pixel having 4 fractional bits
Date:   Wed, 28 Dec 2022 15:30:16 +0100
Message-Id: <20221228144337.661199733@linuxfoundation.org>
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

[ Upstream commit d3c1a8663d0ddb74eaa51121ccbb8340739a12a8 ]

According to the comment this DPU register contains the bits per pixel
as a 6.4 fractional value, conveniently matching the contents of
bits_per_pixel in struct drm_dsc_config which also uses 4 fractional
bits.  However, the downstream source this implementation was
copy-pasted from has its bpp field stored _without_ fractional part.

This makes the entire convoluted math obsolete as it is impossible to
pull those 4 fractional bits out of thin air, by somehow trying to reuse
the lowest 2 bits of a non-fractional bpp (lsb = bpp % 4??).

The rest of the code merely attempts to keep the integer part a multiple
of 4, which is rendered useless thanks to data |= dsc->bits_per_pixel <<
12; already filling up those bits anyway (but not on downstream).

Fixes: c110cfd1753e ("drm/msm/disp/dpu1: Add support for DSC")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Patchwork: https://patchwork.freedesktop.org/patch/508946/
Link: https://lore.kernel.org/r/20221026182824.876933-10-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c
index f2ddcfb6f7ee..3662df698dae 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c
@@ -42,7 +42,7 @@ static void dpu_hw_dsc_config(struct dpu_hw_dsc *hw_dsc,
 			      u32 initial_lines)
 {
 	struct dpu_hw_blk_reg_map *c = &hw_dsc->hw;
-	u32 data, lsb, bpp;
+	u32 data;
 	u32 slice_last_group_size;
 	u32 det_thresh_flatness;
 	bool is_cmd_mode = !(mode & DSC_MODE_VIDEO);
@@ -56,14 +56,7 @@ static void dpu_hw_dsc_config(struct dpu_hw_dsc *hw_dsc,
 	data = (initial_lines << 20);
 	data |= ((slice_last_group_size - 1) << 18);
 	/* bpp is 6.4 format, 4 LSBs bits are for fractional part */
-	data |= dsc->bits_per_pixel << 12;
-	lsb = dsc->bits_per_pixel % 4;
-	bpp = dsc->bits_per_pixel / 4;
-	bpp *= 4;
-	bpp <<= 4;
-	bpp |= lsb;
-
-	data |= bpp << 8;
+	data |= (dsc->bits_per_pixel << 8);
 	data |= (dsc->block_pred_enable << 7);
 	data |= (dsc->line_buf_depth << 3);
 	data |= (dsc->simple_422 << 2);
-- 
2.35.1




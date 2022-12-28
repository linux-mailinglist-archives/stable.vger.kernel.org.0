Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A52657C2D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbiL1P3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbiL1P3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:29:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289671572E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:29:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B052E6155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C7BC433F0;
        Wed, 28 Dec 2022 15:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241379;
        bh=OdE+smot/ZM5r/Fvd7ynQ+TbuW5OrN192l62Yjb/t7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3tbWxxHFv0+2NHAXVyIFcadX/OLKmc98CK6BI6vp4L42So7mKil0umxhOh/GUvBq
         OBUN2gj3c6oxmhMUCeOtW6GY3XtLL3JisKTTaIK1C/VpqqZFIAiijIKLH0sUhWQ84t
         VLxxB95X264VJhWhRpwoxql/fDq2T5/L9b8TykDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0273/1073] drm/msm/dsi: Remove useless math in DSC calculations
Date:   Wed, 28 Dec 2022 15:31:01 +0100
Message-Id: <20221228144335.432059275@linuxfoundation.org>
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

[ Upstream commit 01a907980e0be3310f18c7d4955968f3b28e7147 ]

Multiplying a value by 2 and adding 1 to it always results in a value
that is uneven, and that 1 gets truncated immediately when performing
integer division by 2 again.  There is no "rounding" possible here.

After that target_bpp_x16 is used to store a multiplication of
bits_per_pixel by 16 which is only ever read to immediately be divided
by 16 again, and is elided in much the same way.

Fixes: b9080324d6ca ("drm/msm/dsi: add support for dsc data")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/508932/
Link: https://lore.kernel.org/r/20221026182824.876933-2-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 15e108be1901..843521c9cdcf 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1849,7 +1849,6 @@ static int dsi_populate_dsc_params(struct drm_dsc_config *dsc)
 	int hrd_delay;
 	int pre_num_extra_mux_bits, num_extra_mux_bits;
 	int slice_bits;
-	int target_bpp_x16;
 	int data;
 	int final_value, final_scale;
 	int i;
@@ -1929,14 +1928,7 @@ static int dsi_populate_dsc_params(struct drm_dsc_config *dsc)
 	data = 2048 * (dsc->rc_model_size - dsc->initial_offset + num_extra_mux_bits);
 	dsc->slice_bpg_offset = DIV_ROUND_UP(data, groups_total);
 
-	/* bpp * 16 + 0.5 */
-	data = dsc->bits_per_pixel * 16;
-	data *= 2;
-	data++;
-	data /= 2;
-	target_bpp_x16 = data;
-
-	data = (dsc->initial_xmit_delay * target_bpp_x16) / 16;
+	data = dsc->initial_xmit_delay * dsc->bits_per_pixel;
 	final_value =  dsc->rc_model_size - data + num_extra_mux_bits;
 	dsc->final_offset = final_value;
 
-- 
2.35.1




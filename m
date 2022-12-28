Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC71D657CCB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbiL1PgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiL1PgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:36:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD768140F5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:36:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D4A1B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37CFC433EF;
        Wed, 28 Dec 2022 15:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241764;
        bh=HFl4+YufAVZsxXODYEsLNv5wmaiFCk7uAPqb35Gvfig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeVfGK+jSzzpCqQScrLQJbirchckfqsSHxJKVIUkt0iY5kjBvV78ex9i0HCbCpRtQ
         9V6usGrIV2ynJ9TX5hOPj75CiUKuIhPnXa9UH1ZgeQgU296hF7LjaiAoPSGv7TzL13
         hOSntSXxVNUnB2Kqpkw+ZnXcXlBi9QDsNxK47hh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0286/1146] drm/msm/dsi: Prevent signed BPG offsets from bleeding into adjacent bits
Date:   Wed, 28 Dec 2022 15:30:25 +0100
Message-Id: <20221228144337.908809591@linuxfoundation.org>
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

[ Upstream commit cc84b66be223d36a3d10d59d68ba647e72db3099 ]

The bpg_offset array contains negative BPG offsets which fill the full 8
bits of a char thanks to two's complement: this however results in those
bits bleeding into the next field when the value is packed into DSC PPS
by the drm_dsc_helper function, which only expects range_bpg_offset to
contain 6-bit wide values.  As a consequence random slices appear
corrupted on-screen (tested on a Sony Tama Akatsuki device with sdm845).

Use AND operators to limit these two's complement values to 6 bits,
similar to the AMD and i915 drivers.

Fixes: b9080324d6ca ("drm/msm/dsi: add support for dsc data")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/508941/
Link: https://lore.kernel.org/r/20221026182824.876933-11-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index c229cf6eeb9c..89aadd3b3202 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1782,7 +1782,11 @@ static int dsi_populate_dsc_params(struct msm_dsi_host *msm_host, struct drm_dsc
 	for (i = 0; i < DSC_NUM_BUF_RANGES; i++) {
 		dsc->rc_range_params[i].range_min_qp = min_qp[i];
 		dsc->rc_range_params[i].range_max_qp = max_qp[i];
-		dsc->rc_range_params[i].range_bpg_offset = bpg_offset[i];
+		/*
+		 * Range BPG Offset contains two's-complement signed values that fill
+		 * 8 bits, yet the registers and DCS PPS field are only 6 bits wide.
+		 */
+		dsc->rc_range_params[i].range_bpg_offset = bpg_offset[i] & DSC_RANGE_BPG_OFFSET_MASK;
 	}
 
 	dsc->initial_offset = 6144;		/* Not bpp 12 */
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784FF657CB7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbiL1PfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbiL1PfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:35:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63640164B9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:35:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6A6A61553
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5250C433D2;
        Wed, 28 Dec 2022 15:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241719;
        bh=qGdU3DEytzY1Hd1QqzYoHqygoTR3yuU/e6cUa74W2TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZh8WHGvpxsSPJOCVVt+dpfgaTb5b5BQCTDAzhb9EKWUQQQMjPXPACplEzklBd5mM
         MKywaR/uZGRMnFwdlJWtf9N6f3pwWmvqfA+CWGCQYIlAvaqksc4C48rdG7uFlZdCvO
         0K84aId6+4+wN/jfpd7VIumbTWCtxIskF5AsKdkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0281/1146] drm/msm/dsi: Reuse earlier computed dsc->slice_chunk_size
Date:   Wed, 28 Dec 2022 15:30:20 +0100
Message-Id: <20221228144337.771266159@linuxfoundation.org>
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

[ Upstream commit e443459e2e6b8e0d3187dd0d09ef7fcea87531d2 ]

dsi_populate_dsc_params() is called prior to dsi_update_dsc_timing() and
already computes a value for slice_chunk_size, whose value doesn't need
to be recomputed and re-set here.

Fixes: 08802f515c3c ("drm/msm/dsi: Add support for DSC configuration")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/508934/
Link: https://lore.kernel.org/r/20221026182824.876933-5-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 88c8aa5c6b80..c3156e9066f5 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -845,7 +845,6 @@ static void dsi_update_dsc_timing(struct msm_dsi_host *msm_host, bool is_cmd_mod
 	u32 reg, reg_ctrl, reg_ctrl2;
 	u32 slice_per_intf, total_bytes_per_intf;
 	u32 pkt_per_line;
-	u32 bytes_in_slice;
 	u32 eol_byte_num;
 
 	/* first calculate dsc parameters and then program
@@ -860,11 +859,7 @@ static void dsi_update_dsc_timing(struct msm_dsi_host *msm_host, bool is_cmd_mod
 	if (slice_per_intf > dsc->slice_count)
 		dsc->slice_count = 1;
 
-	bytes_in_slice = DIV_ROUND_UP(dsc->slice_width * dsc->bits_per_pixel, 8);
-
-	dsc->slice_chunk_size = bytes_in_slice;
-
-	total_bytes_per_intf = bytes_in_slice * slice_per_intf;
+	total_bytes_per_intf = dsc->slice_chunk_size * slice_per_intf;
 
 	eol_byte_num = total_bytes_per_intf % 3;
 	pkt_per_line = slice_per_intf / dsc->slice_count;
@@ -890,7 +885,7 @@ static void dsi_update_dsc_timing(struct msm_dsi_host *msm_host, bool is_cmd_mod
 		reg_ctrl |= reg;
 
 		reg_ctrl2 &= ~DSI_COMMAND_COMPRESSION_MODE_CTRL2_STREAM0_SLICE_WIDTH__MASK;
-		reg_ctrl2 |= DSI_COMMAND_COMPRESSION_MODE_CTRL2_STREAM0_SLICE_WIDTH(bytes_in_slice);
+		reg_ctrl2 |= DSI_COMMAND_COMPRESSION_MODE_CTRL2_STREAM0_SLICE_WIDTH(dsc->slice_chunk_size);
 
 		dsi_write(msm_host, REG_DSI_COMMAND_COMPRESSION_MODE_CTRL, reg_ctrl);
 		dsi_write(msm_host, REG_DSI_COMMAND_COMPRESSION_MODE_CTRL2, reg_ctrl2);
-- 
2.35.1




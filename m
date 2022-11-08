Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFD562153C
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbiKHOJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235203AbiKHOJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:09:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA351116D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:09:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37D93B81ADB
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA1FC433D6;
        Tue,  8 Nov 2022 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916568;
        bh=ACB5NCpzrjJVLKWCx5UcKZl9u+6qQLqmZKiRINI/hCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XtkY9cF5AiHUknki63juOnoPPJGDWiW8qtX0SuORj3F7IX8/+xsTVllgcb7lkR4z6
         R0JAE0539xXJORNLuGFObzlqn65gHSQyj0iBxd+mI2vxrDlXtmQWQvVCmX2yn28kk7
         u7uXtVIUT3BStEzwYHMir1GVR6hqGGZq6vvgQn0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dafna Hirschfeld <dafna@fastmail.com>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 064/197] media: rkisp1: Fix source pad format configuration
Date:   Tue,  8 Nov 2022 14:38:22 +0100
Message-Id: <20221108133357.746716737@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit cb00f3a4421d5c7d7155bd4bded7fb2ff8eec211 ]

The ISP converts Bayer data to YUV when operating normally, and can also
operate in pass-through mode where the input and output formats must
match. Converting from YUV to Bayer isn't possible. If such an invalid
configuration is attempted, adjust it by copying the sink pad media bus
code to the source pad.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Dafna Hirschfeld <dafna@fastmail.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/rockchip/rkisp1/rkisp1-isp.c     | 40 +++++++++++++++----
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-isp.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-isp.c
index 383a3ec83ca9..00032b849a07 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-isp.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-isp.c
@@ -472,23 +472,43 @@ static void rkisp1_isp_set_src_fmt(struct rkisp1_isp *isp,
 				   struct v4l2_mbus_framefmt *format,
 				   unsigned int which)
 {
-	const struct rkisp1_mbus_info *mbus_info;
+	const struct rkisp1_mbus_info *sink_info;
+	const struct rkisp1_mbus_info *src_info;
+	struct v4l2_mbus_framefmt *sink_fmt;
 	struct v4l2_mbus_framefmt *src_fmt;
 	const struct v4l2_rect *src_crop;
 
+	sink_fmt = rkisp1_isp_get_pad_fmt(isp, sd_state,
+					  RKISP1_ISP_PAD_SINK_VIDEO, which);
 	src_fmt = rkisp1_isp_get_pad_fmt(isp, sd_state,
 					 RKISP1_ISP_PAD_SOURCE_VIDEO, which);
 	src_crop = rkisp1_isp_get_pad_crop(isp, sd_state,
 					   RKISP1_ISP_PAD_SOURCE_VIDEO, which);
 
+	/*
+	 * Media bus code. The ISP can operate in pass-through mode (Bayer in,
+	 * Bayer out or YUV in, YUV out) or process Bayer data to YUV, but
+	 * can't convert from YUV to Bayer.
+	 */
+	sink_info = rkisp1_mbus_info_get_by_code(sink_fmt->code);
+
 	src_fmt->code = format->code;
-	mbus_info = rkisp1_mbus_info_get_by_code(src_fmt->code);
-	if (!mbus_info || !(mbus_info->direction & RKISP1_ISP_SD_SRC)) {
+	src_info = rkisp1_mbus_info_get_by_code(src_fmt->code);
+	if (!src_info || !(src_info->direction & RKISP1_ISP_SD_SRC)) {
 		src_fmt->code = RKISP1_DEF_SRC_PAD_FMT;
-		mbus_info = rkisp1_mbus_info_get_by_code(src_fmt->code);
+		src_info = rkisp1_mbus_info_get_by_code(src_fmt->code);
 	}
-	if (which == V4L2_SUBDEV_FORMAT_ACTIVE)
-		isp->src_fmt = mbus_info;
+
+	if (sink_info->pixel_enc == V4L2_PIXEL_ENC_YUV &&
+	    src_info->pixel_enc == V4L2_PIXEL_ENC_BAYER) {
+		src_fmt->code = sink_fmt->code;
+		src_info = sink_info;
+	}
+
+	/*
+	 * The source width and height must be identical to the source crop
+	 * size.
+	 */
 	src_fmt->width  = src_crop->width;
 	src_fmt->height = src_crop->height;
 
@@ -498,14 +518,18 @@ static void rkisp1_isp_set_src_fmt(struct rkisp1_isp *isp,
 	 */
 	if (format->flags & V4L2_MBUS_FRAMEFMT_SET_CSC &&
 	    format->quantization == V4L2_QUANTIZATION_FULL_RANGE &&
-	    mbus_info->pixel_enc == V4L2_PIXEL_ENC_YUV)
+	    src_info->pixel_enc == V4L2_PIXEL_ENC_YUV)
 		src_fmt->quantization = V4L2_QUANTIZATION_FULL_RANGE;
-	else if (mbus_info->pixel_enc == V4L2_PIXEL_ENC_YUV)
+	else if (src_info->pixel_enc == V4L2_PIXEL_ENC_YUV)
 		src_fmt->quantization = V4L2_QUANTIZATION_LIM_RANGE;
 	else
 		src_fmt->quantization = V4L2_QUANTIZATION_FULL_RANGE;
 
 	*format = *src_fmt;
+
+	/* Store the source format info when setting the active format. */
+	if (which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		isp->src_fmt = src_info;
 }
 
 static void rkisp1_isp_set_src_crop(struct rkisp1_isp *isp,
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DED4593F0C
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241160AbiHOVK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348044AbiHOVIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:08:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C403C8DA;
        Mon, 15 Aug 2022 12:18:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5860E60EF0;
        Mon, 15 Aug 2022 19:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4500EC433D6;
        Mon, 15 Aug 2022 19:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591086;
        bh=++0gQvoVEsES9czLKXdr0jf/8o4LNf21BoHpAo3XYVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwhRjt9OFz/VE8wTuDz6w2tSUcwZIUkRSZ4midVI2BFIgs1BwyrG2TJpYT/q67aj7
         nSMc/SNL6ZjSbmY6Ns9qIEroFf9eIHJD6zlaCbBjnxNtVuOfe65TAVj/DW4/NQGgvC
         XQH7aJQ+1pPU++Ex6l7TJfTUe5+WQthJOxKwola8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0437/1095] media: hantro: Fix RK3399 H.264 format advertising
Date:   Mon, 15 Aug 2022 19:57:16 +0200
Message-Id: <20220815180447.734658112@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>

[ Upstream commit 177d841fa19542eb35aa5ec9579c4abb989c9255 ]

Commit 1f82f2df523cb ("media: hantro: Enable H.264 on Rockchip VDPU2")
enabled H.264 on some SoCs with VDPU2 cores. This had the side-effect
of exposing H.264 coded format as supported on RK3399.

Fix this and clarify how the codec is explicitly disabled on RK3399 on
this driver.

Fixes: 1f82f2df523cb ("media: hantro: Enable H.264 on Rockchip VDPU2")
Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Tested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/hantro/rockchip_vpu_hw.c    | 60 ++++++++++++++++---
 1 file changed, 53 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/hantro/rockchip_vpu_hw.c b/drivers/staging/media/hantro/rockchip_vpu_hw.c
index 098486b9ec27..26e16b5a6a70 100644
--- a/drivers/staging/media/hantro/rockchip_vpu_hw.c
+++ b/drivers/staging/media/hantro/rockchip_vpu_hw.c
@@ -182,7 +182,7 @@ static const struct hantro_fmt rk3288_vpu_dec_fmts[] = {
 	},
 };
 
-static const struct hantro_fmt rk3399_vpu_dec_fmts[] = {
+static const struct hantro_fmt rockchip_vdpu2_dec_fmts[] = {
 	{
 		.fourcc = V4L2_PIX_FMT_NV12,
 		.codec_mode = HANTRO_MODE_NONE,
@@ -236,6 +236,47 @@ static const struct hantro_fmt rk3399_vpu_dec_fmts[] = {
 	},
 };
 
+static const struct hantro_fmt rk3399_vpu_dec_fmts[] = {
+	{
+		.fourcc = V4L2_PIX_FMT_NV12,
+		.codec_mode = HANTRO_MODE_NONE,
+		.frmsize = {
+			.min_width = FMT_MIN_WIDTH,
+			.max_width = FMT_FHD_WIDTH,
+			.step_width = MB_DIM,
+			.min_height = FMT_MIN_HEIGHT,
+			.max_height = FMT_FHD_HEIGHT,
+			.step_height = MB_DIM,
+		},
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_MPEG2_SLICE,
+		.codec_mode = HANTRO_MODE_MPEG2_DEC,
+		.max_depth = 2,
+		.frmsize = {
+			.min_width = FMT_MIN_WIDTH,
+			.max_width = FMT_FHD_WIDTH,
+			.step_width = MB_DIM,
+			.min_height = FMT_MIN_HEIGHT,
+			.max_height = FMT_FHD_HEIGHT,
+			.step_height = MB_DIM,
+		},
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_VP8_FRAME,
+		.codec_mode = HANTRO_MODE_VP8_DEC,
+		.max_depth = 2,
+		.frmsize = {
+			.min_width = FMT_MIN_WIDTH,
+			.max_width = FMT_UHD_WIDTH,
+			.step_width = MB_DIM,
+			.min_height = FMT_MIN_HEIGHT,
+			.max_height = FMT_UHD_HEIGHT,
+			.step_height = MB_DIM,
+		},
+	},
+};
+
 static irqreturn_t rockchip_vpu1_vepu_irq(int irq, void *dev_id)
 {
 	struct hantro_dev *vpu = dev_id;
@@ -548,8 +589,8 @@ const struct hantro_variant rk3288_vpu_variant = {
 
 const struct hantro_variant rk3328_vpu_variant = {
 	.dec_offset = 0x400,
-	.dec_fmts = rk3399_vpu_dec_fmts,
-	.num_dec_fmts = ARRAY_SIZE(rk3399_vpu_dec_fmts),
+	.dec_fmts = rockchip_vdpu2_dec_fmts,
+	.num_dec_fmts = ARRAY_SIZE(rockchip_vdpu2_dec_fmts),
 	.codec = HANTRO_MPEG2_DECODER | HANTRO_VP8_DECODER |
 		 HANTRO_H264_DECODER,
 	.codec_ops = rk3399_vpu_codec_ops,
@@ -560,6 +601,11 @@ const struct hantro_variant rk3328_vpu_variant = {
 	.num_clocks = ARRAY_SIZE(rockchip_vpu_clk_names),
 };
 
+/*
+ * H.264 decoding explicitly disabled in RK3399.
+ * This ensures userspace applications use the Rockchip VDEC core,
+ * which has better performance.
+ */
 const struct hantro_variant rk3399_vpu_variant = {
 	.enc_offset = 0x0,
 	.enc_fmts = rockchip_vpu_enc_fmts,
@@ -579,8 +625,8 @@ const struct hantro_variant rk3399_vpu_variant = {
 
 const struct hantro_variant rk3568_vpu_variant = {
 	.dec_offset = 0x400,
-	.dec_fmts = rk3399_vpu_dec_fmts,
-	.num_dec_fmts = ARRAY_SIZE(rk3399_vpu_dec_fmts),
+	.dec_fmts = rockchip_vdpu2_dec_fmts,
+	.num_dec_fmts = ARRAY_SIZE(rockchip_vdpu2_dec_fmts),
 	.codec = HANTRO_MPEG2_DECODER |
 		 HANTRO_VP8_DECODER | HANTRO_H264_DECODER,
 	.codec_ops = rk3399_vpu_codec_ops,
@@ -596,8 +642,8 @@ const struct hantro_variant px30_vpu_variant = {
 	.enc_fmts = rockchip_vpu_enc_fmts,
 	.num_enc_fmts = ARRAY_SIZE(rockchip_vpu_enc_fmts),
 	.dec_offset = 0x400,
-	.dec_fmts = rk3399_vpu_dec_fmts,
-	.num_dec_fmts = ARRAY_SIZE(rk3399_vpu_dec_fmts),
+	.dec_fmts = rockchip_vdpu2_dec_fmts,
+	.num_dec_fmts = ARRAY_SIZE(rockchip_vdpu2_dec_fmts),
 	.codec = HANTRO_JPEG_ENCODER | HANTRO_MPEG2_DECODER |
 		 HANTRO_VP8_DECODER | HANTRO_H264_DECODER,
 	.codec_ops = rk3399_vpu_codec_ops,
-- 
2.35.1




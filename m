Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30713333ACE
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 11:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhCJK4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 05:56:51 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:34397 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231228AbhCJK4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 05:56:49 -0500
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2021 05:56:48 EST
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud7.xs4all.net with ESMTPA
        id JwPKlFOT6OruFJwPOlWery; Wed, 10 Mar 2021 11:49:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1615373382; bh=JzMZuBVOJIFHgl51ejoY/59xqgVlozR7BBcPc5ehtpM=;
        h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=blxbO/bX2E8VejjHIDpjiwrCR8mrq+GOc2O6juPtcXxG/+bl7/6QqyM7UKYOCXrAR
         wI6cvAx+gobm75r/2SWglvxC0CMgHHZn/wXus1JlKHhBBRYXd50v9a8Y48d5tSiYDy
         Q7oWgcgwobJhuFHMBZP67N9jbl+SaUbeXv35YPAEIk4afS/hOYNRs+tFa2YFL7VJCD
         hAB13Te/2fRK6OB9+ncspUwltskUo3igK0MfBwSxQb9cM8gD9G/pqDUJUQ7OnP9je4
         Yf9Mlqe0sT4o0KzDEmfXtoOAiYcYTr8klkV14d4andrxBQm963I3fDmybU94I04MAV
         b/9M/NR9kL1fA==
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        =?UTF-8?Q?Jernej_=c5=a0krabec?= <jernej.skrabec@siol.net>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH FOR stable v5.11] media: cedrus: Remove checking for required
 controls
Message-ID: <f938a1ba-d9ae-3b39-a066-60504a9e6c12@xs4all.nl>
Date:   Wed, 10 Mar 2021 11:49:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfEjY2nROBGfLEa1tqFCDSriCvK4OU2xYNodaEis3mzzTNtjc9ozmTNqi8VcDBMK8ifdPNEDgB3wYcm4PDD9zw71V0RBrUQX6xLQkOGHlNPRgWtqKU4ZY
 avk6BujaHM9iWRkcrm/Nnz+zU+1ckbFLYCuF69W2ktc6Z0ckiQCS7hiRmUAYySmAw1IiNsP7mwLenETZIjcVxv/QeKQcGq0ddsyhmRZhrJ1EjKsaB1XDb4YJ
 dR7WaMfYXWBr9EPK3+CjkYkiRoW4R1+p/0K3xZlbAFfnKkKvJt8d7tbHwFsOl4jMMQEsrVcGu8l9DTi+sAraWNkvIiVYPBKiTIHMWOTnBPc=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 7072db89572135f28cad65f15877bf7e67cf2ff8 ]

According to v4l2 request api specifications, it's allowed to skip
control if its content isn't changed for performance reasons. Cedrus
driver predates that, so it has implemented mechanism to check if all
required controls are included in one request.

Conform to specifications with removing that mechanism.

Note that this mechanism with static required flag isn't very good
anyway because need for control is usually signaled in other controls.

Fixes: 50e761516f2b ("media: platform: Add Cedrus VPU decoder driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
Without this patch the H264 cedrus support is non-compliant, and since 5.11
was the first kernel with a stable H264 stateless codec ABI it would be
good to have this merged for 5.11 so the cedrus driver can be used with
H264.
---
 drivers/staging/media/sunxi/cedrus/cedrus.c | 49 ---------------------
 drivers/staging/media/sunxi/cedrus/cedrus.h |  1 -
 2 files changed, 50 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index ddad5d274ee8..7bd9291c8d5f 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -34,56 +34,48 @@ static const struct cedrus_control cedrus_controls[] = {
 			.id	= V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS,
 		},
 		.codec		= CEDRUS_CODEC_MPEG2,
-		.required	= true,
 	},
 	{
 		.cfg = {
 			.id	= V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION,
 		},
 		.codec		= CEDRUS_CODEC_MPEG2,
-		.required	= false,
 	},
 	{
 		.cfg = {
 			.id	= V4L2_CID_STATELESS_H264_DECODE_PARAMS,
 		},
 		.codec		= CEDRUS_CODEC_H264,
-		.required	= true,
 	},
 	{
 		.cfg = {
 			.id	= V4L2_CID_STATELESS_H264_SLICE_PARAMS,
 		},
 		.codec		= CEDRUS_CODEC_H264,
-		.required	= true,
 	},
 	{
 		.cfg = {
 			.id	= V4L2_CID_STATELESS_H264_SPS,
 		},
 		.codec		= CEDRUS_CODEC_H264,
-		.required	= true,
 	},
 	{
 		.cfg = {
 			.id	= V4L2_CID_STATELESS_H264_PPS,
 		},
 		.codec		= CEDRUS_CODEC_H264,
-		.required	= true,
 	},
 	{
 		.cfg = {
 			.id	= V4L2_CID_STATELESS_H264_SCALING_MATRIX,
 		},
 		.codec		= CEDRUS_CODEC_H264,
-		.required	= false,
 	},
 	{
 		.cfg = {
 			.id	= V4L2_CID_STATELESS_H264_PRED_WEIGHTS,
 		},
 		.codec		= CEDRUS_CODEC_H264,
-		.required	= false,
 	},
 	{
 		.cfg = {
@@ -92,7 +84,6 @@ static const struct cedrus_control cedrus_controls[] = {
 			.def	= V4L2_STATELESS_H264_DECODE_MODE_SLICE_BASED,
 		},
 		.codec		= CEDRUS_CODEC_H264,
-		.required	= false,
 	},
 	{
 		.cfg = {
@@ -101,7 +92,6 @@ static const struct cedrus_control cedrus_controls[] = {
 			.def	= V4L2_STATELESS_H264_START_CODE_NONE,
 		},
 		.codec		= CEDRUS_CODEC_H264,
-		.required	= false,
 	},
 	/*
 	 * We only expose supported profiles information,
@@ -120,28 +110,24 @@ static const struct cedrus_control cedrus_controls[] = {
 				BIT(V4L2_MPEG_VIDEO_H264_PROFILE_EXTENDED),
 		},
 		.codec		= CEDRUS_CODEC_H264,
-		.required	= false,
 	},
 	{
 		.cfg = {
 			.id	= V4L2_CID_MPEG_VIDEO_HEVC_SPS,
 		},
 		.codec		= CEDRUS_CODEC_H265,
-		.required	= true,
 	},
 	{
 		.cfg = {
 			.id	= V4L2_CID_MPEG_VIDEO_HEVC_PPS,
 		},
 		.codec		= CEDRUS_CODEC_H265,
-		.required	= true,
 	},
 	{
 		.cfg = {
 			.id	= V4L2_CID_MPEG_VIDEO_HEVC_SLICE_PARAMS,
 		},
 		.codec		= CEDRUS_CODEC_H265,
-		.required	= true,
 	},
 	{
 		.cfg = {
@@ -150,7 +136,6 @@ static const struct cedrus_control cedrus_controls[] = {
 			.def	= V4L2_MPEG_VIDEO_HEVC_DECODE_MODE_SLICE_BASED,
 		},
 		.codec		= CEDRUS_CODEC_H265,
-		.required	= false,
 	},
 	{
 		.cfg = {
@@ -159,14 +144,12 @@ static const struct cedrus_control cedrus_controls[] = {
 			.def	= V4L2_MPEG_VIDEO_HEVC_START_CODE_NONE,
 		},
 		.codec		= CEDRUS_CODEC_H265,
-		.required	= false,
 	},
 	{
 		.cfg = {
 			.id		= V4L2_CID_MPEG_VIDEO_VP8_FRAME_HEADER,
 		},
 		.codec		= CEDRUS_CODEC_VP8,
-		.required	= true,
 	},
 };

@@ -227,12 +210,8 @@ static int cedrus_init_ctrls(struct cedrus_dev *dev, struct cedrus_ctx *ctx)
 static int cedrus_request_validate(struct media_request *req)
 {
 	struct media_request_object *obj;
-	struct v4l2_ctrl_handler *parent_hdl, *hdl;
 	struct cedrus_ctx *ctx = NULL;
-	struct v4l2_ctrl *ctrl_test;
 	unsigned int count;
-	unsigned int i;
-	int ret = 0;

 	list_for_each_entry(obj, &req->objects, list) {
 		struct vb2_buffer *vb;
@@ -259,34 +238,6 @@ static int cedrus_request_validate(struct media_request *req)
 		return -EINVAL;
 	}

-	parent_hdl = &ctx->hdl;
-
-	hdl = v4l2_ctrl_request_hdl_find(req, parent_hdl);
-	if (!hdl) {
-		v4l2_info(&ctx->dev->v4l2_dev, "Missing codec control(s)\n");
-		return -ENOENT;
-	}
-
-	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
-		if (cedrus_controls[i].codec != ctx->current_codec ||
-		    !cedrus_controls[i].required)
-			continue;
-
-		ctrl_test = v4l2_ctrl_request_hdl_ctrl_find(hdl,
-							    cedrus_controls[i].cfg.id);
-		if (!ctrl_test) {
-			v4l2_info(&ctx->dev->v4l2_dev,
-				  "Missing required codec control\n");
-			ret = -ENOENT;
-			break;
-		}
-	}
-
-	v4l2_ctrl_request_hdl_put(hdl);
-
-	if (ret)
-		return ret;
-
 	return vb2_request_validate(req);
 }

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.h b/drivers/staging/media/sunxi/cedrus/cedrus.h
index c96077aaef49..251a6a660351 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
@@ -56,7 +56,6 @@ enum cedrus_h264_pic_type {
 struct cedrus_control {
 	struct v4l2_ctrl_config cfg;
 	enum cedrus_codec	codec;
-	unsigned char		required:1;
 };

 struct cedrus_h264_run {
-- 
2.30.1


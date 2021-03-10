Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89915333DAE
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhCJNYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232783AbhCJNYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6FFB64FE8;
        Wed, 10 Mar 2021 13:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382654;
        bh=YpFHQMZyNfl+6dwoe/1qLnWAdmC1Aeyw5cp/9SSd15A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCkbJifAk+hOqW6FQTubqvcYZjUxmVYdAeT27TiQNM+9C9FLgUr8FB+myaWfsl94r
         gjvfqdXPhAAvGmIlmqD4NPb3B6V9SPKMdbhjrSJDoKvU8rXE835GqK0sGx7of8fcFZ
         h44hQjLhvq3AwSGDosDheb48I7zqj9z69/DOl+7I=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.11 11/36] media: cedrus: Remove checking for required controls
Date:   Wed, 10 Mar 2021 14:23:24 +0100
Message-Id: <20210310132320.872054102@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jernej Skrabec <jernej.skrabec@siol.net>

commit 7072db89572135f28cad65f15877bf7e67cf2ff8 upstream.

According to v4l2 request api specifications, it's allowed to skip
control if its content isn't changed for performance reasons. Cedrus
driver predates that, so it has implemented mechanism to check if all
required controls are included in one request.

Conform to specifications with removing that mechanism.

Note that this mechanism with static required flag isn't very good
anyway because need for control is usually signaled in other controls.

Fixes: 50e761516f2b ("media: platform: Add Cedrus VPU decoder driver")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c |   49 ----------------------------
 drivers/staging/media/sunxi/cedrus/cedrus.h |    1 
 2 files changed, 50 deletions(-)

--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -34,56 +34,48 @@ static const struct cedrus_control cedru
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
@@ -92,7 +84,6 @@ static const struct cedrus_control cedru
 			.def	= V4L2_STATELESS_H264_DECODE_MODE_SLICE_BASED,
 		},
 		.codec		= CEDRUS_CODEC_H264,
-		.required	= false,
 	},
 	{
 		.cfg = {
@@ -101,7 +92,6 @@ static const struct cedrus_control cedru
 			.def	= V4L2_STATELESS_H264_START_CODE_NONE,
 		},
 		.codec		= CEDRUS_CODEC_H264,
-		.required	= false,
 	},
 	/*
 	 * We only expose supported profiles information,
@@ -120,28 +110,24 @@ static const struct cedrus_control cedru
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
@@ -150,7 +136,6 @@ static const struct cedrus_control cedru
 			.def	= V4L2_MPEG_VIDEO_HEVC_DECODE_MODE_SLICE_BASED,
 		},
 		.codec		= CEDRUS_CODEC_H265,
-		.required	= false,
 	},
 	{
 		.cfg = {
@@ -159,14 +144,12 @@ static const struct cedrus_control cedru
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
 
@@ -227,12 +210,8 @@ static int cedrus_init_ctrls(struct cedr
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
@@ -259,34 +238,6 @@ static int cedrus_request_validate(struc
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
 
--- a/drivers/staging/media/sunxi/cedrus/cedrus.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
@@ -56,7 +56,6 @@ enum cedrus_h264_pic_type {
 struct cedrus_control {
 	struct v4l2_ctrl_config cfg;
 	enum cedrus_codec	codec;
-	unsigned char		required:1;
 };
 
 struct cedrus_h264_run {



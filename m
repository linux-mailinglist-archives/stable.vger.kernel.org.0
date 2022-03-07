Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BCE4CF6DB
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238242AbiCGJm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241057AbiCGJls (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:48 -0500
Received: from www.linuxtv.org (www.linuxtv.org [130.149.80.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BD06D967
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 01:39:41 -0800 (PST)
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1nR9q8-00BwGl-5j; Mon, 07 Mar 2022 09:39:40 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Mon, 07 Mar 2022 09:36:07 +0000
Subject: [git:media_stage/master] media: venus: venc: Fix h264 8x8 transform control
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1nR9q8-00BwGl-5j@www.linuxtv.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: venus: venc: Fix h264 8x8 transform control
Author:  Stanimir Varbanov <stanimir.varbanov@linaro.org>
Date:    Tue Feb 8 02:18:16 2022 +0100

During encoder driver open controls are initialized via a call
to v4l2_ctrl_handler_setup which returns EINVAL error for
V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM v4l2 control. The control
default value is disabled and because of firmware limitations
8x8 transform cannot be disabled for the supported HIGH and
CONSTRAINED_HIGH profiles.

To fix the issue change the control default value to enabled
(this is fine because the firmware enables 8x8 transform for
high and constrained_high profiles by default). Also, correct
the checking of profile ids in s_ctrl from hfi to v4l2 ids.

cc: stable@vger.kernel.org # 5.15+
Fixes: bfee75f73c37 ("media: venus: venc: add support for V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM control")
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/platform/qcom/venus/venc.c       | 4 ++--
 drivers/media/platform/qcom/venus/venc_ctrls.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

---

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 84bafc3118cc..adea4c3b8c20 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -662,8 +662,8 @@ static int venc_set_properties(struct venus_inst *inst)
 
 		ptype = HFI_PROPERTY_PARAM_VENC_H264_TRANSFORM_8X8;
 		h264_transform.enable_type = 0;
-		if (ctr->profile.h264 == HFI_H264_PROFILE_HIGH ||
-		    ctr->profile.h264 == HFI_H264_PROFILE_CONSTRAINED_HIGH)
+		if (ctr->profile.h264 == V4L2_MPEG_VIDEO_H264_PROFILE_HIGH ||
+		    ctr->profile.h264 == V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_HIGH)
 			h264_transform.enable_type = ctr->h264_8x8_transform;
 
 		ret = hfi_session_set_property(inst, ptype, &h264_transform);
diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
index 1ada42df314d..ea5805e71c14 100644
--- a/drivers/media/platform/qcom/venus/venc_ctrls.c
+++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
@@ -320,8 +320,8 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 		ctr->intra_refresh_period = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:
-		if (ctr->profile.h264 != HFI_H264_PROFILE_HIGH &&
-		    ctr->profile.h264 != HFI_H264_PROFILE_CONSTRAINED_HIGH)
+		if (ctr->profile.h264 != V4L2_MPEG_VIDEO_H264_PROFILE_HIGH &&
+		    ctr->profile.h264 != V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_HIGH)
 			return -EINVAL;
 
 		/*
@@ -457,7 +457,7 @@ int venc_ctrl_init(struct venus_inst *inst)
 			  V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP, 1, 51, 1, 1);
 
 	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
-			  V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM, 0, 1, 1, 0);
+			  V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM, 0, 1, 1, 1);
 
 	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
 			  V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP, 1, 51, 1, 1);

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D874F2F26
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238216AbiDEJEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243821AbiDEIvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:51:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A325CC8BFA;
        Tue,  5 Apr 2022 01:39:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12204B81C15;
        Tue,  5 Apr 2022 08:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F33DC385A1;
        Tue,  5 Apr 2022 08:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147938;
        bh=G6i5haVbj2OduWENChWdZ9mhaLevM6O81fzdyfMMJVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7I+qgbtsojzs2lBkQj/UikNzMlc0VMK1xaJvqvFgXQOrma8+Ww98fGGx6VLSmV6D
         baZ0lcWdml2+a6VYSk7jFGom8uWC/XYkHuQ1SZCRM880RS1umYstD7CqA/yymHzcLc
         gTWEl6xPaUuJA5LTFM4WzPvpSpr+XNInRRD+BpAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.16 0176/1017] media: venus: venc: Fix h264 8x8 transform control
Date:   Tue,  5 Apr 2022 09:18:09 +0200
Message-Id: <20220405070359.455799626@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

commit 61b3317dd424a3488b6754d7ff8301944d9d17d7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/venc.c       |    4 ++--
 drivers/media/platform/qcom/venus/venc_ctrls.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -662,8 +662,8 @@ static int venc_set_properties(struct ve
 
 		ptype = HFI_PROPERTY_PARAM_VENC_H264_TRANSFORM_8X8;
 		h264_transform.enable_type = 0;
-		if (ctr->profile.h264 == HFI_H264_PROFILE_HIGH ||
-		    ctr->profile.h264 == HFI_H264_PROFILE_CONSTRAINED_HIGH)
+		if (ctr->profile.h264 == V4L2_MPEG_VIDEO_H264_PROFILE_HIGH ||
+		    ctr->profile.h264 == V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_HIGH)
 			h264_transform.enable_type = ctr->h264_8x8_transform;
 
 		ret = hfi_session_set_property(inst, ptype, &h264_transform);
--- a/drivers/media/platform/qcom/venus/venc_ctrls.c
+++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
@@ -320,8 +320,8 @@ static int venc_op_s_ctrl(struct v4l2_ct
 		ctr->intra_refresh_period = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:
-		if (ctr->profile.h264 != HFI_H264_PROFILE_HIGH &&
-		    ctr->profile.h264 != HFI_H264_PROFILE_CONSTRAINED_HIGH)
+		if (ctr->profile.h264 != V4L2_MPEG_VIDEO_H264_PROFILE_HIGH &&
+		    ctr->profile.h264 != V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_HIGH)
 			return -EINVAL;
 
 		/*
@@ -457,7 +457,7 @@ int venc_ctrl_init(struct venus_inst *in
 			  V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP, 1, 51, 1, 1);
 
 	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
-			  V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM, 0, 1, 1, 0);
+			  V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM, 0, 1, 1, 1);
 
 	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
 			  V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP, 1, 51, 1, 1);



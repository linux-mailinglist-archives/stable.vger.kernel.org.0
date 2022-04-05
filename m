Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA76C4F2ECE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345121AbiDEKko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244306AbiDEJlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:41:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754EFBB0B2;
        Tue,  5 Apr 2022 02:26:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 047E66164E;
        Tue,  5 Apr 2022 09:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19280C385A2;
        Tue,  5 Apr 2022 09:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150766;
        bh=nwj9I4hz2LjdI9ekt63/VjDkSUZQm1L///5e87gCFWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqdJhCdgf8oROgseBk7QGjgMaxGfblohV8kckRfMxiMhT/HpdP9N8ZcHK9U6EzZno
         B0HDtQ/jExfAkVVbdNKNZ6+2pN0GF36PygrhNC7kJVnatUciEQPJWP6G759e3GgPxr
         hsvZPnIjz3BiqPN0pyJOdYwkEilesYa5LPudWmts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.15 166/913] media: venus: venc: Fix h264 8x8 transform control
Date:   Tue,  5 Apr 2022 09:20:28 +0200
Message-Id: <20220405070344.823339864@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
@@ -604,8 +604,8 @@ static int venc_set_properties(struct ve
 
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



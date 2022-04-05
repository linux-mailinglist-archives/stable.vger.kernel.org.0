Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DAF4F2672
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbiDEIGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235552AbiDEH7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9D63FBF7;
        Tue,  5 Apr 2022 00:55:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF68E615CD;
        Tue,  5 Apr 2022 07:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4220C340EE;
        Tue,  5 Apr 2022 07:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145328;
        bh=zU+CWYBYU/8pJUNeNTS9RmWcQvumA7Jb/SBfIxAI/3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7bI+vEMcXxCu5wuspnoxZgFUsUPtndkDMSqrzvVoljeR4bxQP82LQsK7jjc0vdXS
         As3mnTSxBSBxAtuRexe3nbXwj7ZLVwuwTPuMOXea0YMWQiZlzdxzDDn4PnrdF02Sf1
         1N1/WSXxR9iJFjRw8WW+gX6jUoSBd0V2BdaT22uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0365/1126] media: v4l2-core: Initialize h264 scaling matrix
Date:   Tue,  5 Apr 2022 09:18:32 +0200
Message-Id: <20220405070418.341509882@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit 0f6146d476fc99862899e70f2554ee77b444b7b9 ]

In the final H264 API, it is not required to set scaling matrix if
they are not present in the bitstream. A flag was added in order to let
the driver know. The downside is that it leaves the default control
value to 0, which isn't valid. As per the spec (see formulas 7-8/7-9),
when the scaling matrix are absent from the bitstream, flat values
of 16 should be used. This improves this control semantic in a way
that the control value are always valid. Drivers can then use
the scaling_matrix control values without having to check its presence.
Same method was employed for MPEG2_QUANTISATION.

This fixes issues with MTK VCODEC H264 decoder when using GStreamer.
GStreamer does not set this control if its not present in the bitstream.
As MTK VDCODEC was using the initialized to 0 values, the frames ended
up completely gray.

Fixes: 54889c51b833d236 ("media: uapi: h264: Rename and clarify PPS_FLAG_SCALING_MATRIX_PRESENT")
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls-core.c b/drivers/media/v4l2-core/v4l2-ctrls-core.c
index b25c77b8a445..df8cff47a7fb 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -114,6 +114,7 @@ static void std_init_compound(const struct v4l2_ctrl *ctrl, u32 idx,
 	struct v4l2_ctrl_vp8_frame *p_vp8_frame;
 	struct v4l2_ctrl_vp9_frame *p_vp9_frame;
 	struct v4l2_ctrl_fwht_params *p_fwht_params;
+	struct v4l2_ctrl_h264_scaling_matrix *p_h264_scaling_matrix;
 	void *p = ptr.p + idx * ctrl->elem_size;
 
 	if (ctrl->p_def.p_const)
@@ -168,6 +169,15 @@ static void std_init_compound(const struct v4l2_ctrl *ctrl, u32 idx,
 		p_fwht_params->flags = V4L2_FWHT_FL_PIXENC_YUV |
 			(2 << V4L2_FWHT_FL_COMPONENTS_NUM_OFFSET);
 		break;
+	case V4L2_CTRL_TYPE_H264_SCALING_MATRIX:
+		p_h264_scaling_matrix = p;
+		/*
+		 * The default (flat) H.264 scaling matrix when none are
+		 * specified in the bitstream, this is according to formulas
+		 *  (7-8) and (7-9) of the specification.
+		 */
+		memset(p_h264_scaling_matrix, 16, sizeof(*p_h264_scaling_matrix));
+		break;
 	}
 }
 
-- 
2.34.1




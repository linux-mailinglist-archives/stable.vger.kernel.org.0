Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384824F363E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344116AbiDEK7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348018AbiDEJqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:46:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D742CDFFAF;
        Tue,  5 Apr 2022 02:33:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FC63B81C6F;
        Tue,  5 Apr 2022 09:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39D7C385A2;
        Tue,  5 Apr 2022 09:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151187;
        bh=/BqF9jgSCsU1r7qpd4RDUUkzXDFKR7HrHJJF5oevN9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpWMdcK7konzSuUkBGdOjKn+XXIk2UxONn9/k5F+E6Qh3Dl0myS1vrEVTKMY2bIHI
         PMyjYqj2FCrhYZexResfTJlmRZmEmQx0TUFiuod17WHxJxByhSR928/SaJi8vUwOmW
         9bYr9Klmg+9jZjVVBLeMMtHLRgsDq6PhcL4zv6NU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 324/913] media: v4l2-core: Initialize h264 scaling matrix
Date:   Tue,  5 Apr 2022 09:23:06 +0200
Message-Id: <20220405070349.562420774@linuxfoundation.org>
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
index c4b5082849b6..45a76f40deeb 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -113,6 +113,7 @@ static void std_init_compound(const struct v4l2_ctrl *ctrl, u32 idx,
 	struct v4l2_ctrl_mpeg2_quantisation *p_mpeg2_quant;
 	struct v4l2_ctrl_vp8_frame *p_vp8_frame;
 	struct v4l2_ctrl_fwht_params *p_fwht_params;
+	struct v4l2_ctrl_h264_scaling_matrix *p_h264_scaling_matrix;
 	void *p = ptr.p + idx * ctrl->elem_size;
 
 	if (ctrl->p_def.p_const)
@@ -160,6 +161,15 @@ static void std_init_compound(const struct v4l2_ctrl *ctrl, u32 idx,
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




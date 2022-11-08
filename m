Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DC862154A
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiKHOKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235175AbiKHOKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:10:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D5313FBC
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:10:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC4C9B81AE4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11962C433D7;
        Tue,  8 Nov 2022 14:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916604;
        bh=7TDdqgEikTI40QNSMMQrhLIJ+17dlaHFiV3DeHyY+xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QkYwz5H2FmkZhFu85kdKHyld3t7xk3dmQW5U5gMKQ2UTCRWV4QHSRixc7zap/yfs
         io/siowpibXo7wSYoQN1btGnqtFnhSeR5Ae0CVxoA1+UgnCcBaRQ4R7OZQ7sZTl4WR
         xfSyHcrOad+Cbg6hbIszBvBOp/4nl0EqFNEBse4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 074/197] media: hantro: Store HEVC bit depth in context
Date:   Tue,  8 Nov 2022 14:38:32 +0100
Message-Id: <20221108133358.213041811@linuxfoundation.org>
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

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

[ Upstream commit 4bec03301ecd81760c159402467dbb2cfd527684 ]

Store HEVC bit depth in context.
Bit depth is equal to hevc sps bit_depth_luma_minus8 + 8.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_drv.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/staging/media/hantro/hantro_drv.c b/drivers/staging/media/hantro/hantro_drv.c
index 2036f72eeb4a..1dd8312d824c 100644
--- a/drivers/staging/media/hantro/hantro_drv.c
+++ b/drivers/staging/media/hantro/hantro_drv.c
@@ -251,6 +251,11 @@ queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
 
 static int hantro_try_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct hantro_ctx *ctx;
+
+	ctx = container_of(ctrl->handler,
+			   struct hantro_ctx, ctrl_handler);
+
 	if (ctrl->id == V4L2_CID_STATELESS_H264_SPS) {
 		const struct v4l2_ctrl_h264_sps *sps = ctrl->p_new.p_h264_sps;
 
@@ -272,6 +277,8 @@ static int hantro_try_ctrl(struct v4l2_ctrl *ctrl)
 		if (sps->bit_depth_luma_minus8 != 0)
 			/* Only 8-bit is supported */
 			return -EINVAL;
+
+		ctx->bit_depth = sps->bit_depth_luma_minus8 + 8;
 	} else if (ctrl->id == V4L2_CID_STATELESS_VP9_FRAME) {
 		const struct v4l2_ctrl_vp9_frame *dec_params = ctrl->p_new.p_vp9_frame;
 
-- 
2.35.1




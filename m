Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CCA343AEA
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 08:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCVHw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 03:52:27 -0400
Received: from www.linuxtv.org ([130.149.80.248]:47110 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhCVHwT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 03:52:19 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1lOFMH-009zFR-TS; Mon, 22 Mar 2021 07:52:17 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Mon, 22 Mar 2021 07:51:50 +0000
Subject: [git:media_tree/fixes] media: coda: fix macroblocks count control usage
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>, stable@vger.kernel.org,
        Marco Felsch <m.felsch@pengutronix.de>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1lOFMH-009zFR-TS@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: coda: fix macroblocks count control usage
Author:  Marco Felsch <m.felsch@pengutronix.de>
Date:    Fri Mar 5 09:23:54 2021 +0100

Commit b2d3bef1aa78 ("media: coda: Add a V4L2 user for control error
macroblocks count") add the control for the decoder devices. But
during streamon() this ioctl gets called for all (encoder and decoder)
devices and on encoder devices this causes a null pointer exception.

Fix this by setting the control only if it is really accessible.

Fixes: b2d3bef1aa78 ("media: coda: Add a V4L2 user for control error macroblocks count")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Cc: <stable@vger.kernel.org>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/platform/coda/coda-common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

---

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 995e95272e51..e600764dce96 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2062,7 +2062,9 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (q_data_dst->fourcc == V4L2_PIX_FMT_JPEG)
 		ctx->params.gop_size = 1;
 	ctx->gopcounter = ctx->params.gop_size - 1;
-	v4l2_ctrl_s_ctrl(ctx->mb_err_cnt_ctrl, 0);
+	/* Only decoders have this control */
+	if (ctx->mb_err_cnt_ctrl)
+		v4l2_ctrl_s_ctrl(ctx->mb_err_cnt_ctrl, 0);
 
 	ret = ctx->ops->start_streaming(ctx);
 	if (ctx->inst_type == CODA_INST_DECODER) {

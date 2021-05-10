Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639C3378915
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237668AbhEJLZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237834AbhEJLQS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:16:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E7AF6128E;
        Mon, 10 May 2021 11:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645101;
        bh=fv4anlzDpP6hMcyLFnxxphDWL1hisyfY/aZq70Zqxxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pwa5lqiJGj3YNZ55BHUbghGRBygEvd9q43kSeyrHpVry90EiRq6ezcYS4qnquPOOk
         RqoWnOWDIVDVDRfPnjnoUhhCVj1r0qGOfCWSyDVprrfVIFHNWN6g6ffzrEhn0BcyBE
         hHls1+gOXxIl57A7cY1nCExcqVUR/4PZ1tVGEYYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.12 353/384] media: coda: fix macroblocks count control usage
Date:   Mon, 10 May 2021 12:22:22 +0200
Message-Id: <20210510102026.394360716@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

commit 0b276e470a4d43e1365d3eb53c608a3d208cabd4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/coda/coda-common.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2062,7 +2062,9 @@ static int coda_start_streaming(struct v
 	if (q_data_dst->fourcc == V4L2_PIX_FMT_JPEG)
 		ctx->params.gop_size = 1;
 	ctx->gopcounter = ctx->params.gop_size - 1;
-	v4l2_ctrl_s_ctrl(ctx->mb_err_cnt_ctrl, 0);
+	/* Only decoders have this control */
+	if (ctx->mb_err_cnt_ctrl)
+		v4l2_ctrl_s_ctrl(ctx->mb_err_cnt_ctrl, 0);
 
 	ret = ctx->ops->start_streaming(ctx);
 	if (ctx->inst_type == CODA_INST_DECODER) {



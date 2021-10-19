Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32B5439020
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 09:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhJYHPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 03:15:22 -0400
Received: from www.linuxtv.org ([130.149.80.248]:59792 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230259AbhJYHPW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 03:15:22 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1meuAF-00GpcA-6X; Mon, 25 Oct 2021 07:12:59 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 19 Oct 2021 07:08:39 +0000
Subject: [git:media_tree/master] media: rkvdec: Do not override sizeimage for output format
To:     linuxtv-commits@linuxtv.org
Cc:     Chen-Yu Tsai <wenst@chromium.org>, stable@vger.kernel.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1meuAF-00GpcA-6X@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: rkvdec: Do not override sizeimage for output format
Author:  Chen-Yu Tsai <wenst@chromium.org>
Date:    Fri Oct 8 11:04:22 2021 +0100

The rkvdec H.264 decoder currently overrides sizeimage for the output
format. This causes issues when userspace requires and requests a larger
buffer, but ends up with one of insufficient size.

Instead, only provide a default size if none was requested. This fixes
the video_decode_accelerator_tests from Chromium failing on the first
frame due to insufficient buffer space. It also aligns the behavior
of the rkvdec driver with the Hantro and Cedrus drivers.

Fixes: cd33c830448b ("media: rkvdec: Add the rkvdec driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/staging/media/rkvdec/rkvdec-h264.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

---

diff --git a/drivers/staging/media/rkvdec/rkvdec-h264.c b/drivers/staging/media/rkvdec/rkvdec-h264.c
index 76e97cbe2512..951e19231da2 100644
--- a/drivers/staging/media/rkvdec/rkvdec-h264.c
+++ b/drivers/staging/media/rkvdec/rkvdec-h264.c
@@ -1015,8 +1015,9 @@ static int rkvdec_h264_adjust_fmt(struct rkvdec_ctx *ctx,
 	struct v4l2_pix_format_mplane *fmt = &f->fmt.pix_mp;
 
 	fmt->num_planes = 1;
-	fmt->plane_fmt[0].sizeimage = fmt->width * fmt->height *
-				      RKVDEC_H264_MAX_DEPTH_IN_BYTES;
+	if (!fmt->plane_fmt[0].sizeimage)
+		fmt->plane_fmt[0].sizeimage = fmt->width * fmt->height *
+					      RKVDEC_H264_MAX_DEPTH_IN_BYTES;
 	return 0;
 }
 

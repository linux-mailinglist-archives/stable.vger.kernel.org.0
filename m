Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F270D1F6CF9
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 19:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbgFKRqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 13:46:25 -0400
Received: from www.linuxtv.org ([130.149.80.248]:39688 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbgFKRqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 13:46:24 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1jjQqZ-008qtw-C9; Thu, 11 Jun 2020 17:18:35 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 11 Jun 2020 17:18:37 +0000
Subject: [git:media_tree/master] media: cedrus: Program output format during each run
To:     linuxtv-commits@linuxtv.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1jjQqZ-008qtw-C9@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: cedrus: Program output format during each run
Author:  Samuel Holland <samuel@sholland.org>
Date:    Sat May 9 22:06:42 2020 +0200

Previously, the output format was programmed as part of the ioctl()
handler. However, this has two problems:

  1) If there are multiple active streams with different output
     formats, the hardware will use whichever format was set last
     for both streams. Similarly, an ioctl() done in an inactive
     context will wrongly affect other active contexts.
  2) The registers are written while the device is not actively
     streaming. To enable runtime PM tied to the streaming state,
     all hardware access needs to be moved inside cedrus_device_run().

The call to cedrus_dst_format_set() is now placed just before the
codec-specific callback that programs the hardware.

Cc: <stable@vger.kernel.org>
Fixes: 50e761516f2b ("media: platform: Add Cedrus VPU decoder driver")
Suggested-by: Jernej Skrabec <jernej.skrabec@siol.net>
Suggested-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Tested-by: Jernej Skrabec <jernej.skrabec@siol.net>
Reviewed-by: Jernej Skrabec <jernej.skrabec@siol.net>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/staging/media/sunxi/cedrus/cedrus_dec.c   | 2 ++
 drivers/staging/media/sunxi/cedrus/cedrus_video.c | 3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

---

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
index 4a2fc33a1d79..58c48e4fdfe9 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
@@ -74,6 +74,8 @@ void cedrus_device_run(void *priv)
 
 	v4l2_m2m_buf_copy_metadata(run.src, run.dst, true);
 
+	cedrus_dst_format_set(dev, &ctx->dst_fmt);
+
 	dev->dec_ops[ctx->current_codec]->setup(ctx, &run);
 
 	/* Complete request(s) controls if needed. */
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index 15cf1f10221b..ed3f511f066f 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -273,7 +273,6 @@ static int cedrus_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
-	struct cedrus_dev *dev = ctx->dev;
 	struct vb2_queue *vq;
 	int ret;
 
@@ -287,8 +286,6 @@ static int cedrus_s_fmt_vid_cap(struct file *file, void *priv,
 
 	ctx->dst_fmt = f->fmt.pix;
 
-	cedrus_dst_format_set(dev, &ctx->dst_fmt);
-
 	return 0;
 }
 

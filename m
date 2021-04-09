Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D18359CA6
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 13:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbhDILHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 07:07:49 -0400
Received: from www.linuxtv.org ([130.149.80.248]:48128 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233586AbhDILHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 07:07:49 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1lUoz9-0014pZ-K7; Fri, 09 Apr 2021 11:07:35 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 09 Apr 2021 11:07:09 +0000
Subject: [git:media_tree/master] media: staging/intel-ipu3: Fix race condition during set_fmt
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ricardo Ribalda <ribalda@chromium.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1lUoz9-0014pZ-K7@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: staging/intel-ipu3: Fix race condition during set_fmt
Author:  Ricardo Ribalda <ribalda@chromium.org>
Date:    Fri Apr 9 10:41:35 2021 +0200

Do not modify imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp, until the
format has been correctly validated.

Otherwise, even if we use a backup variable, there is a period of time
where imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp might have an invalid
value that can be used by other functions.

Cc: stable@vger.kernel.org
Fixes: ad91849996f9 ("media: staging/intel-ipu3: Fix set_fmt error handling")
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/staging/media/ipu3/ipu3-v4l2.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

---

diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index 9e8980b34547..6d9c49b39531 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -669,7 +669,6 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 	struct imgu_css_pipe *css_pipe = &imgu->css.pipes[pipe];
 	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 	struct imgu_v4l2_subdev *imgu_sd = &imgu_pipe->imgu_sd;
-	struct v4l2_pix_format_mplane fmt_backup;
 
 	dev_dbg(dev, "set fmt node [%u][%u](try = %u)", pipe, node, try);
 
@@ -687,6 +686,7 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 
 	dev_dbg(dev, "IPU3 pipe %u pipe_id = %u", pipe, css_pipe->pipe_id);
 
+	css_q = imgu_node_to_queue(node);
 	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
 		unsigned int inode = imgu_map_node(imgu, i);
 
@@ -701,6 +701,11 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 			continue;
 		}
 
+		if (i == css_q) {
+			fmts[i] = &f->fmt.pix_mp;
+			continue;
+		}
+
 		if (try) {
 			fmts[i] = kmemdup(&imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp,
 					  sizeof(struct v4l2_pix_format_mplane),
@@ -729,39 +734,32 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 		rects[IPU3_CSS_RECT_GDC]->height = pad_fmt.height;
 	}
 
-	/*
-	 * imgu doesn't set the node to the value given by user
-	 * before we return success from this function, so set it here.
-	 */
-	css_q = imgu_node_to_queue(node);
 	if (!fmts[css_q]) {
 		ret = -EINVAL;
 		goto out;
 	}
-	fmt_backup = *fmts[css_q];
-	*fmts[css_q] = f->fmt.pix_mp;
 
 	if (try)
 		ret = imgu_css_fmt_try(&imgu->css, fmts, rects, pipe);
 	else
 		ret = imgu_css_fmt_set(&imgu->css, fmts, rects, pipe);
 
-	if (try || ret < 0)
-		*fmts[css_q] = fmt_backup;
-
 	/* ret is the binary number in the firmware blob */
 	if (ret < 0)
 		goto out;
 
-	if (try)
-		f->fmt.pix_mp = *fmts[css_q];
-	else
-		f->fmt = imgu_pipe->nodes[node].vdev_fmt.fmt;
+	/*
+	 * imgu doesn't set the node to the value given by user
+	 * before we return success from this function, so set it here.
+	 */
+	if (!try)
+		imgu_pipe->nodes[node].vdev_fmt.fmt.pix_mp = f->fmt.pix_mp;
 
 out:
 	if (try) {
 		for (i = 0; i < IPU3_CSS_QUEUES; i++)
-			kfree(fmts[i]);
+			if (i != css_q)
+				kfree(fmts[i]);
 	}
 
 	return ret;

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EEB355412
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 14:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243019AbhDFMkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 08:40:42 -0400
Received: from www.linuxtv.org ([130.149.80.248]:45114 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238946AbhDFMkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 08:40:40 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1lTl0P-00EW5C-AV; Tue, 06 Apr 2021 12:40:29 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 06 Apr 2021 12:32:39 +0000
Subject: [git:media_tree/master] media: staging/intel-ipu3: Fix set_fmt error handling
To:     linuxtv-commits@linuxtv.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1lTl0P-00EW5C-AV@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: staging/intel-ipu3: Fix set_fmt error handling
Author:  Ricardo Ribalda <ribalda@chromium.org>
Date:    Wed Mar 10 01:16:46 2021 +0100

If there in an error during a set_fmt, do not overwrite the previous
sizes with the invalid config.

Without this patch, v4l2-compliance ends up allocating 4GiB of RAM and
causing the following OOPs

[   38.662975] ipu3-imgu 0000:00:05.0: swiotlb buffer is full (sz: 4096 bytes)
[   38.662980] DMA: Out of SW-IOMMU space for 4096 bytes at device 0000:00:05.0
[   38.663010] general protection fault: 0000 [#1] PREEMPT SMP

Cc: stable@vger.kernel.org
Fixes: 6d5f26f2e045 ("media: staging/intel-ipu3-v4l: reduce kernel stack usage")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/staging/media/ipu3/ipu3-v4l2.c | 5 +++++
 1 file changed, 5 insertions(+)

---

diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index 60aa02eb7d2a..e8944e489c56 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -669,6 +669,7 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 	struct imgu_css_pipe *css_pipe = &imgu->css.pipes[pipe];
 	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 	struct imgu_v4l2_subdev *imgu_sd = &imgu_pipe->imgu_sd;
+	struct v4l2_pix_format_mplane fmt_backup;
 
 	dev_dbg(dev, "set fmt node [%u][%u](try = %u)", pipe, node, try);
 
@@ -734,6 +735,7 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 		ret = -EINVAL;
 		goto out;
 	}
+	fmt_backup = *fmts[css_q];
 	*fmts[css_q] = f->fmt.pix_mp;
 
 	if (try)
@@ -741,6 +743,9 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 	else
 		ret = imgu_css_fmt_set(&imgu->css, fmts, rects, pipe);
 
+	if (try || ret < 0)
+		*fmts[css_q] = fmt_backup;
+
 	/* ret is the binary number in the firmware blob */
 	if (ret < 0)
 		goto out;

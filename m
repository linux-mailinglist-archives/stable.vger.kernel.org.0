Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6CB359CA7
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 13:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhDILHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 07:07:50 -0400
Received: from www.linuxtv.org ([130.149.80.248]:48136 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233607AbhDILHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 07:07:49 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1lUoz9-0014pt-M8; Fri, 09 Apr 2021 11:07:35 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 09 Apr 2021 11:06:48 +0000
Subject: [git:media_tree/master] media: staging/intel-ipu3: Fix memory leak in imu_fmt
To:     linuxtv-commits@linuxtv.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1lUoz9-0014pt-M8@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: staging/intel-ipu3: Fix memory leak in imu_fmt
Author:  Ricardo Ribalda <ribalda@chromium.org>
Date:    Mon Mar 15 13:34:05 2021 +0100

We are losing the reference to an allocated memory if try. Change the
order of the check to avoid that.

Cc: stable@vger.kernel.org
Fixes: 6d5f26f2e045 ("media: staging/intel-ipu3-v4l: reduce kernel stack usage")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/staging/media/ipu3/ipu3-v4l2.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

---

diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index e8944e489c56..9e8980b34547 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -694,6 +694,13 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 		if (inode == IMGU_NODE_STAT_3A || inode == IMGU_NODE_PARAMS)
 			continue;
 
+		/* CSS expects some format on OUT queue */
+		if (i != IPU3_CSS_QUEUE_OUT &&
+		    !imgu_pipe->nodes[inode].enabled) {
+			fmts[i] = NULL;
+			continue;
+		}
+
 		if (try) {
 			fmts[i] = kmemdup(&imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp,
 					  sizeof(struct v4l2_pix_format_mplane),
@@ -706,10 +713,6 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 			fmts[i] = &imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp;
 		}
 
-		/* CSS expects some format on OUT queue */
-		if (i != IPU3_CSS_QUEUE_OUT &&
-		    !imgu_pipe->nodes[inode].enabled)
-			fmts[i] = NULL;
 	}
 
 	if (!try) {

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C493337854C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhEJK77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234056AbhEJKzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63A5461934;
        Mon, 10 May 2021 10:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643413;
        bh=g4ALrrfM+EPrWkUEza8K2lEDd+k+oaGl1AtL97CyQ3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zeAQFzC8lSrfsizQb0K7yddQCfuyQ7nsWaSQf/SjKrWPRhetJUtL2y+2pG4Zrh8jW
         /CEwuAeqoEbwtZCQx78XdiVp2lQJ7lm+w6h7ZTq/vWBxLpov2BWYHjVzXcGH6gbOvM
         mCcNF/VEtW2a1P6EaaSpMdoyf3A7NvdrEIHd0QEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 278/299] media: staging/intel-ipu3: Fix race condition during set_fmt
Date:   Mon, 10 May 2021 12:21:15 +0200
Message-Id: <20210510102014.109888635@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

commit dccfe2548746ca9cca3a20401ece4cf255d1f171 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/ipu3/ipu3-v4l2.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -669,7 +669,6 @@ static int imgu_fmt(struct imgu_device *
 	struct imgu_css_pipe *css_pipe = &imgu->css.pipes[pipe];
 	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 	struct imgu_v4l2_subdev *imgu_sd = &imgu_pipe->imgu_sd;
-	struct v4l2_pix_format_mplane fmt_backup;
 
 	dev_dbg(dev, "set fmt node [%u][%u](try = %u)", pipe, node, try);
 
@@ -687,6 +686,7 @@ static int imgu_fmt(struct imgu_device *
 
 	dev_dbg(dev, "IPU3 pipe %u pipe_id = %u", pipe, css_pipe->pipe_id);
 
+	css_q = imgu_node_to_queue(node);
 	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
 		unsigned int inode = imgu_map_node(imgu, i);
 
@@ -701,6 +701,11 @@ static int imgu_fmt(struct imgu_device *
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
@@ -729,39 +734,32 @@ static int imgu_fmt(struct imgu_device *
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



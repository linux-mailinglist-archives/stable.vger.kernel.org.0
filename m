Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F05378910
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbhEJLZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237818AbhEJLQP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:16:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E876601FA;
        Mon, 10 May 2021 11:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645093;
        bh=LuLsmtNBOVUVcPlscaaqrxu62cTFLbKV2lTknh3M/k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQOvDVLRbc4fkwxz0PgfldH3XqEJEqMPhoLKWZ0CIkSMMq0FUZYMSWCDTWOaRd4T+
         CWmo9AmQePt6HGWf6AGTWlkQ6WQ9Y1FqrayOLXO9djcuttEnJBcm4JaulkRiNj74h6
         SnCIuIqhGtHl+6Sh9DYgd0Sbc+hTKCry6O6ze/xU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Ribalda <ribalda@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.12 350/384] media: staging/intel-ipu3: Fix set_fmt error handling
Date:   Mon, 10 May 2021 12:22:19 +0200
Message-Id: <20210510102026.299359050@linuxfoundation.org>
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

From: Ricardo Ribalda <ribalda@chromium.org>

commit ad91849996f9dd79741a961fd03585a683b08356 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/ipu3/ipu3-v4l2.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -669,6 +669,7 @@ static int imgu_fmt(struct imgu_device *
 	struct imgu_css_pipe *css_pipe = &imgu->css.pipes[pipe];
 	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 	struct imgu_v4l2_subdev *imgu_sd = &imgu_pipe->imgu_sd;
+	struct v4l2_pix_format_mplane fmt_backup;
 
 	dev_dbg(dev, "set fmt node [%u][%u](try = %u)", pipe, node, try);
 
@@ -737,6 +738,7 @@ static int imgu_fmt(struct imgu_device *
 		ret = -EINVAL;
 		goto out;
 	}
+	fmt_backup = *fmts[css_q];
 	*fmts[css_q] = f->fmt.pix_mp;
 
 	if (try)
@@ -744,6 +746,9 @@ static int imgu_fmt(struct imgu_device *
 	else
 		ret = imgu_css_fmt_set(&imgu->css, fmts, rects, pipe);
 
+	if (try || ret < 0)
+		*fmts[css_q] = fmt_backup;
+
 	/* ret is the binary number in the firmware blob */
 	if (ret < 0)
 		goto out;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB5635981D
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 10:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhDIIlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 04:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhDIIlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 04:41:52 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B0BC061761
        for <stable@vger.kernel.org>; Fri,  9 Apr 2021 01:41:39 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id g5so695073ejx.0
        for <stable@vger.kernel.org>; Fri, 09 Apr 2021 01:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=47rSkhialHM2SkOAJW3qv6IE9Jj4qc4uz5x78cVMkkI=;
        b=UpChw+vWblnIE1lRR76D+GWDGGELmj/FSXOCCx3QtalAp1qiPp9/WSUfWlcde2VhEM
         BbzMqh8sdrsX/S7MMqA4N88ZNKuqSXt3qRn3Ep3WYbEJJ3ZVtpg9U+f9UxD3ETtgy0tx
         NRPEx6lR6T/p4Gm1QWgxA6O2FV/bs4eu5FjAA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=47rSkhialHM2SkOAJW3qv6IE9Jj4qc4uz5x78cVMkkI=;
        b=p8pwMszpaTwN3paDL83dg8HpE53aOJ/XioPXLh612tCndrEbJPwFBhCzV1I3CvL9MJ
         QxM3uP4c65FqVEmLsjkK1cFfyUvIPf1HtnexdhF/Ci8ZayWth2c0tg/hDaVgQR38kKr2
         bbtqJNqrqa9D8DPI88hHGFWUg800D0SFVhCD3VP+9eNKs/tgLBBh6pt8pgd3F4/rA2vn
         cLn6IeS9QJ8b3THuB4xIjOpKMB6xsIdT1M9Y+oGEINC0xxbwjiTs9Itf8q7FIjLIZGu/
         9D0I1W24ikhwqGM0LuEL3iVKkU9s3Tatu9RNSBDH2IauS/HR0ihkK0+K90QX+mRuOaTB
         P4lw==
X-Gm-Message-State: AOAM533Fi8LtEmsVc1beW6ot83wD+rzMr1dxSVIol7RlUXdD9tPc49YW
        AkKUo+cu5Q3ZYHFL1VjPg2otNzxIu2txkvmx
X-Google-Smtp-Source: ABdhPJylEnif/EoElZIuUbdw1UtT4BapfgR1YicH6LguGq7heSEtik7LMA6t5yhUJSCidE958p6BHw==
X-Received: by 2002:a17:906:b296:: with SMTP id q22mr15004950ejz.161.1617957698361;
        Fri, 09 Apr 2021 01:41:38 -0700 (PDT)
Received: from alco.lan ([80.71.134.83])
        by smtp.gmail.com with ESMTPSA id sd21sm865758ejb.98.2021.04.09.01.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 01:41:38 -0700 (PDT)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] media: staging/intel-ipu3: Fix race condition during set_fmt
Date:   Fri,  9 Apr 2021 10:41:35 +0200
Message-Id: <20210409084135.384287-1-ribalda@chromium.org>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/staging/media/ipu3/ipu3-v4l2.c | 30 ++++++++++++--------------
 1 file changed, 14 insertions(+), 16 deletions(-)

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
-- 
2.31.1.295.g9ea45b61b8-goog


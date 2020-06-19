Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8451220111C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404673AbgFSP3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404667AbgFSP3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:29:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D682A21BE5;
        Fri, 19 Jun 2020 15:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580571;
        bh=tH3Xht3LJp4Pj+XEDbZoLHPhR/pCQ8NSKBwMakmsDvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zg5YZ+iaItUKng1WxdGtjZD5b7+Y6PRqbiWlzfJff/g7ayNYP7g7nveqpp9O2Fm8m
         3JsO/a/94CfA3nQFiO3PtrJ7KZp/UIMnW4IDzpa0mjNY4URJ7U6Pvkxu9/eGjM7nT6
         UV9V/IMmRy6zjfGvMr0Y7RJqQELX1uiaRgZphJHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Samuel Holland <samuel@sholland.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.7 300/376] media: cedrus: Program output format during each run
Date:   Fri, 19 Jun 2020 16:33:38 +0200
Message-Id: <20200619141724.541035605@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

commit a8876c22eab9a871834f85de83e98bbf7e6e264d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c   |    2 ++
 drivers/staging/media/sunxi/cedrus/cedrus_video.c |    3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
@@ -74,6 +74,8 @@ void cedrus_device_run(void *priv)
 
 	v4l2_m2m_buf_copy_metadata(run.src, run.dst, true);
 
+	cedrus_dst_format_set(dev, &ctx->dst_fmt);
+
 	dev->dec_ops[ctx->current_codec]->setup(ctx, &run);
 
 	/* Complete request(s) controls if needed. */
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -273,7 +273,6 @@ static int cedrus_s_fmt_vid_cap(struct f
 				struct v4l2_format *f)
 {
 	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
-	struct cedrus_dev *dev = ctx->dev;
 	struct vb2_queue *vq;
 	int ret;
 
@@ -287,8 +286,6 @@ static int cedrus_s_fmt_vid_cap(struct f
 
 	ctx->dst_fmt = f->fmt.pix;
 
-	cedrus_dst_format_set(dev, &ctx->dst_fmt);
-
 	return 0;
 }
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AD6201367
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403950AbgFSPNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:13:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392253AbgFSPNa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:13:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF08421941;
        Fri, 19 Jun 2020 15:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579609;
        bh=z6rKd0CO6HmS92fnceC04UuK8Oj5dVZDmCIrmHaMjkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWNyiVZIGoUy3qI9zAvS/RPt/7UPeHaz0Ro+uS/VjBJXB5RZ7xxJ30SCKB5TjM7lu
         Op75Tgwc55RZR+PvoZN+4uKPM/2EoHbOCwi8rAV3WSfWaJGLxzCuoMIbo6a4sZMijc
         iC/hWnC4NdEfn+ikLUBKlDfatVRkTs+wOP2Q/ZSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Samuel Holland <samuel@sholland.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 200/261] media: cedrus: Program output format during each run
Date:   Fri, 19 Jun 2020 16:33:31 +0200
Message-Id: <20200619141659.484135426@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
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
@@ -65,6 +65,8 @@ void cedrus_device_run(void *priv)
 
 	v4l2_m2m_buf_copy_metadata(run.src, run.dst, true);
 
+	cedrus_dst_format_set(dev, &ctx->dst_fmt);
+
 	dev->dec_ops[ctx->current_codec]->setup(ctx, &run);
 
 	/* Complete request(s) controls if needed. */
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -286,7 +286,6 @@ static int cedrus_s_fmt_vid_cap(struct f
 				struct v4l2_format *f)
 {
 	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
-	struct cedrus_dev *dev = ctx->dev;
 	struct vb2_queue *vq;
 	int ret;
 
@@ -300,8 +299,6 @@ static int cedrus_s_fmt_vid_cap(struct f
 
 	ctx->dst_fmt = f->fmt.pix;
 
-	cedrus_dst_format_set(dev, &ctx->dst_fmt);
-
 	return 0;
 }
 



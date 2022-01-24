Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C3C49955C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392610AbiAXUvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390876AbiAXUqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2828C06125A;
        Mon, 24 Jan 2022 11:56:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 524E560B43;
        Mon, 24 Jan 2022 19:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C21C340E5;
        Mon, 24 Jan 2022 19:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054185;
        bh=1WPtrGRdvx6qK4nXEUfEMqpAwDHs5yO3RQRlQrPvYxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvDMK9uVUxiPybMHcSkICHl4CkmNKsvbzp+iYQRU7gQC8EZvcexK3Gka0sJyM91W/
         dh9Xm4nlh1mGGXo5xD/34v5Wda+BPE9wZhKeAiCaaIURzq/z8csFyeZpKCpFGk4//h
         ah3gsVk+DQLPvCi2EeZXTAPfMDad2aPmsE2tszfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 306/563] media: atomisp: fix try_fmt logic
Date:   Mon, 24 Jan 2022 19:41:11 +0100
Message-Id: <20220124184035.021782371@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit c9e9094c4e42124af909b2f5f6ded0498e0854ac ]

The internal try_fmt logic is not meant to provide everything
that the V4L2 API should provide. Also, it doesn't decrement
the pads that are used only internally by the driver, but aren't
part of the device's output.

Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/atomisp/pci/atomisp_ioctl.c | 72 ++++++++++++++++++-
 1 file changed, 71 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
index 830df02626634..8a0648fd7c813 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
@@ -863,6 +863,72 @@ static int atomisp_g_fmt_file(struct file *file, void *fh,
 	return 0;
 }
 
+static int atomisp_adjust_fmt(struct v4l2_format *f)
+{
+	const struct atomisp_format_bridge *format_bridge;
+	u32 padded_width;
+
+	format_bridge = atomisp_get_format_bridge(f->fmt.pix.pixelformat);
+
+	padded_width = f->fmt.pix.width + pad_w;
+
+	if (format_bridge->planar) {
+		f->fmt.pix.bytesperline = padded_width;
+		f->fmt.pix.sizeimage = PAGE_ALIGN(f->fmt.pix.height *
+						  DIV_ROUND_UP(format_bridge->depth *
+						  padded_width, 8));
+	} else {
+		f->fmt.pix.bytesperline = DIV_ROUND_UP(format_bridge->depth *
+						      padded_width, 8);
+		f->fmt.pix.sizeimage = PAGE_ALIGN(f->fmt.pix.height * f->fmt.pix.bytesperline);
+	}
+
+	if (f->fmt.pix.field == V4L2_FIELD_ANY)
+		f->fmt.pix.field = V4L2_FIELD_NONE;
+
+	format_bridge = atomisp_get_format_bridge(f->fmt.pix.pixelformat);
+	if (!format_bridge)
+		return -EINVAL;
+
+	/* Currently, raw formats are broken!!! */
+	if (format_bridge->sh_fmt == IA_CSS_FRAME_FORMAT_RAW) {
+		f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUV420;
+
+		format_bridge = atomisp_get_format_bridge(f->fmt.pix.pixelformat);
+		if (!format_bridge)
+			return -EINVAL;
+	}
+
+	padded_width = f->fmt.pix.width + pad_w;
+
+	if (format_bridge->planar) {
+		f->fmt.pix.bytesperline = padded_width;
+		f->fmt.pix.sizeimage = PAGE_ALIGN(f->fmt.pix.height *
+						  DIV_ROUND_UP(format_bridge->depth *
+						  padded_width, 8));
+	} else {
+		f->fmt.pix.bytesperline = DIV_ROUND_UP(format_bridge->depth *
+						      padded_width, 8);
+		f->fmt.pix.sizeimage = PAGE_ALIGN(f->fmt.pix.height * f->fmt.pix.bytesperline);
+	}
+
+	if (f->fmt.pix.field == V4L2_FIELD_ANY)
+		f->fmt.pix.field = V4L2_FIELD_NONE;
+
+	/*
+	 * FIXME: do we need to setup this differently, depending on the
+	 * sensor or the pipeline?
+	 */
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
+	f->fmt.pix.ycbcr_enc = V4L2_YCBCR_ENC_709;
+	f->fmt.pix.xfer_func = V4L2_XFER_FUNC_709;
+
+	f->fmt.pix.width -= pad_w;
+	f->fmt.pix.height -= pad_h;
+
+	return 0;
+}
+
 /* This function looks up the closest available resolution. */
 static int atomisp_try_fmt_cap(struct file *file, void *fh,
 			       struct v4l2_format *f)
@@ -874,7 +940,11 @@ static int atomisp_try_fmt_cap(struct file *file, void *fh,
 	rt_mutex_lock(&isp->mutex);
 	ret = atomisp_try_fmt(vdev, f, NULL);
 	rt_mutex_unlock(&isp->mutex);
-	return ret;
+
+	if (ret)
+		return ret;
+
+	return atomisp_adjust_fmt(f);
 }
 
 static int atomisp_s_fmt_cap(struct file *file, void *fh,
-- 
2.34.1




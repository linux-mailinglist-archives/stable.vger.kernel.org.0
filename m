Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705774998E5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453679AbiAXVah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39110 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450582AbiAXVVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4276BB8121C;
        Mon, 24 Jan 2022 21:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFABC340E4;
        Mon, 24 Jan 2022 21:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059257;
        bh=7KCUkHtCZDPiU8Wu1iyvT6sSWdzlValgHc36KTlvECM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1BzH/T2KJmzQteqPHzENW8QbLX26Fq3AesNtDeFTaUxZsGv7PiN+DZk4YtvEhFG5R
         daRt6cAWycXm5NO8e0HvilS+cV4kuQa3H++OJi2G5QbnvWtcl8Pv+uziEjfj4M2+88
         BZYu9Zt/Sv6ldNkl5KQQ17FqWG+UQg1gHQXxasnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0556/1039] media: atomisp: fix try_fmt logic
Date:   Mon, 24 Jan 2022 19:39:05 +0100
Message-Id: <20220124184143.998431150@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 29826f8e4143d..54624f8814e04 100644
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
 	ret = atomisp_try_fmt(vdev, &f->fmt.pix, NULL);
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




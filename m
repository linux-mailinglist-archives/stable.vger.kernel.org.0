Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A654916E2
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240757AbiARCgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343998AbiARCeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:34:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7C9C06139F;
        Mon, 17 Jan 2022 18:32:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 532E2B8122C;
        Tue, 18 Jan 2022 02:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A41C36AEB;
        Tue, 18 Jan 2022 02:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473168;
        bh=TUnm+Toda9hJczhj3ziIH/SgtocelZAF6EwqaINvxNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQGDZxCitCvU7dIfC7P/C+wRiFgfVBzUkZJIRGGKbCW5ZdyyPOvXDE+F9BXtdnXDf
         6Mh6D4KqJyNcrqNfQVmNLTAjjmNLUTFY+YJgn3wzCRuUwNkyVcouk7fGMuszYOGBKT
         3byH8jCEMXx2lOlbtiyZPq65zMxJsCBj2UYp0h5Rmqx6WrEyF7YRrgGPteo5yWzUL8
         GOPJPQ36JN6v/nJWS0P4SiNQg8+ms+IawDKBdBerpmgpSCpgl6V9U9Ns6ipo72u0rj
         UTQhaNalmqZWabdtFkmY9aZ6qKkL5YFKs6t5nv6x34kUH3665ZcQtEm1uTrBIOhSN3
         IdQvEesGf9mHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, peterz@infradead.org,
        kitakar@gmail.com, kaixuxia@tencent.com, dan.carpenter@oracle.com,
        arnd@arndb.de, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 015/188] media: atomisp: fix try_fmt logic
Date:   Mon, 17 Jan 2022 21:28:59 -0500
Message-Id: <20220118023152.1948105-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a57e640fbf791..442446e5d59f7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
@@ -852,6 +852,72 @@ static int atomisp_g_fmt_file(struct file *file, void *fh,
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
@@ -863,7 +929,11 @@ static int atomisp_try_fmt_cap(struct file *file, void *fh,
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


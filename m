Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC0C491A88
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352539AbiARDAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346407AbiARCtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:49:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99112C061756;
        Mon, 17 Jan 2022 18:40:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BA7FB81260;
        Tue, 18 Jan 2022 02:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00E0C36AEB;
        Tue, 18 Jan 2022 02:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473635;
        bh=wIvNlmpifgpujICak+JLTgxCU2meCQ2EhSf6G7TR9lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWjVO4Q0aEOR3DZ5ZsNOSEX5jmeoxG5A2xLcxm6I5IeeZrZ8Q+wc7MtcJi1mvEM3G
         xgtKpGtra/4fhZRPrw/g4A4Q9YjuTxvXE+PTTfPVxTpcCCAezqFU8N7Knq/G5ghcF7
         E5+Mr+CCsWJuC3N/r/9YgVYdUv9b1wFqP+PyXOd4D5lvMdCSB17gdoNmU2r7piRqik
         w27Oahgih+lkgDDKlwZbPbtKATeGOGALQnlGd2aDKdNCnHEQUleUOuZ0Gz789VRzdw
         fm0wh4wCdovHs6Ml6kfmrSQpmrFIf2xHsyxrdMd9VPx9zeb8PAqfYUrN3wa9iYN/vL
         T+5bzYs/kZIiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, kitakar@gmail.com,
        peterz@infradead.org, dan.carpenter@oracle.com, mingo@kernel.org,
        kaixuxia@tencent.com, arnd@arndb.de, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 009/116] media: atomisp: fix try_fmt logic
Date:   Mon, 17 Jan 2022 21:38:20 -0500
Message-Id: <20220118024007.1950576-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 9da82855552de..973012c6153e5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
@@ -834,6 +834,72 @@ static int atomisp_g_fmt_file(struct file *file, void *fh,
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
@@ -845,7 +911,11 @@ static int atomisp_try_fmt_cap(struct file *file, void *fh,
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


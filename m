Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C343E14B959
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgA1Oan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:30:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbgA1O2o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:28:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EF5920716;
        Tue, 28 Jan 2020 14:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221723;
        bh=+LihbHEmFvppMG2thshxBk924j40l+ZVzVgfiqYyC9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtjVczvkSivH0Fb3swj4ureXjWkI6FaNM9lNkkZLmSEkfb2j5FqUxtGxkfyRgw0hg
         gCozJglZQ+rMzRuYr+NEr8i+EfHa13jLTlRNu2cyt7+UEGZXMO3jMfK3GaH2XNRF5x
         KCZS1l05axlfgYMTAF8iBvXkRXNYehqAI6TslY5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4.19 64/92] media: v4l2-ioctl.c: zero reserved fields for S/TRY_FMT
Date:   Tue, 28 Jan 2020 15:08:32 +0100
Message-Id: <20200128135817.488107509@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit ee8951e56c0f960b9621636603a822811cef3158 upstream.

v4l2_vbi_format, v4l2_sliced_vbi_format and v4l2_sdr_format
have a reserved array at the end that should be zeroed by drivers
as per the V4L2 spec. Older drivers often do not do this, so just
handle this in the core.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/v4l2-core/v4l2-ioctl.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1548,12 +1548,12 @@ static int v4l_s_fmt(const struct v4l2_i
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
 		if (unlikely(!ops->vidioc_s_fmt_vbi_cap))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.vbi);
+		CLEAR_AFTER_FIELD(p, fmt.vbi.flags);
 		return ops->vidioc_s_fmt_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
 		if (unlikely(!ops->vidioc_s_fmt_sliced_vbi_cap))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.sliced);
+		CLEAR_AFTER_FIELD(p, fmt.sliced.io_size);
 		return ops->vidioc_s_fmt_sliced_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		if (unlikely(!ops->vidioc_s_fmt_vid_out))
@@ -1576,22 +1576,22 @@ static int v4l_s_fmt(const struct v4l2_i
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
 		if (unlikely(!ops->vidioc_s_fmt_vbi_out))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.vbi);
+		CLEAR_AFTER_FIELD(p, fmt.vbi.flags);
 		return ops->vidioc_s_fmt_vbi_out(file, fh, arg);
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
 		if (unlikely(!ops->vidioc_s_fmt_sliced_vbi_out))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.sliced);
+		CLEAR_AFTER_FIELD(p, fmt.sliced.io_size);
 		return ops->vidioc_s_fmt_sliced_vbi_out(file, fh, arg);
 	case V4L2_BUF_TYPE_SDR_CAPTURE:
 		if (unlikely(!ops->vidioc_s_fmt_sdr_cap))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.sdr);
+		CLEAR_AFTER_FIELD(p, fmt.sdr.buffersize);
 		return ops->vidioc_s_fmt_sdr_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
 		if (unlikely(!ops->vidioc_s_fmt_sdr_out))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.sdr);
+		CLEAR_AFTER_FIELD(p, fmt.sdr.buffersize);
 		return ops->vidioc_s_fmt_sdr_out(file, fh, arg);
 	case V4L2_BUF_TYPE_META_CAPTURE:
 		if (unlikely(!ops->vidioc_s_fmt_meta_cap))
@@ -1635,12 +1635,12 @@ static int v4l_try_fmt(const struct v4l2
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
 		if (unlikely(!ops->vidioc_try_fmt_vbi_cap))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.vbi);
+		CLEAR_AFTER_FIELD(p, fmt.vbi.flags);
 		return ops->vidioc_try_fmt_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
 		if (unlikely(!ops->vidioc_try_fmt_sliced_vbi_cap))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.sliced);
+		CLEAR_AFTER_FIELD(p, fmt.sliced.io_size);
 		return ops->vidioc_try_fmt_sliced_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		if (unlikely(!ops->vidioc_try_fmt_vid_out))
@@ -1663,22 +1663,22 @@ static int v4l_try_fmt(const struct v4l2
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
 		if (unlikely(!ops->vidioc_try_fmt_vbi_out))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.vbi);
+		CLEAR_AFTER_FIELD(p, fmt.vbi.flags);
 		return ops->vidioc_try_fmt_vbi_out(file, fh, arg);
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
 		if (unlikely(!ops->vidioc_try_fmt_sliced_vbi_out))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.sliced);
+		CLEAR_AFTER_FIELD(p, fmt.sliced.io_size);
 		return ops->vidioc_try_fmt_sliced_vbi_out(file, fh, arg);
 	case V4L2_BUF_TYPE_SDR_CAPTURE:
 		if (unlikely(!ops->vidioc_try_fmt_sdr_cap))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.sdr);
+		CLEAR_AFTER_FIELD(p, fmt.sdr.buffersize);
 		return ops->vidioc_try_fmt_sdr_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
 		if (unlikely(!ops->vidioc_try_fmt_sdr_out))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.sdr);
+		CLEAR_AFTER_FIELD(p, fmt.sdr.buffersize);
 		return ops->vidioc_try_fmt_sdr_out(file, fh, arg);
 	case V4L2_BUF_TYPE_META_CAPTURE:
 		if (unlikely(!ops->vidioc_try_fmt_meta_cap))



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8B0214B68E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgA1OFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:05:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728217AbgA1OFK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:05:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55697205F4;
        Tue, 28 Jan 2020 14:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220309;
        bh=TCCNqM2VIhC7R7bn1YC2MWDp0InUfQB7ctD2f7u4L18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0y6nu68zG0tIKobBk3gAkuWQWVeWA4w6kkQJ2XOzOLd1uXp5TmpDRugRaHUp6w9sz
         6vfHds559mTCXpO6FCwDd7xrzuEmP9zOfRZJIHtzX/TDzUv2/jiJLWvWBhVgcx7P26
         rBAb9vmBkt7qrkCFNf/V1RZ0mRJ8hki+3Whi4hY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.4 100/104] media: v4l2-ioctl.c: zero reserved fields for S/TRY_FMT
Date:   Tue, 28 Jan 2020 15:01:01 +0100
Message-Id: <20200128135830.732323946@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
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
@@ -1605,12 +1605,12 @@ static int v4l_s_fmt(const struct v4l2_i
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
@@ -1636,22 +1636,22 @@ static int v4l_s_fmt(const struct v4l2_i
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
@@ -1707,12 +1707,12 @@ static int v4l_try_fmt(const struct v4l2
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
@@ -1738,22 +1738,22 @@ static int v4l_try_fmt(const struct v4l2
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



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29ED114B5C5
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgA1N7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 08:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgA1N7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 08:59:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AC4B2173E;
        Tue, 28 Jan 2020 13:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580219987;
        bh=VuZpuW+dKu4x+uDn4XeU2iKAEIXGuHGdpf8++Js0hxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0Vvm/Pg1scABhCjeX+iAzySzTSZ/d0WcE/rMcA7h28PooXhf5GZIEgWPCA1SKL+h
         BF0sYX3/FrdYeCD+8uU2GAZB6Hs++1ewj+oQx+/QvVC9YU9x3fpcQzf1SI2SeYp6A2
         a9rmhnUSUEwICjrxcQJ++K5XuATFrpGy8fTrAMfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4.14 41/46] media: v4l2-ioctl.c: zero reserved fields for S/TRY_FMT
Date:   Tue, 28 Jan 2020 14:58:15 +0100
Message-Id: <20200128135755.133620718@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135749.822297911@linuxfoundation.org>
References: <20200128135749.822297911@linuxfoundation.org>
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
@@ -1496,12 +1496,12 @@ static int v4l_s_fmt(const struct v4l2_i
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
@@ -1524,22 +1524,22 @@ static int v4l_s_fmt(const struct v4l2_i
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
@@ -1583,12 +1583,12 @@ static int v4l_try_fmt(const struct v4l2
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
@@ -1611,22 +1611,22 @@ static int v4l_try_fmt(const struct v4l2
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



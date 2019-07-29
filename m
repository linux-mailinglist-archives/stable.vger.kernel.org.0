Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 293B979718
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390697AbfG2TyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390967AbfG2TyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:54:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85BB42054F;
        Mon, 29 Jul 2019 19:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430044;
        bh=uUTjCQoqKEAfufn+gvf1uDv6vHmTzHAe+UG4J0N2pI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9EiD+MFUSlSh95gjN77WG9wTZDVo9tNj7o/ucV/uF+7dc9+BYrLd0ii5hykP9IRM
         NsY1AWpPlo9/cStiH5un9igywwGe/iRtxbQ8ukoOUUMFPXCQrT+h0kCG86n0LRyxyM
         6yOKKpXuGpR5MFyh+piEDKa6zszYj0jJP/DVUBSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.2 178/215] media: videodev2.h: change V4L2_PIX_FMT_BGRA444 define: fourcc was already in use
Date:   Mon, 29 Jul 2019 21:22:54 +0200
Message-Id: <20190729190810.865490616@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

commit 22be8233b34f4f468934c5fefcbe6151766fb8f2 upstream.

The V4L2_PIX_FMT_BGRA444 define clashed with the pre-existing V4L2_PIX_FMT_SGRBG12
which strangely enough used the same fourcc, even though that fourcc made no sense
for a Bayer format. In any case, you can't have duplicates, so change the fourcc of
V4L2_PIX_FMT_BGRA444.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v5.2 and up
Fixes: 6c84f9b1d2900 ("media: v4l: Add definitions for missing 16-bit RGB4444 formats")
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 9d9705ceda76..2427bc4d8eba 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -518,7 +518,13 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_RGBX444 v4l2_fourcc('R', 'X', '1', '2') /* 16  rrrrgggg bbbbxxxx */
 #define V4L2_PIX_FMT_ABGR444 v4l2_fourcc('A', 'B', '1', '2') /* 16  aaaabbbb ggggrrrr */
 #define V4L2_PIX_FMT_XBGR444 v4l2_fourcc('X', 'B', '1', '2') /* 16  xxxxbbbb ggggrrrr */
-#define V4L2_PIX_FMT_BGRA444 v4l2_fourcc('B', 'A', '1', '2') /* 16  bbbbgggg rrrraaaa */
+
+/*
+ * Originally this had 'BA12' as fourcc, but this clashed with the older
+ * V4L2_PIX_FMT_SGRBG12 which inexplicably used that same fourcc.
+ * So use 'GA12' instead for V4L2_PIX_FMT_BGRA444.
+ */
+#define V4L2_PIX_FMT_BGRA444 v4l2_fourcc('G', 'A', '1', '2') /* 16  bbbbgggg rrrraaaa */
 #define V4L2_PIX_FMT_BGRX444 v4l2_fourcc('B', 'X', '1', '2') /* 16  bbbbgggg rrrrxxxx */
 #define V4L2_PIX_FMT_RGB555  v4l2_fourcc('R', 'G', 'B', 'O') /* 16  RGB-5-5-5     */
 #define V4L2_PIX_FMT_ARGB555 v4l2_fourcc('A', 'R', '1', '5') /* 16  ARGB-1-5-5-5  */



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65EAA65786
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 15:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbfGKNBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 09:01:34 -0400
Received: from www.linuxtv.org ([130.149.80.248]:60602 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728490AbfGKNBd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 09:01:33 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1hlYhX-0008Bg-3J; Thu, 11 Jul 2019 13:01:31 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Thu, 11 Jul 2019 13:00:38 +0000
Subject: [git:media_tree/master] media: videodev2.h: change V4L2_PIX_FMT_BGRA444 define: fourcc was already in use
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1hlYhX-0008Bg-3J@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: videodev2.h: change V4L2_PIX_FMT_BGRA444 define: fourcc was already in use
Author:  Hans Verkuil <hverkuil@xs4all.nl>
Date:    Thu Jul 11 04:53:25 2019 -0400

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

 include/uapi/linux/videodev2.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

---

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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAE515C124
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgBMPOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:14:23 -0500
Received: from www.linuxtv.org ([130.149.80.248]:36252 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgBMPOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:14:23 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1j2G08-00DQrH-Tq; Thu, 13 Feb 2020 15:02:00 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Wed, 08 Jan 2020 13:34:14 +0000
Subject: [git:media_tree/fixes] media: v4l2-rect.h: fix v4l2_rect_map_inside() top/left adjustments
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Helen Koike <helen.koike@collabora.com>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1j2G08-00DQrH-Tq@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: v4l2-rect.h: fix v4l2_rect_map_inside() top/left adjustments
Author:  Helen Koike <helen.koike@collabora.com>
Date:    Tue Dec 17 21:00:22 2019 +0100

boundary->width and boundary->height are sizes relative to
boundary->left and boundary->top coordinates, but they were not being
taken into consideration to adjust r->left and r->top, leading to the
following error:

Consider the follow as initial values for boundary and r:

struct v4l2_rect boundary = {
	.left = 100,
	.top = 100,
	.width = 800,
	.height = 600,
}

struct v4l2_rect r = {
	.left = 0,
	.top = 0,
	.width = 1920,
	.height = 960,
}

calling v4l2_rect_map_inside(&r, &boundary) was modifying r to:

r = {
	.left = 0,
	.top = 0,
	.width = 800,
	.height = 600,
}

Which is wrongly outside the boundary rectangle, because:

	v4l2_rect_set_max_size(r, boundary); // r->width = 800, r->height = 600
	...
	if (r->left + r->width > boundary->width) // true
		r->left = boundary->width - r->width; // r->left = 800 - 800
	if (r->top + r->height > boundary->height) // true
		r->top = boundary->height - r->height; // r->height = 600 - 600

Fix this by considering top/left coordinates from boundary.

Fixes: ac49de8c49d7 ("[media] v4l2-rect.h: new header with struct v4l2_rect helper functions")
Signed-off-by: Helen Koike <helen.koike@collabora.com>
Cc: <stable@vger.kernel.org>      # for v4.7 and up
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 include/media/v4l2-rect.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

---

diff --git a/include/media/v4l2-rect.h b/include/media/v4l2-rect.h
index c86474dc7b55..8800a640c224 100644
--- a/include/media/v4l2-rect.h
+++ b/include/media/v4l2-rect.h
@@ -63,10 +63,10 @@ static inline void v4l2_rect_map_inside(struct v4l2_rect *r,
 		r->left = boundary->left;
 	if (r->top < boundary->top)
 		r->top = boundary->top;
-	if (r->left + r->width > boundary->width)
-		r->left = boundary->width - r->width;
-	if (r->top + r->height > boundary->height)
-		r->top = boundary->height - r->height;
+	if (r->left + r->width > boundary->left + boundary->width)
+		r->left = boundary->left + boundary->width - r->width;
+	if (r->top + r->height > boundary->top + boundary->height)
+		r->top = boundary->top + boundary->height - r->height;
 }
 
 /**

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A5830A3FB
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 10:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhBAJFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 04:05:44 -0500
Received: from www.linuxtv.org ([130.149.80.248]:41134 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232690AbhBAJFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 04:05:40 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1l6V8C-005hi1-4M; Mon, 01 Feb 2021 09:04:24 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 12 Jan 2021 14:49:12 +0000
Subject: [git:media_tree/master] media: Revert "media: videobuf2: Fix length check for single plane dmabuf queueing"
To:     linuxtv-commits@linuxtv.org
Cc:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Naushir Patuck <naush@raspberrypi.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1l6V8C-005hi1-4M@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: Revert "media: videobuf2: Fix length check for single plane dmabuf queueing"
Author:  Naushir Patuck <naush@raspberrypi.com>
Date:    Wed Jan 6 16:16:57 2021 +0100

The updated length check for dmabuf types broke existing usage in v4l2
userland clients.

Fixes: 961d3b27 ("media: videobuf2: Fix length check for single plane dmabuf queueing")
Cc: stable@vger.kernel.org
Signed-off-by: Naushir Patuck <naush@raspberrypi.com>
Tested-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/common/videobuf2/videobuf2-v4l2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

---

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 96d3b2b2aa31..3f61f5863bf7 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -118,8 +118,7 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 				return -EINVAL;
 		}
 	} else {
-		length = (b->memory == VB2_MEMORY_USERPTR ||
-			  b->memory == VB2_MEMORY_DMABUF)
+		length = (b->memory == VB2_MEMORY_USERPTR)
 			? b->length : vb->planes[0].length;
 
 		if (b->bytesused > length)

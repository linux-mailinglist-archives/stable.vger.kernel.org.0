Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E52BBA9E50
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 11:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731550AbfIEJ1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 05:27:23 -0400
Received: from www.linuxtv.org ([130.149.80.248]:43443 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730633AbfIEJ1X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 05:27:23 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1i5o2z-0006wU-Lu; Thu, 05 Sep 2019 09:27:21 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Thu, 05 Sep 2019 09:26:57 +0000
Subject: [git:media_tree/master] media: videobuf-core.c: poll_wait needs a non-NULL buf pointer
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1i5o2z-0006wU-Lu@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: videobuf-core.c: poll_wait needs a non-NULL buf pointer
Author:  Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:    Wed Sep 4 06:04:07 2019 -0300

poll_wait uses &buf->done, but buf is NULL. Move the poll_wait to later
in the function once buf is correctly set and only call it if it is
non-NULL.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: bb436cbeb918 ("media: videobuf: fix epoll() by calling poll_wait first")
Cc: <stable@vger.kernel.org>      # for v5.1 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/media/v4l2-core/videobuf-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

---

diff --git a/drivers/media/v4l2-core/videobuf-core.c b/drivers/media/v4l2-core/videobuf-core.c
index 7ef3e4d22bf6..939fc11cf080 100644
--- a/drivers/media/v4l2-core/videobuf-core.c
+++ b/drivers/media/v4l2-core/videobuf-core.c
@@ -1123,7 +1123,6 @@ __poll_t videobuf_poll_stream(struct file *file,
 	struct videobuf_buffer *buf = NULL;
 	__poll_t rc = 0;
 
-	poll_wait(file, &buf->done, wait);
 	videobuf_queue_lock(q);
 	if (q->streaming) {
 		if (!list_empty(&q->stream))
@@ -1143,7 +1142,9 @@ __poll_t videobuf_poll_stream(struct file *file,
 		}
 		buf = q->read_buf;
 	}
-	if (!buf)
+	if (buf)
+		poll_wait(file, &buf->done, wait);
+	else
 		rc = EPOLLERR;
 
 	if (0 == rc) {

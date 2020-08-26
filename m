Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA13D2601EC
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbgIGROu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 13:14:50 -0400
Received: from www.linuxtv.org ([130.149.80.248]:50420 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729719AbgIGOOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 10:14:50 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1kFHoP-000IlX-Gw; Mon, 07 Sep 2020 14:08:01 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Wed, 26 Aug 2020 14:29:36 +0000
Subject: [git:media_tree/master] media: media/v4l2-core: Fix kernel-infoleak in video_put_user()
To:     linuxtv-commits@linuxtv.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        stable@vger.kernel.org,
        syzbot+79d751604cb6f29fbf59@syzkaller.appspotmail.com,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1kFHoP-000IlX-Gw@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: media/v4l2-core: Fix kernel-infoleak in video_put_user()
Author:  Peilin Ye <yepeilin.cs@gmail.com>
Date:    Mon Jul 27 10:00:02 2020 +0200

video_put_user() is copying uninitialized stack memory to userspace due
to the compiler not initializing holes in the structures declared on the
stack. Fix it by initializing `ev32` and `vb32` using memset().

Reported-and-tested-by: syzbot+79d751604cb6f29fbf59@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=79d751604cb6f29fbf59

Cc: stable@vger.kernel.org
Fixes: 1a6c0b36dd19 ("media: v4l2-core: fix VIDIOC_DQEVENT for time64 ABI")
Fixes: 577c89b0ce72 ("media: v4l2-core: fix v4l2_buffer handling for time64 ABI")
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/v4l2-core/v4l2-ioctl.c | 50 +++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 23 deletions(-)

---

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index a556880f225a..e3a25ea913ac 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -3189,14 +3189,16 @@ static int video_put_user(void __user *arg, void *parg, unsigned int cmd)
 #ifdef CONFIG_COMPAT_32BIT_TIME
 	case VIDIOC_DQEVENT_TIME32: {
 		struct v4l2_event *ev = parg;
-		struct v4l2_event_time32 ev32 = {
-			.type		= ev->type,
-			.pending	= ev->pending,
-			.sequence	= ev->sequence,
-			.timestamp.tv_sec  = ev->timestamp.tv_sec,
-			.timestamp.tv_nsec = ev->timestamp.tv_nsec,
-			.id		= ev->id,
-		};
+		struct v4l2_event_time32 ev32;
+
+		memset(&ev32, 0, sizeof(ev32));
+
+		ev32.type	= ev->type;
+		ev32.pending	= ev->pending;
+		ev32.sequence	= ev->sequence;
+		ev32.timestamp.tv_sec	= ev->timestamp.tv_sec;
+		ev32.timestamp.tv_nsec	= ev->timestamp.tv_nsec;
+		ev32.id		= ev->id;
 
 		memcpy(&ev32.u, &ev->u, sizeof(ev->u));
 		memcpy(&ev32.reserved, &ev->reserved, sizeof(ev->reserved));
@@ -3210,21 +3212,23 @@ static int video_put_user(void __user *arg, void *parg, unsigned int cmd)
 	case VIDIOC_DQBUF_TIME32:
 	case VIDIOC_PREPARE_BUF_TIME32: {
 		struct v4l2_buffer *vb = parg;
-		struct v4l2_buffer_time32 vb32 = {
-			.index		= vb->index,
-			.type		= vb->type,
-			.bytesused	= vb->bytesused,
-			.flags		= vb->flags,
-			.field		= vb->field,
-			.timestamp.tv_sec	= vb->timestamp.tv_sec,
-			.timestamp.tv_usec	= vb->timestamp.tv_usec,
-			.timecode	= vb->timecode,
-			.sequence	= vb->sequence,
-			.memory		= vb->memory,
-			.m.userptr	= vb->m.userptr,
-			.length		= vb->length,
-			.request_fd	= vb->request_fd,
-		};
+		struct v4l2_buffer_time32 vb32;
+
+		memset(&vb32, 0, sizeof(vb32));
+
+		vb32.index	= vb->index;
+		vb32.type	= vb->type;
+		vb32.bytesused	= vb->bytesused;
+		vb32.flags	= vb->flags;
+		vb32.field	= vb->field;
+		vb32.timestamp.tv_sec	= vb->timestamp.tv_sec;
+		vb32.timestamp.tv_usec	= vb->timestamp.tv_usec;
+		vb32.timecode	= vb->timecode;
+		vb32.sequence	= vb->sequence;
+		vb32.memory	= vb->memory;
+		vb32.m.userptr	= vb->m.userptr;
+		vb32.length	= vb->length;
+		vb32.request_fd	= vb->request_fd;
 
 		if (copy_to_user(arg, &vb32, sizeof(vb32)))
 			return -EFAULT;

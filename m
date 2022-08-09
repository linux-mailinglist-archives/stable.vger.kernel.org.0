Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82BE858DDEA
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344351AbiHISHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344759AbiHISHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:07:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F4326124;
        Tue,  9 Aug 2022 11:03:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F53C61072;
        Tue,  9 Aug 2022 18:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2EDC433B5;
        Tue,  9 Aug 2022 18:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068187;
        bh=nI9JPa5iH8NkzmrboqJwuGN+X0z3Ve0gacmQwPzJKYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oI4RpRROeKm9JONgwueMr6Bf+AV7YwvCJNHJl8w9yXhU2ugS+duDGxTv72JGLJ3Z6
         WKnluxUsX7cF5q2JnTeYlM8T6kt5qNGWlvX4Pk6LycID4SaZFo2XaKEL5cs1bsWliV
         T0egBS8BrQGIT46M5+lg3ERRsxXrnMBgEy3rX82Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 12/15] media: v4l2-mem2mem: Apply DST_QUEUE_OFF_BASE on MMAP buffers across ioctls
Date:   Tue,  9 Aug 2022 20:00:30 +0200
Message-Id: <20220809175510.725441808@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175510.312431319@linuxfoundation.org>
References: <20220809175510.312431319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

commit 8310ca94075e784bbb06593cd6c068ee6b6e4ca6 upstream.

DST_QUEUE_OFF_BASE is applied to offset/mem_offset on MMAP capture buffers
only for the VIDIOC_QUERYBUF ioctl, while the userspace fields (including
offset/mem_offset) are filled in for VIDIOC_{QUERY,PREPARE,Q,DQ}BUF
ioctls. This leads to differences in the values presented to userspace.
If userspace attempts to mmap the capture buffer directly using values
from DQBUF, it will fail.

Move the code that applies the magic offset into a helper, and call
that helper from all four ioctl entry points.

[hverkuil: drop unnecessary '= 0' in v4l2_m2m_querybuf() for ret]

Fixes: 7f98639def42 ("V4L/DVB: add memory-to-memory device helper framework for videobuf")
Fixes: 908a0d7c588e ("[media] v4l: mem2mem: port to videobuf2")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
[OP: backport to 5.4: adjusted return logic in v4l2_m2m_qbuf() to match the
logic in the original commit: call v4l2_m2m_adjust_mem_offset() only if !ret
and before the v4l2_m2m_try_schedule() call]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c |   60 +++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 14 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -460,19 +460,14 @@ int v4l2_m2m_reqbufs(struct file *file,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_reqbufs);
 
-int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
-		      struct v4l2_buffer *buf)
+static void v4l2_m2m_adjust_mem_offset(struct vb2_queue *vq,
+				       struct v4l2_buffer *buf)
 {
-	struct vb2_queue *vq;
-	int ret = 0;
-	unsigned int i;
-
-	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	ret = vb2_querybuf(vq, buf);
-
 	/* Adjust MMAP memory offsets for the CAPTURE queue */
 	if (buf->memory == V4L2_MEMORY_MMAP && !V4L2_TYPE_IS_OUTPUT(vq->type)) {
 		if (V4L2_TYPE_IS_MULTIPLANAR(vq->type)) {
+			unsigned int i;
+
 			for (i = 0; i < buf->length; ++i)
 				buf->m.planes[i].m.mem_offset
 					+= DST_QUEUE_OFF_BASE;
@@ -480,8 +475,23 @@ int v4l2_m2m_querybuf(struct file *file,
 			buf->m.offset += DST_QUEUE_OFF_BASE;
 		}
 	}
+}
+
+int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		      struct v4l2_buffer *buf)
+{
+	struct vb2_queue *vq;
+	int ret;
 
-	return ret;
+	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
+	ret = vb2_querybuf(vq, buf);
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_querybuf);
 
@@ -500,10 +510,16 @@ int v4l2_m2m_qbuf(struct file *file, str
 		return -EPERM;
 	}
 	ret = vb2_qbuf(vq, vdev->v4l2_dev->mdev, buf);
-	if (!ret && !(buf->flags & V4L2_BUF_FLAG_IN_REQUEST))
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	if (!(buf->flags & V4L2_BUF_FLAG_IN_REQUEST))
 		v4l2_m2m_try_schedule(m2m_ctx);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_qbuf);
 
@@ -511,9 +527,17 @@ int v4l2_m2m_dqbuf(struct file *file, st
 		   struct v4l2_buffer *buf)
 {
 	struct vb2_queue *vq;
+	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	return vb2_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+	ret = vb2_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
 
@@ -522,9 +546,17 @@ int v4l2_m2m_prepare_buf(struct file *fi
 {
 	struct video_device *vdev = video_devdata(file);
 	struct vb2_queue *vq;
+	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	return vb2_prepare_buf(vq, vdev->v4l2_dev->mdev, buf);
+	ret = vb2_prepare_buf(vq, vdev->v4l2_dev->mdev, buf);
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_prepare_buf);
 



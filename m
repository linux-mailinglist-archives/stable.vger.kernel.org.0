Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1453EB840
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241265AbhHMPMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241098AbhHMPL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:11:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E6D660E9B;
        Fri, 13 Aug 2021 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867462;
        bh=B9xhWPdX0M6M79odqt8H1U03a/8ABDTVm5YQ83pN8OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEnqymwD6iOFVHah1gc4UXij7lIInNVZbD8It8+ov5BNd0153X9eU0+A1rtuiv34J
         dwpeGXaBVFwJu40GDl6umGRMjE8kLQb5hTwbROuBFYTMO4t/2e1wz7V4OiwRMsKw4z
         HwPJf0LB7M6Ap1DaoSA1J2M71HYOAvYYKFRIo/Ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/42] media: videobuf2-core: dequeue if start_streaming fails
Date:   Fri, 13 Aug 2021 17:06:32 +0200
Message-Id: <20210813150525.322171768@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
References: <20210813150525.098817398@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit c592b46907adbeb81243f7eb7a468c36692658b8 ]

If a vb2_queue sets q->min_buffers_needed then when the number of
queued buffers reaches q->min_buffers_needed, vb2_core_qbuf() will call
the start_streaming() callback. If start_streaming() returns an error,
then that error was just returned by vb2_core_qbuf(), but the buffer
was still queued. However, userspace expects that if VIDIOC_QBUF fails,
the buffer is returned dequeued.

So if start_streaming() fails, then remove the buffer from the queue,
thus avoiding this unwanted side-effect.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Fixes: b3379c6201bb ("[media] vb2: only call start_streaming if sufficient buffers are queued")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/videobuf2-core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index f1725da2a90d..5cd496e5010c 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1371,6 +1371,7 @@ static int vb2_start_streaming(struct vb2_queue *q)
 int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 {
 	struct vb2_buffer *vb;
+	enum vb2_buffer_state orig_state;
 	int ret;
 
 	if (q->error) {
@@ -1400,6 +1401,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	 * Add to the queued buffers list, a buffer will stay on it until
 	 * dequeued in dqbuf.
 	 */
+	orig_state = vb->state;
 	list_add_tail(&vb->queued_entry, &q->queued_list);
 	q->queued_count++;
 	q->waiting_for_buffers = false;
@@ -1430,8 +1432,17 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	if (q->streaming && !q->start_streaming_called &&
 	    q->queued_count >= q->min_buffers_needed) {
 		ret = vb2_start_streaming(q);
-		if (ret)
+		if (ret) {
+			/*
+			 * Since vb2_core_qbuf will return with an error,
+			 * we should return it to state DEQUEUED since
+			 * the error indicates that the buffer wasn't queued.
+			 */
+			list_del(&vb->queued_entry);
+			q->queued_count--;
+			vb->state = orig_state;
 			return ret;
+		}
 	}
 
 	dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
-- 
2.30.2




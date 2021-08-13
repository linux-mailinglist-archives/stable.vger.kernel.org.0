Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770FD3EB807
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241348AbhHMPKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241491AbhHMPKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:10:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F075A6109D;
        Fri, 13 Aug 2021 15:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867388;
        bh=dbdpBBFRRzf13jbm/8FS7yEMCQC+VVBhsWAdwznpnhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCLcvMRg+2NycGmVgOLSx3nar0pM7zmqV/Vhdss7TXeusfxCs5lvDdqtzQNmNz1gh
         nS8jje50TsSJCwbTe30pkuENPxZxhVW1g1EfD2QsKDlFZqZ2P0yQJ2BG3u0Z2k93QT
         T7jbc/SkQ0bO8oVDO5KpI8MJmwk/JvRRXlMZmAsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 03/30] media: videobuf2-core: dequeue if start_streaming fails
Date:   Fri, 13 Aug 2021 17:06:31 +0200
Message-Id: <20210813150522.556786043@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.445553924@linuxfoundation.org>
References: <20210813150522.445553924@linuxfoundation.org>
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
index b1a4d4e2341b..3ac9f7260e72 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1370,6 +1370,7 @@ static int vb2_start_streaming(struct vb2_queue *q)
 int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 {
 	struct vb2_buffer *vb;
+	enum vb2_buffer_state orig_state;
 	int ret;
 
 	if (q->error) {
@@ -1399,6 +1400,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	 * Add to the queued buffers list, a buffer will stay on it until
 	 * dequeued in dqbuf.
 	 */
+	orig_state = vb->state;
 	list_add_tail(&vb->queued_entry, &q->queued_list);
 	q->queued_count++;
 	q->waiting_for_buffers = false;
@@ -1429,8 +1431,17 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
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
 
 	dprintk(1, "qbuf of buffer %d succeeded\n", vb->index);
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 225BB2F423
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbfE3Efc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:35:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727909AbfE3DNK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:10 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACF3A2454D;
        Thu, 30 May 2019 03:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185989;
        bh=FG0jL5+rD8oinBF3d0IvCIWcpVZPSVgTH/kRbxm0j+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2qXG02KsBNADXHVvvCDCzI+RDoBWzRGmeNMPVkBRBlExyaJsG4Z3yJPettgsMvWCO
         /8gL8sH7j11kD7NMTAhlZwZBQKYq529csdxJPhkj5nAns6/LRysbmWKy4EMAjDMb/F
         bgJSJqutLt1xDgrpt1knHYgy81cveAekHdMjWhI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Syzbot <syzbot+4180ff9ca6810b06c1e9@syzkaller.appspotmail.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.0 033/346] media: vb2: add waiting_in_dqbuf flag
Date:   Wed, 29 May 2019 20:01:46 -0700
Message-Id: <20190530030542.483709505@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

commit d65842f7126aa1a87fb44b7c9980c12630ed4f33 upstream.

Calling VIDIOC_DQBUF can release the core serialization lock pointed to
by vb2_queue->lock if it has to wait for a new buffer to arrive.

However, if userspace dup()ped the video device filehandle, then it is
possible to read or call DQBUF from two filehandles at the same time.

It is also possible to call REQBUFS from one filehandle while the other
is waiting for a buffer. This will remove all the buffers and reallocate
new ones. Removing all the buffers isn't the problem here (that's already
handled correctly by DQBUF), but the reallocating part is: DQBUF isn't
aware that the buffers have changed.

This is fixed by setting a flag whenever the lock is released while waiting
for a buffer to arrive. And checking the flag where needed so we can return
-EBUSY.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Reported-by: Syzbot <syzbot+4180ff9ca6810b06c1e9@syzkaller.appspotmail.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/common/videobuf2/videobuf2-core.c |   22 ++++++++++++++++++++++
 include/media/videobuf2-core.h                  |    1 +
 2 files changed, 23 insertions(+)

--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -672,6 +672,11 @@ int vb2_core_reqbufs(struct vb2_queue *q
 		return -EBUSY;
 	}
 
+	if (q->waiting_in_dqbuf && *count) {
+		dprintk(1, "another dup()ped fd is waiting for a buffer\n");
+		return -EBUSY;
+	}
+
 	if (*count == 0 || q->num_buffers != 0 ||
 	    (q->memory != VB2_MEMORY_UNKNOWN && q->memory != memory)) {
 		/*
@@ -807,6 +812,10 @@ int vb2_core_create_bufs(struct vb2_queu
 	}
 
 	if (!q->num_buffers) {
+		if (q->waiting_in_dqbuf && *count) {
+			dprintk(1, "another dup()ped fd is waiting for a buffer\n");
+			return -EBUSY;
+		}
 		memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
 		q->memory = memory;
 		q->waiting_for_buffers = !q->is_output;
@@ -1638,6 +1647,11 @@ static int __vb2_wait_for_done_vb(struct
 	for (;;) {
 		int ret;
 
+		if (q->waiting_in_dqbuf) {
+			dprintk(1, "another dup()ped fd is waiting for a buffer\n");
+			return -EBUSY;
+		}
+
 		if (!q->streaming) {
 			dprintk(1, "streaming off, will not wait for buffers\n");
 			return -EINVAL;
@@ -1665,6 +1679,7 @@ static int __vb2_wait_for_done_vb(struct
 			return -EAGAIN;
 		}
 
+		q->waiting_in_dqbuf = 1;
 		/*
 		 * We are streaming and blocking, wait for another buffer to
 		 * become ready or for streamoff. Driver's lock is released to
@@ -1685,6 +1700,7 @@ static int __vb2_wait_for_done_vb(struct
 		 * the locks or return an error if one occurred.
 		 */
 		call_void_qop(q, wait_finish, q);
+		q->waiting_in_dqbuf = 0;
 		if (ret) {
 			dprintk(1, "sleep was interrupted\n");
 			return ret;
@@ -2572,6 +2588,12 @@ static size_t __vb2_perform_fileio(struc
 	if (!data)
 		return -EINVAL;
 
+	if (q->waiting_in_dqbuf) {
+		dprintk(3, "another dup()ped fd is %s\n",
+			read ? "reading" : "writing");
+		return -EBUSY;
+	}
+
 	/*
 	 * Initialize emulator on first call.
 	 */
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -586,6 +586,7 @@ struct vb2_queue {
 	unsigned int			start_streaming_called:1;
 	unsigned int			error:1;
 	unsigned int			waiting_for_buffers:1;
+	unsigned int			waiting_in_dqbuf:1;
 	unsigned int			is_multiplanar:1;
 	unsigned int			is_output:1;
 	unsigned int			copy_timestamp:1;



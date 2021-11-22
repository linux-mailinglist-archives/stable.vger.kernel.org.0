Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D640458F21
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 14:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239192AbhKVNKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 08:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:43162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239534AbhKVNJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Nov 2021 08:09:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE45D60234;
        Mon, 22 Nov 2021 13:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637586412;
        bh=bDV2XBuDXfGYQR2A/0P2rnv3uJW5Rq7BHbRbY+2TNAM=;
        h=Subject:To:Cc:From:Date:From;
        b=u/ad80NpS+9T0fxBgGlqYPU/zAo7MDUbXSP464+En8B6rzcPE1PxbRtWVSsRcEgPI
         jP1BR4mDyvvSw8dwRLk2YdgKcaJaJJe5kPmyEt3HE//Yje+6/XIuWz1TipIdVX2kLr
         lU4m12JOkPyYpxiEpm4XSeMuU7EPnbjy2XWN7kuw=
Subject: FAILED: patch "[PATCH] dma-buf/poll: Get a file reference for outstanding fence" failed to apply to 5.10-stable tree
To:     mdaenzer@redhat.com, christian.koenig@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Nov 2021 14:06:41 +0100
Message-ID: <16375864012941@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ff2d23843f7fb4f13055be5a4a9a20ddd04e6e9c Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>
Date: Fri, 23 Jul 2021 09:58:57 +0200
Subject: [PATCH] dma-buf/poll: Get a file reference for outstanding fence
 callbacks
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This makes sure we don't hit the

	BUG_ON(dmabuf->cb_in.active || dmabuf->cb_out.active);

in dma_buf_release, which could be triggered by user space closing the
dma-buf file description while there are outstanding fence callbacks
from dma_buf_poll.

Cc: stable@vger.kernel.org
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210723075857.4065-1-michel@daenzer.net
Signed-off-by: Christian König <christian.koenig@amd.com>

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index beb504a92d60..35fe1cb5ad98 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -67,12 +67,9 @@ static void dma_buf_release(struct dentry *dentry)
 	BUG_ON(dmabuf->vmapping_counter);
 
 	/*
-	 * Any fences that a dma-buf poll can wait on should be signaled
-	 * before releasing dma-buf. This is the responsibility of each
-	 * driver that uses the reservation objects.
-	 *
-	 * If you hit this BUG() it means someone dropped their ref to the
-	 * dma-buf while still having pending operation to the buffer.
+	 * If you hit this BUG() it could mean:
+	 * * There's a file reference imbalance in dma_buf_poll / dma_buf_poll_cb or somewhere else
+	 * * dmabuf->cb_in/out.active are non-0 despite no pending fence callback
 	 */
 	BUG_ON(dmabuf->cb_in.active || dmabuf->cb_out.active);
 
@@ -200,6 +197,7 @@ static loff_t dma_buf_llseek(struct file *file, loff_t offset, int whence)
 static void dma_buf_poll_cb(struct dma_fence *fence, struct dma_fence_cb *cb)
 {
 	struct dma_buf_poll_cb_t *dcb = (struct dma_buf_poll_cb_t *)cb;
+	struct dma_buf *dmabuf = container_of(dcb->poll, struct dma_buf, poll);
 	unsigned long flags;
 
 	spin_lock_irqsave(&dcb->poll->lock, flags);
@@ -207,6 +205,8 @@ static void dma_buf_poll_cb(struct dma_fence *fence, struct dma_fence_cb *cb)
 	dcb->active = 0;
 	spin_unlock_irqrestore(&dcb->poll->lock, flags);
 	dma_fence_put(fence);
+	/* Paired with get_file in dma_buf_poll */
+	fput(dmabuf->file);
 }
 
 static bool dma_buf_poll_add_cb(struct dma_resv *resv, bool write,
@@ -259,6 +259,9 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
 		spin_unlock_irq(&dmabuf->poll.lock);
 
 		if (events & EPOLLOUT) {
+			/* Paired with fput in dma_buf_poll_cb */
+			get_file(dmabuf->file);
+
 			if (!dma_buf_poll_add_cb(resv, true, dcb))
 				/* No callback queued, wake up any other waiters */
 				dma_buf_poll_cb(NULL, &dcb->cb);
@@ -279,6 +282,9 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
 		spin_unlock_irq(&dmabuf->poll.lock);
 
 		if (events & EPOLLIN) {
+			/* Paired with fput in dma_buf_poll_cb */
+			get_file(dmabuf->file);
+
 			if (!dma_buf_poll_add_cb(resv, false, dcb))
 				/* No callback queued, wake up any other waiters */
 				dma_buf_poll_cb(NULL, &dcb->cb);


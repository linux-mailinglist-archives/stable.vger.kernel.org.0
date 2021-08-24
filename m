Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A843F652C
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239078AbhHXRKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238710AbhHXRJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:09:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3629B61A3F;
        Tue, 24 Aug 2021 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824418;
        bh=tZ6H/TBRQ34caCU563PUVut+5bvcoFxoFsuyy/jbZd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dnfGJiamjD6pDdTltxV57z2Unk9erUGkkvpjDzCuSRpgQzq+7HqfCaXrxogEqGtgj
         uEmmJR1xmKXqLftpHuWPPyNwobRH/0sXW7fEO21NFpCQEduF7OKP3u2kOgcDelaIi+
         LWX7AVy1RFOSJftlYqwQ/RYzYnlSiNN8VY/rJDzP5pocLLALhhv2u7E5xYQ1RFfYZp
         9WTCniuYkhNcOtIouDdyhp/ZwQYmFNXVu/+y+a4aAWzERK7VQVEudmydHaAt4zAym9
         J+H6n6Axclw583cTvE3SPawVuOiwUXZqETFgi6UuNRNP5MjhFprsFzKTWchfHyuCgN
         Mtvi3uWMn53tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kernel test robot <oliver.sang@intel.com>,
        Sandeep Patil <sspatil@android.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 68/98] pipe: avoid unnecessary EPOLLET wakeups under normal loads
Date:   Tue, 24 Aug 2021 12:58:38 -0400
Message-Id: <20210824165908.709932-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 3b844826b6c6affa80755254da322b017358a2f4 ]

I had forgotten just how sensitive hackbench is to extra pipe wakeups,
and commit 3a34b13a88ca ("pipe: make pipe writes always wake up
readers") ended up causing a quite noticeable regression on larger
machines.

Now, hackbench isn't necessarily a hugely meaningful benchmark, and it's
not clear that this matters in real life all that much, but as Mel
points out, it's used often enough when comparing kernels and so the
performance regression shows up like a sore thumb.

It's easy enough to fix at least for the common cases where pipes are
used purely for data transfer, and you never have any exciting poll
usage at all.  So set a special 'poll_usage' flag when there is polling
activity, and make the ugly "EPOLLET has crazy legacy expectations"
semantics explicit to only that case.

I would love to limit it to just the broken EPOLLET case, but the pipe
code can't see the difference between epoll and regular select/poll, so
any non-read/write waiting will trigger the extra wakeup behavior.  That
is sufficient for at least the hackbench case.

Apart from making the odd extra wakeup cases more explicitly about
EPOLLET, this also makes the extra wakeup be at the _end_ of the pipe
write, not at the first write chunk.  That is actually much saner
semantics (as much as you can call any of the legacy edge-triggered
expectations for EPOLLET "sane") since it means that you know the wakeup
will happen once the write is done, rather than possibly in the middle
of one.

[ For stable people: I'm putting a "Fixes" tag on this, but I leave it
  up to you to decide whether you actually want to backport it or not.
  It likely has no impact outside of synthetic benchmarks  - Linus ]

Link: https://lore.kernel.org/lkml/20210802024945.GA8372@xsang-OptiPlex-9020/
Fixes: 3a34b13a88ca ("pipe: make pipe writes always wake up readers")
Reported-by: kernel test robot <oliver.sang@intel.com>
Tested-by: Sandeep Patil <sspatil@android.com>
Tested-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pipe.c                 | 15 +++++++++------
 include/linux/pipe_fs_i.h |  2 ++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 28b2e973f10e..48abe65333c4 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -444,9 +444,6 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 #endif
 
 	/*
-	 * Epoll nonsensically wants a wakeup whether the pipe
-	 * was already empty or not.
-	 *
 	 * If it wasn't empty we try to merge new data into
 	 * the last buffer.
 	 *
@@ -455,9 +452,9 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 	 * spanning multiple pages.
 	 */
 	head = pipe->head;
-	was_empty = true;
+	was_empty = pipe_empty(head, pipe->tail);
 	chars = total_len & (PAGE_SIZE-1);
-	if (chars && !pipe_empty(head, pipe->tail)) {
+	if (chars && !was_empty) {
 		unsigned int mask = pipe->ring_size - 1;
 		struct pipe_buffer *buf = &pipe->bufs[(head - 1) & mask];
 		int offset = buf->offset + buf->len;
@@ -590,8 +587,11 @@ out:
 	 * This is particularly important for small writes, because of
 	 * how (for example) the GNU make jobserver uses small writes to
 	 * wake up pending jobs
+	 *
+	 * Epoll nonsensically wants a wakeup whether the pipe
+	 * was already empty or not.
 	 */
-	if (was_empty) {
+	if (was_empty || pipe->poll_usage) {
 		wake_up_interruptible_sync_poll(&pipe->rd_wait, EPOLLIN | EPOLLRDNORM);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 	}
@@ -654,6 +654,9 @@ pipe_poll(struct file *filp, poll_table *wait)
 	struct pipe_inode_info *pipe = filp->private_data;
 	unsigned int head, tail;
 
+	/* Epoll has some historical nasty semantics, this enables them */
+	pipe->poll_usage = 1;
+
 	/*
 	 * Reading pipe state only -- no need for acquiring the semaphore.
 	 *
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 5d2705f1d01c..fc5642431b92 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -48,6 +48,7 @@ struct pipe_buffer {
  *	@files: number of struct file referring this pipe (protected by ->i_lock)
  *	@r_counter: reader counter
  *	@w_counter: writer counter
+ *	@poll_usage: is this pipe used for epoll, which has crazy wakeups?
  *	@fasync_readers: reader side fasync
  *	@fasync_writers: writer side fasync
  *	@bufs: the circular array of pipe buffers
@@ -70,6 +71,7 @@ struct pipe_inode_info {
 	unsigned int files;
 	unsigned int r_counter;
 	unsigned int w_counter;
+	unsigned int poll_usage;
 	struct page *tmp_page;
 	struct fasync_struct *fasync_readers;
 	struct fasync_struct *fasync_writers;
-- 
2.30.2


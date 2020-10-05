Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58170283A77
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgJEPeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbgJEPe1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:34:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AB512074F;
        Mon,  5 Oct 2020 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912067;
        bh=0mfxOL4H44kvo4nnTcJqcg5b+z/EfojOmOvVbLG4P+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCnyjrUXyyCT/Q7+hUivrZqsdsBOP8NDcjUniIL55YVY1eHsqyI8eL7Odn2/Xj6r4
         vTmhi8r4c78tKL+WfVMDMIsrerMmTKMGMXRcQWgBcY2/oxsxyQDsIsq7m6aYT4MO9n
         BstkAbsqhSr21mFtCA/9O2v48gg+FCbWVwJP/TXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 76/85] pipe: remove pipe_wait() and fix wakeup race with splice
Date:   Mon,  5 Oct 2020 17:27:12 +0200
Message-Id: <20201005142118.388341339@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 472e5b056f000a778abb41f1e443de58eb259783 ]

The pipe splice code still used the old model of waiting for pipe IO by
using a non-specific "pipe_wait()" that waited for any pipe event to
happen, which depended on all pipe IO being entirely serialized by the
pipe lock.  So by checking the state you were waiting for, and then
adding yourself to the wait queue before dropping the lock, you were
guaranteed to see all the wakeups.

Strictly speaking, the actual wakeups were not done under the lock, but
the pipe_wait() model still worked, because since the waiter held the
lock when checking whether it should sleep, it would always see the
current state, and the wakeup was always done after updating the state.

However, commit 0ddad21d3e99 ("pipe: use exclusive waits when reading or
writing") split the single wait-queue into two, and in the process also
made the "wait for event" code wait for _two_ wait queues, and that then
showed a race with the wakers that were not serialized by the pipe lock.

It's only splice that used that "pipe_wait()" model, so the problem
wasn't obvious, but Josef Bacik reports:

 "I hit a hang with fstest btrfs/187, which does a btrfs send into
  /dev/null. This works by creating a pipe, the write side is given to
  the kernel to write into, and the read side is handed to a thread that
  splices into a file, in this case /dev/null.

  The box that was hung had the write side stuck here [pipe_write] and
  the read side stuck here [splice_from_pipe_next -> pipe_wait].

  [ more details about pipe_wait() scenario ]

  The problem is we're doing the prepare_to_wait, which sets our state
  each time, however we can be woken up either with reads or writes. In
  the case above we race with the WRITER waking us up, and re-set our
  state to INTERRUPTIBLE, and thus never break out of schedule"

Josef had a patch that avoided the issue in pipe_wait() by just making
it set the state only once, but the deeper problem is that pipe_wait()
depends on a level of synchonization by the pipe mutex that it really
shouldn't.  And the whole "wait for any pipe state change" model really
isn't very good to begin with.

So rather than trying to work around things in pipe_wait(), remove that
legacy model of "wait for arbitrary pipe event" entirely, and actually
create functions that wait for the pipe actually being readable or
writable, and can do so without depending on the pipe lock serializing
everything.

Fixes: 0ddad21d3e99 ("pipe: use exclusive waits when reading or writing")
Link: https://lore.kernel.org/linux-fsdevel/bfa88b5ad6f069b2b679316b9e495a970130416c.1601567868.git.josef@toxicpanda.com/
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-and-tested-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pipe.c                 | 62 ++++++++++++++++++++++++++-------------
 fs/splice.c               |  8 ++---
 include/linux/pipe_fs_i.h |  5 ++--
 3 files changed, 48 insertions(+), 27 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 60dbee4571436..117db82b10af5 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -106,25 +106,6 @@ void pipe_double_lock(struct pipe_inode_info *pipe1,
 	}
 }
 
-/* Drop the inode semaphore and wait for a pipe event, atomically */
-void pipe_wait(struct pipe_inode_info *pipe)
-{
-	DEFINE_WAIT(rdwait);
-	DEFINE_WAIT(wrwait);
-
-	/*
-	 * Pipes are system-local resources, so sleeping on them
-	 * is considered a noninteractive wait:
-	 */
-	prepare_to_wait(&pipe->rd_wait, &rdwait, TASK_INTERRUPTIBLE);
-	prepare_to_wait(&pipe->wr_wait, &wrwait, TASK_INTERRUPTIBLE);
-	pipe_unlock(pipe);
-	schedule();
-	finish_wait(&pipe->rd_wait, &rdwait);
-	finish_wait(&pipe->wr_wait, &wrwait);
-	pipe_lock(pipe);
-}
-
 static void anon_pipe_buf_release(struct pipe_inode_info *pipe,
 				  struct pipe_buffer *buf)
 {
@@ -1035,12 +1016,52 @@ SYSCALL_DEFINE1(pipe, int __user *, fildes)
 	return do_pipe2(fildes, 0);
 }
 
+/*
+ * This is the stupid "wait for pipe to be readable or writable"
+ * model.
+ *
+ * See pipe_read/write() for the proper kind of exclusive wait,
+ * but that requires that we wake up any other readers/writers
+ * if we then do not end up reading everything (ie the whole
+ * "wake_next_reader/writer" logic in pipe_read/write()).
+ */
+void pipe_wait_readable(struct pipe_inode_info *pipe)
+{
+	pipe_unlock(pipe);
+	wait_event_interruptible(pipe->rd_wait, pipe_readable(pipe));
+	pipe_lock(pipe);
+}
+
+void pipe_wait_writable(struct pipe_inode_info *pipe)
+{
+	pipe_unlock(pipe);
+	wait_event_interruptible(pipe->wr_wait, pipe_writable(pipe));
+	pipe_lock(pipe);
+}
+
+/*
+ * This depends on both the wait (here) and the wakeup (wake_up_partner)
+ * holding the pipe lock, so "*cnt" is stable and we know a wakeup cannot
+ * race with the count check and waitqueue prep.
+ *
+ * Normally in order to avoid races, you'd do the prepare_to_wait() first,
+ * then check the condition you're waiting for, and only then sleep. But
+ * because of the pipe lock, we can check the condition before being on
+ * the wait queue.
+ *
+ * We use the 'rd_wait' waitqueue for pipe partner waiting.
+ */
 static int wait_for_partner(struct pipe_inode_info *pipe, unsigned int *cnt)
 {
+	DEFINE_WAIT(rdwait);
 	int cur = *cnt;
 
 	while (cur == *cnt) {
-		pipe_wait(pipe);
+		prepare_to_wait(&pipe->rd_wait, &rdwait, TASK_INTERRUPTIBLE);
+		pipe_unlock(pipe);
+		schedule();
+		finish_wait(&pipe->rd_wait, &rdwait);
+		pipe_lock(pipe);
 		if (signal_pending(current))
 			break;
 	}
@@ -1050,7 +1071,6 @@ static int wait_for_partner(struct pipe_inode_info *pipe, unsigned int *cnt)
 static void wake_up_partner(struct pipe_inode_info *pipe)
 {
 	wake_up_interruptible_all(&pipe->rd_wait);
-	wake_up_interruptible_all(&pipe->wr_wait);
 }
 
 static int fifo_open(struct inode *inode, struct file *filp)
diff --git a/fs/splice.c b/fs/splice.c
index d7c8a7c4db07f..c3d00dfc73446 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -563,7 +563,7 @@ static int splice_from_pipe_next(struct pipe_inode_info *pipe, struct splice_des
 			sd->need_wakeup = false;
 		}
 
-		pipe_wait(pipe);
+		pipe_wait_readable(pipe);
 	}
 
 	return 1;
@@ -1077,7 +1077,7 @@ static int wait_for_space(struct pipe_inode_info *pipe, unsigned flags)
 			return -EAGAIN;
 		if (signal_pending(current))
 			return -ERESTARTSYS;
-		pipe_wait(pipe);
+		pipe_wait_writable(pipe);
 	}
 }
 
@@ -1454,7 +1454,7 @@ static int ipipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 			ret = -EAGAIN;
 			break;
 		}
-		pipe_wait(pipe);
+		pipe_wait_readable(pipe);
 	}
 
 	pipe_unlock(pipe);
@@ -1493,7 +1493,7 @@ static int opipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 			ret = -ERESTARTSYS;
 			break;
 		}
-		pipe_wait(pipe);
+		pipe_wait_writable(pipe);
 	}
 
 	pipe_unlock(pipe);
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 50afd0d0084ca..5d2705f1d01c3 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -240,8 +240,9 @@ extern unsigned int pipe_max_size;
 extern unsigned long pipe_user_pages_hard;
 extern unsigned long pipe_user_pages_soft;
 
-/* Drop the inode semaphore and wait for a pipe event, atomically */
-void pipe_wait(struct pipe_inode_info *pipe);
+/* Wait for a pipe to be readable/writable while dropping the pipe lock */
+void pipe_wait_readable(struct pipe_inode_info *);
+void pipe_wait_writable(struct pipe_inode_info *);
 
 struct pipe_inode_info *alloc_pipe_info(void);
 void free_pipe_info(struct pipe_inode_info *);
-- 
2.25.1




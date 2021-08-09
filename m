Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B2C3E434D
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 11:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbhHIJws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 05:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhHIJws (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 05:52:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F6A160F11;
        Mon,  9 Aug 2021 09:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628502748;
        bh=JcFdmL1yqMs5GyZAdlm01Li/8XUWupyp3IqhMdZipEc=;
        h=Subject:To:Cc:From:Date:From;
        b=gv2znH/zJHMFCmatvKbiIkWLrFGI+W2dkq9u7SFz9eiPA2/LuLQ9GV7eAwseTUCTW
         2C5nAyYU+PHhGlvVlA9h8CoVGMIxWyKoWuzylkKX0Z0RP/fTMJTgiOJdxOlepFuivj
         /PVdelH1pqOqJkMx1AjijkSsK02rmqKZU7EKA+CU=
Subject: FAILED: patch "[PATCH] pipe: increase minimum default pipe size to 2 pages" failed to apply to 4.4-stable tree
To:     alex_y_xu@yahoo.ca, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Aug 2021 11:52:25 +0200
Message-ID: <162850274511123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 46c4c9d1beb7f5b4cec4dd90e7728720583ee348 Mon Sep 17 00:00:00 2001
From: "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>
Date: Thu, 5 Aug 2021 10:40:47 -0400
Subject: [PATCH] pipe: increase minimum default pipe size to 2 pages

This program always prints 4096 and hangs before the patch, and always
prints 8192 and exits successfully after:

  int main()
  {
      int pipefd[2];
      for (int i = 0; i < 1025; i++)
          if (pipe(pipefd) == -1)
              return 1;
      size_t bufsz = fcntl(pipefd[1], F_GETPIPE_SZ);
      printf("%zd\n", bufsz);
      char *buf = calloc(bufsz, 1);
      write(pipefd[1], buf, bufsz);
      read(pipefd[0], buf, bufsz-1);
      write(pipefd[1], buf, 1);
  }

Note that you may need to increase your RLIMIT_NOFILE before running the
program.

Fixes: 759c01142a ("pipe: limit the per-user amount of pages allocated in pipes")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/lkml/1628086770.5rn8p04n6j.none@localhost/
Link: https://lore.kernel.org/lkml/1628127094.lxxn016tj7.none@localhost/
Signed-off-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/pipe.c b/fs/pipe.c
index 9ef4231cce61..8e6ef62aeb1c 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -31,6 +31,21 @@
 
 #include "internal.h"
 
+/*
+ * New pipe buffers will be restricted to this size while the user is exceeding
+ * their pipe buffer quota. The general pipe use case needs at least two
+ * buffers: one for data yet to be read, and one for new data. If this is less
+ * than two, then a write to a non-empty pipe may block even if the pipe is not
+ * full. This can occur with GNU make jobserver or similar uses of pipes as
+ * semaphores: multiple processes may be waiting to write tokens back to the
+ * pipe before reading tokens: https://lore.kernel.org/lkml/1628086770.5rn8p04n6j.none@localhost/.
+ *
+ * Users can reduce their pipe buffers with F_SETPIPE_SZ below this at their
+ * own risk, namely: pipe writes to non-full pipes may block until the pipe is
+ * emptied.
+ */
+#define PIPE_MIN_DEF_BUFFERS 2
+
 /*
  * The max size that a non-root user is allowed to grow the pipe. Can
  * be set by root in /proc/sys/fs/pipe-max-size
@@ -781,8 +796,8 @@ struct pipe_inode_info *alloc_pipe_info(void)
 	user_bufs = account_pipe_buffers(user, 0, pipe_bufs);
 
 	if (too_many_pipe_buffers_soft(user_bufs) && pipe_is_unprivileged_user()) {
-		user_bufs = account_pipe_buffers(user, pipe_bufs, 1);
-		pipe_bufs = 1;
+		user_bufs = account_pipe_buffers(user, pipe_bufs, PIPE_MIN_DEF_BUFFERS);
+		pipe_bufs = PIPE_MIN_DEF_BUFFERS;
 	}
 
 	if (too_many_pipe_buffers_hard(user_bufs) && pipe_is_unprivileged_user())


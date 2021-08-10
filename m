Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F583E7F5B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhHJRkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235081AbhHJRjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:39:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32946610A0;
        Tue, 10 Aug 2021 17:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617013;
        bh=RABCGUc/EXegW3+JRJjZfkZkcxe79Tvl1euXjL0Bkp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItW/PH5GXADg6/fBnOC/gdHxbysdKQiNRz8KsTBLJsi23jW5M+cvvrr2fX85OPQIz
         X2EVpnU97WKqgxeax3Ju7so0wby2C0Uryks0Zs8hEpD7oO0lXrZxxcW9bo37Vutzel
         eI5zyy6G/IzDVkM9lW+Tp/Nnu7Mbl0lLCuZr+euw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 59/85] pipe: increase minimum default pipe size to 2 pages
Date:   Tue, 10 Aug 2021 19:30:32 +0200
Message-Id: <20210810172950.227398327@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>

commit 46c4c9d1beb7f5b4cec4dd90e7728720583ee348 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pipe.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -31,6 +31,21 @@
 #include "internal.h"
 
 /*
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
+/*
  * The max size that a non-root user is allowed to grow the pipe. Can
  * be set by root in /proc/sys/fs/pipe-max-size
  */
@@ -666,8 +681,8 @@ struct pipe_inode_info *alloc_pipe_info(
 	user_bufs = account_pipe_buffers(user, 0, pipe_bufs);
 
 	if (too_many_pipe_buffers_soft(user_bufs) && is_unprivileged_user()) {
-		user_bufs = account_pipe_buffers(user, pipe_bufs, 1);
-		pipe_bufs = 1;
+		user_bufs = account_pipe_buffers(user, pipe_bufs, PIPE_MIN_DEF_BUFFERS);
+		pipe_bufs = PIPE_MIN_DEF_BUFFERS;
 	}
 
 	if (too_many_pipe_buffers_hard(user_bufs) && is_unprivileged_user())



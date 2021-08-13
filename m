Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367833EB7C0
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241219AbhHMPJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:09:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241212AbhHMPI6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:08:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CED0A610CC;
        Fri, 13 Aug 2021 15:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867311;
        bh=qZ4IcnHx3383ghvLlZ7qJxumrSCLaF9VxZIGvrEvCWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PMgrNWGVocq7FjoES3D7TjbHt8QBqqS0wey4YkzVCnLIe44mVRLVUZkFekNMP3qNM
         4/vQ53kO9AfwctdoD8+RmJDSf/HjY/DeO6djCrDNTGf5mxUh7N5suY3GDPewJlUvlf
         M/QI2PgKIRbnV+2nq93P/m3PE93xTIpi9D08Eu/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 22/25] pipe: increase minimum default pipe size to 2 pages
Date:   Fri, 13 Aug 2021 17:06:46 +0200
Message-Id: <20210813150521.439309896@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150520.718161915@linuxfoundation.org>
References: <20210813150520.718161915@linuxfoundation.org>
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
 fs/pipe.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -28,6 +28,21 @@
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
@@ -621,7 +636,7 @@ struct pipe_inode_info *alloc_pipe_info(
 
 		if (!too_many_pipe_buffers_hard(user)) {
 			if (too_many_pipe_buffers_soft(user))
-				pipe_bufs = 1;
+				pipe_bufs = PIPE_MIN_DEF_BUFFERS;
 			pipe->bufs = kzalloc(sizeof(struct pipe_buffer) * pipe_bufs, GFP_KERNEL);
 		}
 



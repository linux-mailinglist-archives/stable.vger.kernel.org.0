Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4096528B7B2
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389810AbgJLNp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389773AbgJLNpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B709223AE;
        Mon, 12 Oct 2020 13:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510338;
        bh=CgaHqJO8XAuH9PEVA4CIAqnDO0BsBwV/yY0szY2KZOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faio3Fnkkzki2LB3chMewM+BcS44Px6bV8tbqyC2N3FkbwFOYdXdDWzq9zepXTfLA
         KTzyiMAgRl0XjIPZL8XWChTBB4fpJsC6vOmZ2Ve2Ak/35LElclOe3PoQ6pYflJU17v
         M/WTBYyVjggcuhuiOw+tV3LsmqhF9ASg2E0zXziE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 016/124] splice: teach splice pipe reading about empty pipe buffers
Date:   Mon, 12 Oct 2020 15:30:20 +0200
Message-Id: <20201012133147.636077331@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit d1a819a2ec2d3b5e6a8f8a9f67386bda0ad315bc upstream.

Tetsuo Handa reports that splice() can return 0 before the real EOF, if
the data in the splice source pipe is an empty pipe buffer.  That empty
pipe buffer case doesn't happen in any normal situation, but you can
trigger it by doing a write to a pipe that fails due to a page fault.

Tetsuo has a test-case to show the behavior:

  #define _GNU_SOURCE
  #include <sys/types.h>
  #include <sys/stat.h>
  #include <fcntl.h>
  #include <unistd.h>

  int main(int argc, char *argv[])
  {
	const int fd = open("/tmp/testfile", O_WRONLY | O_CREAT, 0600);
	int pipe_fd[2] = { -1, -1 };
	pipe(pipe_fd);
	write(pipe_fd[1], NULL, 4096);
	/* This splice() should wait unless interrupted. */
	return !splice(pipe_fd[0], NULL, fd, NULL, 65536, 0);
  }

which results in

    write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
    splice(4, NULL, 3, NULL, 65536, 0)      = 0

and this can confuse splice() users into believing they have hit EOF
prematurely.

The issue was introduced when the pipe write code started pre-allocating
the pipe buffers before copying data from user space.

This is modified verion of Tetsuo's original patch.

Fixes: a194dfe6e6f6 ("pipe: Rearrange sequence in pipe_write() to preallocate slot")
Link:https://lore.kernel.org/linux-fsdevel/20201005121339.4063-1-penguin-kernel@I-love.SAKURA.ne.jp/
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Acked-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/splice.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -526,6 +526,22 @@ static int splice_from_pipe_feed(struct
 	return 1;
 }
 
+/* We know we have a pipe buffer, but maybe it's empty? */
+static inline bool eat_empty_buffer(struct pipe_inode_info *pipe)
+{
+	unsigned int tail = pipe->tail;
+	unsigned int mask = pipe->ring_size - 1;
+	struct pipe_buffer *buf = &pipe->bufs[tail & mask];
+
+	if (unlikely(!buf->len)) {
+		pipe_buf_release(pipe, buf);
+		pipe->tail = tail+1;
+		return true;
+	}
+
+	return false;
+}
+
 /**
  * splice_from_pipe_next - wait for some data to splice from
  * @pipe:	pipe to splice from
@@ -545,6 +561,7 @@ static int splice_from_pipe_next(struct
 	if (signal_pending(current))
 		return -ERESTARTSYS;
 
+repeat:
 	while (pipe_empty(pipe->head, pipe->tail)) {
 		if (!pipe->writers)
 			return 0;
@@ -566,6 +583,9 @@ static int splice_from_pipe_next(struct
 		pipe_wait_readable(pipe);
 	}
 
+	if (eat_empty_buffer(pipe))
+		goto repeat;
+
 	return 1;
 }
 



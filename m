Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048DC6165A
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfGGTiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:38:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57102 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727521AbfGGTiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:06 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz4-0006g8-C6; Sun, 07 Jul 2019 20:38:02 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz3-0005Zu-32; Sun, 07 Jul 2019 20:38:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jann Horn" <jannh@google.com>, "Al Viro" <viro@zeniv.linux.org.uk>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.961437661@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 045/129] splice: don't merge into linked buffers
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit a0ce2f0aa6ad97c3d4927bf2ca54bcebdf062d55 upstream.

Before this patch, it was possible for two pipes to affect each other after
data had been transferred between them with tee():

============
$ cat tee_test.c

int main(void) {
  int pipe_a[2];
  if (pipe(pipe_a)) err(1, "pipe");
  int pipe_b[2];
  if (pipe(pipe_b)) err(1, "pipe");
  if (write(pipe_a[1], "abcd", 4) != 4) err(1, "write");
  if (tee(pipe_a[0], pipe_b[1], 2, 0) != 2) err(1, "tee");
  if (write(pipe_b[1], "xx", 2) != 2) err(1, "write");

  char buf[5];
  if (read(pipe_a[0], buf, 4) != 4) err(1, "read");
  buf[4] = 0;
  printf("got back: '%s'\n", buf);
}
$ gcc -o tee_test tee_test.c
$ ./tee_test
got back: 'abxx'
$
============

As suggested by Al Viro, fix it by creating a separate type for
non-mergeable pipe buffers, then changing the types of buffers in
splice_pipe_to_pipe() and link_pipe().

Fixes: 7c77f0b3f920 ("splice: implement pipe to pipe splicing")
Fixes: 70524490ee2e ("[PATCH] splice: add support for sys_tee()")
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[bwh: Backported to 3.16: Use generic_pipe_buf_steal(), as for other pipe
 types, since anon_pipe_buf_steal() does not exist here]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/pipe.c                 | 14 ++++++++++++++
 fs/splice.c               |  4 ++++
 include/linux/pipe_fs_i.h |  1 +
 3 files changed, 19 insertions(+)

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -219,6 +219,14 @@ static const struct pipe_buf_operations
 	.get = generic_pipe_buf_get,
 };
 
+static const struct pipe_buf_operations anon_pipe_buf_nomerge_ops = {
+	.can_merge = 0,
+	.confirm = generic_pipe_buf_confirm,
+	.release = anon_pipe_buf_release,
+	.steal = generic_pipe_buf_steal,
+	.get = generic_pipe_buf_get,
+};
+
 static const struct pipe_buf_operations packet_pipe_buf_ops = {
 	.can_merge = 0,
 	.confirm = generic_pipe_buf_confirm,
@@ -227,6 +235,12 @@ static const struct pipe_buf_operations
 	.get = generic_pipe_buf_get,
 };
 
+void pipe_buf_mark_unmergeable(struct pipe_buffer *buf)
+{
+	if (buf->ops == &anon_pipe_buf_ops)
+		buf->ops = &anon_pipe_buf_nomerge_ops;
+}
+
 static ssize_t
 pipe_read(struct kiocb *iocb, struct iov_iter *to)
 {
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1901,6 +1901,8 @@ retry:
 			 */
 			obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
 
+			pipe_buf_mark_unmergeable(obuf);
+
 			obuf->len = len;
 			opipe->nrbufs++;
 			ibuf->offset += obuf->len;
@@ -1975,6 +1977,8 @@ static int link_pipe(struct pipe_inode_i
 		 */
 		obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
 
+		pipe_buf_mark_unmergeable(obuf);
+
 		if (obuf->len > len)
 			obuf->len = len;
 
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -140,6 +140,7 @@ void generic_pipe_buf_get(struct pipe_in
 int generic_pipe_buf_confirm(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
 void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer *);
+void pipe_buf_mark_unmergeable(struct pipe_buffer *buf);
 
 extern const struct pipe_buf_operations nosteal_pipe_buf_ops;
 


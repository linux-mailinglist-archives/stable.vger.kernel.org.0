Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1443C56AF67
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 02:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbiGHAZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 20:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236840AbiGHAZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 20:25:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F08E70E40;
        Thu,  7 Jul 2022 17:25:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FFEA62184;
        Fri,  8 Jul 2022 00:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB29C3411E;
        Fri,  8 Jul 2022 00:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657239938;
        bh=8YiAwdaURTlAmrXZDORT3bxPagAU+XoqRjmG6ERzZ+Y=;
        h=Date:To:From:Subject:From;
        b=URggccqELltFYcYladS22tc8TkAqo1OIshjNOrDhD8s0gKYDw54Cw7VgJR4rk8fpq
         PCaeedqeHDKSVU6+a88Kpb8KxC6tnl5GWsMhcjCMreb8uqlmNRoWrm2We9Wr/OPjRb
         3dwifQvjciHu6OYf8C+2QZBMwuMS5XSKuhFbrb14=
Date:   Thu, 07 Jul 2022 17:25:37 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        stable@vger.kernel.org, avagin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-sendfile-handles-o_nonblock-of-out_fd.patch added to mm-hotfixes-unstable branch
Message-Id: <20220708002538.5FB29C3411E@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs: sendfile handles O_NONBLOCK of out_fd
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-sendfile-handles-o_nonblock-of-out_fd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-sendfile-handles-o_nonblock-of-out_fd.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrei Vagin <avagin@gmail.com>
Subject: fs: sendfile handles O_NONBLOCK of out_fd

sendfile has to return EAGAIN if out_fd is nonblocking and the write into
it would block.

Here is a small reproducer for the problem:

#define _GNU_SOURCE /* See feature_test_macros(7) */
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/sendfile.h>


#define FILE_SIZE (1UL << 30)
int main(int argc, char **argv) {
        int p[2], fd;

        if (pipe2(p, O_NONBLOCK))
                return 1;

        fd = open(argv[1], O_RDWR | O_TMPFILE, 0666);
        if (fd < 0)
                return 1;
        ftruncate(fd, FILE_SIZE);

        if (sendfile(p[1], fd, 0, FILE_SIZE) == -1) {
                fprintf(stderr, "FAIL\n");
        }
        if (sendfile(p[1], fd, 0, FILE_SIZE) != -1 || errno != EAGAIN) {
                fprintf(stderr, "FAIL\n");
        }
        return 0;
}

It worked before b964bf53e540, it is stuck after b964bf53e540, and it
works again with this fix.

This regression occurred because do_splice_direct() calls pipe_write
that handles O_NONBLOCK.  Here is a trace log from the reproducer:

 1)               |  __x64_sys_sendfile64() {
 1)               |    do_sendfile() {
 1)               |      __fdget()
 1)               |      rw_verify_area()
 1)               |      __fdget()
 1)               |      rw_verify_area()
 1)               |      do_splice_direct() {
 1)               |        rw_verify_area()
 1)               |        splice_direct_to_actor() {
 1)               |          do_splice_to() {
 1)               |            rw_verify_area()
 1)               |            generic_file_splice_read()
 1) + 74.153 us   |          }
 1)               |          direct_splice_actor() {
 1)               |            iter_file_splice_write() {
 1)               |              __kmalloc()
 1)   0.148 us    |              pipe_lock();
 1)   0.153 us    |              splice_from_pipe_next.part.0();
 1)   0.162 us    |              page_cache_pipe_buf_confirm();
... 16 times
 1)   0.159 us    |              page_cache_pipe_buf_confirm();
 1)               |              vfs_iter_write() {
 1)               |                do_iter_write() {
 1)               |                  rw_verify_area()
 1)               |                  do_iter_readv_writev() {
 1)               |                    pipe_write() {
 1)               |                      mutex_lock()
 1)   0.153 us    |                      mutex_unlock();
 1)   1.368 us    |                    }
 1)   1.686 us    |                  }
 1)   5.798 us    |                }
 1)   6.084 us    |              }
 1)   0.174 us    |              kfree();
 1)   0.152 us    |              pipe_unlock();
 1) + 14.461 us   |            }
 1) + 14.783 us   |          }
 1)   0.164 us    |          page_cache_pipe_buf_release();
... 16 times
 1)   0.161 us    |          page_cache_pipe_buf_release();
 1)               |          touch_atime()
 1) + 95.854 us   |        }
 1) + 99.784 us   |      }
 1) ! 107.393 us  |    }
 1) ! 107.699 us  |  }

Link: https://lkml.kernel.org/r/20220415005015.525191-1-avagin@gmail.com
Fixes: b964bf53e540 ("teach sendfile(2) to handle send-to-pipe directly")
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/read_write.c~fs-sendfile-handles-o_nonblock-of-out_fd
+++ a/fs/read_write.c
@@ -1263,6 +1263,9 @@ static ssize_t do_sendfile(int out_fd, i
 					  count, fl);
 		file_end_write(out.file);
 	} else {
+		if (out.file->f_flags & O_NONBLOCK)
+			fl |= SPLICE_F_NONBLOCK;
+
 		retval = splice_file_to_pipe(in.file, opipe, &pos, count, fl);
 	}
 
_

Patches currently in -mm which might be from avagin@gmail.com are

fs-sendfile-handles-o_nonblock-of-out_fd.patch


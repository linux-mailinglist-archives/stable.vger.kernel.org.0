Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11FC1526A5B
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 21:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346683AbiEMT13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 15:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383957AbiEMT0C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 15:26:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180A53B01E;
        Fri, 13 May 2022 12:23:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE3E2B8315C;
        Fri, 13 May 2022 19:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8A0C34100;
        Fri, 13 May 2022 19:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469822;
        bh=eNgrNyrzoHeF29y5MWq8fDP+ngWfj38kTgNrVtsUw+0=;
        h=Date:To:From:Subject:From;
        b=pNuXuP2xm/vAaB2VePCsQ7hYpngcwwmMS2RYNxfEnUYargld9JSC6+kx79kkLJtPn
         tSeucugGDUdLbK+mK2hZreebCSd5nnPm/+uhCvtXCV7EDmh/y0eMqj+eGuRDlyPZV2
         1L8QFKxerrx7S1ZOzZHKxFGiJma51ETERyCzogX8=
Date:   Fri, 13 May 2022 12:23:41 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        stable@vger.kernel.org, avagin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-sendfile-handles-o_nonblock-of-out_fd.patch removed from -mm tree
Message-Id: <20220513192342.7C8A0C34100@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: fs: sendfile handles O_NONBLOCK of out_fd
has been removed from the -mm tree.  Its filename was
     fs-sendfile-handles-o_nonblock-of-out_fd.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1247,6 +1247,9 @@ static ssize_t do_sendfile(int out_fd, i
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



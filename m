Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99418586A16
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbiHAMMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbiHAMLT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:11:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4C86D575;
        Mon,  1 Aug 2022 04:57:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CED1B80E8F;
        Mon,  1 Aug 2022 11:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2494C433D6;
        Mon,  1 Aug 2022 11:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355014;
        bh=fBocT6bum1EtRI8WqnaZX72t0t2OdnKuGvPTbs2rxwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zg3JkKF6r6YQs6CJHcE1T1324xYhnfEQHXABi0S7M9X2Yyt8uv+yxbHCqnPR1bEHg
         JYb1pnIREDBwqNkCZeNFkLHGrsG769s19v0N9j5huGapP0P3wlZLwXwCOjAEGOpCey
         5WD9srjLjj9WFuB38Nt3k9ot5DqQ7STdJ43j5aXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrei Vagin <avagin@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.18 08/88] fs: sendfile handles O_NONBLOCK of out_fd
Date:   Mon,  1 Aug 2022 13:46:22 +0200
Message-Id: <20220801114138.428187170@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

commit bdeb77bc2c405fa9f954c20269db175a0bd2793f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/read_write.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1247,6 +1247,9 @@ static ssize_t do_sendfile(int out_fd, i
 					  count, fl);
 		file_end_write(out.file);
 	} else {
+		if (out.file->f_flags & O_NONBLOCK)
+			fl |= SPLICE_F_NONBLOCK;
+
 		retval = splice_file_to_pipe(in.file, opipe, &pos, count, fl);
 	}
 



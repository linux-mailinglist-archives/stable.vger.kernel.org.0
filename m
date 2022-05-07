Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E59251EA66
	for <lists+stable@lfdr.de>; Sat,  7 May 2022 23:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbiEGV4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 May 2022 17:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387528AbiEGV4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 May 2022 17:56:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D30EFD10;
        Sat,  7 May 2022 14:52:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3C4860F2D;
        Sat,  7 May 2022 21:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065C6C385A6;
        Sat,  7 May 2022 21:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651960352;
        bh=1I4TKssy6yHtJB0DOLvoU/YN0ZUywf5dO/iYT5pJTTo=;
        h=Date:To:From:Subject:From;
        b=Gh1jcRFxVeCZSBIEIWnFuhczU68nJUtL4y0VZAwJKnYJIPz4vHmeVZKuu5PvrSvpq
         rzWsPa/OevXv1//F7wddJcKxrT6RwfGgsQ2SiJ0SNH2Rixhq2fjyD981BW20KR+A6m
         A1naD9dCxPQFtE3gZ+X4D3dhgYEeUXcIcP1zvBis=
Date:   Sat, 07 May 2022 14:52:31 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        stable@vger.kernel.org, avagin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-sendfile-handles-o_nonblock-of-out_fd.patch added to mm-nonmm-unstable branch
Message-Id: <20220507215232.065C6C385A6@smtp.kernel.org>
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
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-sendfile-handles-o_nonblock-of-out_fd.patch

This patch should soon appear in the mm-nonmm-unstable branch at
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

fs-sendfile-handles-o_nonblock-of-out_fd.patch


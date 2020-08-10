Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4B82402FF
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 09:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgHJHwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 03:52:50 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51083 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgHJHwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 03:52:49 -0400
Received: from fsav402.sakura.ne.jp (fsav402.sakura.ne.jp [133.242.250.101])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 07A7qQ44046079;
        Mon, 10 Aug 2020 16:52:26 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav402.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav402.sakura.ne.jp);
 Mon, 10 Aug 2020 16:52:26 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav402.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 07A7qH7j045729
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Mon, 10 Aug 2020 16:52:26 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH] block: allow for_each_bvec to support zero len bvec
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org
References: <20200810031915.2209658-1-ming.lei@redhat.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <db57f8ca-b3c3-76ec-1e49-d8f8161ba78d@i-love.sakura.ne.jp>
Date:   Mon, 10 Aug 2020 16:52:17 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200810031915.2209658-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/08/10 12:19, Ming Lei wrote:
> Block layer usually doesn't support or allow zero-length bvec. Since
> commit 1bdc76aea115 ("iov_iter: use bvec iterator to implement
> iterate_bvec()"), iterate_bvec() switches to bvec iterator. However,
> Al mentioned that 'Zero-length segments are not disallowed' in iov_iter.
> 
> Fixes for_each_bvec() so that it can move on after seeing one zero
> length bvec.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> Link: https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2262077.html
> Fixes: 1bdc76aea115 ("iov_iter: use bvec iterator to implement iterate_bvec()")

Is this Fixes: correct? That commit should be in RHEL8's 4.18 kernel but that kernel
does not hit this bug.

Moreover, maybe nobody cares, but behavior of splice() differs when there are only 
zero-length pages. With this fix, splice() returns 0 despite there is still pipe writers.
Man page seems to say that splice() returns 0 when there is no pipe writers...

    A return value of 0 means end of input.  If fd_in refers to a pipe,
    then this means that there was no data to transfer, and it would not
    make sense to block because there are no writers connected to the
    write end of the pipe.

----- test case -----
#define _GNU_SOURCE
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char *argv[])
{
        static char buffer[4096];
        const int fd = open("/tmp/testfile", O_WRONLY | O_CREAT, 0600);
        int pipe_fd[2] = { EOF, EOF };
        pipe(pipe_fd);
        write(pipe_fd[1], NULL, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        memset(buffer, 'a', sizeof(buffer));
        //write(pipe_fd[1], buffer, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        memset(buffer, 'b', sizeof(buffer));
        //write(pipe_fd[1], buffer, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        memset(buffer, 'c', sizeof(buffer));
        //write(pipe_fd[1], buffer, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        memset(buffer, 'd', sizeof(buffer));
        //write(pipe_fd[1], buffer, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        write(pipe_fd[1], NULL, sizeof(buffer));
        splice(pipe_fd[0], NULL, fd, NULL, 65536, 0);
        return 0;
}

----- 4.18.0-193.14.2.el8_2.x86_64 -----
openat(AT_FDCWD, "/tmp/testfile", O_WRONLY|O_CREAT, 0600) = 3
pipe([4, 5])                            = 0
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
splice(4, NULL, 3, NULL, 65536, 0

^C)      = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
strace: Process 1486 detached

----- linux.git + this fix -----
open("/tmp/testfile", O_WRONLY|O_CREAT, 0600) = 3
pipe([4, 5])                            = 0
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
splice(4, NULL, 3, NULL, 65536, 0)      = 0
exit_group(0)                           = ?
+++ exited with 0 +++

> Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

I just forwarded syzbot's report. Thus, credit goes to

Reported-by: syzbot <syzbot+61acc40a49a3e46e25ea@syzkaller.appspotmail.com>

> Tested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: <stable@vger.kernel.org>

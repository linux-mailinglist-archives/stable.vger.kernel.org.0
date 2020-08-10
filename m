Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A7A240B1B
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 18:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgHJQXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 12:23:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53203 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725869AbgHJQXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 12:23:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597076630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=79To6yhBbxnqdoLB/vAGghJg4sifmUnfnr7NL9vQa4k=;
        b=If+HcbzKRDP1IajTUWP/1yt4XP3Z+0c1qNxnwXrK3h8O674yAG127zslx0F3nTufjcPfz6
        bKgrGDaIranNn/hpGhIyXlqZ2imdR6mPAm/Ew/YgafvYdeD+q9QCwG2eI9JZrnurG0i1eV
        5vWFvjtsMB9xvNJ2eptsnHEOf0ZJvcM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-XcJe6OeZOEizSKEHRHbt4Q-1; Mon, 10 Aug 2020 12:23:47 -0400
X-MC-Unique: XcJe6OeZOEizSKEHRHbt4Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F466800474;
        Mon, 10 Aug 2020 16:23:45 +0000 (UTC)
Received: from T590 (ovpn-12-105.pek2.redhat.com [10.72.12.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD5C187D6B;
        Mon, 10 Aug 2020 16:23:38 +0000 (UTC)
Date:   Tue, 11 Aug 2020 00:23:31 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] block: allow for_each_bvec to support zero len bvec
Message-ID: <20200810162331.GA2215158@T590>
References: <20200810031915.2209658-1-ming.lei@redhat.com>
 <db57f8ca-b3c3-76ec-1e49-d8f8161ba78d@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db57f8ca-b3c3-76ec-1e49-d8f8161ba78d@i-love.sakura.ne.jp>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 04:52:17PM +0900, Tetsuo Handa wrote:
> On 2020/08/10 12:19, Ming Lei wrote:
> > Block layer usually doesn't support or allow zero-length bvec. Since
> > commit 1bdc76aea115 ("iov_iter: use bvec iterator to implement
> > iterate_bvec()"), iterate_bvec() switches to bvec iterator. However,
> > Al mentioned that 'Zero-length segments are not disallowed' in iov_iter.
> > 
> > Fixes for_each_bvec() so that it can move on after seeing one zero
> > length bvec.
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > Link: https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2262077.html
> > Fixes: 1bdc76aea115 ("iov_iter: use bvec iterator to implement iterate_bvec()")
> 
> Is this Fixes: correct? That commit should be in RHEL8's 4.18 kernel but that kernel
> does not hit this bug.

Yeah, it is correct, see the following link:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.8&id=1bdc76aea1159a750846c2fc98e404403eb7d51c

Commit 1bdc76aea115 was merged to v4.8, so it is definitely in both RHEL8's
4.18 based kernel and upstream kernel.

> 
> Moreover, maybe nobody cares, but behavior of splice() differs when there are only 
> zero-length pages. With this fix, splice() returns 0 despite there is still pipe writers.

It is another new issue, which isn't related with Commit 1bdc76aea115,
see below.

> Man page seems to say that splice() returns 0 when there is no pipe writers...
> 
>     A return value of 0 means end of input.  If fd_in refers to a pipe,
>     then this means that there was no data to transfer, and it would not
>     make sense to block because there are no writers connected to the
>     write end of the pipe.
> 
> ----- test case -----
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <unistd.h>
> #include <string.h>
> 
> int main(int argc, char *argv[])
> {
>         static char buffer[4096];
>         const int fd = open("/tmp/testfile", O_WRONLY | O_CREAT, 0600);
>         int pipe_fd[2] = { EOF, EOF };
>         pipe(pipe_fd);
>         write(pipe_fd[1], NULL, sizeof(buffer));
>         write(pipe_fd[1], NULL, sizeof(buffer));
>         memset(buffer, 'a', sizeof(buffer));
>         //write(pipe_fd[1], buffer, sizeof(buffer));
>         write(pipe_fd[1], NULL, sizeof(buffer));
>         write(pipe_fd[1], NULL, sizeof(buffer));
>         memset(buffer, 'b', sizeof(buffer));
>         //write(pipe_fd[1], buffer, sizeof(buffer));
>         write(pipe_fd[1], NULL, sizeof(buffer));
>         write(pipe_fd[1], NULL, sizeof(buffer));
>         memset(buffer, 'c', sizeof(buffer));
>         //write(pipe_fd[1], buffer, sizeof(buffer));
>         write(pipe_fd[1], NULL, sizeof(buffer));
>         write(pipe_fd[1], NULL, sizeof(buffer));
>         memset(buffer, 'd', sizeof(buffer));
>         //write(pipe_fd[1], buffer, sizeof(buffer));
>         write(pipe_fd[1], NULL, sizeof(buffer));
>         write(pipe_fd[1], NULL, sizeof(buffer));
>         splice(pipe_fd[0], NULL, fd, NULL, 65536, 0);
>         return 0;
> }

The above test doesn't trigger the reported lockup issue, so this patch
isn't related with the new issue you described.

> 
> ----- 4.18.0-193.14.2.el8_2.x86_64 -----
> openat(AT_FDCWD, "/tmp/testfile", O_WRONLY|O_CREAT, 0600) = 3
> pipe([4, 5])                            = 0
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> splice(4, NULL, 3, NULL, 65536, 0
> 
> ^C)      = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
> strace: Process 1486 detached

The same behavior can be observed on v4.8 too, both v4.8 and v4.18
includes 1bdc76aea115. If you apply the fix against v4.8, you can
observe the same behavior too.

> 
> ----- linux.git + this fix -----

It should have been linux.git, :-)

I think this new issue may be introduced between v4.18 and v5.8.

> open("/tmp/testfile", O_WRONLY|O_CREAT, 0600) = 3
> pipe([4, 5])                            = 0
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> write(5, NULL, 4096)                    = -1 EFAULT (Bad address)
> splice(4, NULL, 3, NULL, 65536, 0)      = 0
> exit_group(0)                           = ?
> +++ exited with 0 +++
> 
> > Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> 
> I just forwarded syzbot's report. Thus, credit goes to
> 
> Reported-by: syzbot <syzbot+61acc40a49a3e46e25ea@syzkaller.appspotmail.com>

OK.


Thanks,
Ming


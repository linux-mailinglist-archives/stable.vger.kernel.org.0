Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3424242724
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 11:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgHLJBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 05:01:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30209 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726255AbgHLJBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 05:01:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597222862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P9SH4zs6bYGoVk6Zl3euYE37Cx5b4umaTEKRb90euIo=;
        b=HvV7eAmEb7KG45OKZJlQCRWtRigtdvmKzhbuKBxXN96D/b+jpdtWEkfbJauoPUw1ChivTc
        IO8xG5pQlGtuGp+VyKEl3XkS4HRCf3/AORq2JMeEd4nyWeWhkQ8V4m2vgSIEjKYMmb9hL+
        CYCz0iS5U3Q8rlAAhgqqMEt3srwf8yE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-9v9RQZ7ZPO2fxIZYV7nNHQ-1; Wed, 12 Aug 2020 05:00:51 -0400
X-MC-Unique: 9v9RQZ7ZPO2fxIZYV7nNHQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4810D802B45;
        Wed, 12 Aug 2020 09:00:50 +0000 (UTC)
Received: from T590 (ovpn-13-156.pek2.redhat.com [10.72.13.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E12560BE5;
        Wed, 12 Aug 2020 09:00:43 +0000 (UTC)
Date:   Wed, 12 Aug 2020 17:00:39 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] block: allow for_each_bvec to support zero len bvec
Message-ID: <20200812090039.GA2317340@T590>
References: <20200810031915.2209658-1-ming.lei@redhat.com>
 <db57f8ca-b3c3-76ec-1e49-d8f8161ba78d@i-love.sakura.ne.jp>
 <20200810162331.GA2215158@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810162331.GA2215158@T590>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 12:23:31AM +0800, Ming Lei wrote:
> On Mon, Aug 10, 2020 at 04:52:17PM +0900, Tetsuo Handa wrote:
> > On 2020/08/10 12:19, Ming Lei wrote:
> > > Block layer usually doesn't support or allow zero-length bvec. Since
> > > commit 1bdc76aea115 ("iov_iter: use bvec iterator to implement
> > > iterate_bvec()"), iterate_bvec() switches to bvec iterator. However,
> > > Al mentioned that 'Zero-length segments are not disallowed' in iov_iter.
> > > 
> > > Fixes for_each_bvec() so that it can move on after seeing one zero
> > > length bvec.
> > > 
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > Link: https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2262077.html
> > > Fixes: 1bdc76aea115 ("iov_iter: use bvec iterator to implement iterate_bvec()")
> > 
> > Is this Fixes: correct? That commit should be in RHEL8's 4.18 kernel but that kernel
> > does not hit this bug.
> 
> Yeah, it is correct, see the following link:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.8&id=1bdc76aea1159a750846c2fc98e404403eb7d51c
> 
> Commit 1bdc76aea115 was merged to v4.8, so it is definitely in both RHEL8's
> 4.18 based kernel and upstream kernel.
> 
> > 
> > Moreover, maybe nobody cares, but behavior of splice() differs when there are only 
> > zero-length pages. With this fix, splice() returns 0 despite there is still pipe writers.
> 
> It is another new issue, which isn't related with Commit 1bdc76aea115,
> see below.
> 
> > Man page seems to say that splice() returns 0 when there is no pipe writers...
> > 
> >     A return value of 0 means end of input.  If fd_in refers to a pipe,
> >     then this means that there was no data to transfer, and it would not
> >     make sense to block because there are no writers connected to the
> >     write end of the pipe.
> > 
> > ----- test case -----
> > #define _GNU_SOURCE
> > #include <stdio.h>
> > #include <sys/types.h>
> > #include <sys/stat.h>
> > #include <fcntl.h>
> > #include <unistd.h>
> > #include <string.h>
> > 
> > int main(int argc, char *argv[])
> > {
> >         static char buffer[4096];
> >         const int fd = open("/tmp/testfile", O_WRONLY | O_CREAT, 0600);
> >         int pipe_fd[2] = { EOF, EOF };
> >         pipe(pipe_fd);
> >         write(pipe_fd[1], NULL, sizeof(buffer));
> >         write(pipe_fd[1], NULL, sizeof(buffer));
> >         memset(buffer, 'a', sizeof(buffer));
> >         //write(pipe_fd[1], buffer, sizeof(buffer));
> >         write(pipe_fd[1], NULL, sizeof(buffer));
> >         write(pipe_fd[1], NULL, sizeof(buffer));
> >         memset(buffer, 'b', sizeof(buffer));
> >         //write(pipe_fd[1], buffer, sizeof(buffer));
> >         write(pipe_fd[1], NULL, sizeof(buffer));
> >         write(pipe_fd[1], NULL, sizeof(buffer));
> >         memset(buffer, 'c', sizeof(buffer));
> >         //write(pipe_fd[1], buffer, sizeof(buffer));
> >         write(pipe_fd[1], NULL, sizeof(buffer));
> >         write(pipe_fd[1], NULL, sizeof(buffer));
> >         memset(buffer, 'd', sizeof(buffer));
> >         //write(pipe_fd[1], buffer, sizeof(buffer));
> >         write(pipe_fd[1], NULL, sizeof(buffer));
> >         write(pipe_fd[1], NULL, sizeof(buffer));
> >         splice(pipe_fd[0], NULL, fd, NULL, 65536, 0);
> >         return 0;
> > }
> 
> The above test doesn't trigger the reported lockup issue, so this patch
> isn't related with the new issue you described.

BTW, for_each_bvec won't be called in the above splice test code.


Thanks,
Ming


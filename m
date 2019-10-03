Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4214C9F32
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 15:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfJCNQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 09:16:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfJCNQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 09:16:57 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4C9E20862;
        Thu,  3 Oct 2019 13:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570108617;
        bh=Mw6DDY/9E3nfBk1771v0uvAwqQEJC9YnJillLcytyHQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OYld8DQypzBcKP9I5RVsAkvzZ6ia3/oqwCUj1ThVcrPFabs+RWlHs+FuIADYsRTb1
         SY9bZ/yw1YYRhO9HBVIyxf5vD9+P2RWchdy6Ic6AjS3nOFm4Qd0jr5i3+HdqHehmuU
         6m36+1gVMqSmZHViSfKK9A2Ie25AXiLGxrr2bykI=
Date:   Thu, 3 Oct 2019 09:16:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     ebiggers@google.com, hch@lst.de, mszeredi@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] fuse: fix deadlock with aio poll and
 fuse_iqueue::waitq.lock" failed to apply to 4.19-stable tree
Message-ID: <20191003131655.GW17454@sasha-vm>
References: <157008885411399@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157008885411399@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 09:47:34AM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 76e43c8ccaa35c30d5df853013561145a0f750a5 Mon Sep 17 00:00:00 2001
>From: Eric Biggers <ebiggers@google.com>
>Date: Sun, 8 Sep 2019 20:15:18 -0700
>Subject: [PATCH] fuse: fix deadlock with aio poll and fuse_iqueue::waitq.lock
>
>When IOCB_CMD_POLL is used on the FUSE device, aio_poll() disables IRQs
>and takes kioctx::ctx_lock, then fuse_iqueue::waitq.lock.
>
>This may have to wait for fuse_iqueue::waitq.lock to be released by one
>of many places that take it with IRQs enabled.  Since the IRQ handler
>may take kioctx::ctx_lock, lockdep reports that a deadlock is possible.
>
>Fix it by protecting the state of struct fuse_iqueue with a separate
>spinlock, and only accessing fuse_iqueue::waitq using the versions of
>the waitqueue functions which do IRQ-safe locking internally.
>
>Reproducer:
>
>	#include <fcntl.h>
>	#include <stdio.h>
>	#include <sys/mount.h>
>	#include <sys/stat.h>
>	#include <sys/syscall.h>
>	#include <unistd.h>
>	#include <linux/aio_abi.h>
>
>	int main()
>	{
>		char opts[128];
>		int fd = open("/dev/fuse", O_RDWR);
>		aio_context_t ctx = 0;
>		struct iocb cb = { .aio_lio_opcode = IOCB_CMD_POLL, .aio_fildes = fd };
>		struct iocb *cbp = &cb;
>
>		sprintf(opts, "fd=%d,rootmode=040000,user_id=0,group_id=0", fd);
>		mkdir("mnt", 0700);
>		mount("foo",  "mnt", "fuse", 0, opts);
>		syscall(__NR_io_setup, 1, &ctx);
>		syscall(__NR_io_submit, ctx, 1, &cbp);
>	}
>
>Beginning of lockdep output:
>
>	=====================================================
>	WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
>	5.3.0-rc5 #9 Not tainted
>	-----------------------------------------------------
>	syz_fuse/135 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
>	000000003590ceda (&fiq->waitq){+.+.}, at: spin_lock include/linux/spinlock.h:338 [inline]
>	000000003590ceda (&fiq->waitq){+.+.}, at: aio_poll fs/aio.c:1751 [inline]
>	000000003590ceda (&fiq->waitq){+.+.}, at: __io_submit_one.constprop.0+0x203/0x5b0 fs/aio.c:1825
>
>	and this task is already holding:
>	0000000075037284 (&(&ctx->ctx_lock)->rlock){..-.}, at: spin_lock_irq include/linux/spinlock.h:363 [inline]
>	0000000075037284 (&(&ctx->ctx_lock)->rlock){..-.}, at: aio_poll fs/aio.c:1749 [inline]
>	0000000075037284 (&(&ctx->ctx_lock)->rlock){..-.}, at: __io_submit_one.constprop.0+0x1f4/0x5b0 fs/aio.c:1825
>	which would create a new lock dependency:
>	 (&(&ctx->ctx_lock)->rlock){..-.} -> (&fiq->waitq){+.+.}
>
>	but this new dependency connects a SOFTIRQ-irq-safe lock:
>	 (&(&ctx->ctx_lock)->rlock){..-.}
>
>	[...]
>
>Reported-by: syzbot+af05535bb79520f95431@syzkaller.appspotmail.com
>Reported-by: syzbot+d86c4426a01f60feddc7@syzkaller.appspotmail.com
>Fixes: bfe4037e722e ("aio: implement IOCB_CMD_POLL")
>Cc: <stable@vger.kernel.org> # v4.19+
>Cc: Christoph Hellwig <hch@lst.de>
>Signed-off-by: Eric Biggers <ebiggers@google.com>
>Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

There were some context changes mostly due to commit 217316a601016 ("fuse:
Optimize request_end() by not taking fiq->waitq.lock"). I've fixed it up
and queued on 4.14-4.4.

--
Thanks,
Sasha

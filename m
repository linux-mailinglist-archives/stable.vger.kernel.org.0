Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5242643CE6C
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 18:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238524AbhJ0QOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 12:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232600AbhJ0QOE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 12:14:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB1C861040;
        Wed, 27 Oct 2021 16:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635351099;
        bh=eZT2NLQUkt3NV+GuHjsfez64ygMrq9vvLTAL0xDytko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ITTTlVZOiSLB8C2B/qKNBU/AlWDuAvWvN9XGy3xyFoV0LPK7v1phuMMGV7JmgSN9V
         PjsgSQEEyIf7dRyGovKtHSgOF2YhQ9GJpTRIzljmANaD/V/5scRxNUg/m+XoAAqcK4
         qjaYr2vmJT40G8E2r7w53mjr8ZKt/F21OlRemJqQ=
Date:   Wed, 27 Oct 2021 18:11:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        xiaoguang.wang@linux.alibaba.com, io-uring@vger.kernel.org,
        Abaci <abaci@linux.alibaba.com>,
        Hao Xu <haoxu@linux.alibaba.com>,
        syzbot+59d8a1f4e60c20c066cf@syzkaller.appspotmail.com
Subject: Re: [PATCH v5.10.y 1/1] io_uring: don't take uring_lock during iowq
 cancel
Message-ID: <YXl6K63mUkSdYBji@kroah.com>
References: <20211027140802.1892780-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027140802.1892780-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 03:08:02PM +0100, Lee Jones wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> [ Upstream commit 792bb6eb862333658bf1bd2260133f0507e2da8d ]
> 
> [   97.866748] a.out/2890 is trying to acquire lock:
> [   97.867829] ffff8881046763e8 (&ctx->uring_lock){+.+.}-{3:3}, at:
> io_wq_submit_work+0x155/0x240
> [   97.869735]
> [   97.869735] but task is already holding lock:
> [   97.871033] ffff88810dfe0be8 (&ctx->uring_lock){+.+.}-{3:3}, at:
> __x64_sys_io_uring_enter+0x3f0/0x5b0
> [   97.873074]
> [   97.873074] other info that might help us debug this:
> [   97.874520]  Possible unsafe locking scenario:
> [   97.874520]
> [   97.875845]        CPU0
> [   97.876440]        ----
> [   97.877048]   lock(&ctx->uring_lock);
> [   97.877961]   lock(&ctx->uring_lock);
> [   97.878881]
> [   97.878881]  *** DEADLOCK ***
> [   97.878881]
> [   97.880341]  May be due to missing lock nesting notation
> [   97.880341]
> [   97.881952] 1 lock held by a.out/2890:
> [   97.882873]  #0: ffff88810dfe0be8 (&ctx->uring_lock){+.+.}-{3:3}, at:
> __x64_sys_io_uring_enter+0x3f0/0x5b0
> [   97.885108]
> [   97.885108] stack backtrace:
> [   97.890457] Call Trace:
> [   97.891121]  dump_stack+0xac/0xe3
> [   97.891972]  __lock_acquire+0xab6/0x13a0
> [   97.892940]  lock_acquire+0x2c3/0x390
> [   97.894894]  __mutex_lock+0xae/0x9f0
> [   97.901101]  io_wq_submit_work+0x155/0x240
> [   97.902112]  io_wq_cancel_cb+0x162/0x490
> [   97.904126]  io_async_find_and_cancel+0x3b/0x140
> [   97.905247]  io_issue_sqe+0x86d/0x13e0
> [   97.909122]  __io_queue_sqe+0x10b/0x550
> [   97.913971]  io_queue_sqe+0x235/0x470
> [   97.914894]  io_submit_sqes+0xcce/0xf10
> [   97.917872]  __x64_sys_io_uring_enter+0x3fb/0x5b0
> [   97.921424]  do_syscall_64+0x2d/0x40
> [   97.922329]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> While holding uring_lock, e.g. from inline execution, async cancel
> request may attempt cancellations through io_wq_submit_work, which may
> try to grab a lock. Delay it to task_work, so we do it from a clean
> context and don't have to worry about locking.
> 
> Cc: <stable@vger.kernel.org> # 5.5+
> Fixes: c07e6719511e ("io_uring: hold uring_lock while completing failed polled io in io_wq_submit_work()")
> Reported-by: Abaci <abaci@linux.alibaba.com>
> Reported-by: Hao Xu <haoxu@linux.alibaba.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> [Lee: The first hunk solves a different (double free) issue in v5.10.
>       Only the first hunk of the original patch is relevant to v5.10 AND
>       the first hunk of the original patch is only relevant to v5.10]
> Reported-by: syzbot+59d8a1f4e60c20c066cf@syzkaller.appspotmail.com
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Now queued up, thanks.

greg k-h

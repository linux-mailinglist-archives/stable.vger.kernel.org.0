Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBE034F02A
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 19:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhC3Rvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 13:51:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230071AbhC3RvV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 13:51:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35E60619B1;
        Tue, 30 Mar 2021 17:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617126681;
        bh=45BQ2rqSanmyuwF7j0WjHSCyn5B7G221PGMTNBHT6j0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kcro1xDUOLU0FlIGCW2pk8ZXTFDgEDe46jzBL+OwYDlNmEVoh11qeEtlmQEe6zZil
         mQWPNIaUPadWpMnf7yTv6CK7UJHgMLSF+9O+naMci5+KYQlGS4dyW0SwOmSQkttRWP
         1H8dhNMgElIW6wUgJwGMkiLUDxzzOiJQwfCN59EXI8DGGjFf1l+23tpyCtV+piTIgV
         PLfSYlm5fmG7r0G586tFXPK7q1XCaPXnZhPLq7We7MeSBHm30iE51EzSIk8tio/PJQ
         yDoVDT8QfBSbM9QuL1/DBmR1NR6aZNXxQ56NO5av//Dtg9yEw9g7jpeYo3Dk/T50Bk
         YKFoJ78khJjtA==
Date:   Tue, 30 Mar 2021 13:51:20 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     axboe@kernel.dk, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: ensure SQPOLL startup is
 triggered before error" failed to apply to 5.11-stable tree
Message-ID: <YGNlGKotvNw4B7uR@sashalap>
References: <161699979611052@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <161699979611052@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 08:36:36AM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.11-stable tree.
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
>From eb85890b29e4d7ae1accdcfba35ed8b16ba9fb97 Mon Sep 17 00:00:00 2001
>From: Jens Axboe <axboe@kernel.dk>
>Date: Thu, 25 Feb 2021 10:13:29 -0700
>Subject: [PATCH] io_uring: ensure SQPOLL startup is triggered before error
> shutdown
>
>syzbot reports the following hang:
>
>INFO: task syz-executor.0:12538 can't die for more than 143 seconds.
>task:syz-executor.0  state:D stack:28352 pid:12538 ppid:  8423 flags:0x00004004
>Call Trace:
> context_switch kernel/sched/core.c:4324 [inline]
> __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
> schedule+0xcf/0x270 kernel/sched/core.c:5154
> schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
> do_wait_for_common kernel/sched/completion.c:85 [inline]
> __wait_for_common kernel/sched/completion.c:106 [inline]
> wait_for_common kernel/sched/completion.c:117 [inline]
> wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
> io_sq_thread_finish+0x96/0x580 fs/io_uring.c:7152
> io_sq_offload_create fs/io_uring.c:7929 [inline]
> io_uring_create fs/io_uring.c:9465 [inline]
> io_uring_setup+0x1fb2/0x2c20 fs/io_uring.c:9550
> do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> entry_SYSCALL_64_after_hwframe+0x44/0xae
>
>which is due to exiting after the SQPOLL thread has been created, but
>hasn't been started yet. Ensure that we always complete the startup
>side when waiting for it to exit.

I *think* that this patch fixes 37d1e2e3642e ("io_uring: move SQPOLL
thread io-wq forked worker"), so we don't need to backport it.

-- 
Thanks,
Sasha

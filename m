Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8444ED506F
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 16:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfJLOeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Oct 2019 10:34:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727265AbfJLOeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Oct 2019 10:34:04 -0400
Received: from localhost (unknown [216.243.17.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 907C52089C;
        Sat, 12 Oct 2019 14:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570890843;
        bh=PLD21OxWHRYA4PnSOpeLzzY5lRzX7rtg2yd5680TBiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M75OYXK62AE+15OFzJQJbh+KoHxyhbJWxOAcNtFMPfVRnJq/PnFluJkaX6cgmqetv
         gmp0pAbmop6H8JXvxec2KfTmSjljQSpQJmvXknF+Mt4ntl0FMmj8vbDyW6RsgJc/T5
         H1u5OXB0t5cJbNyajVcNgB2Uzf+MV3W9HNnhiAHw=
Date:   Sat, 12 Oct 2019 10:34:02 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     tj@kernel.org, akpm@linux-foundation.org, axboe@kernel.dk,
        clm@fb.com, jack@suse.cz, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] writeback: fix use-after-free in
 finish_writeback_work()" failed to apply to 5.3-stable tree
Message-ID: <20191012143402.GA15167@sasha-vm>
References: <157086827811218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157086827811218@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 12, 2019 at 10:17:58AM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
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
>From 8e00c4e9dd852f7a9bf12234fad65a2f2f93788f Mon Sep 17 00:00:00 2001
>From: Tejun Heo <tj@kernel.org>
>Date: Sun, 6 Oct 2019 17:58:09 -0700
>Subject: [PATCH] writeback: fix use-after-free in finish_writeback_work()
>
>finish_writeback_work() reads @done->waitq after decrementing
>@done->cnt.  However, once @done->cnt reaches zero, @done may be freed
>(from stack) at any moment and @done->waitq can contain something
>unrelated by the time finish_writeback_work() tries to read it.  This
>led to the following crash.
>
>  "BUG: kernel NULL pointer dereference, address: 0000000000000002"
>  #PF: supervisor write access in kernel mode
>  #PF: error_code(0x0002) - not-present page
>  PGD 0 P4D 0
>  Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
>  CPU: 40 PID: 555153 Comm: kworker/u98:50 Kdump: loaded Not tainted
>  ...
>  Workqueue: writeback wb_workfn (flush-btrfs-1)
>  RIP: 0010:_raw_spin_lock_irqsave+0x10/0x30
>  Code: 48 89 d8 5b c3 e8 50 db 6b ff eb f4 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 53 9c 5b fa 31 c0 ba 01 00 00 00 <f0> 0f b1 17 75 05 48 89 d8 5b c3 89 c6 e8 fe ca 6b ff eb f2 66 90
>  RSP: 0018:ffffc90049b27d98 EFLAGS: 00010046
>  RAX: 0000000000000000 RBX: 0000000000000246 RCX: 0000000000000000
>  RDX: 0000000000000001 RSI: 0000000000000003 RDI: 0000000000000002
>  RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
>  R10: ffff889fff407600 R11: ffff88ba9395d740 R12: 000000000000e300
>  R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
>  FS:  0000000000000000(0000) GS:ffff88bfdfa00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000002 CR3: 0000000002409005 CR4: 00000000001606e0
>  Call Trace:
>   __wake_up_common_lock+0x63/0xc0
>   wb_workfn+0xd2/0x3e0
>   process_one_work+0x1f5/0x3f0
>   worker_thread+0x2d/0x3d0
>   kthread+0x111/0x130
>   ret_from_fork+0x1f/0x30
>
>Fix it by reading and caching @done->waitq before decrementing
>@done->cnt.
>
>Link: http://lkml.kernel.org/r/20190924010631.GH2233839@devbig004.ftw2.facebook.com
>Fixes: 5b9cce4c7eb069 ("writeback: Generalize and expose wb_completion")

Hm... 5b9cce4c7eb069 went upstream during the 5.4 merge window, but:

>Signed-off-by: Tejun Heo <tj@kernel.org>
>Debugged-by: Chris Mason <clm@fb.com>
>Reviewed-by: Jens Axboe <axboe@kernel.dk>
>Cc: Jan Kara <jack@suse.cz>
>Cc: <stable@vger.kernel.org>	[5.2+]

This tag says that 8e00c4e9dd85 should be backported to 5.3.

-- 
Thanks,
Sasha

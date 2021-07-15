Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499273C9ED6
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 14:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237413AbhGOMop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:44:45 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:46124 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234549AbhGOMop (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 08:44:45 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0C6491FE20;
        Thu, 15 Jul 2021 12:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1626352911; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qt2mIxvW9VEXRTw9mZpJtc7bEQkk/f9nExFHMeH2U7U=;
        b=x7akm8O3ZjI4XVD+qJWwnQrJYpI9hO4uz9HZwuoCSm7zJJJHmQ7lkOh5lnBpJLwNEJz2+V
        nTA0p4i2DYmFeP67Vi/1hAm20o2q9fZ5UHAM2Nt1s/VzUAttuMiCp5FxbwU02NMQ3ynexK
        CfMNoiwmrf9o3yBlVXE46IryyCU9FQo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1626352911;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qt2mIxvW9VEXRTw9mZpJtc7bEQkk/f9nExFHMeH2U7U=;
        b=TZo8rJqylSJ4OL9WRdpyWC9ghKxrT2QHcfk/XjMZJcn6b07FWxDLLtDiAaaHcVAntrUpRY
        tZ+cJ8wqcOhqTjBw==
Received: from quack2.suse.cz (unknown [10.100.200.198])
        by relay2.suse.de (Postfix) with ESMTP id E6B2AA3B99;
        Thu, 15 Jul 2021 12:41:50 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id C48241E0BF2; Thu, 15 Jul 2021 14:41:50 +0200 (CEST)
Date:   Thu, 15 Jul 2021 14:41:50 +0200
From:   Jan Kara <jack@suse.cz>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Holger Kiehl <Holger.Kiehl@dwd.de>, Jan Kara <jack@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
Message-ID: <20210715124150.GC31920@quack2.suse.cz>
References: <20210712060912.995381202@linuxfoundation.org>
 <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de>
 <YO56HTE3k95JLeje@kroah.com>
 <50fb4713-6b5d-b5e0-786a-6ece57896d2f@praktifix.dwd.de>
 <df63b875-f140-606a-862a-73b102345cd@praktifix.dwd.de>
 <YO7nHhW2t4wEiI9G@kroah.com>
 <CA+G9fYuhbE6sY3ykoiyqZqYSG=+V0r3z0TiaVL8LptbXWw=duQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuhbE6sY3ykoiyqZqYSG=+V0r3z0TiaVL8LptbXWw=duQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Naresh!

On Wed 14-07-21 19:22:59, Naresh Kamboju wrote:
> My two cents,
> While running ssuite long running stress testing we have noticed deadlock.
> 
> > So if you drop that, all works well?  I'll go drop that from the queues
> > now.
> 
> Let me drop that patch and test it again.
> 
> Crash log,
> 
> [ 1957.278399] ============================================
> [ 1957.283717] WARNING: possible recursive locking detected
> [ 1957.289031] 5.13.2-rc1 #1 Not tainted
> [ 1957.292703] --------------------------------------------
> [ 1957.298016] kworker/u8:7/236 is trying to acquire lock:
> [ 1957.303241] ffff8cc203f92c38 (&bfqd->lock){-.-.}-{2:2}, at:
> bfq_finish_requeue_request+0x55/0x500 [bfq]
> [ 1957.312643]
> [ 1957.312643] but task is already holding lock:
> [ 1957.318467] ffff8cc203f92c38 (&bfqd->lock){-.-.}-{2:2}, at:
> bfq_insert_requests+0x81/0x1750 [bfq]
> [ 1957.327334]
> [ 1957.327334] other info that might help us debug this:
> [ 1957.333852]  Possible unsafe locking scenario:
> [ 1957.333852]
> [ 1957.339762]        CPU0
> [ 1957.342206]        ----
> [ 1957.344651]   lock(&bfqd->lock);
> [ 1957.347873]   lock(&bfqd->lock);
> [ 1957.351097]
> [ 1957.351097]  *** DEADLOCK ***
> [ 1957.351097]
> [ 1957.357008]  May be due to missing lock nesting notation
> [ 1957.357008]
> [ 1957.363783] 3 locks held by kworker/u8:7/236:
> [ 1957.368136]  #0: ffff8cc2009c5938
> ((wq_completion)writeback){+.+.}-{0:0}, at:
> process_one_work+0x207/0x5e0
> [ 1957.377782]  #1: ffff9ba980d57e68
> ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at:
> process_one_work+0x207/0x5e0
> [ 1957.388640]  #2: ffff8cc203f92c38 (&bfqd->lock){-.-.}-{2:2}, at:
> bfq_insert_requests+0x81/0x1750 [bfq]
> [ 1957.397938]
> [ 1957.397938] stack backtrace:
> [ 1957.402291] CPU: 1 PID: 236 Comm: kworker/u8:7 Not tainted 5.13.2-rc1 #1
> [ 1957.408989] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [ 1957.416374] Workqueue: writeback wb_workfn (flush-8:0)
> [ 1957.421513] Call Trace:
> [ 1957.423966]  dump_stack+0x76/0x95
> [ 1957.427283]  __lock_acquire+0xb70/0x1a50
> [ 1957.431203]  ? lock_is_held_type+0xa0/0x110
> [ 1957.435388]  ? bfq_init_rq+0x30e/0x1140 [bfq]
> [ 1957.439748]  lock_acquire+0x258/0x2e0
> [ 1957.443413]  ? bfq_finish_requeue_request+0x55/0x500 [bfq]
> [ 1957.448923]  ? __lock_acquire+0x4a6/0x1a50
> [ 1957.453016]  ? __lock_acquire+0x3e0/0x1a50
> [ 1957.457107]  _raw_spin_lock_irqsave+0x3f/0x60
> [ 1957.461466]  ? bfq_finish_requeue_request+0x55/0x500 [bfq]
> [ 1957.466950]  bfq_finish_requeue_request+0x55/0x500 [bfq]
> [ 1957.472256]  ? rcu_read_lock_sched_held+0x4f/0x80
> [ 1957.476960]  blk_mq_free_request+0x3e/0x140
> [ 1957.481146]  blk_put_request+0xe/0x10
> [ 1957.484804]  blk_attempt_req_merge+0x1d/0x30
> [ 1957.489075]  elv_attempt_insert_merge+0x34/0x90
> [ 1957.493599]  blk_mq_sched_try_insert_merge+0x2c/0x50
> [ 1957.498556]  bfq_insert_requests+0x8d/0x1750 [bfq]
> [ 1957.503342]  ? find_held_lock+0x35/0xa0
> [ 1957.507180]  ? writeback_sb_inodes+0x35a/0x550
> [ 1957.511618]  blk_mq_sched_insert_requests+0xd9/0x2a0
> [ 1957.516580]  blk_mq_flush_plug_list+0x138/0x270
> [ 1957.521110]  blk_flush_plug_list+0xd1/0x100
> [ 1957.525295]  blk_finish_plug+0x2c/0x40
> [ 1957.529045]  wb_writeback+0x1ab/0x430
> [ 1957.532702]  ? _raw_spin_unlock_bh+0x30/0x40
> [ 1957.536970]  wb_workfn+0xcb/0x660
> [ 1957.540286]  ? wb_workfn+0xcb/0x660
> [ 1957.543770]  ? lock_acquire+0x258/0x2e0
> [ 1957.547600]  ? process_one_work+0x207/0x5e0
> [ 1957.551778]  process_one_work+0x289/0x5e0
> [ 1957.555782]  ? inode_wait_for_writeback+0x40/0x40
> [ 1957.560477]  ? process_one_work+0x289/0x5e0
> [ 1957.564656]  worker_thread+0x3c/0x3f0
> [ 1957.568315]  ? process_one_work+0x5e0/0x5e0
> [ 1957.572500]  kthread+0x14c/0x170
> [ 1957.575733]  ? set_kthread_struct+0x40/0x40
> [ 1957.579921]  ret_from_fork+0x22/0x30
> Waiting for transitory to terminate: 5[0KWaiting for transitory to
> terminate: 4[0K[ 2106.390977] systemd[1]: systemd-resolved.service:
> Watchdog timeout (limit 3min)!
> [ 2106.398454] systemd[1]: systemd-resolved.service: Killing process
> 349 (systemd-resolve) with signal SIGABRT.

Thanks for testing and the report! So this looks like you didn't have
commit fd2ef39cc9a ("blk: Fix lock inversion between ioc lock and bfqd
lock") applied. As I was looking into BFQ code indeed commit a921c655f2
("bfq: Remove merged request already in bfq_requests_merged()") on its own
would introduce this deadlock which then gets fixed up by commit
fd2ef39cc9a (I didn't realize this when writing the series). So we either
need to apply both commits or none of them. Do you see some problems with
both commits applied?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

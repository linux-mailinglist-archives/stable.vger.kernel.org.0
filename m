Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C6E2D0A70
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 06:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgLGFxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 00:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgLGFxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 00:53:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C560C0613D0;
        Sun,  6 Dec 2020 21:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=A1tGF9rNiKZDOvD4YqoK9lBHk40Vt+h1aHFxkwMUwSE=; b=qR2+Ti96aNHdnR3kH464//4ZmJ
        5AGhF1g7LRM0LZ28XY06kKfnw4rsaAcncRUFwjbPHhlsfs5g09GhsStgtA0qZy99Vug2S1KegCVvj
        ohuh/tGnPIy8MtmSMUGqpnQETmo0JKXmmXwmhpMfOSBgRaMsSQZ10Rgdw2Pn/DUq6FccI0yW0wPgZ
        EV5NyIdg+LMGlf/d2U1OjEGIOfFP70QOsgGUcNKOyp8KMpxvxdUDrjlkY9VPEE43loeEmmnlD7nAt
        VQQkGcfwW8yVAldMI1swD1QshGrx/s9Nj0NOTy7YqQheOfUQiTD1J9vAapOZWSldWl3HorwN20GFz
        1MhlLviw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1km9Rt-0003ji-2Y; Mon, 07 Dec 2020 05:52:37 +0000
Date:   Mon, 7 Dec 2020 05:52:36 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>, rcu@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>,
        linux-stable <stable@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: sched: core.c:7270 Illegal context switch in RCU-bh read-side
 critical section! __alloc_pages_nodemask
Message-ID: <20201207055236.GS11935@casper.infradead.org>
References: <CA+G9fYvhJTwQkGyH7HQzSsDBHT7pm5ziA9VTkRhE_bDSQp3JYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvhJTwQkGyH7HQzSsDBHT7pm5ziA9VTkRhE_bDSQp3JYg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 11:06:10AM +0530, Naresh Kamboju wrote:
> While booting arm64 hikey board with stable-rc 5.9.13-rc1 the following warning
> noticed. This is hard to reproduce.

Ugh.  You've got two warnings interleaved here.  This is impossible
to read.  Do you have any examples where only one of them happens?

> Step to reproduce:
> ------------------------
> # Boot arm64 hikey device with stable-rc 5.9.13-rc1
> # Since it is hard to reproduce you may notice this warning
> 
> Crash log :
> --------------
> [   10.763081] [drm] Initialized kirin 1.0.0 20150718 for f4100000.ade
> on minor 1
> [   10.764088] Bluetooth: hci0: change remote baud rate command in firmware
> [[0;32m  OK  [0m] Started TEE Supplicant.
> [   10.791741] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> req 400000Hz, actual 400000HZ div = 31)
> E/TC:0 tee_entry_std:545 Bad arg address 0x6b681000
> [[0;32m  OK  [0m] Started Periodic Command Scheduler.
> [   10.846417] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> req 25000000Hz, actual 24800000HZ div = 0)
> [   10.887083]
> [   10.887087]
> [   10.887095] =====================================
> [   10.887098] =============================
> [   10.887101] WARNING: bad unlock balance detected!
> [   10.887107] WARNING: suspicious RCU usage
> [   10.887112] 5.9.13-rc1 #1 Not tainted
> [   10.887120] 5.9.13-rc1 #1 Not tainted
> [   10.887122] -------------------------------------
> [   10.887129] systemd-udevd/306 is trying to release lock (
> [   10.887133] -----------------------------
> [   10.887135] fs_reclaim) at:
> [   10.887144] /usr/src/kernel/kernel/sched/core.c:7270 Illegal
> context switch in RCU-bh read-side critical section!
> [   10.887163] [<ffff80001030f2e8>] __alloc_pages_nodemask+0x250/0x4c0
> [   10.887166]
> [   10.887166] other info that might help us debug this:
> [   10.887166]
> [   10.887170] but there are no more locks to release!
> [   10.887175]
> [   10.887175] other info that might help us debug this:
> [   10.887179]
> [   10.887179] rcu_scheduler_active = 2, debug_locks = 0
> [   10.887182] 1 lock held by systemd-udevd/306:
> [   10.887189] 1 lock held by systemd-sysctl/342:
> [   10.887192]  #0: ffff00007474e518
> [   10.887199]  #0:
> [   10.887202]  (
> [   10.887209] ffff000070c54708
> [   10.887212] &mm->mmap_lock){++++}-{3:3}
> [   10.887219]  (
> [   10.887228] , at: do_page_fault+0x168/0x420
> [   10.887230] &type->i_mutex_dir_key
> [   10.887235]
> [   10.887235] stack backtrace:
> [   10.887237] #3){++++}-{3:3}
> [   10.887246] CPU: 1 PID: 306 Comm: systemd-udevd Not tainted 5.9.13-rc1 #1
> [   10.887255] , at: iterate_dir+0x54/0x1d0
> [   10.887258] Hardware name: HiKey Development Board (DT)
> [   10.887264]
> [   10.887264] stack backtrace:
> [   10.887266] Call trace:
> [   10.887276]  dump_backtrace+0x0/0x1f8
> [   10.887283]  show_stack+0x2c/0x38
> [   10.887292]  dump_stack+0xec/0x158
> [   10.887303]  print_unlock_imbalance_bug+0xec/0xf0
> [   10.887311]  lock_release+0x300/0x388
> [   10.887320]  __alloc_pages_nodemask+0x268/0x4c0
> [   10.887329]  alloc_pages_vma+0x90/0x240
> [   10.887338]  handle_mm_fault+0x8d4/0x12f0
> [   10.887346]  do_page_fault+0x1c4/0x420
> [   10.887353]  do_translation_fault+0xb0/0xcc
> [   10.887363]  do_mem_abort+0x50/0xb0
> [   10.887372]  el1_abort+0x28/0x30
> [   10.887379]  el1_sync_handler+0xc0/0xf0
> [   10.887386]  el1_sync+0x7c/0x100
> [   10.887397]  __arch_copy_to_user+0x1d8/0x310
> [   10.887407]  copy_page_to_iter+0x110/0x3e8
> [   10.887416]  generic_file_buffered_read+0x4b8/0xaa8
> [   10.887423]  generic_file_read_iter+0xd4/0x168
> [   10.887432]  blkdev_read_iter+0x50/0x78
> [   10.887442]  new_sync_read+0x100/0x1a0
> [   10.887449]  vfs_read+0x1b4/0x1d8
> [   10.887457]  ksys_read+0x74/0xf8
> [   10.887465]  __arm64_sys_read+0x24/0x30
> [   10.887472]  el0_svc_common.constprop.3+0x7c/0x198
> [   10.887478]  do_el0_svc+0x34/0xa0
> [   10.887486]  el0_sync_handler+0x16c/0x210
> [   10.887492]  el0_sync+0x140/0x180
> [   10.887504] CPU: 6 PID: 342 Comm: systemd-sysctl Not tainted 5.9.13-rc1 #1
> [   10.887510] Hardware name: HiKey Development Board (DT)
> [   10.887515] Call trace:
> [   10.887524]  dump_backtrace+0x0/0x1f8
> [   10.887531]  show_stack+0x2c/0x38
> [   10.887542]  dump_stack+0xec/0x158
> [   10.887552]  lockdep_rcu_suspicious+0xd4/0xf8
> [   10.887561]  ___might_sleep+0x1e4/0x208
> [   10.887569]  __might_sleep+0x54/0x90
> [   10.887577]  __might_fault+0x58/0xa8
> [   10.887584]  filldir64+0x1f0/0x488
> [   10.887593]  call_filldir+0xb0/0x140
> [   10.887600]  ext4_readdir+0x700/0x900
> [   10.887607]  iterate_dir+0x88/0x1d0
> [   10.887615]  __arm64_sys_getdents64+0x70/0x1a0
> [   10.887622]  el0_svc_common.constprop.3+0x7c/0x198
> [   10.887629]  do_el0_svc+0x34/0xa0
> [   10.887637]  el0_sync_handler+0x16c/0x210
> [   10.887644]  el0_sync+0x140/0x180
> [   10.912334] Console: switching to colour frame buffer device 256x72
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> 
> Full boot log link,
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.y/build/v5.9.12-47-g1372e1af58d4/testrun/3538040/suite/linux-log-parser/test/check-kernel-warning-2012813/log
> 
> metadata:
>   git branch: linux-5.9.y
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git commit: 1372e1af58d410676db7917cc3484ca22d471623
>   git describe: v5.9.12-47-g1372e1af58d4
>   make_kernelversion: 5.9.13-rc1
>   kernel-config:
> http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/hikey/lkft/linux-stable-rc-5.9/47/config
> 
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
> 

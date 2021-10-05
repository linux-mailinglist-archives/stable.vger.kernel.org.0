Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20227421EF2
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 08:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbhJEGnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 02:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232361AbhJEGnh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 02:43:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB2466101E;
        Tue,  5 Oct 2021 06:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633416107;
        bh=f3ZK9sPZ3xIV5pqs7xzihpi018YXotDED4kPjdkFiB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O46IOlfbSVozYGhCRIa/Qi5Tp4pqZb4skC4k/lFuuajp98qssgk0/0Gk3FunLefJY
         XkNH4Pw1nyGVFfzS/g1HFpIqwpmeSyf8rWTF6Jsi/8p9AUFfbN51MRRmlpPnXT9Jmp
         JybBW3WcOeaHCfU7N3KW3vQYSRuSAsC9Gjqp7mOU=
Date:   Tue, 5 Oct 2021 08:41:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.14 000/172] 5.14.10-rc1 review
Message-ID: <YVvzqdhF6EJ24Kh5@kroah.com>
References: <20211004125044.945314266@linuxfoundation.org>
 <CA+G9fYuZf8qJJnUMfL8jXScgvX17MLTVDNNXAXYGMS_paBOfHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuZf8qJJnUMfL8jXScgvX17MLTVDNNXAXYGMS_paBOfHg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 09:34:22AM +0530, Naresh Kamboju wrote:
> On Mon, 4 Oct 2021 at 18:43, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.14.10 release.
> > There are 172 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Regression found on i386 and x86.
> following kernel warning reported on stable-rc linux-5.14.y while booting x86.
> 
> metadata:
>   git branch: linux-5.14.y
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git commit: cda15f9c69e08480d4308d0e5c62bd44324a9ff0
>   git describe: v5.14.9-173-gcda15f9c69e0
>   make_kernelversion: 5.14.10-rc1
>   kernel-config:
> http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-stable-rc-5.14/36/config
> 
> Kernel crash:
> --------------
> [   22.356755] =========================
> [   22.360414] WARNING: held lock freed!
> [   22.364071] 5.14.10-rc1 #1 Not tainted
> [   22.367824] -------------------------
> [   22.371489] systemd-network/341 is freeing memory
> ffff9d21cbea0000-ffff9d21cbea06bf, with a lock still held there!
> [   22.381828] ffff9d21cbea0120 (sk_lock-AF_INET){+.+.}-{0:0}, at:
> sk_common_release+0x21/0x100
> [   22.384624] igb 0000:02:00.0 eno2: renamed from eth1
> [   22.390260] 2 locks held by systemd-network/341:
> [   22.390261]  #0: ffff9d21c406eb10
> (&sb->s_type->i_mutex_key#6){+.+.}-{3:3}, at: __sock_release+0x32/0xc0
> [   22.390267]  #1: ffff9d21cbea0120 (sk_lock-AF_INET){+.+.}-{0:0},
> at: sk_common_release+0x21/0x100
> [   22.390272]
> [   22.390272] stack backtrace:
> [   22.390273] CPU: 2 PID: 341 Comm: systemd-network Not tainted 5.14.10-rc1 #1
> [   22.390275] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.0b 07/27/2017
> [   22.390276] Call Trace:
> [   22.390278]  dump_stack_lvl+0x49/0x5e
> [   22.390281]  dump_stack+0x10/0x12
> [   22.390283]  debug_check_no_locks_freed+0x111/0x120
> [   22.390286]  slab_free_freelist_hook+0x119/0x1d0
> [   22.390289]  kmem_cache_free+0x102/0x540
> [   22.390291]  ? __sk_destruct+0x145/0x210
> [   22.390294]  __sk_destruct+0x145/0x210
> [   22.390296]  sk_destruct+0x48/0x50
> [   22.409489] ata_id (348) used greatest stack depth: 11952 bytes left
> [   22.418194]  __sk_free+0x2f/0xc0
> [   22.418198]  sk_free+0x26/0x40
> [   22.418200]  sk_common_release+0xa9/0x100
> [   22.487567]  udp_lib_close+0x9/0x10
> [   22.491057]  inet_release+0x44/0x80
> [   22.494542]  __sock_release+0x42/0xc0
> [   22.498209]  sock_close+0x18/0x20
> [   22.501525]  __fput+0xb5/0x260
> [   22.504578]  ____fput+0xe/0x10
> [   22.507636]  task_work_run+0x6f/0xc0
> [   22.511216]  exit_to_user_mode_prepare+0x1f6/0x200
> [   22.515999]  syscall_exit_to_user_mode+0x1d/0x50
> [   22.520610]  do_syscall_64+0x67/0x80
> [   22.524190]  ? irqentry_exit+0x75/0x80
> [   22.527940]  ? exc_page_fault+0x6c/0x200
> [   22.531859]  ? asm_exc_page_fault+0x8/0x30
> [   22.535950]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   22.541002] RIP: 0033:0x7f52fe67e641
> [   22.544580] Code: f7 d8 64 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f
> 1f 84 00 00 00 00 00 66 90 8b 05 aa cd 20 00 85 c0 75 16 b8 03 00 00
> 00 0f 05 <48> 3d 00 f0 ff ff 77 3f c3 66 0f 1f 44 00 00 53 89 fb 48 83
> ec 10
> [   22.563318] RSP: 002b:00007ffe31761878 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000003
> [   22.570884] RAX: 0000000000000000 RBX: 0000000000000010 RCX: 00007f52fe67e641
> [   22.578007] RDX: 00000000000073b0 RSI: 0000000000000000 RDI: 0000000000000010
> [   22.585130] RBP: 00007f52feed8338 R08: 000055893cf103c3 R09: 0000000000000078
> [   22.592253] R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000
> [   22.599379] R13: 00007ffe317618c0 R14: 0000000000000000 R15: 00007ffe31762a60
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ref:
> https://lkft.validation.linaro.org/scheduler/job/3658919#L1477
> 
> -- 
> Linaro LKFT
> https://lkft.linaro.org

Any chance at bisection?

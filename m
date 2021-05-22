Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D72538D4DE
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 11:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhEVJlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 05:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230040AbhEVJlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 May 2021 05:41:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C5986121E;
        Sat, 22 May 2021 09:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621676381;
        bh=tfF9+YhDr2xfNe6gGZFpVXgjcYb+3uxCebRm62G0ghs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1oiYVz4HZ0MOm2t/lINFcnX81UythZV9nMTunqZ8DChaRYlZkGN/RuHqO70xXRw82
         WXawUYtIDQ3wPNSn3w7ILEQYhg7gTU0lkFISQ9GTarK+S+A3IFS5+1p69JOEUU/Q3W
         4PImVMg1SsCay7yXPQYXk/q1+iwgm/GMG/IrdZRU=
Date:   Sat, 22 May 2021 11:39:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/37] 5.4.121-rc1 review
Message-ID: <YKjRWydp1bRV3SjP@kroah.com>
References: <20210520092052.265851579@linuxfoundation.org>
 <0a9f8458-60a4-e87a-04cb-ed2840d15bbf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a9f8458-60a4-e87a-04cb-ed2840d15bbf@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 09:39:26PM -0700, Florian Fainelli wrote:
> 
> 
> On 5/20/2021 2:22 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.121 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.121-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> Was not able to bisect yet since the nightly tests were running but one
> of our boards caught the following running an ARM 32-bit kernel. The
> same board did not reproduce that warning a second time around, I will
> keep an eye on it. Other than that, everything went well.
> 
> There are no change to RCU, scheduler or kthreads but we do make SMC
> calls for SCMI (power management) so my guess would be that "ARM:
> 9075/1: kernel: Fix interrupted SMC calls" would trigger that. We have
> 15 other boards that run the same configuration but did not catch that.
> 
> # sleep 5
> [   16.864190] bcmgenet 47d580000.ethernet eth0: Link is Up - 1Gbps/Full
> - flow control off
> [   17.568981] ------------[ cut here ]------------
> [   17.573669] WARNING: CPU: 0 PID: 10 at kernel/kthread.c:75
> kthread_is_per_cpu+0x4c/0x50
> [   17.581669] Modules linked in:
> [   17.584726] CPU: 0 PID: 10 Comm: rcu_sched Not tainted
> 5.4.121-1.1pre-g5cdf7521a963 #2
> [   17.592638] Hardware name: Broadcom STB (Flattened Device Tree)
> [   17.598553] Backtrace:
> [   17.601014] [<c0bf79f0>] (dump_backtrace) from [<c0bf7c90>]
> (show_stack+0x20/0x24)
> [   17.608581]  r7:0000004b r6:600b0093 r5:00000000 r4:c20a99d0
> [   17.614244] [<c0bf7c70>] (show_stack) from [<c0c04f48>]
> (dump_stack+0x9c/0xb0)
> [   17.621477] [<c0c04eac>] (dump_stack) from [<c0224b58>]
> (__warn+0xe0/0x108)
> [   17.628432]  r7:0000004b r6:00000009 r5:c0248f64 r4:c0f429cc
> [   17.634087] [<c0224a78>] (__warn) from [<c0bf83b8>]
> (warn_slowpath_fmt+0x70/0xc0)
> [   17.641564]  r7:0000004b r6:c0f429cc r5:c2004c88 r4:00000000
> [   17.647219] [<c0bf834c>] (warn_slowpath_fmt) from [<c0248f64>]
> (kthread_is_per_cpu+0x4c/0x50)
> [   17.655739]  r9:00000000 r8:ceff4200 r7:ceff4200 r6:d05dca5c
> r5:d05dc480 r4:ceff4200
> [   17.663485] [<c0248f18>] (kthread_is_per_cpu) from [<c0259a34>]
> (can_migrate_task+0x1ec/0x24c)
> [   17.672091]  r5:d05dc480 r4:ced25d14
> [   17.675661] [<c0259848>] (can_migrate_task) from [<c025e820>]
> (load_balance+0x394/0xa64)
> [   17.683747]  r10:d05dc480 r9:00000000 r8:d05dca5c r7:ceff4200
> r6:d05dca5c r5:d05dc480
> [   17.691571]  r4:ceff4298 r3:00000200
> [   17.695140] [<c025e48c>] (load_balance) from [<c025fa60>]
> (newidle_balance+0x214/0x508)
> [   17.703140]  r10:d05a3b50 r9:17309672 r8:00000000 r7:c2004cf8
> r6:fffbb4a9 r5:d05a3480
> [   17.710963]  r4:cee6d100
> [   17.713491] [<c025f84c>] (newidle_balance) from [<c025fdc0>]
> (pick_next_task_fair+0x30/0x338)
> [   17.722011]  r10:c0e02774 r9:ced25e54 r8:d059c440 r7:c1f3f480
> r6:ced03600 r5:ced25e54
> [   17.729834]  r4:d05a3480
> [   17.732364] [<c025fd90>] (pick_next_task_fair) from [<c0c08e20>]
> (__schedule+0x120/0x5f8)
> [   17.740537]  r7:c1f3f480 r6:c0e027d4 r5:ced03600 r4:d05a3480
> [   17.746190] [<c0c08d00>] (__schedule) from [<c0c09350>]
> (schedule+0x58/0xd4)
> [   17.753233]  r10:fffbb0c1 r9:d059c440 r8:d059c440 r7:ced25eac
> r6:c2003d00 r5:ced03600
> [   17.761057]  r4:ffffe000
> [   17.763586] [<c0c092f8>] (schedule) from [<c0c0d77c>]
> (schedule_timeout+0x194/0x3a0)
> [   17.771323]  r5:c2004c88 r4:fffbb0c4
> [   17.774901] [<c0c0d5e8>] (schedule_timeout) from [<c0297de4>]
> (rcu_gp_kthread+0x650/0x1300)
> [   17.783247]  r10:c2015900 r9:c2015c64 r8:00000005 r7:c2003d00
> r6:c2015a40 r5:00000000
> [   17.791071]  r4:00000003
> [   17.793598] [<c0297794>] (rcu_gp_kthread) from [<c0248890>]
> (kthread+0x170/0x174)
> [   17.801075]  r7:ced24000
> [   17.803606] [<c0248720>] (kthread) from [<c02010d8>]
> (ret_from_fork+0x14/0x3c)
> [   17.810823] Exception stack(0xced25fb0 to 0xced25ff8)
> [   17.815868] 5fa0:                                     00000000
> 00000000 00000000 00000000
> [   17.824042] 5fc0: 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000
> [   17.832214] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [   17.838822]  r10:00000000 r9:00000000 r8:00000000 r7:00000000
> r6:00000000 r5:c0248720
> [   17.846646]  r4:cece8980
> [   17.849171] ---[ end trace ccac79dc167b02d7 ]---
> # ping -c 2 192.168.1.254
> PING 192.168.1.254 (192.168.1.254): 56 data bytes
> 64 bytes from 192.168.1.254: seq=0 ttl=64 time=0.636 ms
> 64 bytes from 192.168.1.254: seq=1 ttl=64 time=0.310 ms

Odd.  Let me know if you can bisect this down to an offending commit.

thanks,

greg k-h

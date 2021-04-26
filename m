Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034D136B02C
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 11:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhDZJGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 05:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232068AbhDZJGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 05:06:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0BCC61001;
        Mon, 26 Apr 2021 09:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619427942;
        bh=RPVEzH89LdDz+18RiANymiSp2qhrJ+TwA0Z1Q0cns8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zVBtfoXgAr8Wg8QdmWf9uoAMtSDyzGt6I2dOmPjVEG6X9Zlb+sI/eGA1jNV+xdQdE
         2sWOxIWNSq4ftY+D7uLhc8SX+DV4N+7eGlD4iiGkV5qcuJJgN7GGhE1NsLezGAaZMd
         QwuQ+yoH70MyHQbSDgYcLOKMJICnzgyKpZjan/Xw=
Date:   Mon, 26 Apr 2021 11:05:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hanjun Guo <guohanjun@huawei.com>
Cc:     He Ying <heying24@huawei.com>, patchwork@huawei.com,
        huawei.libin@huawei.com, yangerkun@huawei.com, xiexiuqi@huawei.com,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH hulk-4.19-next] irqchip/gic-v3: Do not enable irqs when
 handling spurious interrups
Message-ID: <YIaCYxauSWtHA8wr@kroah.com>
References: <20210426023929.89400-1-heying24@huawei.com>
 <YIZSLWRYa+VzZfrm@kroah.com>
 <bd1206d7-e23d-59b2-6fbb-9938d3dc27a1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd1206d7-e23d-59b2-6fbb-9938d3dc27a1@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 04:44:45PM +0800, Hanjun Guo wrote:
> On 2021/4/26 13:39, Greg KH wrote:
> > On Sun, Apr 25, 2021 at 10:39:29PM -0400, He Ying wrote:
> > > hulk inclusion
> > > category: bugfix
> > > bugzilla: NA
> > > DTS: NA
> > > CVE: NA
> > > 
> > > --------------------------------
> > > 
> > > We triggered the following error while running our 4.19 kernel
> > > with the pseudo-NMI patches backported to it:
> > > 
> > > [   14.816231] ------------[ cut here ]------------
> > > [   14.816231] kernel BUG at irq.c:99!
> > > [   14.816232] Internal error: Oops - BUG: 0 [#1] SMP
> > > [   14.816232] Process swapper/0 (pid: 0, stack limit = 0x(____ptrval____))
> > > [   14.816233] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           O      4.19.95.aarch64 #14
> > > [   14.816233] Hardware name: evb (DT)
> > > [   14.816234] pstate: 80400085 (Nzcv daIf +PAN -UAO)
> > > [   14.816234] pc : asm_nmi_enter+0x94/0x98
> > > [   14.816235] lr : asm_nmi_enter+0x18/0x98
> > > [   14.816235] sp : ffff000008003c50
> > > [   14.816235] pmr_save: 00000070
> > > [   14.816237] x29: ffff000008003c50 x28: ffff0000095f56c0
> > > [   14.816238] x27: 0000000000000000 x26: ffff000008004000
> > > [   14.816239] x25: 00000000015e0000 x24: ffff8008fb916000
> > > [   14.816240] x23: 0000000020400005 x22: ffff0000080817cc
> > > [   14.816241] x21: ffff000008003da0 x20: 0000000000000060
> > > [   14.816242] x19: 00000000000003ff x18: ffffffffffffffff
> > > [   14.816243] x17: 0000000000000008 x16: 003d090000000000
> > > [   14.816244] x15: ffff0000095ea6c8 x14: ffff8008fff5ab40
> > > [   14.816244] x13: ffff8008fff58b9d x12: 0000000000000000
> > > [   14.816245] x11: ffff000008c8a200 x10: 000000008e31fca5
> > > [   14.816246] x9 : ffff000008c8a208 x8 : 000000000000000f
> > > [   14.816247] x7 : 0000000000000004 x6 : ffff8008fff58b9e
> > > [   14.816248] x5 : 0000000000000000 x4 : 0000000080000000
> > > [   14.816249] x3 : 0000000000000000 x2 : 0000000080000000
> > > [   14.816250] x1 : 0000000000120000 x0 : ffff0000095f56c0
> > > [   14.816251] Call trace:
> > > [   14.816251]  asm_nmi_enter+0x94/0x98
> > > [   14.816251]  el1_irq+0x8c/0x180                    (IRQ C)
> > > [   14.816252]  gic_handle_irq+0xbc/0x2e4
> > > [   14.816252]  el1_irq+0xcc/0x180                    (IRQ B)
> > > [   14.816253]  arch_timer_handler_virt+0x38/0x58
> > > [   14.816253]  handle_percpu_devid_irq+0x90/0x240
> > > [   14.816253]  generic_handle_irq+0x34/0x50
> > > [   14.816254]  __handle_domain_irq+0x68/0xc0
> > > [   14.816254]  gic_handle_irq+0xf8/0x2e4
> > > [   14.816255]  el1_irq+0xcc/0x180                    (IRQ A)
> > > [   14.816255]  arch_cpu_idle+0x34/0x1c8
> > > [   14.816255]  default_idle_call+0x24/0x44
> > > [   14.816256]  do_idle+0x1d0/0x2c8
> > > [   14.816256]  cpu_startup_entry+0x28/0x30
> > > [   14.816256]  rest_init+0xb8/0xc8
> > > [   14.816257]  start_kernel+0x4c8/0x4f4
> > > [   14.816257] Code: 940587f1 d5384100 b9401001 36a7fd01 (d4210000)
> > > [   14.816258] Modules linked in: start_dp(O) smeth(O)
> > > [   15.103092] ---[ end trace 701753956cb14aa8 ]---
> > > [   15.103093] Kernel panic - not syncing: Fatal exception in interrupt
> > > [   15.103099] SMP: stopping secondary CPUs
> > > [   15.103100] Kernel Offset: disabled
> > > [   15.103100] CPU features: 0x36,a2400218
> > > [   15.103100] Memory Limit: none
> > > 
> > > which is cause by a 'BUG_ON(in_nmi())' in nmi_enter().
> > > 
> > > >From the call trace, we can find three interrupts (noted A, B, C above):
> > > interrupt (A) is preempted by (B), which is further interrupted by (C).
> > > 
> > > Subsequent investigations show that (B) results in nmi_enter() being
> > > called, but that it actually is a spurious interrupt. Furthermore,
> > > interrupts are reenabled in the context of (B), and (C) fires with
> > > NMI priority. We end-up with a nested NMI situation, something
> > > we definitely do not want to (and cannot) handle.
> > > 
> > > The bug here is that spurious interrupts should never result in any
> > > state change, and we should just return to the interrupted context.
> > > Moving the handling of spurious interrupts as early as possible in
> > > the GICv3 handler fixes this issue.
> > > 
> > > Fixes: 3f1f3234bc2d ("irqchip/gic-v3: Switch to PMR masking before calling IRQ handler")
> > 
> > This commit is in 5.1, not 4.19.
> > 
> > How are you hitting this?
> > 
> > What are we supposed to do wit this patch?
> > 
> > confused,
> 
> Sorry for the noise, we have an internally used kernel which is based
> on LTS 4.19 kernel, and we backported some mainline features including
> the pseudo NMI for ARM64, that's why we backporting the following
> bugfixes as well.
> 
> I didn't notice it was cced stable and Marc as well, and adding
> my review tag (for internally review process), sorry.

Not a problem, thanks for letting us know.

greg k-h

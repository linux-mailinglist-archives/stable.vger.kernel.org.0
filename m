Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CE936AC2B
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 08:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhDZG3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 02:29:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:17401 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbhDZG3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 02:29:06 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FTFKB4hgbzlYfV;
        Mon, 26 Apr 2021 14:26:22 +0800 (CST)
Received: from [10.67.110.136] (10.67.110.136) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Mon, 26 Apr 2021 14:28:15 +0800
Subject: Re: [PATCH hulk-4.19-next] irqchip/gic-v3: Do not enable irqs when
 handling spurious interrups
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <patchwork@huawei.com>, <huawei.libin@huawei.com>,
        <yangerkun@huawei.com>, <xiexiuqi@huawei.com>,
        <guohanjun@huawei.com>, Marc Zyngier <maz@kernel.org>,
        <stable@vger.kernel.org>
References: <20210426023929.89400-1-heying24@huawei.com>
 <YIZSLWRYa+VzZfrm@kroah.com>
From:   He Ying <heying24@huawei.com>
Message-ID: <25325534-5c4a-2dbe-be06-5945e4af3e48@huawei.com>
Date:   Mon, 26 Apr 2021 14:28:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YIZSLWRYa+VzZfrm@kroah.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.110.136]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Sorry to bother you. This email was meant to be sent internally. I 
forgot to suppress cc.


ÔÚ 2021/4/26 13:39, Greg KH Ð´µÀ:
> On Sun, Apr 25, 2021 at 10:39:29PM -0400, He Ying wrote:
>> hulk inclusion
>> category: bugfix
>> bugzilla: NA
>> DTS: NA
>> CVE: NA
>>
>> --------------------------------
>>
>> We triggered the following error while running our 4.19 kernel
>> with the pseudo-NMI patches backported to it:
>>
>> [   14.816231] ------------[ cut here ]------------
>> [   14.816231] kernel BUG at irq.c:99!
>> [   14.816232] Internal error: Oops - BUG: 0 [#1] SMP
>> [   14.816232] Process swapper/0 (pid: 0, stack limit = 0x(____ptrval____))
>> [   14.816233] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           O      4.19.95.aarch64 #14
>> [   14.816233] Hardware name: evb (DT)
>> [   14.816234] pstate: 80400085 (Nzcv daIf +PAN -UAO)
>> [   14.816234] pc : asm_nmi_enter+0x94/0x98
>> [   14.816235] lr : asm_nmi_enter+0x18/0x98
>> [   14.816235] sp : ffff000008003c50
>> [   14.816235] pmr_save: 00000070
>> [   14.816237] x29: ffff000008003c50 x28: ffff0000095f56c0
>> [   14.816238] x27: 0000000000000000 x26: ffff000008004000
>> [   14.816239] x25: 00000000015e0000 x24: ffff8008fb916000
>> [   14.816240] x23: 0000000020400005 x22: ffff0000080817cc
>> [   14.816241] x21: ffff000008003da0 x20: 0000000000000060
>> [   14.816242] x19: 00000000000003ff x18: ffffffffffffffff
>> [   14.816243] x17: 0000000000000008 x16: 003d090000000000
>> [   14.816244] x15: ffff0000095ea6c8 x14: ffff8008fff5ab40
>> [   14.816244] x13: ffff8008fff58b9d x12: 0000000000000000
>> [   14.816245] x11: ffff000008c8a200 x10: 000000008e31fca5
>> [   14.816246] x9 : ffff000008c8a208 x8 : 000000000000000f
>> [   14.816247] x7 : 0000000000000004 x6 : ffff8008fff58b9e
>> [   14.816248] x5 : 0000000000000000 x4 : 0000000080000000
>> [   14.816249] x3 : 0000000000000000 x2 : 0000000080000000
>> [   14.816250] x1 : 0000000000120000 x0 : ffff0000095f56c0
>> [   14.816251] Call trace:
>> [   14.816251]  asm_nmi_enter+0x94/0x98
>> [   14.816251]  el1_irq+0x8c/0x180                    (IRQ C)
>> [   14.816252]  gic_handle_irq+0xbc/0x2e4
>> [   14.816252]  el1_irq+0xcc/0x180                    (IRQ B)
>> [   14.816253]  arch_timer_handler_virt+0x38/0x58
>> [   14.816253]  handle_percpu_devid_irq+0x90/0x240
>> [   14.816253]  generic_handle_irq+0x34/0x50
>> [   14.816254]  __handle_domain_irq+0x68/0xc0
>> [   14.816254]  gic_handle_irq+0xf8/0x2e4
>> [   14.816255]  el1_irq+0xcc/0x180                    (IRQ A)
>> [   14.816255]  arch_cpu_idle+0x34/0x1c8
>> [   14.816255]  default_idle_call+0x24/0x44
>> [   14.816256]  do_idle+0x1d0/0x2c8
>> [   14.816256]  cpu_startup_entry+0x28/0x30
>> [   14.816256]  rest_init+0xb8/0xc8
>> [   14.816257]  start_kernel+0x4c8/0x4f4
>> [   14.816257] Code: 940587f1 d5384100 b9401001 36a7fd01 (d4210000)
>> [   14.816258] Modules linked in: start_dp(O) smeth(O)
>> [   15.103092] ---[ end trace 701753956cb14aa8 ]---
>> [   15.103093] Kernel panic - not syncing: Fatal exception in interrupt
>> [   15.103099] SMP: stopping secondary CPUs
>> [   15.103100] Kernel Offset: disabled
>> [   15.103100] CPU features: 0x36,a2400218
>> [   15.103100] Memory Limit: none
>>
>> which is cause by a 'BUG_ON(in_nmi())' in nmi_enter().
>>
>> >From the call trace, we can find three interrupts (noted A, B, C above):
>> interrupt (A) is preempted by (B), which is further interrupted by (C).
>>
>> Subsequent investigations show that (B) results in nmi_enter() being
>> called, but that it actually is a spurious interrupt. Furthermore,
>> interrupts are reenabled in the context of (B), and (C) fires with
>> NMI priority. We end-up with a nested NMI situation, something
>> we definitely do not want to (and cannot) handle.
>>
>> The bug here is that spurious interrupts should never result in any
>> state change, and we should just return to the interrupted context.
>> Moving the handling of spurious interrupts as early as possible in
>> the GICv3 handler fixes this issue.
>>
>> Fixes: 3f1f3234bc2d ("irqchip/gic-v3: Switch to PMR masking before calling IRQ handler")
> This commit is in 5.1, not 4.19.
>
> How are you hitting this?
>
> What are we supposed to do wit this patch?
>
> confused,

Our kernel is 4.19, but has backported pseudo-NMI patches from higher 
version, including

this commit of course. This point is written in the commit msg.


Marc Zyngier and Mark Rutland acked the origional patch and accepted it. 
Maybe you can

review the origional one which is titled as "[PATCH v2] irqchip/gic-v3: 
Do not enable irqs

when handling spurious interrups".


Sorry again to bother you.


Thanks.


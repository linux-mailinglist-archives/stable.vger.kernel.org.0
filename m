Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE94A4A46AB
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 13:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359140AbiAaMOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 07:14:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40318 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359489AbiAaMOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 07:14:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22AB660FB5;
        Mon, 31 Jan 2022 12:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF5EC340E8;
        Mon, 31 Jan 2022 12:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643631281;
        bh=tKoPLp67gjFjMhDzuFz3EmTYWN5hO2IqTUY/OW5vmLI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FR0hgiRXzb71oLsnXUHru/qJmCbaojPo4/mNPPHYJOGWksYFKnth+2bpGNHIk9Rkj
         IlrsquLPbRBKKpzDK6R9ffpGrXQIgAqWzR1G8WLqIU3hNcPaJe0uBqKAfkWROkp2e+
         uGg6MKDRAWfeegMjftke98DqcBTVfo+ERhTAUELO3iE8FOLnTZ5Gebt28wRXzU8cWw
         6pUJCE9WW+xlL9wngdgqMqwfWWqdITbkG27fuCByFk4YH06wvnMkWqmpzpttGHrn0y
         8ZwjB7bT6HtKTdbE/ad7blJn7q2B8KKdO5Zc7Ro+MtUeQFUreHbNhNEhJzqyKlYJxH
         AA0QvoJbUDbPg==
Received: by mail-wr1-f51.google.com with SMTP id c23so25015614wrb.5;
        Mon, 31 Jan 2022 04:14:41 -0800 (PST)
X-Gm-Message-State: AOAM532Rry2Hg3BU3wLimzQdPq2OOC+vS+OJeQMAk3TeFUg5+TX1/F/Y
        ujbTlnWO1Fb0IbhoKc/i+uD49tgGeDf3EU5PXEQ=
X-Google-Smtp-Source: ABdhPJwtJICpdNQtjXyznRxLoXhSaZ1cdbyP+Vst6bgTfhhQ4vqvLkq7mPZnBWfDFwPmkthzouwRa5H/48CryKZXw8Q=
X-Received: by 2002:a05:6000:1107:: with SMTP id z7mr17231316wrw.189.1643631279820;
 Mon, 31 Jan 2022 04:14:39 -0800 (PST)
MIME-Version: 1.0
References: <20220131105215.644174521@linuxfoundation.org> <20220131105216.796938973@linuxfoundation.org>
In-Reply-To: <20220131105216.796938973@linuxfoundation.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 31 Jan 2022 13:14:28 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEOTRBdSXrmWSZ2hj+cksWYHeZOnoZAxwVHcPtowUhFSg@mail.gmail.com>
Message-ID: <CAMj1kXEOTRBdSXrmWSZ2hj+cksWYHeZOnoZAxwVHcPtowUhFSg@mail.gmail.com>
Subject: Re: [PATCH 5.4 33/64] ARM: 9170/1: fix panic when kasan and kprobe
 are enabled
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        huangshaobo <huangshaobo6@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022 at 11:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: sparkhuang <huangshaobo6@huawei.com>
>
> commit 8b59b0a53c840921b625378f137e88adfa87647e upstream.
>
> arm32 uses software to simulate the instruction replaced
> by kprobe. some instructions may be simulated by constructing
> assembly functions. therefore, before executing instruction
> simulation, it is necessary to construct assembly function
> execution environment in C language through binding registers.
> after kasan is enabled, the register binding relationship will
> be destroyed, resulting in instruction simulation errors and
> causing kernel panic.
>
> the kprobe emulate instruction function is distributed in three
> files: actions-common.c actions-arm.c actions-thumb.c, so disable
> KASAN when compiling these files.
>
> for example, use kprobe insert on cap_capable+20 after kasan
> enabled, the cap_capable assembly code is as follows:
> <cap_capable>:
> e92d47f0        push    {r4, r5, r6, r7, r8, r9, sl, lr}
> e1a05000        mov     r5, r0
> e280006c        add     r0, r0, #108    ; 0x6c
> e1a04001        mov     r4, r1
> e1a06002        mov     r6, r2
> e59fa090        ldr     sl, [pc, #144]  ;
> ebfc7bf8        bl      c03aa4b4 <__asan_load4>
> e595706c        ldr     r7, [r5, #108]  ; 0x6c
> e2859014        add     r9, r5, #20
> ......
> The emulate_ldr assembly code after enabling kasan is as follows:
> c06f1384 <emulate_ldr>:
> e92d47f0        push    {r4, r5, r6, r7, r8, r9, sl, lr}
> e282803c        add     r8, r2, #60     ; 0x3c
> e1a05000        mov     r5, r0
> e7e37855        ubfx    r7, r5, #16, #4
> e1a00008        mov     r0, r8
> e1a09001        mov     r9, r1
> e1a04002        mov     r4, r2
> ebf35462        bl      c03c6530 <__asan_load4>
> e357000f        cmp     r7, #15
> e7e36655        ubfx    r6, r5, #12, #4
> e205a00f        and     sl, r5, #15
> 0a000001        beq     c06f13bc <emulate_ldr+0x38>
> e0840107        add     r0, r4, r7, lsl #2
> ebf3545c        bl      c03c6530 <__asan_load4>
> e084010a        add     r0, r4, sl, lsl #2
> ebf3545a        bl      c03c6530 <__asan_load4>
> e2890010        add     r0, r9, #16
> ebf35458        bl      c03c6530 <__asan_load4>
> e5990010        ldr     r0, [r9, #16]
> e12fff30        blx     r0
> e356000f        cm      r6, #15
> 1a000014        bne     c06f1430 <emulate_ldr+0xac>
> e1a06000        mov     r6, r0
> e2840040        add     r0, r4, #64     ; 0x40
> ......
>
> when running in emulate_ldr to simulate the ldr instruction, panic
> occurred, and the log is as follows:
> Unable to handle kernel NULL pointer dereference at virtual address
> 00000090
> pgd = ecb46400
> [00000090] *pgd=2e0fa003, *pmd=00000000
> Internal error: Oops: 206 [#1] SMP ARM
> PC is at cap_capable+0x14/0xb0
> LR is at emulate_ldr+0x50/0xc0
> psr: 600d0293 sp : ecd63af8  ip : 00000004  fp : c0a7c30c
> r10: 00000000  r9 : c30897f4  r8 : ecd63cd4
> r7 : 0000000f  r6 : 0000000a  r5 : e59fa090  r4 : ecd63c98
> r3 : c06ae294  r2 : 00000000  r1 : b7611300  r0 : bf4ec008
> Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: 32c5387d  Table: 2d546400  DAC: 55555555
> Process bash (pid: 1643, stack limit = 0xecd60190)
> (cap_capable) from (kprobe_handler+0x218/0x340)
> (kprobe_handler) from (kprobe_trap_handler+0x24/0x48)
> (kprobe_trap_handler) from (do_undefinstr+0x13c/0x364)
> (do_undefinstr) from (__und_svc_finish+0x0/0x30)
> (__und_svc_finish) from (cap_capable+0x18/0xb0)
> (cap_capable) from (cap_vm_enough_memory+0x38/0x48)
> (cap_vm_enough_memory) from
> (security_vm_enough_memory_mm+0x48/0x6c)
> (security_vm_enough_memory_mm) from
> (copy_process.constprop.5+0x16b4/0x25c8)
> (copy_process.constprop.5) from (_do_fork+0xe8/0x55c)
> (_do_fork) from (SyS_clone+0x1c/0x24)
> (SyS_clone) from (__sys_trace_return+0x0/0x10)
> Code: 0050a0e1 6c0080e2 0140a0e1 0260a0e1 (f801f0e7)
>
> Fixes: 35aa1df43283 ("ARM kprobes: instruction single-stepping support")
> Fixes: 421015713b30 ("ARM: 9017/2: Enable KASan for ARM")
> Signed-off-by: huangshaobo <huangshaobo6@huawei.com>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Probably a bit late to mention this but v5.4 does not support KASAN on
ARM, so this patch is fairly pointless.

> ---
>  arch/arm/probes/kprobes/Makefile |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- a/arch/arm/probes/kprobes/Makefile
> +++ b/arch/arm/probes/kprobes/Makefile
> @@ -1,4 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
> +KASAN_SANITIZE_actions-common.o := n
> +KASAN_SANITIZE_actions-arm.o := n
> +KASAN_SANITIZE_actions-thumb.o := n
>  obj-$(CONFIG_KPROBES)          += core.o actions-common.o checkers-common.o
>  obj-$(CONFIG_ARM_KPROBES_TEST) += test-kprobes.o
>  test-kprobes-objs              := test-core.o
>
>

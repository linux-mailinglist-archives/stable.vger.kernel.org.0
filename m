Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663F6583F1E
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 14:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238820AbiG1Mmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 08:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238137AbiG1Mmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 08:42:50 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA924F6AE;
        Thu, 28 Jul 2022 05:42:49 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id 125so1492118vsx.7;
        Thu, 28 Jul 2022 05:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jg5lIrA1Nmh5UvhPYy2QWqb9BuZ3z6KhgX1vk09dz9U=;
        b=j7gGVeWa7IKZYsj05ig/vAcIMFEYG/zKbqMHKlDAcg/dGOiWPgVmby6Y6VzMKdgOeh
         nGg33aFwhMtFOq/bcKB7Y0ISqBeho4vrfqCs91vh5lvxpwK4+Aei2eGunNRcW8x1Pung
         wlIRgBybj3Ap/GA/NZt1Yx6syqcCJCrcd5H3jYfEK1/5yLMM8iJDkwRHE2dTzO0rHpZZ
         7IvyQG4XpnTTYN2GykTh1oKCSIGnmcc2kek75GtemfAMVeBHrTRLCIylfmEDF6Yxww+v
         lep5xuZjMeX8fmpRbzJ/rqe9i4cOZKkqiHMcgCpfEM6ei3FYkSHv4scpxadtVD7GfFfl
         2Fpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jg5lIrA1Nmh5UvhPYy2QWqb9BuZ3z6KhgX1vk09dz9U=;
        b=FZ8f70sWQSKuRk4EEw/pKReHUCT80jvYF4rWfaubna4f7x2yL2qX+dTqeXbavZL8NU
         uPaz5u/DRKmg+DlrSBJe9kYm2aNxHGNYB8M91Q0YnYjZQaOzFSMrKJRHbR5uNnztOzYE
         5uxNKGEvBmZ5ze65nTTMCEglxRzLxz5DWtjJbeUwWn/ILa3VWzq1GOWfQLtwF1td4nXl
         OngufnXpOK0/zN1cvV9qZrieC4j8U17E9mmRWq9yGsOtS4wGiRgzSgYBYmiIgMDG6zPB
         SkSKZ+fOS0H7gSXf/UnRiD0bmGZ3pj0MUMOUiy6Xtq0Sho5jUuAP1H0IEjj10Hyx7qZO
         Xo2g==
X-Gm-Message-State: AJIora83Z7MC4/wVRwukO8S89Zx9vic5PomLiaFxpBy7xmA7NhlMrdsj
        3aluMQ8x0DTRMuKyLEXxCHSJMwdUlzS2qbnfMEmPsySG
X-Google-Smtp-Source: AGRyM1t6xQ7l9gz0UG1rjgaRRZ0gfywDfvIoZKHm4fUPan868K5+fzofemzf+hOPVqIL8yJYJUGU414xnZvYkZqKzNk=
X-Received: by 2002:a67:e307:0:b0:358:5896:c0a1 with SMTP id
 j7-20020a67e307000000b003585896c0a1mr6752177vsf.70.1659012168634; Thu, 28 Jul
 2022 05:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220714084136.570176-1-chenhuacai@loongson.cn> <20220714084136.570176-2-chenhuacai@loongson.cn>
In-Reply-To: <20220714084136.570176-2-chenhuacai@loongson.cn>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Thu, 28 Jul 2022 20:42:35 +0800
Message-ID: <CAAhV-H7W8V8XdJXX5FvyvvSCAbeTSgLEKhHLivm89T-Nd59Umw@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] LoongArch: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
To:     Huacai Chen <chenhuacai@loongson.cn>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, loongarch@lists.linux.dev,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Guo Ren <guoren@kernel.org>,
        Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Arnd,

Since the SH maintainer hasn't responded, I suppose it is better to
let both LoongArch fix and SH fix go through your asm-generic tree?

Huacai

On Thu, Jul 14, 2022 at 4:41 PM Huacai Chen <chenhuacai@loongson.cn> wrote:
>
> When CONFIG_CPUMASK_OFFSTACK and CONFIG_DEBUG_PER_CPU_MAPS is selected,
> cpu_max_bits_warn() generates a runtime warning similar as below while
> we show /proc/cpuinfo. Fix this by using nr_cpu_ids (the runtime limit)
> instead of NR_CPUS to iterate CPUs.
>
> [    3.052463] ------------[ cut here ]------------
> [    3.059679] WARNING: CPU: 3 PID: 1 at include/linux/cpumask.h:108 show_cpuinfo+0x5e8/0x5f0
> [    3.070072] Modules linked in: efivarfs autofs4
> [    3.076257] CPU: 0 PID: 1 Comm: systemd Not tainted 5.19-rc5+ #1052
> [    3.084034] Hardware name: Loongson Loongson-3A5000-7A1000-1w-V0.1-CRB/Loongson-LS3A5000-7A1000-1w-EVB-V1.21, BIOS Loongson-UDK2018-V2.0.04082-beta7 04/27
> [    3.099465] Stack : 9000000100157b08 9000000000f18530 9000000000cf846c 9000000100154000
> [    3.109127]         9000000100157a50 0000000000000000 9000000100157a58 9000000000ef7430
> [    3.118774]         90000001001578e8 0000000000000040 0000000000000020 ffffffffffffffff
> [    3.128412]         0000000000aaaaaa 1ab25f00eec96a37 900000010021de80 900000000101c890
> [    3.138056]         0000000000000000 0000000000000000 0000000000000000 0000000000aaaaaa
> [    3.147711]         ffff8000339dc220 0000000000000001 0000000006ab4000 0000000000000000
> [    3.157364]         900000000101c998 0000000000000004 9000000000ef7430 0000000000000000
> [    3.167012]         0000000000000009 000000000000006c 0000000000000000 0000000000000000
> [    3.176641]         9000000000d3de08 9000000001639390 90000000002086d8 00007ffff0080286
> [    3.186260]         00000000000000b0 0000000000000004 0000000000000000 0000000000071c1c
> [    3.195868]         ...
> [    3.199917] Call Trace:
> [    3.203941] [<90000000002086d8>] show_stack+0x38/0x14c
> [    3.210666] [<9000000000cf846c>] dump_stack_lvl+0x60/0x88
> [    3.217625] [<900000000023d268>] __warn+0xd0/0x100
> [    3.223958] [<9000000000cf3c90>] warn_slowpath_fmt+0x7c/0xcc
> [    3.231150] [<9000000000210220>] show_cpuinfo+0x5e8/0x5f0
> [    3.238080] [<90000000004f578c>] seq_read_iter+0x354/0x4b4
> [    3.245098] [<90000000004c2e90>] new_sync_read+0x17c/0x1c4
> [    3.252114] [<90000000004c5174>] vfs_read+0x138/0x1d0
> [    3.258694] [<90000000004c55f8>] ksys_read+0x70/0x100
> [    3.265265] [<9000000000cfde9c>] do_syscall+0x7c/0x94
> [    3.271820] [<9000000000202fe4>] handle_syscall+0xc4/0x160
> [    3.281824] ---[ end trace 8b484262b4b8c24c ]---
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>  arch/loongarch/kernel/proc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/kernel/proc.c b/arch/loongarch/kernel/proc.c
> index e0b5f3b031b1..b12a1f21f864 100644
> --- a/arch/loongarch/kernel/proc.c
> +++ b/arch/loongarch/kernel/proc.c
> @@ -106,7 +106,7 @@ static void *c_start(struct seq_file *m, loff_t *pos)
>  {
>         unsigned long i = *pos;
>
> -       return i < NR_CPUS ? (void *)(i + 1) : NULL;
> +       return i < nr_cpu_ids ? (void *)(i + 1) : NULL;
>  }
>
>  static void *c_next(struct seq_file *m, void *v, loff_t *pos)
> --
> 2.31.1
>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2C748B188
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 17:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240422AbiAKQET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 11:04:19 -0500
Received: from mail-vk1-f173.google.com ([209.85.221.173]:36636 "EHLO
        mail-vk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240042AbiAKQET (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 11:04:19 -0500
Received: by mail-vk1-f173.google.com with SMTP id d189so10690727vkg.3;
        Tue, 11 Jan 2022 08:04:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RIfSf8RUH0htO7ClMjULi1Y2Og1NiFoaaMK0wKyXP44=;
        b=sFsbZTU4eg7O6HW8mvk897FL7jHMGjTvuplsZ1s9OK7pUjVcL7qlgufti8lKPJCtxn
         5FSW7mD96qlhjh2Z21Nv56GGHSY9prdTo+j67kQZSw29mw6G1tFAfLZANSh6fOZDcyZ1
         H6DfZcBgMHKoT+TGNEPrskkcp+QBANAvhct6pPhXyCafJiPP/N0V+EJvZ6Zj+EIORNty
         gBZ/P3AByPD1y+aOftkXsqARFTMD174KKLzi1f7O2JE/4+DYw8MDLPcHFMfNeW8nMzzf
         I/QsZKu/MRHdXSZHYoC2ACuP4l5OrNYLjf6p4Kp+Bwi5Lfy2EKS1Q5a2A26jQLImUho+
         1Sow==
X-Gm-Message-State: AOAM531pPcBIW9auk3Wt/2s7vhBLQ0OkOZX0m3xKGClRBR2maFUOHMM2
        dCxDJqSg5eN3UT9yNZWaqrAu9jHzoh11Xg==
X-Google-Smtp-Source: ABdhPJyelwaNtTr0KwiQjPC/D/sy46J/j8caHJnhTyqNiDlMiJaa6wobsWWhqPLW8A/+HfZ5zoUl1w==
X-Received: by 2002:a05:6122:208a:: with SMTP id i10mr2644747vkd.18.1641917058723;
        Tue, 11 Jan 2022 08:04:18 -0800 (PST)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id p187sm584817vke.34.2022.01.11.08.04.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 08:04:17 -0800 (PST)
Received: by mail-ua1-f51.google.com with SMTP id x33so29332562uad.12;
        Tue, 11 Jan 2022 08:04:16 -0800 (PST)
X-Received: by 2002:ab0:2118:: with SMTP id d24mr2301575ual.78.1641917056493;
 Tue, 11 Jan 2022 08:04:16 -0800 (PST)
MIME-Version: 1.0
References: <20211119164413.29052-1-palmer@rivosinc.com> <20211119164413.29052-3-palmer@rivosinc.com>
In-Reply-To: <20211119164413.29052-3-palmer@rivosinc.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 11 Jan 2022 17:04:05 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXQg942-DwDBJANsFiOCqyAwCt_GwW4HuC1nh0_DNmyEQ@mail.gmail.com>
Message-ID: <CAMuHMdXQg942-DwDBJANsFiOCqyAwCt_GwW4HuC1nh0_DNmyEQ@mail.gmail.com>
Subject: Re: [PATCH 02/12] RISC-V: MAXPHYSMEM_2GB doesn't depend on CMODEL_MEDLOW
To:     Palmer Dabbelt <palmer@rivosinc.com>
Cc:     linux-riscv <linux-riscv@lists.infradead.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        heinrich.schuchardt@canonical.com,
        Atish Patra <atish.patra@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Palmer,

On Fri, Nov 19, 2021 at 5:47 PM Palmer Dabbelt <palmer@rivosinc.com> wrote:
> From: Palmer Dabbelt <palmer@rivosinc.com>
>
> For non-relocatable kernels we need to be able to link the kernel at
> approximately PAGE_OFFSET, thus requiring medany (as medlow requires the
> code to be linked within 2GiB of 0).  The inverse doesn't apply, though:
> since medany code can be linked anywhere it's fine to link it close to
> 0, so we can support the smaller memory config.
>
> Fixes: de5f4b8f634b ("RISC-V: Define MAXPHYSMEM_1GB only for RV32")
> Cc: stable@vger.kernel.org
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

Thanks for your patch, which is now commit 9f36b96bc70f9707 ("RISC-V:
MAXPHYSMEM_2GB doesn't depend on CMODEL_MEDLOW").

> I found this when going through the savedefconfig diffs for the K210
> defconfigs.  I'm not entirely sure they're doing the right thing here
> (they should probably be setting CMODEL_LOW to take advantage of the
> better code generation), but I don't have any way to test those
> platforms so I don't want to change too much.

I can confirm MAXPHYSMEM_2GB works on K210 with CMODEL_MEDANY.

As the Icicle has 1760 MiB of RAM, I gave it a try with MAXPHYSMEM_2GB
(and CMODEL_MEDANY), too.  Unfortunately it crashes very early
(needs earlycon to see):

    OF: fdt: Ignoring memory range 0x80000000 - 0x80200000
    Machine model: Microchip PolarFire-SoC Icicle Kit
    printk: debug: ignoring loglevel setting.
    earlycon: ns16550a0 at MMIO32 0x0000000020100000 (options '115200n8')
    printk: bootconsole [ns16550a0] enabled
    printk: debug: skip boot console de-registration.
    efi: UEFI not found.
    Unable to handle kernel paging request at virtual address ffffffff87e00001
    Oops [#1]
    Modules linked in:
    CPU: 0 PID: 0 Comm: swapper Not tainted 5.16.0-08771-g85515233477d #56
    Hardware name: Microchip PolarFire-SoC Icicle Kit (DT)
    epc : fdt_check_header+0x14/0x208
     ra : early_init_dt_verify+0x16/0x94
    epc : ffffffff802ddacc ra : ffffffff8082415a sp : ffffffff81203ee0
     gp : ffffffff812ec3a8 tp : ffffffff8120cd80 t0 : 0000000000000005
     t1 : 0000001040000000 t2 : ffffffff80000000 s0 : ffffffff81203f00
     s1 : ffffffff87e00000 a0 : ffffffff87e00000 a1 : 000000040ffffce7
     a2 : 00000000000000e7 a3 : ffffffff8080394c a4 : 0000000000000000
     a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000000000000
     s2 : ffffffff81203f98 s3 : 8000000a00006800 s4 : fffffffffffffff3
     s5 : 0000000000000000 s6 : 0000000000000001 s7 : 0000000000000000
     s8 : 0000000020236c20 s9 : 0000000000000000 s10: 0000000000000000
     s11: 0000000000000000 t3 : 0000000000000018 t4 : 00ff000000000000
     t5 : 0000000000000000 t6 : 0000000000000010
    status: 0000000200000100 badaddr: ffffffff87e00001 cause: 000000000000000d
    [<ffffffff802ddacc>] fdt_check_header+0x14/0x208
    [<ffffffff8082415a>] early_init_dt_verify+0x16/0x94
    [<ffffffff80802dee>] setup_arch+0xec/0x4ec
    [<ffffffff80800700>] start_kernel+0x88/0x6d6
    random: get_random_bytes called from
print_oops_end_marker+0x22/0x44 with crng_init=0
    ---[ end trace 903df1a0ade0b876 ]---
    Kernel panic - not syncing: Attempted to kill the idle task!
    ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---

So the FDT is at 0xffffffff87e00000, i.e. at 0x7e00000 from the start
of virtual memory (CONFIG_PAGE_OFFSET=0xffffffff80000000), and thus
within the 2 GiB range.

> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -280,7 +280,7 @@ choice
>                 depends on 32BIT
>                 bool "1GiB"
>         config MAXPHYSMEM_2GB
> -               depends on 64BIT && CMODEL_MEDLOW
> +               depends on 64BIT
>                 bool "2GiB"
>         config MAXPHYSMEM_128GB
>                 depends on 64BIT && CMODEL_MEDANY

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

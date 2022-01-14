Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4678B48E81C
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 11:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240106AbiANKMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 05:12:42 -0500
Received: from mail-ua1-f48.google.com ([209.85.222.48]:35772 "EHLO
        mail-ua1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236780AbiANKMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 05:12:42 -0500
Received: by mail-ua1-f48.google.com with SMTP id m90so16144712uam.2;
        Fri, 14 Jan 2022 02:12:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q0iNxqWG6KKW3gmatJQgzSgoTuWKZwlECTtaOguELtw=;
        b=KLk0hiGeZc2VnSm5sNJl0Cjw8DrCk16mSk5l4BI0SEEM0BbSLJNapcFRBOdnNczpGA
         qoxlZLy8EZfvMRBeDozgxiQ/AL0GbrvsrCI23bxzyBgWqOKQ4u5hulINjlzt2pMtR9ES
         KmTiTou4FnDkdbSiYbSEMtW1f+Hcrl8VgLJo8U/h2jGKRPnNkWvx3AjwMKejMPKheOr6
         eH3ZboZnWlV+J+EEg8fy/9M7bneb6T+OPBy0Xv7brZ3Vw4jcDJzCWOVg4FGtA9B2mC9n
         YZvUzDt0wUkPePbwm/ILywGQI2Ge2ykaTl3nPnGdk4nJjC59uW25VyaJ8Dfzc3GoCJoS
         eVWQ==
X-Gm-Message-State: AOAM533vZJngrIE8Z5q6ZkpMsurVV+F4lbsrkJTW9OqE4SiEdIZtIo7/
        a9hf8WYuB2pJzM/D4Z61zwSzuxxJOxvxlg==
X-Google-Smtp-Source: ABdhPJzBe9w0yz3/ti5DwxQN0m8NYH63m7ldTdeqTxEBkzgCzTZUrILvptww9T1KCoQcv7XPKv6Gng==
X-Received: by 2002:ab0:3ca1:: with SMTP id a33mr416914uax.4.1642155161727;
        Fri, 14 Jan 2022 02:12:41 -0800 (PST)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id j129sm1984239vkh.16.2022.01.14.02.12.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 02:12:40 -0800 (PST)
Received: by mail-ua1-f46.google.com with SMTP id p37so16051938uae.8;
        Fri, 14 Jan 2022 02:12:39 -0800 (PST)
X-Received: by 2002:a67:e985:: with SMTP id b5mr3532550vso.77.1642155159526;
 Fri, 14 Jan 2022 02:12:39 -0800 (PST)
MIME-Version: 1.0
References: <20211119164413.29052-1-palmer@rivosinc.com> <20211119164413.29052-3-palmer@rivosinc.com>
 <CAMuHMdXQg942-DwDBJANsFiOCqyAwCt_GwW4HuC1nh0_DNmyEQ@mail.gmail.com> <aa05f467-efc2-ca66-3485-aa59ba72a730@ghiti.fr>
In-Reply-To: <aa05f467-efc2-ca66-3485-aa59ba72a730@ghiti.fr>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 14 Jan 2022 11:12:28 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUpi7hJwDrcCyzrooJN=gQjmwShD073UwXp7UxghHeMSA@mail.gmail.com>
Message-ID: <CAMuHMdUpi7hJwDrcCyzrooJN=gQjmwShD073UwXp7UxghHeMSA@mail.gmail.com>
Subject: Re: [PATCH 02/12] RISC-V: MAXPHYSMEM_2GB doesn't depend on CMODEL_MEDLOW
To:     Alexandre ghiti <alex@ghiti.fr>
Cc:     Palmer Dabbelt <palmer@rivosinc.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
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

Hi Alex,

On Tue, Jan 11, 2022 at 5:14 PM Alexandre ghiti <alex@ghiti.fr> wrote:
> On 1/11/22 17:04, Geert Uytterhoeven wrote:
> > On Fri, Nov 19, 2021 at 5:47 PM Palmer Dabbelt <palmer@rivosinc.com> wrote:
> >> From: Palmer Dabbelt <palmer@rivosinc.com>
> >>
> >> For non-relocatable kernels we need to be able to link the kernel at
> >> approximately PAGE_OFFSET, thus requiring medany (as medlow requires the
> >> code to be linked within 2GiB of 0).  The inverse doesn't apply, though:
> >> since medany code can be linked anywhere it's fine to link it close to
> >> 0, so we can support the smaller memory config.
> >>
> >> Fixes: de5f4b8f634b ("RISC-V: Define MAXPHYSMEM_1GB only for RV32")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> > Thanks for your patch, which is now commit 9f36b96bc70f9707 ("RISC-V:
> > MAXPHYSMEM_2GB doesn't depend on CMODEL_MEDLOW").
> >
> >> I found this when going through the savedefconfig diffs for the K210
> >> defconfigs.  I'm not entirely sure they're doing the right thing here
> >> (they should probably be setting CMODEL_LOW to take advantage of the
> >> better code generation), but I don't have any way to test those
> >> platforms so I don't want to change too much.
> > I can confirm MAXPHYSMEM_2GB works on K210 with CMODEL_MEDANY.
> >
> > As the Icicle has 1760 MiB of RAM, I gave it a try with MAXPHYSMEM_2GB
> > (and CMODEL_MEDANY), too.  Unfortunately it crashes very early
> > (needs earlycon to see):
> >
> >      OF: fdt: Ignoring memory range 0x80000000 - 0x80200000
> >      Machine model: Microchip PolarFire-SoC Icicle Kit
> >      printk: debug: ignoring loglevel setting.
> >      earlycon: ns16550a0 at MMIO32 0x0000000020100000 (options '115200n8')
> >      printk: bootconsole [ns16550a0] enabled
> >      printk: debug: skip boot console de-registration.
> >      efi: UEFI not found.
> >      Unable to handle kernel paging request at virtual address ffffffff87e00001
> >      Oops [#1]
> >      Modules linked in:
> >      CPU: 0 PID: 0 Comm: swapper Not tainted 5.16.0-08771-g85515233477d #56
> >      Hardware name: Microchip PolarFire-SoC Icicle Kit (DT)
> >      epc : fdt_check_header+0x14/0x208
> >       ra : early_init_dt_verify+0x16/0x94
> >      epc : ffffffff802ddacc ra : ffffffff8082415a sp : ffffffff81203ee0
> >       gp : ffffffff812ec3a8 tp : ffffffff8120cd80 t0 : 0000000000000005
> >       t1 : 0000001040000000 t2 : ffffffff80000000 s0 : ffffffff81203f00
> >       s1 : ffffffff87e00000 a0 : ffffffff87e00000 a1 : 000000040ffffce7
> >       a2 : 00000000000000e7 a3 : ffffffff8080394c a4 : 0000000000000000
> >       a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000000000000
> >       s2 : ffffffff81203f98 s3 : 8000000a00006800 s4 : fffffffffffffff3
> >       s5 : 0000000000000000 s6 : 0000000000000001 s7 : 0000000000000000
> >       s8 : 0000000020236c20 s9 : 0000000000000000 s10: 0000000000000000
> >       s11: 0000000000000000 t3 : 0000000000000018 t4 : 00ff000000000000
> >       t5 : 0000000000000000 t6 : 0000000000000010
> >      status: 0000000200000100 badaddr: ffffffff87e00001 cause: 000000000000000d
> >      [<ffffffff802ddacc>] fdt_check_header+0x14/0x208
> >      [<ffffffff8082415a>] early_init_dt_verify+0x16/0x94
> >      [<ffffffff80802dee>] setup_arch+0xec/0x4ec
> >      [<ffffffff80800700>] start_kernel+0x88/0x6d6
> >      random: get_random_bytes called from
> > print_oops_end_marker+0x22/0x44 with crng_init=0
> >      ---[ end trace 903df1a0ade0b876 ]---
> >      Kernel panic - not syncing: Attempted to kill the idle task!
> >      ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---
> >
> > So the FDT is at 0xffffffff87e00000, i.e. at 0x7e00000 from the start
> > of virtual memory (CONFIG_PAGE_OFFSET=0xffffffff80000000), and thus
> > within the 2 GiB range.
>
>
> I think you have just encountered what I suspected and mentioned in [1]:
> we recently moved the kernel to the PAGE_OFFSET address used with
> MAXPHYSMEM_2GB.
>
> I would try to cherry-pick [1] and see if that works better :)
>
> Alex
>
> [1]
> https://patchwork.kernel.org/project/linux-riscv/patch/20211206104657.433304-6-alexandre.ghiti@canonical.com/

Thanks, works fine with just that patch (needed small changes), or with
the full series.

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD3A48E7C1
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 10:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240077AbiANJpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 04:45:12 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:47405 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240052AbiANJpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 04:45:11 -0500
Received: (Authenticated sender: alex@ghiti.fr)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 1870AC0012;
        Fri, 14 Jan 2022 09:45:00 +0000 (UTC)
Message-ID: <e649ef4c-a149-8b84-07d1-7e3b0c74bafa@ghiti.fr>
Date:   Fri, 14 Jan 2022 10:45:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 02/12] RISC-V: MAXPHYSMEM_2GB doesn't depend on
 CMODEL_MEDLOW
Content-Language: en-US
To:     Conor.Dooley@microchip.com, geert@linux-m68k.org,
        palmer@rivosinc.com
Cc:     linux-riscv@lists.infradead.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu,
        heinrich.schuchardt@canonical.com, bin.meng@windriver.com,
        sagar.kadam@sifive.com, damien.lemoal@wdc.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20211119164413.29052-1-palmer@rivosinc.com>
 <20211119164413.29052-3-palmer@rivosinc.com>
 <CAMuHMdXQg942-DwDBJANsFiOCqyAwCt_GwW4HuC1nh0_DNmyEQ@mail.gmail.com>
 <232b8a0d-b25d-b942-eeec-9a67b66b81ce@microchip.com>
 <d95094f8-2407-7e93-490d-94fce2af21a3@ghiti.fr>
 <23d570fe-e91f-aebc-e4e8-c0fdacab22b8@microchip.com>
From:   Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <23d570fe-e91f-aebc-e4e8-c0fdacab22b8@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/22 10:41, Conor.Dooley@microchip.com wrote:
> On 14/01/2022 09:09, Alexandre ghiti wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know
>> the content is safe
>>
>> Hi Conor,
>>
>> On 1/14/22 09:40, Conor.Dooley@microchip.com wrote:
>>> On 11/01/2022 16:04, Geert Uytterhoeven wrote:
>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you
>>>> know the content is safe
>>>>
>>>> Hi Palmer,
>>>>
>>>> On Fri, Nov 19, 2021 at 5:47 PM Palmer Dabbelt <palmer@rivosinc.com>
>>>> wrote:
>>>>> From: Palmer Dabbelt <palmer@rivosinc.com>
>>>>>
>>>>> For non-relocatable kernels we need to be able to link the kernel at
>>>>> approximately PAGE_OFFSET, thus requiring medany (as medlow requires
>>>>> the
>>>>> code to be linked within 2GiB of 0).  The inverse doesn't apply,
>>>>> though:
>>>>> since medany code can be linked anywhere it's fine to link it close to
>>>>> 0, so we can support the smaller memory config.
>>>>>
>>>>> Fixes: de5f4b8f634b ("RISC-V: Define MAXPHYSMEM_1GB only for RV32")
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
>>>> Thanks for your patch, which is now commit 9f36b96bc70f9707 ("RISC-V:
>>>> MAXPHYSMEM_2GB doesn't depend on CMODEL_MEDLOW").
>>>>
>>>>> I found this when going through the savedefconfig diffs for the K210
>>>>> defconfigs.  I'm not entirely sure they're doing the right thing here
>>>>> (they should probably be setting CMODEL_LOW to take advantage of the
>>>>> better code generation), but I don't have any way to test those
>>>>> platforms so I don't want to change too much.
>>>> I can confirm MAXPHYSMEM_2GB works on K210 with CMODEL_MEDANY.
>>>>
>>>> As the Icicle has 1760 MiB of RAM, I gave it a try with MAXPHYSMEM_2GB
>>>> (and CMODEL_MEDANY), too.  Unfortunately it crashes very early
>>>> (needs earlycon to see):
>>> Given you said 1760 MiB I assume you're not running the device tree
>>> currently in the kernel?
>>> But the defconfig is /arch/riscv/configs/defconfig?
>>>
>>> I tested it w/ my newer version of the dts, using both 1760 & 736 MiB
>>> (ddrc_cache_lo only) w/ MAXPHYSMEM_2GB.
>>> Enabling MAXPHYSMEM_2GB with either CMODEL_MEDANY or CMODEL_MEDLOW
>>> lead to the same boot failure as you got.
>>
>> Any chance you can give a try to [1] so that I can extract it from my
>> sv48 patchset and propose it to fixes if it works?
> Applied, tested with 1760 & 736 MiB - booted fine. :)


Great, I'll extract it, rephrase it (since it is not a suspicion 
anymore), add Geert Reported-by and your Tested-by.

Thanks!

Alex


>> Thanks,
>>
>> Alex
>>
>> https://patchwork.kernel.org/project/linux-riscv/patch/20211206104657.433304-6-alexandre.ghiti@canonical.com/
>>
>>
>>
>>>>        OF: fdt: Ignoring memory range 0x80000000 - 0x80200000
>>>>        Machine model: Microchip PolarFire-SoC Icicle Kit
>>>>        printk: debug: ignoring loglevel setting.
>>>>        earlycon: ns16550a0 at MMIO32 0x0000000020100000 (options
>>>> '115200n8')
>>>>        printk: bootconsole [ns16550a0] enabled
>>>>        printk: debug: skip boot console de-registration.
>>>>        efi: UEFI not found.
>>>>        Unable to handle kernel paging request at virtual address
>>>> ffffffff87e00001
>>>>        Oops [#1]
>>>>        Modules linked in:
>>>>        CPU: 0 PID: 0 Comm: swapper Not tainted
>>>> 5.16.0-08771-g85515233477d #56
>>>>        Hardware name: Microchip PolarFire-SoC Icicle Kit (DT)
>>>>        epc : fdt_check_header+0x14/0x208
>>>>         ra : early_init_dt_verify+0x16/0x94
>>>>        epc : ffffffff802ddacc ra : ffffffff8082415a sp : ffffffff81203ee0
>>>>         gp : ffffffff812ec3a8 tp : ffffffff8120cd80 t0 : 0000000000000005
>>>>         t1 : 0000001040000000 t2 : ffffffff80000000 s0 : ffffffff81203f00
>>>>         s1 : ffffffff87e00000 a0 : ffffffff87e00000 a1 : 000000040ffffce7
>>>>         a2 : 00000000000000e7 a3 : ffffffff8080394c a4 : 0000000000000000
>>>>         a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000000000000
>>>>         s2 : ffffffff81203f98 s3 : 8000000a00006800 s4 : fffffffffffffff3
>>>>         s5 : 0000000000000000 s6 : 0000000000000001 s7 : 0000000000000000
>>>>         s8 : 0000000020236c20 s9 : 0000000000000000 s10: 0000000000000000
>>>>         s11: 0000000000000000 t3 : 0000000000000018 t4 : 00ff000000000000
>>>>         t5 : 0000000000000000 t6 : 0000000000000010
>>>>        status: 0000000200000100 badaddr: ffffffff87e00001 cause:
>>>> 000000000000000d
>>>>        [<ffffffff802ddacc>] fdt_check_header+0x14/0x208
>>>>        [<ffffffff8082415a>] early_init_dt_verify+0x16/0x94
>>>>        [<ffffffff80802dee>] setup_arch+0xec/0x4ec
>>>>        [<ffffffff80800700>] start_kernel+0x88/0x6d6
>>>>        random: get_random_bytes called from
>>>> print_oops_end_marker+0x22/0x44 with crng_init=0
>>>>        ---[ end trace 903df1a0ade0b876 ]---
>>>>        Kernel panic - not syncing: Attempted to kill the idle task!
>>>>        ---[ end Kernel panic - not syncing: Attempted to kill the idle
>>>> task! ]---
>>>>
>>>> So the FDT is at 0xffffffff87e00000, i.e. at 0x7e00000 from the start
>>>> of virtual memory (CONFIG_PAGE_OFFSET=0xffffffff80000000), and thus
>>>> within the 2 GiB range.
>>>>
>>>>> --- a/arch/riscv/Kconfig
>>>>> +++ b/arch/riscv/Kconfig
>>>>> @@ -280,7 +280,7 @@ choice
>>>>>                    depends on 32BIT
>>>>>                    bool "1GiB"
>>>>>            config MAXPHYSMEM_2GB
>>>>> -               depends on 64BIT && CMODEL_MEDLOW
>>>>> +               depends on 64BIT
>>>>>                    bool "2GiB"
>>>>>            config MAXPHYSMEM_128GB
>>>>>                    depends on 64BIT && CMODEL_MEDANY
>>>> Gr{oetje,eeting}s,
>>>>
>>>>                            Geert
>>>>
>>>> -- 
>>>> Geert Uytterhoeven -- There's lots of Linux beyond ia32 --
>>>> geert@linux-m68k.org
>>>>
>>>> In personal conversations with technical people, I call myself a
>>>> hacker. But
>>>> when I'm talking to journalists I just say "programmer" or something
>>>> like that.
>>>>                                    -- Linus Torvalds
>>>>
>>>> _______________________________________________
>>>> linux-riscv mailing list
>>>> linux-riscv@lists.infradead.org
>>>> http://lists.infradead.org/mailman/listinfo/linux-riscv
>>>>
>>> _______________________________________________
>>> linux-riscv mailing list
>>> linux-riscv@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-riscv
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

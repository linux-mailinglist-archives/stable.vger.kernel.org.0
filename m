Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E4A1F4784
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 21:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730747AbgFITui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 15:50:38 -0400
Received: from foss.arm.com ([217.140.110.172]:48158 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730734AbgFITui (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 15:50:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C6F51F1;
        Tue,  9 Jun 2020 12:50:37 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EAECE3F73D;
        Tue,  9 Jun 2020 12:50:36 -0700 (PDT)
Subject: Re: [PATCH v2] arm64: acpi: fix UBSAN warning
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Enrico Weigelt <info@metux.net>,
        Allison Randal <allison@lohutok.net>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <CAKwvOdnBhHnhUZ9MHgqEQ4nEyzHWUH+DPV-J0KoYyWNEnsDHbg@mail.gmail.com>
 <20200608203818.189423-1-ndesaulniers@google.com>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <dfdbce19-74dd-40a6-b083-168406bc214e@arm.com>
Date:   Tue, 9 Jun 2020 14:50:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200608203818.189423-1-ndesaulniers@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 6/8/20 3:38 PM, Nick Desaulniers wrote:
> Will reported a UBSAN warning:
> 
> UBSAN: null-ptr-deref in arch/arm64/kernel/smp.c:596:6
> member access within null pointer of type 'struct acpi_madt_generic_interrupt'
> CPU: 0 PID: 0 Comm: swapper Not tainted 5.7.0-rc6-00124-g96bc42ff0a82 #1
> Call trace:
>   dump_backtrace+0x0/0x384
>   show_stack+0x28/0x38
>   dump_stack+0xec/0x174
>   handle_null_ptr_deref+0x134/0x174
>   __ubsan_handle_type_mismatch_v1+0x84/0xa4
>   acpi_parse_gic_cpu_interface+0x60/0xe8
>   acpi_parse_entries_array+0x288/0x498
>   acpi_table_parse_entries_array+0x178/0x1b4
>   acpi_table_parse_madt+0xa4/0x110
>   acpi_parse_and_init_cpus+0x38/0x100
>   smp_init_cpus+0x74/0x258
>   setup_arch+0x350/0x3ec
>   start_kernel+0x98/0x6f4
> 
> This is from the use of the ACPI_OFFSET in
> arch/arm64/include/asm/acpi.h. Replace its use with offsetof from
> include/linux/stddef.h which should implement the same logic using
> __builtin_offsetof, so that UBSAN wont warn.

I looked at the longer thread about this, given that it appears to be a 
false positive with respect to the macro, I tend to prefer Ard's 
suggestion of just changing the offset value (1 should be sufficient 
rather than 0) to avoid this kind of problem in the future.

But either way, this change looks fine too.

Reviewed-by: Jeremy Linton <jeremy.linton@arm.com>

Thanks,

> 
> Link: https://lore.kernel.org/lkml/20200521100952.GA5360@willie-the-truck/
> Cc: stable@vger.kernel.org
> Reported-by: Will Deacon <will@kernel.org>
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
> Changes V1 -> V2:
> * Just fix one of the two warnings, specific to arm64.
> * Put warning in commit message.
> 
>   arch/arm64/include/asm/acpi.h | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index b263e239cb59..a45366c3909b 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -12,6 +12,7 @@
>   #include <linux/efi.h>
>   #include <linux/memblock.h>
>   #include <linux/psci.h>
> +#include <linux/stddef.h>
>   
>   #include <asm/cputype.h>
>   #include <asm/io.h>
> @@ -31,14 +32,14 @@
>    * is therefore used to delimit the MADT GICC structure minimum length
>    * appropriately.
>    */
> -#define ACPI_MADT_GICC_MIN_LENGTH   ACPI_OFFSET(  \
> +#define ACPI_MADT_GICC_MIN_LENGTH   offsetof(  \
>   	struct acpi_madt_generic_interrupt, efficiency_class)
>   
>   #define BAD_MADT_GICC_ENTRY(entry, end)					\
>   	(!(entry) || (entry)->header.length < ACPI_MADT_GICC_MIN_LENGTH || \
>   	(unsigned long)(entry) + (entry)->header.length > (end))
>   
> -#define ACPI_MADT_GICC_SPE  (ACPI_OFFSET(struct acpi_madt_generic_interrupt, \
> +#define ACPI_MADT_GICC_SPE  (offsetof(struct acpi_madt_generic_interrupt, \
>   	spe_interrupt) + sizeof(u16))
>   
>   /* Basic configuration for ACPI */
> 


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18331F4626
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733165AbgFISYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:24:08 -0400
Received: from foss.arm.com ([217.140.110.172]:45998 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730588AbgFIRrD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:47:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45AD51F1;
        Tue,  9 Jun 2020 10:47:02 -0700 (PDT)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A21CA3F73D;
        Tue,  9 Jun 2020 10:47:00 -0700 (PDT)
Date:   Tue, 9 Jun 2020 18:46:54 +0100
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Enrico Weigelt <info@metux.net>,
        Allison Randal <allison@lohutok.net>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arm64: acpi: fix UBSAN warning
Message-ID: <20200609174654.GA2994@e121166-lin.cambridge.arm.com>
References: <CAKwvOdnBhHnhUZ9MHgqEQ4nEyzHWUH+DPV-J0KoYyWNEnsDHbg@mail.gmail.com>
 <20200608203818.189423-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608203818.189423-1-ndesaulniers@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 08, 2020 at 01:38:17PM -0700, Nick Desaulniers wrote:
> Will reported a UBSAN warning:
> 
> UBSAN: null-ptr-deref in arch/arm64/kernel/smp.c:596:6
> member access within null pointer of type 'struct acpi_madt_generic_interrupt'
> CPU: 0 PID: 0 Comm: swapper Not tainted 5.7.0-rc6-00124-g96bc42ff0a82 #1
> Call trace:
>  dump_backtrace+0x0/0x384
>  show_stack+0x28/0x38
>  dump_stack+0xec/0x174
>  handle_null_ptr_deref+0x134/0x174
>  __ubsan_handle_type_mismatch_v1+0x84/0xa4
>  acpi_parse_gic_cpu_interface+0x60/0xe8
>  acpi_parse_entries_array+0x288/0x498
>  acpi_table_parse_entries_array+0x178/0x1b4
>  acpi_table_parse_madt+0xa4/0x110
>  acpi_parse_and_init_cpus+0x38/0x100
>  smp_init_cpus+0x74/0x258
>  setup_arch+0x350/0x3ec
>  start_kernel+0x98/0x6f4
> 
> This is from the use of the ACPI_OFFSET in
> arch/arm64/include/asm/acpi.h. Replace its use with offsetof from
> include/linux/stddef.h which should implement the same logic using
> __builtin_offsetof, so that UBSAN wont warn.
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
>  arch/arm64/include/asm/acpi.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index b263e239cb59..a45366c3909b 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -12,6 +12,7 @@
>  #include <linux/efi.h>
>  #include <linux/memblock.h>
>  #include <linux/psci.h>
> +#include <linux/stddef.h>
>  
>  #include <asm/cputype.h>
>  #include <asm/io.h>
> @@ -31,14 +32,14 @@
>   * is therefore used to delimit the MADT GICC structure minimum length
>   * appropriately.
>   */
> -#define ACPI_MADT_GICC_MIN_LENGTH   ACPI_OFFSET(  \
> +#define ACPI_MADT_GICC_MIN_LENGTH   offsetof(  \
>  	struct acpi_madt_generic_interrupt, efficiency_class)
>  
>  #define BAD_MADT_GICC_ENTRY(entry, end)					\
>  	(!(entry) || (entry)->header.length < ACPI_MADT_GICC_MIN_LENGTH || \
>  	(unsigned long)(entry) + (entry)->header.length > (end))
>  
> -#define ACPI_MADT_GICC_SPE  (ACPI_OFFSET(struct acpi_madt_generic_interrupt, \
> +#define ACPI_MADT_GICC_SPE  (offsetof(struct acpi_madt_generic_interrupt, \
>  	spe_interrupt) + sizeof(u16))
>  
>  /* Basic configuration for ACPI */
> -- 
> 2.27.0.278.ge193c7cf3a9-goog
> 

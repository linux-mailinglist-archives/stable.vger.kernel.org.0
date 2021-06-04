Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A719D39BCEC
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 18:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhFDQWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 12:22:30 -0400
Received: from foss.arm.com ([217.140.110.172]:42454 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229809AbhFDQWa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 12:22:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB7851063;
        Fri,  4 Jun 2021 09:20:43 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 459693F73D;
        Fri,  4 Jun 2021 09:20:41 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] arm64: kexec_file: Forbid non-crash kernels
To:     Marc Zyngier <maz@kernel.org>, kexec@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Bhupesh SHARMA <bhupesh.sharma@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Dave Young <dyoung@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Moritz Fischer <mdf@kernel.org>, kernel-team@android.com,
        stable@vger.kernel.org
References: <20210531095720.77469-1-maz@kernel.org>
 <20210531095720.77469-2-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <e1d3bd1a-3935-d14b-9d2a-183ec4758665@arm.com>
Date:   Fri, 4 Jun 2021 17:20:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210531095720.77469-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31/05/2021 10:57, Marc Zyngier wrote:
> It has been reported that kexec_file doesn't really work on arm64.
> It completely ignores any of the existing reservations, which results
> in the secondary kernel being loaded where the GICv3 LPI tables live,


> or even corrupting the ACPI tables.

I'd like to know how the ACPI tables bit happens.

ACPI tables should be in EFI_ACPI_RECLAIM_MEMORY or EFI_ACPI_MEMORY_NVS (which isn't
treated as usable).

EFI's reserve_regions() does this:
|	if (!is_usable_memory(md))
|		memblock_mark_nomap(paddr, size);
|
|	/* keep ACPI reclaim memory intact for kexec etc. */
|	if (md->type == EFI_ACPI_RECLAIM_MEMORY)
|		memblock_reserve(paddr, size);

which is called via efi_init(), and all those regions end up listed as reserved in
/proc/iomem. (this is why arm64 doesn't call acpi_reserve_initial_tables())

If your firmware puts ACPI tables are in EFI_CONVENTIONAL_MEMORY, you have bigger problems
as the kernel could get relocated over the top of them during boot, and even if it
doesn't, nothing stops that  memory being allocated for user-space.

Even acpi_table_upgrade() calls memblock_reserve() and happens early enough not to be a
problem.


Please share ... enjoyment, optional.

(boot with efi=debug and post the EFI memory map and the 'ACPI: FOO 0xphysicaladdress'
stuff at the top of the boot log)


Thanks,

James


> Since only crash kernels are imune to this as they use a reserved
> memory region, disable the non-crash kernel use case. Further
> patches will try and restore the functionality.

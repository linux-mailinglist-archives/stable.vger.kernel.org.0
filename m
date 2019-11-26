Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A32E0109DF9
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 13:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfKZMar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 07:30:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:45256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727408AbfKZMar (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 07:30:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A9FB6AC10;
        Tue, 26 Nov 2019 12:30:45 +0000 (UTC)
Date:   Tue, 26 Nov 2019 13:30:43 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH -tip, v2] x86/mm/32: Sync only to VMALLOC_END in
 vmalloc_sync_all()
Message-ID: <20191126123043.GH21753@suse.de>
References: <20191126100942.13059-1-joro@8bytes.org>
 <20191126111119.GA110513@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126111119.GA110513@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ingo,

On Tue, Nov 26, 2019 at 12:11:19PM +0100, Ingo Molnar wrote:
> The vmalloc_sync_all() also iterating over the LDT range is buggy, 
> because for the LDT the mappings are *intentionally* and fundamentally 
> different between processes, i.e. not synchronized.

Yes, you are right, your patch description is much better, thanks for
making it more clear and correct.

> Furthermore I'm not sure we need to iterate over the PKMAP range either: 
> those are effectively permanent PMDs as well, and they are not part of 
> the vmalloc.c lazy deallocation scheme in any case - they are handled 
> entirely separately in mm/highmem.c et al.

I looked a bit at that, and I didn't find an explict place where the
PKMAP PMD gets established. It probably happens implicitly on the first
kmap() call, so we are safe as long as the first call to kmap happens
before the kernel starts the first userspace process.

But that is not an issue that should be handled by vmalloc_sync_all(),
as the name already implies that it only cares about the vmalloc range.
So your change to only iterate to VMALLOC_END makes sense and we should
establish the PKMAP PMD at a defined place to make sure it exists when
we start the first process.

> Note that this is *completely* untested - I might have wrecked PKMAP in 
> my ignorance. Mind giving it a careful review and a test?

My testing environment for 32 bit is quite limited these days, but I
tested it in my PTI-x32 environment and the patch below works perfectly
fine there and still fixes the ldt_gdt selftest.


Regards,

	Joerg

> ===========================>
> Subject: x86/mm/32: Sync only to VMALLOC_END in vmalloc_sync_all()
> From:  Joerg Roedel <jroedel@suse.de>
> Date: Tue, 26 Nov 2019 11:09:42 +0100
> 
> From: Joerg Roedel <jroedel@suse.de>
> 
> The job of vmalloc_sync_all() is to help the lazy freeing of vmalloc()
> ranges: before such vmap ranges are reused we make sure that they are
> unmapped from every task's page tables.
> 
> This is really easy on pagetable setups where the kernel page tables
> are shared between all tasks - this is the case on 32-bit kernels
> with SHARED_KERNEL_PMD = 1.
> 
> But on !SHARED_KERNEL_PMD 32-bit kernels this involves iterating
> over the pgd_list and clearing all pmd entries in the pgds that
> are cleared in the init_mm.pgd, which is the reference pagetable
> that the vmalloc() code uses.
> 
> In that context the current practice of vmalloc_sync_all() iterating
> until FIX_ADDR_TOP is buggy:
> 
>         for (address = VMALLOC_START & PMD_MASK;
>              address >= TASK_SIZE_MAX && address < FIXADDR_TOP;
>              address += PMD_SIZE) {
>                 struct page *page;
> 
> Because iterating up to FIXADDR_TOP will involve a lot of non-vmalloc
> address ranges:
> 
> 	VMALLOC -> PKMAP -> LDT -> CPU_ENTRY_AREA -> FIX_ADDR
> 
> This is mostly harmless for the FIX_ADDR and CPU_ENTRY_AREA ranges
> that don't clear their pmds, but it's lethal for the LDT range,
> which relies on having different mappings in different processes,
> and 'synchronizing' them in the vmalloc sense corrupts those
> pagetable entries (clearing them).
> 
> This got particularly prominent with PTI, which turns SHARED_KERNEL_PMD
> off and makes this the dominant mapping mode on 32-bit.
> 
> To make LDT working again vmalloc_sync_all() must only iterate over
> the volatile parts of the kernel address range that are identical
> between all processes.
> 
> So the correct check in vmalloc_sync_all() is "address < VMALLOC_END"
> to make sure the VMALLOC areas are synchronized and the LDT
> mapping is not falsely overwritten.
> 
> The CPU_ENTRY_AREA and the FIXMAP area are no longer synced either,
> but this is not really a proplem since their PMDs get established
> during bootup and never change.
> 
> This change fixes the ldt_gdt selftest in my setup.
> 
> Reported-by: Borislav Petkov <bp@suse.de>
> Tested-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> Cc: <stable@vger.kernel.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Brian Gerst <brgerst@gmail.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Fixes: 7757d607c6b3: ("x86/pti: Allow CONFIG_PAGE_TABLE_ISOLATION for x86_32")
> Link: https://lkml.kernel.org/r/20191126100942.13059-1-joro@8bytes.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/mm/fault.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: tip/arch/x86/mm/fault.c
> ===================================================================
> --- tip.orig/arch/x86/mm/fault.c
> +++ tip/arch/x86/mm/fault.c
> @@ -197,7 +197,7 @@ void vmalloc_sync_all(void)
>  		return;
>  
>  	for (address = VMALLOC_START & PMD_MASK;
> -	     address >= TASK_SIZE_MAX && address < FIXADDR_TOP;
> +	     address >= TASK_SIZE_MAX && address < VMALLOC_END;
>  	     address += PMD_SIZE) {
>  		struct page *page;
>  

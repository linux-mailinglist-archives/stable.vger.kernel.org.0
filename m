Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0FEA109CCA
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 12:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfKZLL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 06:11:26 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37577 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfKZLL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 06:11:26 -0500
Received: by mail-wr1-f68.google.com with SMTP id g7so1253767wrw.4;
        Tue, 26 Nov 2019 03:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x+WqZjeCRspEF+RwRN7Hn4tViVidZnTr86uErHywbk0=;
        b=CpS50T7FiK6jheHaUipDko0lZsPIQCWIgoxwclzGnImFydLeerGjUJVOB1oMAVsaKm
         omvNaunRCqOHQ61QjmR2AheAaLdbvP4B/42uP6+wGcUJ1+b4QkajObRjX0R6iqgkHxuv
         kKG2lQ0gPD7Zu2iqAPZekrZxWsEXMepoLLG7WGIS22YuB6fZ9EHby8NBZl/4P0QVX3Ad
         C2qgwVGE7HoIUfft1nms1kLmyQqyz+rvaBUUIN/M6hIw5C3qRyQGEfzbdUg1373EjoLZ
         pg+25qoLJPbYsC0Qm/zQewa1NxZokI9si0/BXMY7U/G8+VbD3gyFMm6C0UpRzRKgjlI9
         T+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=x+WqZjeCRspEF+RwRN7Hn4tViVidZnTr86uErHywbk0=;
        b=tqV20V93ESkSpl9GYxD3O0k9MHBeNtNZb75fJT2exMjt9Z1ulyfdtBtgcOGPtPgZ1p
         qCTgeMjE7vjhKFeajr500lrLSRIm2BgkrAW9PtH9+QbHbAabpoJUfA9VBem9IHOxxHXM
         E3Ik8YgsyPwaZnKMNDRgJAA72qqnhndzR/lvJ/mFGnp7e47/gDI4QdS9sz5QQeqUnrcg
         Z115UkKa3OV2sNxL/QBVsUdRFRhQrustmvN+l/3B1Ci1b8Ztadt1Hc3DEHgwNOu9b4C3
         lf33OTSbYOmYT/IL38Uw1znY3z6wx9dhXe0gG/Om026xurufbaVlv+e2VGb2xNf4v2rp
         8cbg==
X-Gm-Message-State: APjAAAX9W6XzW8HcOORTKZgLncQsYypUtbLJOob7zbga24FLaIdqNSfU
        I200MvwtJqKwwwUNlIi44Ws=
X-Google-Smtp-Source: APXvYqxlq0zl7sqrZjk9qLVmAFOw7376EPYyCBZdD5Iq5GQBEcmNsMhoxruMtI9RJZUsYQVVcN15BQ==
X-Received: by 2002:a5d:4d4a:: with SMTP id a10mr28721038wru.220.1574766682022;
        Tue, 26 Nov 2019 03:11:22 -0800 (PST)
Received: from gmail.com (54033286.catv.pool.telekom.hu. [84.3.50.134])
        by smtp.gmail.com with ESMTPSA id u13sm2463210wmm.45.2019.11.26.03.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 03:11:21 -0800 (PST)
Date:   Tue, 26 Nov 2019 12:11:19 +0100
From:   Ingo Molnar <mingo@kernel.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: [PATCH -tip, v2] x86/mm/32: Sync only to VMALLOC_END in
 vmalloc_sync_all()
Message-ID: <20191126111119.GA110513@gmail.com>
References: <20191126100942.13059-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126100942.13059-1-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Joerg Roedel <joro@8bytes.org> wrote:

> From: Joerg Roedel <jroedel@suse.de>
> 
> When vmalloc_sync_all() iterates over the address space until
> FIX_ADDR_TOP it will sync the whole kernel address space starting from
> VMALLOC_START.
> 
> This is not a problem when the kernel address range is identical in
> all page-tables, but this is no longer the case when PTI is enabled on
> x86-32. In that case the per-process LDT is mapped in the kernel
> address range and vmalloc_sync_all() clears the LDT mapping for all
> processes.
> 
> To make LDT working again vmalloc_sync_all() must only iterate over
> the volatile parts of the kernel address range that are identical
> between all processes. This includes the VMALLOC and the PKMAP areas
> on x86-32.
> 
> The order of the ranges in the address space is:
> 
> 	VMALLOC -> PKMAP -> LDT -> CPU_ENTRY_AREA -> FIX_ADDR
> 
> So the right check in vmalloc_sync_all() is "address < LDT_BASE_ADDR"
> to make sure the VMALLOC and PKMAP areas are synchronized and the LDT
> mapping is not falsely overwritten. the CPU_ENTRY_AREA and
> the FIXMAP area are no longer synced as well, but these
> ranges are synchronized on page-table creation time and do
> not change during runtime.

Note that the last sentence is not really true, because various fixmap 
PTE entries and the CEA areas may change: ACPI uses a dynamic fixmap 
entry in ghes_map() and PTI uses dynamic PTEs as well, such as when 
mapping the debug store in alloc_bts_buffer(), etc.

What you wanted to say is probably that on 32-bit kernels with
!SHARED_KERNEL_PMD page table layouts the init_mm.pgd is the 'reference
kernel page table', which, whenever vmalloc pmds get removed, must be 
copied over into all page tables listed in pgd_list.

(The addition of vmalloc PMD and PTE entries is lazy processed, at fault 
time.)

The vmalloc_sync_all() also iterating over the LDT range is buggy, 
because for the LDT the mappings are *intentionally* and fundamentally 
different between processes, i.e. not synchronized.

Furthermore I'm not sure we need to iterate over the PKMAP range either: 
those are effectively permanent PMDs as well, and they are not part of 
the vmalloc.c lazy deallocation scheme in any case - they are handled 
entirely separately in mm/highmem.c et al.

The reason vmalloc_sync_all() doesn't wreck the pkmap range is really 
just accidental, because kmap() is a globally synchronized mapping 
concept as well - but it doesn't actually remove pmds.

Anyway, below is the patch modified to only iterate over the vmalloc 
ranges.

Note that VMALLOC_END is two guard pages short of the true end of the 
vmalloc area - this should not matter because vmalloc_sync_all() only 
looks down to the pmd depth, which is at least 2MB granular.

Note that this is *completely* untested - I might have wrecked PKMAP in 
my ignorance. Mind giving it a careful review and a test?

Thanks,

	Ingo

===========================>
Subject: x86/mm/32: Sync only to VMALLOC_END in vmalloc_sync_all()
From:  Joerg Roedel <jroedel@suse.de>
Date: Tue, 26 Nov 2019 11:09:42 +0100

From: Joerg Roedel <jroedel@suse.de>

The job of vmalloc_sync_all() is to help the lazy freeing of vmalloc()
ranges: before such vmap ranges are reused we make sure that they are
unmapped from every task's page tables.

This is really easy on pagetable setups where the kernel page tables
are shared between all tasks - this is the case on 32-bit kernels
with SHARED_KERNEL_PMD = 1.

But on !SHARED_KERNEL_PMD 32-bit kernels this involves iterating
over the pgd_list and clearing all pmd entries in the pgds that
are cleared in the init_mm.pgd, which is the reference pagetable
that the vmalloc() code uses.

In that context the current practice of vmalloc_sync_all() iterating
until FIX_ADDR_TOP is buggy:

        for (address = VMALLOC_START & PMD_MASK;
             address >= TASK_SIZE_MAX && address < FIXADDR_TOP;
             address += PMD_SIZE) {
                struct page *page;

Because iterating up to FIXADDR_TOP will involve a lot of non-vmalloc
address ranges:

	VMALLOC -> PKMAP -> LDT -> CPU_ENTRY_AREA -> FIX_ADDR

This is mostly harmless for the FIX_ADDR and CPU_ENTRY_AREA ranges
that don't clear their pmds, but it's lethal for the LDT range,
which relies on having different mappings in different processes,
and 'synchronizing' them in the vmalloc sense corrupts those
pagetable entries (clearing them).

This got particularly prominent with PTI, which turns SHARED_KERNEL_PMD
off and makes this the dominant mapping mode on 32-bit.

To make LDT working again vmalloc_sync_all() must only iterate over
the volatile parts of the kernel address range that are identical
between all processes.

So the correct check in vmalloc_sync_all() is "address < VMALLOC_END"
to make sure the VMALLOC areas are synchronized and the LDT
mapping is not falsely overwritten.

The CPU_ENTRY_AREA and the FIXMAP area are no longer synced either,
but this is not really a proplem since their PMDs get established
during bootup and never change.

This change fixes the ldt_gdt selftest in my setup.

Reported-by: Borislav Petkov <bp@suse.de>
Tested-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Cc: <stable@vger.kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 7757d607c6b3: ("x86/pti: Allow CONFIG_PAGE_TABLE_ISOLATION for x86_32")
Link: https://lkml.kernel.org/r/20191126100942.13059-1-joro@8bytes.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/arch/x86/mm/fault.c
===================================================================
--- tip.orig/arch/x86/mm/fault.c
+++ tip/arch/x86/mm/fault.c
@@ -197,7 +197,7 @@ void vmalloc_sync_all(void)
 		return;
 
 	for (address = VMALLOC_START & PMD_MASK;
-	     address >= TASK_SIZE_MAX && address < FIXADDR_TOP;
+	     address >= TASK_SIZE_MAX && address < VMALLOC_END;
 	     address += PMD_SIZE) {
 		struct page *page;
 

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2FB48F204
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 22:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiANV0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 16:26:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54014 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiANV0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 16:26:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95BA861F85;
        Fri, 14 Jan 2022 21:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2C2C36AE9;
        Fri, 14 Jan 2022 21:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642195560;
        bh=D4XDC8+UErC1Yj02L5DJLEKNsLTWCellAgAC60/AMbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UsdV2pbp/IDOyj9u8C1t+6BcIs4jWNgrKXq+TFxdqACdUGuKwBWOICaXs/sRO5ecQ
         A/5tQR2M7tT2njdWGGOlWoFVOryClDlDKOqFPjCctEhYG/KyRw/0fEnj6D+DCjKvmH
         Ct5UHz4XbcgOE7nCJv6feWCjzbchepbBxJv7Icpp4OnOYfQBDrfwYjsBvS77dnFVwV
         sKVlfpkoRWlzQttY7JsXE1YWoNlDYJsyJM3EOEXHuvtQXLUjBlW9eXrLhAI5SNDxj+
         nldUNjJjxkr8QhMJ3hSj935Sv2vrLuBUOwEm0gOvRSbnkKDzJUJMskX1POviPWe5v0
         8z0SHKaqhOtXQ==
Date:   Fri, 14 Jan 2022 23:25:47 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3] x86/sgx: Free backing memory after faulting the
 enclave page
Message-ID: <YeHqW8AaQ3HZZoQx@iki.fi>
References: <20220108140510.76583-1-jarkko@kernel.org>
 <cd26205a-8551-194f-58df-05f89cd4f049@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd26205a-8551-194f-58df-05f89cd4f049@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 10:08:02PM -0800, Reinette Chatre wrote:
> Hi Jarkko,
> 
> On 1/8/2022 6:05 AM, Jarkko Sakkinen wrote:
> > There is a limited amount of SGX memory (EPC) on each system.  When that
> > memory is used up, SGX has its own swapping mechanism which is similar
> > in concept but totally separate from the core mm/* code.  Instead of
> > swapping to disk, SGX swaps from EPC to normal RAM.  That normal RAM
> > comes from a shared memory pseudo-file and can itself be swapped by the
> > core mm code.  There is a hierarchy like this:
> > 
> > 	EPC <-> shmem <-> disk
> > 
> > After data is swapped back in from shmem to EPC, the shmem backing
> > storage needs to be freed.  Currently, the backing shmem is not freed.
> > This effectively wastes the shmem while the enclave is running.  The
> > memory is recovered when the enclave is destroyed and the backing
> > storage freed.
> > 
> > Sort this out by freeing memory with shmem_truncate_range(), as soon as
> > a page is faulted back to the EPC.  In addition, free the memory for
> > PCMD pages as soon as all PCMD's in a page have been marked as unused
> > by zeroing its contents.
> > 
> > Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: stable@vger.kernel.org
> > Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> > v3:
> > * Resend.
> > v2:
> > * Rewrite commit message as proposed by Dave.
> > * Truncate PCMD pages (Dave).
> > ---
> >  arch/x86/kernel/cpu/sgx/encl.c | 48 +++++++++++++++++++++++++++++++---
> >  1 file changed, 44 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > index 001808e3901c..ea43c10e5458 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -12,6 +12,27 @@
> >  #include "encls.h"
> >  #include "sgx.h"
> >  
> > +
> > +/*
> > + * Get the page number of the page in the backing storage, which stores the PCMD
> > + * of the enclave page in the given page index.  PCMD pages are located after
> > + * the backing storage for the visible enclave pages and SECS.
> > + */
> > +static inline pgoff_t sgx_encl_get_backing_pcmd_nr(struct sgx_encl *encl, pgoff_t index)
> > +{
> > +	return PFN_DOWN(encl->size) + 1 + (index / sizeof(struct sgx_pcmd));
> > +}
> > +
> > +/*
> > + * Free a page from the backing storage in the given page index.
> > + */
> > +static inline void sgx_encl_truncate_backing_page(struct sgx_encl *encl, pgoff_t index)
> > +{
> > +	struct inode *inode = file_inode(encl->backing);
> > +
> > +	shmem_truncate_range(inode, PFN_PHYS(index), PFN_PHYS(index) + PAGE_SIZE - 1);
> > +}
> > +
> >  /*
> >   * ELDU: Load an EPC page as unblocked. For more info, see "OS Management of EPC
> >   * Pages" in the SDM.
> > @@ -24,7 +45,10 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >  	struct sgx_encl *encl = encl_page->encl;
> >  	struct sgx_pageinfo pginfo;
> >  	struct sgx_backing b;
> > +	bool pcmd_page_empty;
> >  	pgoff_t page_index;
> > +	pgoff_t pcmd_index;
> > +	u8 *pcmd_page;
> >  	int ret;
> >  
> >  	if (secs_page)
> > @@ -38,8 +62,8 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >  
> >  	pginfo.addr = encl_page->desc & PAGE_MASK;
> >  	pginfo.contents = (unsigned long)kmap_atomic(b.contents);
> > -	pginfo.metadata = (unsigned long)kmap_atomic(b.pcmd) +
> > -			  b.pcmd_offset;
> > +	pcmd_page = kmap_atomic(b.pcmd);
> > +	pginfo.metadata = (unsigned long)pcmd_page + b.pcmd_offset;
> >  
> >  	if (secs_page)
> >  		pginfo.secs = (u64)sgx_get_epc_virt_addr(secs_page);
> > @@ -55,11 +79,27 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >  		ret = -EFAULT;
> >  	}
> >  
> > -	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - b.pcmd_offset));
> > +	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
> > +
> > +	/*
> > +	 * The area for the PCMD in the page was zeroed above.  Check if the
> > +	 * whole page is now empty meaning that all PCMD's have been zeroed:
> > +	 */
> > +	pcmd_page_empty = !memchr_inv(pcmd_page, 0, PAGE_SIZE);
> > +
> > +	kunmap_atomic(pcmd_page);
> >  	kunmap_atomic((void *)(unsigned long)pginfo.contents);
> >  
> >  	sgx_encl_put_backing(&b, false);
> >  
> > +	/* Free the backing memory. */
> > +	sgx_encl_truncate_backing_page(encl, page_index);
> > +
> > +	if (pcmd_page_empty) {
> > +		pcmd_index = sgx_encl_get_backing_pcmd_nr(encl, page_index);
> > +		sgx_encl_truncate_backing_page(encl, pcmd_index);
> > +	}
> > +
> >  	return ret;
> >  }
> >  
> > @@ -577,7 +617,7 @@ static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
> >  int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
> >  			 struct sgx_backing *backing)
> >  {
> > -	pgoff_t pcmd_index = PFN_DOWN(encl->size) + 1 + (page_index >> 5);
> > +	pgoff_t pcmd_index = sgx_encl_get_backing_pcmd_nr(encl, page_index);
> >  	struct page *contents;
> >  	struct page *pcmd;
> >  
> 
> I applied this patch on top of commit 2056e2989bf4 ("x86/sgx: Fix NULL pointer
> dereference on non-SGX systems") found on branch x86/sgx of the tip repo.
> 
> When I run the SGX selftests the new oversubscription test case is failing with
> the error below:
> ./test_sgx
> TAP version 13
> 1..6
> # Starting 6 tests from 2 test cases.
> #  RUN           enclave.unclobbered_vdso ...
> #            OK  enclave.unclobbered_vdso
> ok 1 enclave.unclobbered_vdso
> #  RUN           enclave.unclobbered_vdso_oversubscribed ...
> # main.c:330:unclobbered_vdso_oversubscribed:Expected (&self->run)->function (2) == EEXIT (4)
> # main.c:330:unclobbered_vdso_oversubscribed:0x0e 0x06 0x00007f6000000fff
> # main.c:338:unclobbered_vdso_oversubscribed:Expected get_op.value (0) == MAGIC (1234605616436508552)
> # main.c:339:unclobbered_vdso_oversubscribed:Expected (&self->run)->function (2) == EEXIT (4)
> # main.c:339:unclobbered_vdso_oversubscribed:0x0e 0x06 0x00007f6000000fff
> # unclobbered_vdso_oversubscribed: Test failed at step #2
> #          FAIL  enclave.unclobbered_vdso_oversubscribed
> not ok 2 enclave.unclobbered_vdso_oversubscribed
> #  RUN           enclave.clobbered_vdso ...
> #            OK  enclave.clobbered_vdso
> ok 3 enclave.clobbered_vdso
> #  RUN           enclave.clobbered_vdso_and_user_function ...
> #            OK  enclave.clobbered_vdso_and_user_function
> ok 4 enclave.clobbered_vdso_and_user_function
> #  RUN           enclave.tcs_entry ...
> #            OK  enclave.tcs_entry
> ok 5 enclave.tcs_entry
> #  RUN           enclave.pte_permissions ...
> #            OK  enclave.pte_permissions
> 
> The kernel logs also contain a splat that I have not encountered before:
> 
> ------------[ cut here ]------------
> ELDU returned 9 (0x9)
> WARNING: CPU: 6 PID: 2470 at arch/x86/kernel/cpu/sgx/encl.c:77 sgx_encl_eldu+0x37c/0x3f0
> Modules linked in: intel_rapl_msr intel_rapl_common i10nm_edac x86_pkg_temp_thermal ipmi_ssif coretemp kvm_intel kvm cmdlinepart intel_spi_pci intel_spi spi_nor ipmi_si mei_me ipmi_devintf input_leds irqbypass mtd mei ioatdma intel_pch_thermal wmi ipmi_msghandler acpi_power_meter iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi btrfs blake2b_generic zstd_compress raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 multipath linear ixgbe crct10dif_pclmul crc32_pclmul ghash_clmulni_intel hid_generic aesni_intel crypto_simd xfrm_algo usbhid cryptd ast dca hid mdio drm_vram_helper drm_ttm_helper
> CPU: 6 PID: 2470 Comm: test_sgx Not tainted 5.16.0-rc1+ #24
> Hardware name: Intel Corporation 
> RIP: 0010:sgx_encl_eldu+0x37c/0x3f0
> Code: 89 c2 48 c7 c6 e1 e9 3e 9b 48 c7 c7 e6 e9 3e 9b 44 89 95 54 ff ff ff 4c 89 85 58 ff ff ff c6 05 fc bd dd 01 01 e8 54 88 03 00 <0f> 0b 44 8b 95 54 ff ff ff 4c 8b 85 58 ff ff ff e9 46 fe ff ff 48
> <snip>
> Call Trace:
> <TASK>
> sgx_encl_load_page+0x82/0xc0
> ? sgx_encl_load_page+0x82/0xc0
> sgx_vma_fault+0x40/0xe0
> __do_fault+0x32/0x110
> __handle_mm_fault+0xf84/0x1510
> handle_mm_fault+0x13e/0x3f0
> do_user_addr_fault+0x210/0x660
> ? rcu_read_lock_sched_held+0x4f/0x80
> exc_page_fault+0x7b/0x270
> ? asm_exc_page_fault+0x8/0x30
> asm_exc_page_fault+0x1e/0x30
> RIP: 0033:0x7ffe7fdc3dba
> <snip>
> 
> I ran the test on two systems and in both cases the test failed accompanied by
> the kernel splat.
> 
> Reinette

Thank you for testing this.

I did not get any errors when I run kselftest at the time *but* it was
exactly two months ago (2021-11-11). I cannot recall whether this test
was already in at the time, or did I run the overcommit test out-of-tree,
or if some confliciting non-kselftest changes have been applied.

I'll do the backtracking when I have the time by doing git bisect between
2021-11-11 x86/sgx and the current one.

/Jarkko

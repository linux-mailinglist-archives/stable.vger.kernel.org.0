Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652A04BF801
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 13:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiBVMYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 07:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbiBVMYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 07:24:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCC89AE76;
        Tue, 22 Feb 2022 04:23:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2375B819B7;
        Tue, 22 Feb 2022 12:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DC8C340E8;
        Tue, 22 Feb 2022 12:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645532623;
        bh=xjBH/cG+W5wVWzGCrdCbV5RgUnv6AePGL7a3RIdGucE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z0S5qSWxlznGnXFUlFfDNP1aQBI/4CImA/mcXGgRflOI6tFqBe7rL7wR8FTDSuen0
         RpVYhwEp6mx5svdsU2bkzF3ssYYt58aCXcif2H8EYeiVBtdND3YZntYn8lu5PO0ZKj
         SBMBlCtz/GBGMBnvTnUXtgJjGK8GoRN//TEg/46/eUNaR7MgY82vOmKmOR3N6HrQ6y
         h9p+zT28Auoo7D32knHKEYEjTaGEzeK/vl2y46dXj4E/KnDwj8OJoAdcA+pW0c5eJN
         7xr9yy3JAeinJwUxzmG6u3E/byNZO50B9+qiOt8FYnmFPdydEfVLDLAXxKDj3jdyNj
         ERdnBlKMsgbFw==
Date:   Tue, 22 Feb 2022 13:24:18 +0100
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, nathaniel@profian.com
Subject: Re: [PATCH v4] x86/sgx: Free backing memory after faulting the
 enclave page
Message-ID: <YhTV8okRsEw/j8JG@iki.fi>
References: <20220222120342.5277-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222120342.5277-1-jarkko@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 22, 2022 at 01:03:41PM +0100, Jarkko Sakkinen wrote:
> There is a limited amount of SGX memory (EPC) on each system.  When that
> memory is used up, SGX has its own swapping mechanism which is similar
> in concept but totally separate from the core mm/* code.  Instead of
> swapping to disk, SGX swaps from EPC to normal RAM.  That normal RAM
> comes from a shared memory pseudo-file and can itself be swapped by the
> core mm code.  There is a hierarchy like this:
> 
> 	EPC <-> shmem <-> disk
> 
> After data is swapped back in from shmem to EPC, the shmem backing
> storage needs to be freed.  Currently, the backing shmem is not freed.
> This effectively wastes the shmem while the enclave is running.  The
> memory is recovered when the enclave is destroyed and the backing
> storage freed.
> 
> Sort this out by freeing memory with shmem_truncate_range(), as soon as
> a page is faulted back to the EPC.  In addition, free the memory for
> PCMD pages as soon as all PCMD's in a page have been marked as unused
> by zeroing its contents.
> 
> Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: stable@vger.kernel.org
> Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> v4:
> * Sanitized the offset calculations.
> v3:
> * Resend.
> v2:
> * Rewrite commit message as proposed by Dave.
> * Truncate PCMD pages (Dave).
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 44 +++++++++++++++++++++++++++-------
>  1 file changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 8be6f0592bdc..94319190efb1 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -12,6 +12,17 @@
>  #include "encls.h"
>  #include "sgx.h"
>  
> +
> +/*
> + * Free a page from the backing storage in the given page index.
> + */
> +static inline void sgx_encl_truncate_backing_page(struct sgx_encl *encl, pgoff_t index)
> +{
> +	struct inode *inode = file_inode(encl->backing);
> +
> +	shmem_truncate_range(inode, PFN_PHYS(index), PFN_PHYS(index) + PAGE_SIZE - 1);
> +}
> +
>  /*
>   * ELDU: Load an EPC page as unblocked. For more info, see "OS Management of EPC
>   * Pages" in the SDM.
> @@ -24,7 +35,9 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  	struct sgx_encl *encl = encl_page->encl;
>  	struct sgx_pageinfo pginfo;
>  	struct sgx_backing b;
> +	bool pcmd_page_empty;
>  	pgoff_t page_index;
> +	u8 *pcmd_page;
>  	int ret;
>  
>  	if (secs_page)
> @@ -38,8 +51,8 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  
>  	pginfo.addr = encl_page->desc & PAGE_MASK;
>  	pginfo.contents = (unsigned long)kmap_atomic(b.contents);
> -	pginfo.metadata = (unsigned long)kmap_atomic(b.pcmd) +
> -			  b.pcmd_offset;
> +	pcmd_page = kmap_atomic(b.pcmd);
> +	pginfo.metadata = (unsigned long)pcmd_page + b.pcmd_offset;
>  
>  	if (secs_page)
>  		pginfo.secs = (u64)sgx_get_epc_virt_addr(secs_page);
> @@ -55,11 +68,28 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  		ret = -EFAULT;
>  	}
>  
> -	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - b.pcmd_offset));
> +	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
> +
> +	/*
> +	 * The area for the PCMD in the page was zeroed above.  Check if the
> +	 * whole page is now empty meaning that all PCMD's have been zeroed:
> +	 */
> +	pcmd_page_empty = !memchr_inv(pcmd_page, 0, PAGE_SIZE);
> +
> +	kunmap_atomic(pcmd_page);
>  	kunmap_atomic((void *)(unsigned long)pginfo.contents);
>  
>  	sgx_encl_put_backing(&b, false);
>  
> +	sgx_encl_truncate_backing_page(encl, page_index);
> +
> +	if (pcmd_page_empty) {
> +		pgoff_t pcmd_off = encl->size + PAGE_SIZE /* SECS */ +
> +				   page_index * sizeof(struct sgx_pcmd);
> +
> +		sgx_encl_truncate_backing_page(encl, PFN_DOWN(pcmd_off));
> +	}
> +
>  	return ret;
>  }
>  
> @@ -583,7 +613,7 @@ static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
>  static int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
>  				struct sgx_backing *backing)
>  {
> -	pgoff_t pcmd_index = PFN_DOWN(encl->size) + 1 + (page_index >> 5);
> +	pgoff_t pcmd_off = encl->size + PAGE_SIZE /* SECS */ + page_index * sizeof(struct sgx_pcmd);
>  	struct page *contents;
>  	struct page *pcmd;
>  
> @@ -591,7 +621,7 @@ static int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
>  	if (IS_ERR(contents))
>  		return PTR_ERR(contents);
>  
> -	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
> +	pcmd = sgx_encl_get_backing_page(encl, PFN_DOWN(pcmd_off));
>  	if (IS_ERR(pcmd)) {
>  		put_page(contents);
>  		return PTR_ERR(pcmd);
> @@ -600,9 +630,7 @@ static int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
>  	backing->page_index = page_index;
>  	backing->contents = contents;
>  	backing->pcmd = pcmd;
> -	backing->pcmd_offset =
> -		(page_index & (PAGE_SIZE / sizeof(struct sgx_pcmd) - 1)) *
> -		sizeof(struct sgx_pcmd);
> +	backing->pcmd_offset = pcmd_off & (PAGE_SIZE - 1);
>  
>  	return 0;
>  }
> -- 
> 2.35.1
> 

Tested this in my XPS13 2020 model: i7-1065G7

I did the testing in bare metal to minimize any possible side-effects.

$ ./test_sgx 
TAP version 13
1..6
# Starting 6 tests from 2 test cases.
#  RUN           enclave.unclobbered_vdso ...
#            OK  enclave.unclobbered_vdso
ok 1 enclave.unclobbered_vdso
#  RUN           enclave.unclobbered_vdso_oversubscribed ...
#            OK  enclave.unclobbered_vdso_oversubscribed
ok 2 enclave.unclobbered_vdso_oversubscribed
#  RUN           enclave.clobbered_vdso ...
#            OK  enclave.clobbered_vdso
ok 3 enclave.clobbered_vdso
#  RUN           enclave.clobbered_vdso_and_user_function ...
#            OK  enclave.clobbered_vdso_and_user_function
ok 4 enclave.clobbered_vdso_and_user_function
#  RUN           enclave.tcs_entry ...
#            OK  enclave.tcs_entry
ok 5 enclave.tcs_entry
#  RUN           enclave.pte_permissions ...
#            OK  enclave.pte_permissions
ok 6 enclave.pte_permissions
# PASSED: 6 / 6 tests passed.
# Totals: pass:6 fail:0 xfail:0 xpass:0 skip:0 error:0

BR, Jarkko

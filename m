Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D8C4D1658
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 12:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344626AbiCHLht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 06:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346269AbiCHLhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 06:37:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DFB3CA5B;
        Tue,  8 Mar 2022 03:36:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FDF161657;
        Tue,  8 Mar 2022 11:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B025C340EB;
        Tue,  8 Mar 2022 11:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646739408;
        bh=mY08w+v9XXfUiTCBJ7UOPNnHi31W9WF2KER6j5/de34=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fZjmYpdk1V7xqtgga2zkgjxyKGES25yooX25Sr5NV47DD9xKA3ddfoKEeuG9c/h5q
         +gXlZXGeX+gFX680jx2s8lRdX+TLWiRCyjCOF5xId4Pp7gN8SfRvPqp5fZx24h/4km
         wOy+3+cNu6ir1cchndu3f0KTmOArMRvh7NCB5YqVOuUnvwSKIb4UX8c4P4DvNtqv1Q
         KGAJr9JhNh2t54jwEFGr76LdlnqJWW78qWuNKBKk1phA5qgOgh1ZmWkyxWgsQkclMm
         z3EurEFcmbyjA3rIfCFxTgc2m5ln5heqqM2Thv+iCqtuWyNwGLaeDOMhR0jFmeHk7p
         9Heqm2+JjoNeA==
Date:   Tue, 8 Mar 2022 13:36:08 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6] x86/sgx: Free backing memory after faulting the
 enclave page
Message-ID: <Yic/qD7Nq9VocH6W@iki.fi>
References: <20220303223859.273187-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303223859.273187-1-jarkko@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 04, 2022 at 12:38:58AM +0200, Jarkko Sakkinen wrote:
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
> v6:
> * Re-applied on top of tip/x86/sgx and fixed the merge conflict, i.e.
>   sgx_encl_get_backing() instead of sgx_encl_lookup_backing().
> v5:
> * Encapsulated file offset calculation for PCMD struct.
> * Replaced "magic number" PAGE_SIZE with sizeof(struct sgx_secs) to make
>   the offset calculation more self-documentative.
> v4:
> * Sanitized the offset calculations.
> v3:
> * Resend.
> v2:
> * Rewrite commit message as proposed by Dave.
> * Truncate PCMD pages (Dave).
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 57 ++++++++++++++++++++++++++++------
>  1 file changed, 48 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 001808e3901c..6fa3d0a14b93 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -12,6 +12,30 @@
>  #include "encls.h"
>  #include "sgx.h"
>  
> +/*
> + * Calculate byte offset of a PCMD struct associated with an enclave page. PCMD's
> + * follow right after the EPC data in the backing storage. In addition to the
> + * visible enclave pages, there's one extra page slot for SECS, before PCMD
> + * structs.
> + */
> +static inline pgoff_t sgx_encl_get_backing_page_pcmd_offset(struct sgx_encl *encl,
> +							    unsigned long page_index)
> +{
> +	pgoff_t epc_end_off = encl->size + sizeof(struct sgx_secs);
> +
> +	return epc_end_off + page_index * sizeof(struct sgx_pcmd);
> +}
> +
> +/*
> + * Free a page from the backing storage in the given page index.
> + */
> +static inline void sgx_encl_truncate_backing_page(struct sgx_encl *encl, unsigned long page_index)
> +{
> +	struct inode *inode = file_inode(encl->backing);
> +
> +	shmem_truncate_range(inode, PFN_PHYS(page_index), PFN_PHYS(page_index) + PAGE_SIZE - 1);
> +}
> +
>  /*
>   * ELDU: Load an EPC page as unblocked. For more info, see "OS Management of EPC
>   * Pages" in the SDM.
> @@ -22,9 +46,11 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  {
>  	unsigned long va_offset = encl_page->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK;
>  	struct sgx_encl *encl = encl_page->encl;
> +	pgoff_t page_index, page_pcmd_off;
>  	struct sgx_pageinfo pginfo;
>  	struct sgx_backing b;
> -	pgoff_t page_index;
> +	bool pcmd_page_empty;
> +	u8 *pcmd_page;
>  	int ret;
>  
>  	if (secs_page)
> @@ -32,14 +58,16 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  	else
>  		page_index = PFN_DOWN(encl->size);
>  
> +	page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
> +
>  	ret = sgx_encl_get_backing(encl, page_index, &b);
>  	if (ret)
>  		return ret;
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
> @@ -55,11 +83,24 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
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
> +	if (pcmd_page_empty)
> +		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
> +
>  	return ret;
>  }
>  
> @@ -577,7 +618,7 @@ static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
>  int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
>  			 struct sgx_backing *backing)
>  {
> -	pgoff_t pcmd_index = PFN_DOWN(encl->size) + 1 + (page_index >> 5);
> +	pgoff_t page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
>  	struct page *contents;
>  	struct page *pcmd;
>  
> @@ -585,7 +626,7 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
>  	if (IS_ERR(contents))
>  		return PTR_ERR(contents);
>  
> -	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
> +	pcmd = sgx_encl_get_backing_page(encl, PFN_DOWN(page_pcmd_off));
>  	if (IS_ERR(pcmd)) {
>  		put_page(contents);
>  		return PTR_ERR(pcmd);
> @@ -594,9 +635,7 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
>  	backing->page_index = page_index;
>  	backing->contents = contents;
>  	backing->pcmd = pcmd;
> -	backing->pcmd_offset =
> -		(page_index & (PAGE_SIZE / sizeof(struct sgx_pcmd) - 1)) *
> -		sizeof(struct sgx_pcmd);
> +	backing->pcmd_offset = page_pcmd_off & (PAGE_SIZE - 1);
>  
>  	return 0;
>  }
> -- 
> 2.35.1
> 

Is there still something to be done?

BR, Jarkko

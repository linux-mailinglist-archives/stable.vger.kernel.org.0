Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE3E468863
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 00:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbhLDXxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 18:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237288AbhLDXxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 18:53:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D398C061751;
        Sat,  4 Dec 2021 15:49:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4EB2B80176;
        Sat,  4 Dec 2021 23:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B7DC341C2;
        Sat,  4 Dec 2021 23:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638661776;
        bh=voKfHJbeasmLadd3q3Do+PxfFvNASFpZELRln6ClKCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZuVYcJNVztR3W9xfhw46U3MRUX7MAjL++k3Wp4KsKyke7UFPYU/SMykPrBMzZ6oTN
         Gjdu7JWNNEa7tVr6ocPelVmDfqwKQZOgWFOkcDnPeVu2HMZkwxpgOwJW3Gx2V4gwas
         Zavd6QuYM5JBfLfGttRm7jpoI3030CsTnvpAWT7OjEM39YExDvVrwS012i/uA2Sszu
         TE+ppLHL71DbVGFOG2fMs7kjAJmPuR0UKDWQkmG88EN58NqeqQJhSfGFIC9yIC3ST4
         zWFUNfriEqXoqVLmKAGA6wW2ZK3earpGu06spzCXQF1MGz4qyEk0cXfjq6xbWMZ8CD
         89FgXTKjGCaXg==
Date:   Sun, 5 Dec 2021 01:49:32 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>
Cc:     reinette.chatre@intel.com, tony.luck@intel.com,
        nathaniel@profian.com, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/sgx: Free backing memory after faulting the
 enclave page
Message-ID: <Yav+jLMu5aFRqWxJ@iki.fi>
References: <20211111174401.865493-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111174401.865493-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 07:44:01PM +0200, Jarkko Sakkinen wrote:
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
> v2:
> * Rewrite commit message as proposed by Dave.
> * Truncate PCMD pages (Dave).
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 48 +++++++++++++++++++++++++++++++---
>  1 file changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 001808e3901c..ea43c10e5458 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -12,6 +12,27 @@
>  #include "encls.h"
>  #include "sgx.h"
>  
> +
> +/*
> + * Get the page number of the page in the backing storage, which stores the PCMD
> + * of the enclave page in the given page index.  PCMD pages are located after
> + * the backing storage for the visible enclave pages and SECS.
> + */
> +static inline pgoff_t sgx_encl_get_backing_pcmd_nr(struct sgx_encl *encl, pgoff_t index)
> +{
> +	return PFN_DOWN(encl->size) + 1 + (index / sizeof(struct sgx_pcmd));
> +}
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
> @@ -24,7 +45,10 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  	struct sgx_encl *encl = encl_page->encl;
>  	struct sgx_pageinfo pginfo;
>  	struct sgx_backing b;
> +	bool pcmd_page_empty;
>  	pgoff_t page_index;
> +	pgoff_t pcmd_index;
> +	u8 *pcmd_page;
>  	int ret;
>  
>  	if (secs_page)
> @@ -38,8 +62,8 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
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
> @@ -55,11 +79,27 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
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
> +	/* Free the backing memory. */
> +	sgx_encl_truncate_backing_page(encl, page_index);
> +
> +	if (pcmd_page_empty) {
> +		pcmd_index = sgx_encl_get_backing_pcmd_nr(encl, page_index);
> +		sgx_encl_truncate_backing_page(encl, pcmd_index);
> +	}
> +
>  	return ret;
>  }
>  
> @@ -577,7 +617,7 @@ static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
>  int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
>  			 struct sgx_backing *backing)
>  {
> -	pgoff_t pcmd_index = PFN_DOWN(encl->size) + 1 + (page_index >> 5);
> +	pgoff_t pcmd_index = sgx_encl_get_backing_pcmd_nr(encl, page_index);
>  	struct page *contents;
>  	struct page *pcmd;
>  
> -- 
> 2.32.0
> 

Just a friendly remainder.

/Jarkko

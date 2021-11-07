Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1390C447557
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 20:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235501AbhKGTsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 14:48:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhKGTsp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Nov 2021 14:48:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDF5461244;
        Sun,  7 Nov 2021 19:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636314362;
        bh=p9PTXUIwv2K7l8DSFkmLc/2KXRsnKtTpnM7ftuPGdPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KGDkyWxwS0SuPHoBQKoQnM93WMntBtAqayiHdnaQL75CU3PzJlr4wRyFsvQXq7RQw
         s07SWk81Gvb6CgPN/ZW+uRIZ9peodNHhE6nDMor4lRNtfEbiVrsdD628yxACftcgut
         eRxxY2+WFEiPDSJ6HTwamiw9F8Zr+Qs2HfEnPxQHG58wm0NTsmf7YwfWQm9Td+4LbY
         HIO1c2tnsU1yebQBX61lmc4Ev0K1W7kL4TWhIaMti8G7eNuWwZitLSkeO+jjxeWVzv
         zlEjhchdhgk2hIdmdc8zXu9QJB17m5yKOLuAd+jEZ+T4sOvvZeGRY7xy7JRSRT7mck
         tRgON3ATRZvVQ==
Date:   Sun, 7 Nov 2021 21:45:59 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>,
        reinette.chatre@intel.com, tony.luck@intel.com,
        nathaniel@profian.com, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Free backing memory after faulting the enclave
 page
Message-ID: <YYgs94O3eiKJwKgi@iki.fi>
References: <20211103232238.110557-1-jarkko@kernel.org>
 <7c122a82-e418-0bce-8f67-cbaa15abc9b9@intel.com>
 <YYgVsi7y4TNuSRLc@iki.fi>
 <984bc7a4-1c7a-f2c0-5885-0dc7fad3d2b6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <984bc7a4-1c7a-f2c0-5885-0dc7fad3d2b6@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 07, 2021 at 11:06:01AM -0800, Dave Hansen wrote:
> On 11/7/21 10:06 AM, Jarkko Sakkinen wrote:
> > On Thu, Nov 04, 2021 at 03:38:55PM -0700, Dave Hansen wrote:
> >> On 11/3/21 4:22 PM, Jarkko Sakkinen wrote:
> >>> --- a/arch/x86/kernel/cpu/sgx/encl.c
> >>> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> >>> @@ -22,6 +22,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >>>  {
> >>>  	unsigned long va_offset = encl_page->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK;
> >>>  	struct sgx_encl *encl = encl_page->encl;
> >>> +	struct inode *inode = file_inode(encl->backing);
> >>>  	struct sgx_pageinfo pginfo;
> >>>  	struct sgx_backing b;
> >>>  	pgoff_t page_index;
> >>> @@ -60,6 +61,9 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >>>  
> >>>  	sgx_encl_put_backing(&b, false);
> >>>  
> >>> +	/* Free the backing memory. */
> >>> +	shmem_truncate_range(inode, PFN_PHYS(page_index), PFN_PHYS(page_index) + PAGE_SIZE - 1);
> >>> +
> >>>  	return ret;
> >>>  }
> >>
> >> This also misses tearing down the backing storage if it is in place at
> >> sgx_encl_release().
> > 
> > Hmm... sgx_encl_release() does fput(). Isn't that enough to tear it down,
> > or does it require explicit truncate, i.e. something like
> > 
> >         shmem_truncate_range(file_inode(encl->backing), encl->base, encl->size - 1);
> 
> That's true, the page cache should all be torn down along with the
> fput().  *But*, it would be a very nice property if the backing storage
> was empty by this point.  It essentially ensures that no enclave-runtime
> cases missed truncating the backing storage away.

What if an enclave is released a point when all of its pages
are swapped out? Or even simpler case would an enclave that is
larger than all of EPC.

What can be made sure is that for all pages, which are in EPC,
the backing page is truncated.

> >> Does a entry->epc_page==NULL page in there guarantee that it has backing
> >> storage?
> > 
> > Yes, it is an invariant. That what I was thinking to use for PCMD: iterate
> > 32 pages and check if they have a faulted page.
> 
> I think the rule should be that entry->epc_page==NULL enclave pages have
> backing storage.  All entry->epc_page!=NULL do *not* have backing storage.

Yes, that is the goal of this patch.

/Jarkko

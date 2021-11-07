Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882194474DF
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 19:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhKGSJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 13:09:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:58260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230234AbhKGSJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Nov 2021 13:09:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4FF461074;
        Sun,  7 Nov 2021 18:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636308405;
        bh=aWDSKq24BEhQZHeIVmLKMzpNb1qnm7PcMMkOet0HbOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YyoV6PFTEMjfGZnwHwoSrRHiYSp0T+aYNPNIX7ECRTHdnT3KDL6VPww9Dh3VcL22s
         QJ2D/6jmHGkqK5pcxt3eMgqZoak3DqpXQb9BtTHik6X0WTRzC1a4feQOqynCj9E5qj
         TKbGnOsgpDN4sVeUqqmuBUfhjZzTkB/LstTUEjsaH7SWztpqWRnUJt4gNkOybGomEu
         yD/nzxBS9+a1S316dbdI0LfxExalcle1xBtuPC+P5Pn62y9+Wqx9QmoI9D9KUv6WsF
         cSGJbgnfEa3uhApFubysKNXUQixdyaEZgU3b0CG3b/E2iL0ihqLMUdKJeltmicHCUC
         QlSgcu0xbQYow==
Date:   Sun, 7 Nov 2021 20:06:42 +0200
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
Message-ID: <YYgVsi7y4TNuSRLc@iki.fi>
References: <20211103232238.110557-1-jarkko@kernel.org>
 <7c122a82-e418-0bce-8f67-cbaa15abc9b9@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c122a82-e418-0bce-8f67-cbaa15abc9b9@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 03:38:55PM -0700, Dave Hansen wrote:
> On 11/3/21 4:22 PM, Jarkko Sakkinen wrote:
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -22,6 +22,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >  {
> >  	unsigned long va_offset = encl_page->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK;
> >  	struct sgx_encl *encl = encl_page->encl;
> > +	struct inode *inode = file_inode(encl->backing);
> >  	struct sgx_pageinfo pginfo;
> >  	struct sgx_backing b;
> >  	pgoff_t page_index;
> > @@ -60,6 +61,9 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >  
> >  	sgx_encl_put_backing(&b, false);
> >  
> > +	/* Free the backing memory. */
> > +	shmem_truncate_range(inode, PFN_PHYS(page_index), PFN_PHYS(page_index) + PAGE_SIZE - 1);
> > +
> >  	return ret;
> >  }
> 
> This also misses tearing down the backing storage if it is in place at
> sgx_encl_release().

Hmm... sgx_encl_release() does fput(). Isn't that enough to tear it down,
or does it require explicit truncate, i.e. something like

        shmem_truncate_range(file_inode(encl->backing), encl->base, encl->size - 1);


> Does a entry->epc_page==NULL page in there guarantee that it has backing
> storage?

Yes, it is an invariant. That what I was thinking to use for PCMD: iterate
32 pages and check if they have a faulted page.

/Jarkko

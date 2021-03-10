Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15743340FE
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 16:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbhCJPBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 10:01:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhCJPBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 10:01:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77B7764EFE;
        Wed, 10 Mar 2021 15:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615388460;
        bh=1cf22zRqKYkUMXPfWyA63RDLMOreSLGYDa97S769FvY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b1o0J0ci823rHynKGMs7SfrHjNj3bi0okmEbLl1j0NbMMAU1MUNOnXDhDp7/VrN+Y
         Nr6giB/Qciu2OdoI5jzTtWiMfhm+okheWvW/TiUVGzXGmG4Qj4Qk+RsY3o1FhiIF6h
         BjP97yq3Zx8G4uPk0leTAojOBDVFAlWQUXxRO1MkrFestMfiYYEntCyXMprt8wnNqO
         uBj78/j6ezZBce3G1ZKetq9TPrE4J/+1k8PqQBUZLWcy4JOSH1g/jbyafMSIrGF8s6
         ScPDmBCyLIQQfenFnjkP16oOQfhgSKqPH6Tq84v0LTsP8e7LS3YSXk2J/VzzvxEFGJ
         c7gFjLl3/4Whg==
Date:   Wed, 10 Mar 2021 17:00:35 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>,
        Serge Ayoun <serge.ayoun@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] x86/sgx: Fix a resource leak in sgx_init()
Message-ID: <YEjfEzDfRdd0fK88@kernel.org>
References: <20210303150323.433207-1-jarkko@kernel.org>
 <20210303150323.433207-2-jarkko@kernel.org>
 <57b33fb5-f961-5c81-72f1-ebf5e6af671c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57b33fb5-f961-5c81-72f1-ebf5e6af671c@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 08:56:52AM -0800, Dave Hansen wrote:
> On 3/3/21 7:03 AM, Jarkko Sakkinen wrote:
> > If sgx_page_cache_init() fails in the middle, a trivial return
> > statement causes unused memory and virtual address space reserved for
> > the EPC section, not freed. Fix this by using the same rollback, as
> > when sgx_page_reclaimer_init() fails.
> ...
> > @@ -708,8 +708,10 @@ static int __init sgx_init(void)
> >  	if (!cpu_feature_enabled(X86_FEATURE_SGX))
> >  		return -ENODEV;
> >  
> > -	if (!sgx_page_cache_init())
> > -		return -ENOMEM;
> > +	if (!sgx_page_cache_init()) {
> > +		ret = -ENOMEM;
> > +		goto err_page_cache;
> > +	}
> 
> 
> Currently, the only way sgx_page_cache_init() can fail is in the case
> that there are no sections:
> 
>         if (!sgx_nr_epc_sections) {
>                 pr_err("There are zero EPC sections.\n");
>                 return false;
>         }
> 
> That only happened if all sgx_setup_epc_section() calls failed.
> sgx_setup_epc_section() never both allocates memory with vmalloc for
> section->pages *and* fails.  If sgx_setup_epc_section() has a successful
> memremap() but a failed vmalloc(), it cleans up with memunmap().
> 
> In other words, I see how this _looks_ like a memory leak from
> sgx_init(), but I don't see an actual leak in practice.
> 
> Am I missing something?

In sgx_setup_epc_section():


	section->pages = vmalloc(nr_pages * sizeof(struct sgx_epc_page));
	if (!section->pages) {
		memunmap(section->virt_addr);
		return false;
	}

I.e. this rollback does not happen without this fix applied:

	for (i = 0; i < sgx_nr_epc_sections; i++) {
		vfree(sgx_epc_sections[i].pages);
		memunmap(sgx_epc_sections[i].virt_addr);
	}

/Jarkko

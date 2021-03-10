Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FE2334A29
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 22:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhCJVxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 16:53:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231267AbhCJVxE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 16:53:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CE8864FC4;
        Wed, 10 Mar 2021 21:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615413184;
        bh=EwsKrrbncZeCnhMF4JXbIPhZYAxrRS99Wmz783LaGa4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P3zXB+SDDs+GqkX8ZZn8CDmAPTB3lj8wYot8pek1kUSzwqGGnxG/koXowN6ck1vW8
         JjtFM3jHbuui53lbZ6zBIyeAyiburKmnfCnHwoZdLVrI4ezLG7mk7CYnT3VaV739U1
         cSWqitRuqewagfIxCcOYuvVQ7Mz811iSOSM+UNj6PtMnul/XYZiHQelDOPV+GH601D
         3mmX+LstY2uy04ZRW7fgwCdyTZc3uu8xf6Dvz0jKc6xKqtvRXxL19Rec7fw7aCIv2G
         FJLoQBi69//Nrng8UgKF6zHQEqdOCs81eOBHzCemqwHOwI/F1JDN3RMOL1eWzgaGO7
         ds8lKDjlLZpJA==
Date:   Wed, 10 Mar 2021 23:52:40 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Serge Ayoun <serge.ayoun@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] x86/sgx: Fix a resource leak in sgx_init()
Message-ID: <YEk/qNwCkL63CYFy@kernel.org>
References: <20210303150323.433207-1-jarkko@kernel.org>
 <20210303150323.433207-2-jarkko@kernel.org>
 <57b33fb5-f961-5c81-72f1-ebf5e6af671c@intel.com>
 <YEjfEzDfRdd0fK88@kernel.org>
 <YEjqieABvycpGn0h@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEjqieABvycpGn0h@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 07:49:29AM -0800, Sean Christopherson wrote:
> On Wed, Mar 10, 2021, Jarkko Sakkinen wrote:
> > On Wed, Mar 03, 2021 at 08:56:52AM -0800, Dave Hansen wrote:
> > > On 3/3/21 7:03 AM, Jarkko Sakkinen wrote:
> > > > If sgx_page_cache_init() fails in the middle, a trivial return
> > > > statement causes unused memory and virtual address space reserved for
> > > > the EPC section, not freed. Fix this by using the same rollback, as
> > > > when sgx_page_reclaimer_init() fails.
> > > ...
> > > > @@ -708,8 +708,10 @@ static int __init sgx_init(void)
> > > >  	if (!cpu_feature_enabled(X86_FEATURE_SGX))
> > > >  		return -ENODEV;
> > > >  
> > > > -	if (!sgx_page_cache_init())
> > > > -		return -ENOMEM;
> > > > +	if (!sgx_page_cache_init()) {
> > > > +		ret = -ENOMEM;
> > > > +		goto err_page_cache;
> > > > +	}
> > > 
> > > 
> > > Currently, the only way sgx_page_cache_init() can fail is in the case
> > > that there are no sections:
> > > 
> > >         if (!sgx_nr_epc_sections) {
> > >                 pr_err("There are zero EPC sections.\n");
> > >                 return false;
> > >         }
> > > 
> > > That only happened if all sgx_setup_epc_section() calls failed.
> > > sgx_setup_epc_section() never both allocates memory with vmalloc for
> > > section->pages *and* fails.  If sgx_setup_epc_section() has a successful
> > > memremap() but a failed vmalloc(), it cleans up with memunmap().
> > > 
> > > In other words, I see how this _looks_ like a memory leak from
> > > sgx_init(), but I don't see an actual leak in practice.
> > > 
> > > Am I missing something?
> > 
> > In sgx_setup_epc_section():
> > 
> > 
> > 	section->pages = vmalloc(nr_pages * sizeof(struct sgx_epc_page));
> > 	if (!section->pages) {
> > 		memunmap(section->virt_addr);
> > 		return false;
> > 	}
> > 
> > I.e. this rollback does not happen without this fix applied:
> > 
> > 	for (i = 0; i < sgx_nr_epc_sections; i++) {
> > 		vfree(sgx_epc_sections[i].pages);
> > 		memunmap(sgx_epc_sections[i].virt_addr);
> > 	}
> 
> Dave is pointing out that sgx_page_cache_init() fails if and only if _all_
> sections fail sgx_setup_epc_section(), and if all sections fail then
> sgx_nr_epc_sections is '0' and the above is a nop.
> 
> That behavior is by design, as we didn't want to kill SGX if a single section
> failed to initialize for whatever reason.

My bad. You're correct. I got mixed up by the rollback :-) Thanks!

I'll just drop the whole patch.

/Jarkko

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCFA22AC2A
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 12:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgGWKIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 06:08:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgGWKIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 06:08:49 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CBB22086A;
        Thu, 23 Jul 2020 10:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595498928;
        bh=AML2GZZ2Ph91q1oR/Eg49IMw55Q5QbxKvzvu1iz4bIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=znBEr0fjlV5rdxomE2c2cQfMuQCavRErZqYac5EeyDHjYb8f0l2fdRZsHNZmfC2wq
         yy/ZPIbgy+ilYflMX3t24hpAMnehRlU3O/PJIcrtIvDsQtxVLtJH/IKUVkubqYQZ+J
         lp0pMsjHDo6n8wGKQefFPgy22LP0Efb/r3nN81AE=
Date:   Thu, 23 Jul 2020 11:08:44 +0100
From:   Will Deacon <will@kernel.org>
To:     Quentin Perret <qperret@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        james.morse@arm.com, suzuki.poulose@arm.com,
        kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Don't inherit exec permission across
 page-table levels
Message-ID: <20200723100843.GA15711@willie-the-truck>
References: <20200722131511.14639-1-will@kernel.org>
 <20200722155428.GA275809@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722155428.GA275809@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Quentin,

On Wed, Jul 22, 2020 at 04:54:28PM +0100, Quentin Perret wrote:
> On Wednesday 22 Jul 2020 at 14:15:10 (+0100), Will Deacon wrote:
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 8c0035cab6b6..69dc36d1d486 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1326,7 +1326,7 @@ static bool stage2_get_leaf_entry(struct kvm *kvm, phys_addr_t addr,
> >  	return true;
> >  }
> >  
> > -static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
> > +static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr, unsigned long sz)
> >  {
> >  	pud_t *pudp;
> >  	pmd_t *pmdp;
> > @@ -1338,9 +1338,9 @@ static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
> >  		return false;
> >  
> >  	if (pudp)
> > -		return kvm_s2pud_exec(pudp);
> > +		return sz == PUD_SIZE && kvm_s2pud_exec(pudp);
> >  	else if (pmdp)
> > -		return kvm_s2pmd_exec(pmdp);
> > +		return sz == PMD_SIZE && kvm_s2pmd_exec(pmdp);
> >  	else
> >  		return kvm_s2pte_exec(ptep);
> 
> This wants a 'sz == PAGE_SIZE' check, otherwise you'll happily inherit
> the exec flag when a PTE has exec rights while you create a block
> mapping on top.

Nice catch! Somehow I thought we always had PAGE_SIZE in the 'else' case,
but that's obviously not true now that you've pointed it out.

> Also, I think it should be safe to make the PMD and PUD case more
> permissive, as 'sz <= PMD_SIZE' for instance, as the icache
> invalidation shouldn't be an issue there? That probably doesn't matter
> all that much though.

I'll make that change anyway.

> > @@ -1958,7 +1958,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  	 * execute permissions, and we preserve whatever we have.
> >  	 */
> >  	needs_exec = exec_fault ||
> > -		(fault_status == FSC_PERM && stage2_is_exec(kvm, fault_ipa));
> > +		(fault_status == FSC_PERM &&
> > +		 stage2_is_exec(kvm, fault_ipa, vma_pagesize));
> >  
> >  	if (vma_pagesize == PUD_SIZE) {
> >  		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
> > -- 
> > 2.28.0.rc0.105.gf9edc3c819-goog
> > 
> 
> FWIW, I reproduced the issue with a dummy guest accessing memory just
> the wrong way, and toggling dirty logging at the right moment. And this
> patch + my suggestion above seems to cure things.

Testing?! It'll never catch on...

> So, with the above applied:
> 
> Reviewed-by: Quentin Perret <qperret@google.com>
> Tested-by: Quentin Perret <qperret@google.com>

Cheers. v2 coming up.

Will

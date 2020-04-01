Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB2A19AC3A
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 15:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732439AbgDANAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 09:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732370AbgDANAX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 09:00:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7197B206E9;
        Wed,  1 Apr 2020 13:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585746022;
        bh=zHyBMVhaIhlISRnToLLwxhZaI6ACFg6J6D55j8fChhk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jiG8NUvZAtehOd9HFhr7qayqLGRP8D9fmH6bohxobCVFBr5j3+HUfKYeKLIEfs7xG
         zDkdETym3MeF3K6sPVYKt8xTccUsbKJUQ6XhjbUiC+/SFPOda/H6hWnipB4u+jIDnn
         VEmA0GG4RGcpP6FWLgHhQXX2Yjqr1p7+tHU0xfA4=
Date:   Wed, 1 Apr 2020 15:00:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhuang Yanying <ann.zhuangyanying@huawei.com>
Cc:     pbonzini@redhat.com, tv@lio96.de, stable@vger.kernel.org,
        LinFeng <linfeng23@huawei.com>
Subject: Re: [PATCH 2/2] KVM: special handling of zero_page in some flows
Message-ID: <20200401130020.GB2262255@kroah.com>
References: <1585745456-24340-1-git-send-email-ann.zhuangyanying@huawei.com>
 <1585745456-24340-3-git-send-email-ann.zhuangyanying@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585745456-24340-3-git-send-email-ann.zhuangyanying@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 08:50:56PM +0800, Zhuang Yanying wrote:
> From: LinFeng <linfeng23@huawei.com>
> 
> Just adding !is_zero_page() to kvm_is_reserved_pfn() is too
> rough. According to commit:e433e83bc3("KVM: MMU: Do not treat
> ZONE_DEVICE pages as being reserved"), special handling in some
> other flows is also need by zero_page, if not treat zero_page as
> being reserved.
> 
> Signed-off-by: LinFeng <linfeng23@huawei.com>
> Signed-off-by: Zhuang Yanying <ann.zhuangyanying@huawei.com>
> ---
>  arch/x86/kvm/mmu.c  | 2 ++
>  virt/kvm/kvm_main.c | 6 +++---
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 732c0270a489..e8db17d87c1a 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2961,6 +2961,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>  	 * here.
>  	 */
>  	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
> +	    !is_zero_pfn(pfn) &&
>  	    level == PT_PAGE_TABLE_LEVEL &&
>  	    PageTransCompoundMap(pfn_to_page(pfn)) &&
>  	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
> @@ -5010,6 +5011,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  		 */
>  		if (sp->role.direct &&
>  			!kvm_is_reserved_pfn(pfn) &&
> +			!is_zero_pfn(pfn) &&
>  			PageTransCompoundMap(pfn_to_page(pfn))) {
>  			drop_spte(kvm, sptep);
>  			need_tlb_flush = 1;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7f7c22a687c0..fc0446bb393b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1660,7 +1660,7 @@ static struct page *kvm_pfn_to_page(kvm_pfn_t pfn)
>  	if (is_error_noslot_pfn(pfn))
>  		return KVM_ERR_PTR_BAD_PAGE;
>  
> -	if (kvm_is_reserved_pfn(pfn)) {
> +	if (kvm_is_reserved_pfn(pfn) && is_zero_pfn(pfn)) {
>  		WARN_ON(1);
>  		return KVM_ERR_PTR_BAD_PAGE;
>  	}
> @@ -1719,7 +1719,7 @@ static void kvm_release_pfn_dirty(kvm_pfn_t pfn)
>  
>  void kvm_set_pfn_dirty(kvm_pfn_t pfn)
>  {
> -	if (!kvm_is_reserved_pfn(pfn)) {
> +	if (!kvm_is_reserved_pfn(pfn) && !is_zero_pfn(pfn)) {
>  		struct page *page = pfn_to_page(pfn);
>  
>  		if (!PageReserved(page))
> @@ -1730,7 +1730,7 @@ EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
>  
>  void kvm_set_pfn_accessed(kvm_pfn_t pfn)
>  {
> -	if (!kvm_is_reserved_pfn(pfn))
> +	if (!kvm_is_reserved_pfn(pfn) && !is_zero_pfn(pfn))
>  		mark_page_accessed(pfn_to_page(pfn));
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
> -- 
> 2.23.0
> 
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

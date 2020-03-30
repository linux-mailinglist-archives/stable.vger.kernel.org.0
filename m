Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8306197D2B
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 15:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgC3Nku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 09:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727276AbgC3Nku (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 09:40:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1EEF20771;
        Mon, 30 Mar 2020 13:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585575649;
        bh=QYNmt9DwUijGnD5EW+rD7wXTenM30N2BJv89lk/Q9oI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c6P9xFuhdq45/9iGm0PMX5+1WcqAyNMnmjqCrqy+UhcvfNAeWmHV3/V4EcZ7gyhU9
         f9zpB2RuJ7SJHr3YzJyvug6DgN8UcpChG2X52PzL9xkKJG0ofBZD2c8wE2rlQaPQao
         QAwA6xbRPRjOLM5V0vxKvBoXqdMs4BH9jga88z6g=
Date:   Mon, 30 Mar 2020 15:40:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhuang Yanying <ann.zhuangyanying@huawei.com>
Cc:     tv@lio96.de, stable@vger.kernel.org, pbonzini@redhat.com,
        LinFeng <linfeng23@huawei.com>
Subject: Re: [PATCH 2/2] KVM: special handling of zero_page in some flows
Message-ID: <20200330134047.GB332213@kroah.com>
References: <8350b14e-f708-f2e3-19cd-4e85a4a3235c@redhat.com>
 <1585575162-37912-1-git-send-email-ann.zhuangyanying@huawei.com>
 <1585575162-37912-3-git-send-email-ann.zhuangyanying@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585575162-37912-3-git-send-email-ann.zhuangyanying@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 09:32:42PM +0800, Zhuang Yanying wrote:
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
> index d9c7e986b4e4..63155e67abf7 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2826,6 +2826,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>  	 * here.
>  	 */
>  	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
> +	    !is_zero_pfn(pfn) &&
>  	    level == PT_PAGE_TABLE_LEVEL &&
>  	    PageTransCompoundMap(pfn_to_page(pfn)) &&
>  	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
> @@ -4788,6 +4789,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  		 */
>  		if (sp->role.direct &&
>  			!kvm_is_reserved_pfn(pfn) &&
> +			!is_zero_pfn(pfn) &&
>  			PageTransCompoundMap(pfn_to_page(pfn))) {
>  			drop_spte(kvm, sptep);
>  			need_tlb_flush = 1;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d49cdd6ca883..ddc8c2a6e206 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1658,7 +1658,7 @@ static struct page *kvm_pfn_to_page(kvm_pfn_t pfn)
>  	if (is_error_noslot_pfn(pfn))
>  		return KVM_ERR_PTR_BAD_PAGE;
>  
> -	if (kvm_is_reserved_pfn(pfn)) {
> +	if (kvm_is_reserved_pfn(pfn) && is_zero_pfn(pfn)) {
>  		WARN_ON(1);
>  		return KVM_ERR_PTR_BAD_PAGE;
>  	}
> @@ -1717,7 +1717,7 @@ static void kvm_release_pfn_dirty(kvm_pfn_t pfn)
>  
>  void kvm_set_pfn_dirty(kvm_pfn_t pfn)
>  {
> -	if (!kvm_is_reserved_pfn(pfn)) {
> +	if (!kvm_is_reserved_pfn(pfn) && !is_zero_pfn(pfn)) {
>  		struct page *page = pfn_to_page(pfn);
>  
>  		if (!PageReserved(page))
> @@ -1728,7 +1728,7 @@ EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
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

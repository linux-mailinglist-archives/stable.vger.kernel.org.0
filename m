Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4BE19AC38
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 15:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732252AbgDANAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 09:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732439AbgDANAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 09:00:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19EA5206E9;
        Wed,  1 Apr 2020 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585746015;
        bh=wbmMtKq8OesIKxt+Bsmwbn40mtVE28sFlu9uvzGCJ/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OOsNRY9AaGA++EpA0phgb7wmYuxQ2avG089cH2y62rBdGPajH/5VSbDnP8H3ZllCg
         d7Ij2FCzOyNOcK8gmRS+dDUZs75QNmDCUZSj9BI47Z+NQNEZ3lq8yR5hraQGu+/7P8
         hdoRT+lUwMSXoDmPOCoX93KLfKm5vZr2TO13ZxLU=
Date:   Wed, 1 Apr 2020 15:00:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhuang Yanying <ann.zhuangyanying@huawei.com>
Cc:     pbonzini@redhat.com, tv@lio96.de, stable@vger.kernel.org,
        LinFeng <linfeng23@huawei.com>
Subject: Re: [PATCH 0/2] KVM: fix overflow of zero page refcount with ksm
 running
Message-ID: <20200401130011.GA2262255@kroah.com>
References: <1585745456-24340-1-git-send-email-ann.zhuangyanying@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585745456-24340-1-git-send-email-ann.zhuangyanying@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 08:50:54PM +0800, Zhuang Yanying wrote:
> From: LinFeng <linfeng23@huawei.com>
> 
> We found that the !is_zero_page() in kvm_is_mmio_pfn() was
> submmited in commit:90cff5a8cc("KVM: check for !is_zero_pfn() in
> kvm_is_mmio_pfn()"), but reverted in commit:0ef2459983("kvm: fix
> kvm_is_mmio_pfn() and rename to kvm_is_reserved_pfn()").
> 
> Maybe just adding !is_zero_page() to kvm_is_reserved_pfn() is too
> rough. According to commit:e433e83bc3("KVM: MMU: Do not treat
> ZONE_DEVICE pages as being reserved"), special handling in some
> other flows is also need by zero_page, if we would treat zero_page
> as being reserved.
> 
> Well, as fixing all functions reference to kvm_is_reserved_pfn() in
> this patch, we found that only kvm_release_pfn_clean() and
> kvm_get_pfn() don't need special handling.
> 
> So, we thought why not only check is_zero_page() in before get and
> put page, and revert our last commit:31e813f38f("KVM: fix overflow
> of zero page refcount with ksm running") in master.
> Instead of adding !is_zero_page() in kvm_is_reserved_pfn(),
> new idea is as follow:
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7f9ee2929cfe..f9a1f9cf188e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1695,7 +1695,8 @@ EXPORT_SYMBOL_GPL(kvm_release_page_clean);
> 
>  void kvm_release_pfn_clean(kvm_pfn_t pfn)
>  {
> -	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn))
> +	if (!is_error_noslot_pfn(pfn) &&
> +	    (!kvm_is_reserved_pfn(pfn) || is_zero_pfn(pfn)))
>  		put_page(pfn_to_page(pfn));
>  }
>  EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
> @@ -1734,7 +1735,7 @@ EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
> 
>  void kvm_get_pfn(kvm_pfn_t pfn)
>  {
> -	if (!kvm_is_reserved_pfn(pfn))
> +	if (!kvm_is_reserved_pfn(pfn) || is_zero_pfn(pfn))
>  		get_page(pfn_to_page(pfn));
>  }
>  EXPORT_SYMBOL_GPL(kvm_get_pfn);
> 
> We are confused why ZONE_DEVICE not do this, but treating it as
> no reserved. Is it racy if we change only use the patch in cover letter,
> but not the series patches.
> 
> And we check the code of v4.9.y v4.10.y v4.11.y v4.12.y, this bug exists
> in v4.11.y and later, but not in v4.9.y v4.10.y or before.
> After commit:e86c59b1b1("mm/ksm: improve deduplication of zero pages
> with colouring"), ksm will use zero pages with colouring. This feature
> was added in v4.11.y, so I wonder why v4.9.y has this bug.
> 
> We use crash tools attaching to /proc/kcore to check the refcount of
> zero_page, then create and destroy vm. The refcount stays at 1 on v4.9.y,
> well it increases only after v4.11.y. Are you sure it is the same bug
> you run into? Is there something we missing?
> 
> LinFeng (1):
>   KVM: special handling of zero_page in some flows
> 
> Zhuang Yanying (1):
>   KVM: fix overflow of zero page refcount with ksm running
> 
>  arch/x86/kvm/mmu.c  | 2 ++
>  virt/kvm/kvm_main.c | 9 +++++----
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
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

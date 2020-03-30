Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F75197D29
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 15:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgC3Nkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 09:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728091AbgC3Nkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 09:40:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0B932073B;
        Mon, 30 Mar 2020 13:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585575642;
        bh=Rq9pjcYdP+FLKKa18jxJtMzX9TjOTiqhSQsNTmLSUw0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NvYJsEyD1r0L7+hpm3gz+UKkVljgej39Mq0EXVrDTC2qpIC6wsSEIL/6DEq6AA2JW
         4sXwLGPakXENXByu780o2C7etdrUPkb5pQKcjAp9LiOctAoy+Ani/x+JM3+ZB4RYAH
         0f3tSGw9XIs/QmBWvDENHqDwKnO+fYcocUnb9bGk=
Date:   Mon, 30 Mar 2020 15:40:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhuang Yanying <ann.zhuangyanying@huawei.com>
Cc:     tv@lio96.de, stable@vger.kernel.org, pbonzini@redhat.com,
        LinFeng <linfeng23@huawei.com>
Subject: Re: [PATCH 0/2] KVM: fix overflow of zero page refcount with ksm
 running
Message-ID: <20200330134039.GA332213@kroah.com>
References: <8350b14e-f708-f2e3-19cd-4e85a4a3235c@redhat.com>
 <1585575162-37912-1-git-send-email-ann.zhuangyanying@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585575162-37912-1-git-send-email-ann.zhuangyanying@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 09:32:40PM +0800, Zhuang Yanying wrote:
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
> other flows is also need by zero_page, if we treat zero_page as
> being reserved.
> 
> Well, as fixing all functions reference to kvm_is_reserved_pfn() in
> this patch, we found that only kvm_release_pfn_clean() and
> kvm_get_pfn() don't need special handling.
> 
> So, we thought why not only check is_zero_page() in before get and
> put page, and revert our last commit:31e813f38f("KVM: fix overflow
> of zero page refcount with ksm running").
> Instead of add !is_zero_page() in kvm_is_reserved_pfn(),
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

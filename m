Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BABC109A5C
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 09:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfKZInc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 03:43:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55951 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725940AbfKZInb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 03:43:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574757810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=qRebXvy1MrUFFQVKp4nVYsX6imAAqHN+087BgM7udBw=;
        b=h3pVz7sA3GpUKGssHhBFLCAEekYW52zowjfZD+ldseLLft0dBi6bhKbpA6xv5ZJ9cK7EKD
        JyEBeRTZV5Sml9KmMOPQ+m6ATL6BKXpArQigpwbNFJf4nO+DQmlDy7DxSBrayPQdUQF+7N
        tdTzF+0+8YOQBxyn5khUOThxeVO+5J8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-6JGIp6EXMTqIc9HyYZOnqA-1; Tue, 26 Nov 2019 03:43:27 -0500
Received: by mail-wr1-f72.google.com with SMTP id h7so10218510wrb.2
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 00:43:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qRebXvy1MrUFFQVKp4nVYsX6imAAqHN+087BgM7udBw=;
        b=gLTAT8uJRaS3/oueem5F2AJmHU98NIqi2iHNPBQng6Qyde1tSdkJJzmzUHKNpjon4z
         EtB90mNX4HXf4+6E1E+1qM3I++PCPtEwLqDXgANU6pC7gPSnS8sUQn9+JZ+0IZqpG2R/
         Gr8rjDQpr0v7jQL7vFk+4TepP8LKwmj/f1o7H4OeAE2ZyiHkl2eXL/L195Ynx2d1gitE
         /J2S+k+FRUiTKNo6zT2b66yCv6ZhlQYl58jWviVnkdDjpKe5nWCaApYhECKijJFRkjY1
         VJSSYpEvjZtfUjo+s8Cmc/18I+tA4mPA2lXURlM9MjIPx5fDoeeW49RkZ/tGiy5Ahc8l
         B5+w==
X-Gm-Message-State: APjAAAWRnD+pdskl/CPzrqoolG/USsBazEsTfLwkeHiQ46gvQ56Q4+bp
        OzXZc32tf0dMZkXLZGZcl3fhi83Ucekktp5gHbXSZrbQgIIcw+8CryU31/oT0WFm4fjhJFZuGCJ
        O1JfP7EXJvdVpqjZT
X-Received: by 2002:a7b:c4c5:: with SMTP id g5mr3126955wmk.149.1574757805764;
        Tue, 26 Nov 2019 00:43:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqxLrI8+d0wHGbyZ5QRRU1gJlX4ez4u6d5OVvbwvaBXMv7PHoj4BXzLpaEbMWY3tbsAi1jvzQQ==
X-Received: by 2002:a7b:c4c5:: with SMTP id g5mr3126923wmk.149.1574757805345;
        Tue, 26 Nov 2019 00:43:25 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5454:a592:5a0a:75c? ([2001:b07:6468:f312:5454:a592:5a0a:75c])
        by smtp.gmail.com with ESMTPSA id z15sm2166228wmi.12.2019.11.26.00.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 00:43:24 -0800 (PST)
Subject: Re: [PATCH 4.14 STABLE] KVM: MMU: Do not treat ZONE_DEVICE pages as
 being reserved
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20191125190205.28474-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8fb87848-325b-41ea-5db1-cba9cec2355a@redhat.com>
Date:   Tue, 26 Nov 2019 09:43:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191125190205.28474-1-sean.j.christopherson@intel.com>
Content-Language: en-US
X-MC-Unique: 6JGIp6EXMTqIc9HyYZOnqA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/11/19 20:02, Sean Christopherson wrote:
> [ Upstream commit a78986aae9b2988f8493f9f65a587ee433e83bc3 ]
> 
> Explicitly exempt ZONE_DEVICE pages from kvm_is_reserved_pfn() and
> instead manually handle ZONE_DEVICE on a case-by-case basis.  For things
> like page refcounts, KVM needs to treat ZONE_DEVICE pages like normal
> pages, e.g. put pages grabbed via gup().  But for flows such as setting
> A/D bits or shifting refcounts for transparent huge pages, KVM needs to
> to avoid processing ZONE_DEVICE pages as the flows in question lack the
> underlying machinery for proper handling of ZONE_DEVICE pages.
> 
> This fixes a hang reported by Adam Borowski[*] in dev_pagemap_cleanup()
> when running a KVM guest backed with /dev/dax memory, as KVM straight up
> doesn't put any references to ZONE_DEVICE pages acquired by gup().
> 
> Note, Dan Williams proposed an alternative solution of doing put_page()
> on ZONE_DEVICE pages immediately after gup() in order to simplify the
> auditing needed to ensure is_zone_device_page() is called if and only if
> the backing device is pinned (via gup()).  But that approach would break
> kvm_vcpu_{un}map() as KVM requires the page to be pinned from map() 'til
> unmap() when accessing guest memory, unlike KVM's secondary MMU, which
> coordinates with mmu_notifier invalidations to avoid creating stale
> page references, i.e. doesn't rely on pages being pinned.
> 
> [*] http://lkml.kernel.org/r/20190919115547.GA17963@angband.pl
> 
> Reported-by: Adam Borowski <kilobyte@angband.pl>
> Analyzed-by: David Hildenbrand <david@redhat.com>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Cc: stable@vger.kernel.org
> Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [sean: backport to 4.x; resolve conflict in mmu.c]
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/mmu.c       |  8 ++++----
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/kvm_main.c      | 26 +++++++++++++++++++++++---
>  3 files changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 8cd26e50d41c..c0b0135ef07f 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -3177,7 +3177,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>  	 * here.
>  	 */
>  	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
> -	    level == PT_PAGE_TABLE_LEVEL &&
> +	    !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
>  	    PageTransCompoundMap(pfn_to_page(pfn)) &&
>  	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
>  		unsigned long mask;
> @@ -5344,9 +5344,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  		 * the guest, and the guest page table is using 4K page size
>  		 * mapping if the indirect sp has level = 1.
>  		 */
> -		if (sp->role.direct &&
> -			!kvm_is_reserved_pfn(pfn) &&
> -			PageTransCompoundMap(pfn_to_page(pfn))) {
> +		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
> +		    !kvm_is_zone_device_pfn(pfn) &&
> +		    PageTransCompoundMap(pfn_to_page(pfn))) {
>  			drop_spte(kvm, sptep);
>  			need_tlb_flush = 1;
>  			goto restart;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index bb4758ffd403..7668c68ddb5b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -890,6 +890,7 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
>  void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
>  
>  bool kvm_is_reserved_pfn(kvm_pfn_t pfn);
> +bool kvm_is_zone_device_pfn(kvm_pfn_t pfn);
>  
>  struct kvm_irq_ack_notifier {
>  	struct hlist_node link;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ea61162b2b53..cdaacdf7bc87 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -142,10 +142,30 @@ __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
>  {
>  }
>  
> +bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
> +{
> +	/*
> +	 * The metadata used by is_zone_device_page() to determine whether or
> +	 * not a page is ZONE_DEVICE is guaranteed to be valid if and only if
> +	 * the device has been pinned, e.g. by get_user_pages().  WARN if the
> +	 * page_count() is zero to help detect bad usage of this helper.
> +	 */
> +	if (!pfn_valid(pfn) || WARN_ON_ONCE(!page_count(pfn_to_page(pfn))))
> +		return false;
> +
> +	return is_zone_device_page(pfn_to_page(pfn));
> +}
> +
>  bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
>  {
> +	/*
> +	 * ZONE_DEVICE pages currently set PG_reserved, but from a refcounting
> +	 * perspective they are "normal" pages, albeit with slightly different
> +	 * usage rules.
> +	 */
>  	if (pfn_valid(pfn))
> -		return PageReserved(pfn_to_page(pfn));
> +		return PageReserved(pfn_to_page(pfn)) &&
> +		       !kvm_is_zone_device_pfn(pfn);
>  
>  	return true;
>  }
> @@ -1730,7 +1750,7 @@ static void kvm_release_pfn_dirty(kvm_pfn_t pfn)
>  
>  void kvm_set_pfn_dirty(kvm_pfn_t pfn)
>  {
> -	if (!kvm_is_reserved_pfn(pfn)) {
> +	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn)) {
>  		struct page *page = pfn_to_page(pfn);
>  
>  		if (!PageReserved(page))
> @@ -1741,7 +1761,7 @@ EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
>  
>  void kvm_set_pfn_accessed(kvm_pfn_t pfn)
>  {
> -	if (!kvm_is_reserved_pfn(pfn))
> +	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
>  		mark_page_accessed(pfn_to_page(pfn));
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


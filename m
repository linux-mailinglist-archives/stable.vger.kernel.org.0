Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7644528AF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 04:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbhKPDsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 22:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbhKPDsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 22:48:45 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A480C110EE9
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 16:03:55 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id np3so14225248pjb.4
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 16:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8J6SrWmOSBx0Eer2nFky7m+KMtaCM4n8TKtQXxkVHnw=;
        b=lwm06xDq1JW/PcHGiUjaY8OtAFoYPk/19/j8Z+AeoXlzC8UV5cJQq+1ROeZ7VmUhGH
         HPN9NAVhMztjXiaAzuR5J6ueTVhBt2xnDNYhCWKVjZN4GUW/SUjPnA5vubdw+BCSToCC
         6lC+CLzMRi965XkIqY9i5OomO6n/nbqDjwy09s87Mf/0sA296P/Ud9swjlnHwK+hLOJW
         DUCh5hiPnJpFUun9mGNhXH0GYh2sJyi7vTigj9wMH3+AGKXLCJPzF2Fys0h/BfxQMNXG
         L7fTUhhMdoEG6BxceC3j3V2iD1WtnmPYVWESwoRK3ruSnD3loEb41McNPM/8XIDG7A/l
         sYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8J6SrWmOSBx0Eer2nFky7m+KMtaCM4n8TKtQXxkVHnw=;
        b=O+/01C7QqoqrLN4D7PyREBCh+caVh7rjxOC/HXK7zL5giHRdG/HNgIKJfVj3icINrd
         nw1LITAh+Mhc/KhbiIju2LgHA5IInz/8+JUf3XmRdLHwhcyJLD20zS54lR3EjXXrLYgx
         CmDoYLTuT2s+ZSq/S3Wpl3IisxitciJZqyL6MZaIF9XuTtf9QlmDzv3/xOw6QxyaaehQ
         E0fGcQg/Iz/Pq/utdAccvOt8CAf1wd3fbR/ygDa30YC6UlrSZ8ndz1Z0X7xB2Hdpf6Yu
         KmNCZAEdMkFmFivUaO9HBORE0qjzpdUdW6HWyXP14KhPtOYnFiqHOgdimGmGZN3QMVSK
         r78g==
X-Gm-Message-State: AOAM530w1janObEIvU4eL47MdmtZvaBVR14eXGI9l9FtbetkZ7H2PopS
        JcCg2z8gzwSa1ryn9fEi9vR9jg==
X-Google-Smtp-Source: ABdhPJyU2Qq7WXKdSJ0HfPEpTBOs/zs4tQA39Ma0O/VfQlvcctfAnSKR5wJup402ZLmb3dhB0+ermQ==
X-Received: by 2002:a17:90b:4d09:: with SMTP id mw9mr3282146pjb.238.1637021034474;
        Mon, 15 Nov 2021 16:03:54 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d6sm15597690pfh.190.2021.11.15.16.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 16:03:53 -0800 (PST)
Date:   Tue, 16 Nov 2021 00:03:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] KVM: x86/mmu: Fix TLB flush range when handling
 disconnected pt
Message-ID: <YZL1ZiKQVRQd8rZi@google.com>
References: <20211115211704.2621644-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211115211704.2621644-1-bgardon@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021, Ben Gardon wrote:
> When recursively clearing out disconnected pts, the range based TLB
> flush in handle_removed_tdp_mmu_page uses the wrong starting GFN,
> resulting in the flush mostly missing the affected range. Fix this by
> using base_gfn for the flush.
> 
> In response to feedback from David Matlack on the RFC version of this
> patch, also move a few definitions into the for loop in the function to
> prevent unintended references to them in the future.

Rats, I didn't read David's feedback or I would've responded there.

> Fixes: a066e61f13cf ("KVM: x86/mmu: Factor out handling of removed page tables")
> CC: stable@vger.kernel.org
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7c5dd83e52de..4bd541050d21 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -317,9 +317,6 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
>  	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(pt));
>  	int level = sp->role.level;
>  	gfn_t base_gfn = sp->gfn;
> -	u64 old_child_spte;
> -	u64 *sptep;
> -	gfn_t gfn;
>  	int i;
>  
>  	trace_kvm_mmu_prepare_zap_page(sp);
> @@ -327,8 +324,9 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
>  	tdp_mmu_unlink_page(kvm, sp, shared);
>  
>  	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
> -		sptep = rcu_dereference(pt) + i;
> -		gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
> +		u64 *sptep = rcu_dereference(pt) + i;
> +		gfn_t gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
> +		u64 old_child_spte;

TL;DR: this type of optional refactoring doesn't belong in a patch Cc'd for stable,
and my personal preference is to always declare variables at function scope (it's
not a hard rule though, Paolo has overruled me at least once :-) ).

Declaring variables in an inner scope is not always "better".  In particular, it
can lead to variable shadowing, which can lead to functional issues of a different
sort.  Most shadowing is fairly obvious, and truly egregious bugs will often result
in the compiler complaining about consuming an uninitialized variable.

But the worst-case scenario is if the inner scope shadows a function parameter, in
which the case the compiler will not complain and will even consume an uninitialized
variable without warning.  IIRC, we actually had a Hyper-V bug of that nature
where an incoming @vcpu was shadowed.  Examples below.

So yes, on one hand moving the declarations inside the loop avoid potential flavor
of bug, but they create the possibility for an entirely different class of bugs.
The main reason I prefer declaring at function scope is that I find it easier to
visually detect using variables after a for loop, versus detecting that a variable
is being shadowed, especially if the function is largish and the two declarations
don't fit on the screen.

There are of course counter-examples, e.g. commit 5c49d1850ddd ("KVM: VMX: Fix a
TSX_CTRL_CPUID_CLEAR field mask issue") immediately jumps to mind, so there's
certainly an element of personal preference.

E.g. this will fail with "error: ‘sptep’ redeclared as different kind of symbol

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4e226cdb40d9..011639bf633c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -369,7 +369,7 @@ static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
  * early rcu_dereferences in the function.
  */
 static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
-                                       bool shared)
+                                       bool shared, u64 *sptep)
 {
        struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(pt));
        int level = sp->role.level;
@@ -431,8 +431,9 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
                                    shared);
        }

-       kvm_flush_remote_tlbs_with_address(kvm, gfn,
-                                          KVM_PAGES_PER_HPAGE(level + 1));
+       if (sptep)
+               kvm_flush_remote_tlbs_with_address(kvm, gfn,
+                                                  KVM_PAGES_PER_HPAGE(level + 1));

        call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
@@ -532,7 +533,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
         */
        if (was_present && !was_leaf && (is_leaf || !is_present))
                handle_removed_tdp_mmu_page(kvm,
-                               spte_to_child_pt(old_spte, level), shared);
+                               spte_to_child_pt(old_spte, level), shared, NULL);
 }

 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,


whereas moving the second declaration into the loop will compile happily.

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4e226cdb40d9..3e83fd66c0dc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -369,13 +369,12 @@ static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
  * early rcu_dereferences in the function.
  */
 static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
-                                       bool shared)
+                                       bool shared, u64 *sptep)
 {
        struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(pt));
        int level = sp->role.level;
        gfn_t base_gfn = sp->gfn;
        u64 old_child_spte;
-       u64 *sptep;
        gfn_t gfn;
        int i;

@@ -384,7 +383,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
        tdp_mmu_unlink_page(kvm, sp, shared);

        for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
-               sptep = rcu_dereference(pt) + i;
+               u64 *sptep = rcu_dereference(pt) + i;
                gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);

                if (shared) {
@@ -431,8 +430,9 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
                                    shared);
        }

-       kvm_flush_remote_tlbs_with_address(kvm, gfn,
-                                          KVM_PAGES_PER_HPAGE(level + 1));
+       if (sptep)
+               kvm_flush_remote_tlbs_with_address(kvm, gfn,
+                                                  KVM_PAGES_PER_HPAGE(level + 1));

        call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
@@ -532,7 +532,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
         */
        if (was_present && !was_leaf && (is_leaf || !is_present))
                handle_removed_tdp_mmu_page(kvm,
-                               spte_to_child_pt(old_spte, level), shared);
+                               spte_to_child_pt(old_spte, level), shared, NULL);
 }

 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,

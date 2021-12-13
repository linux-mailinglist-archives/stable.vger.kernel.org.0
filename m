Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836534731E3
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 17:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbhLMQgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 11:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbhLMQgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 11:36:06 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA58C061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 08:36:05 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id u80so15390073pfc.9
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 08:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5wyxUOFKzXzWH6KmMgR+HYDbJTzQzijXFBl960+ZGjY=;
        b=D8O81HGIxMuUln1CvFs5EppKQefv7NmfhODLWT6c95m5ppaYrbylr/8cX4L3KfDPG/
         KwTwxNpcAZUCpn1+SywI9p6Mo2PwVKUSmKkpKGoiWlgLqY8QzAhdXR4Lxf6Sx8B6KEOl
         9Y4wvQPORVDvX/Xq9OwUDBf7DgvYBz+tjueGiOed2Rrcz14r0yb+kNN5Vd+u6dHsWc0R
         XpqeSCjvAjo5yhyTI6ughv6riC68rRsXPaGBa+Xx/5U3yp8lAzBo+JWXzcJfW79E+Kpu
         kGbFUH4Jf4vKZdlaSqyIqPUQ9L9OG3S71vKMhrj57V8gSru8Qozg4tu/OmEFXTkNRm78
         MBvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5wyxUOFKzXzWH6KmMgR+HYDbJTzQzijXFBl960+ZGjY=;
        b=VpBV0+b803yy3Z9MI1jEUhqBYSCEWa0SHI85rwVG3CjJC46wcn0I5Dl+P+2Cj5RF+2
         t2C5Ftb/qiey0GYctEmbvpIxCsYNdRFB6M4yefCCqQjRdluQGkVqQeVbwB/KKALTIgGC
         6TWO8MoR7rfTlG0fVDI6LMoU6HNMYJGrOi5tH5Woj1gFNjl9hhtp0UBPjvVSARvTxw/q
         Xvc3uap+wTeLIcJHrMSAmiyim3HoXzvrfG1GzgbYNZYyOmGkC5/U7ZBvQqO3hgEKa1EX
         3V6ejmab9pS5SefeU3ZD4bc7l/N1nYS61JPTEDVbNRh5D7kuGrmLmrFVqcNuqxncwo3x
         4NTg==
X-Gm-Message-State: AOAM5337kpJxRtMZVoEWGQdUyMSY6swfk8/MZ/fB9gmfbyUdBXmsq70O
        54r3RbeUtcFF5BVyzTGLDatgag==
X-Google-Smtp-Source: ABdhPJyXncbWfDcnfXrMsKYIsvJnDH5haMuRwYLqcxc16EUEfKi0gk5UXHBHOqGpstTcilOU7RUBsw==
X-Received: by 2002:a63:c155:: with SMTP id p21mr46985502pgi.156.1639413364899;
        Mon, 13 Dec 2021 08:36:04 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y28sm12953221pfa.208.2021.12.13.08.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 08:36:04 -0800 (PST)
Date:   Mon, 13 Dec 2021 16:36:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ignat@cloudflare.com, bgardon@google.com, dmatlack@google.com,
        stevensd@chromium.org, kernel-team@cloudflare.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: zap invalid roots in kvm_tdp_mmu_zap_all
Message-ID: <Ybd2cEqUnxiy/JBd@google.com>
References: <20211213112514.78552-1-pbonzini@redhat.com>
 <20211213112514.78552-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213112514.78552-3-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021, Paolo Bonzini wrote:
> kvm_tdp_mmu_zap_all is intended to visit all roots and zap their page
> tables, which flushes the accessed and dirty bits out to the Linux
> "struct page"s.  Missing some of the roots has catastrophic effects,
> because kvm_tdp_mmu_zap_all is called when the MMU notifier is being
> removed and any PTEs left behind might become dangling by the time
> kvm-arch_destroy_vm tears down the roots for good.
> 
> Unfortunately that is exactly what kvm_tdp_mmu_zap_all is doing: it
> visits all roots via for_each_tdp_mmu_root_yield_safe, which in turn
> uses kvm_tdp_mmu_get_root to skip invalid roots.  If the current root is
> invalid at the time of kvm_tdp_mmu_zap_all, its page tables will remain
> in place but will later be zapped during kvm_arch_destroy_vm.

As stated in the bug report thread[*], it should be impossible as for the MMU
notifier to be unregistered while kvm_mmu_zap_all_fast() is running.

I do believe there's a race between set_nx_huge_pages() and kvm_mmu_notifier_release(),
but that would result in the use-after-free kvm_set_pfn_dirty() tracing back to
set_nx_huge_pages(), not kvm_destroy_vm().  And for that, I would much prefer we
elevant mm->users while changing the NX hugepage setting.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8f0035517450..985df4db8192 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6092,10 +6092,15 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
                mutex_lock(&kvm_lock);

                list_for_each_entry(kvm, &vm_list, vm_list) {
+                       if (!mmget_not_zero(kvm->mm))
+                               continue;
+
                        mutex_lock(&kvm->slots_lock);
                        kvm_mmu_zap_all_fast(kvm);
                        mutex_unlock(&kvm->slots_lock);

+                       mmput_async(kvm->mm);
+
                        wake_up_process(kvm->arch.nx_lpage_recovery_thread);
                }
                mutex_unlock(&kvm_lock);

[*] https://lore.kernel.org/all/Ybdxd7QcJI71UpHm@google.com/

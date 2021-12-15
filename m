Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FFC476651
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 00:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbhLOXFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 18:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbhLOXFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 18:05:07 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F71C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 15:05:06 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id o14so17831473plg.5
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 15:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lMlGfQcYsOkWIgxJk/RWiaBio+VGizOwATkBBqm0XI0=;
        b=QJi8+rVXfcVmd5wSI/t0hwk4ozX4If56kovh5WGEqW0Lj/Qr2f1oRw28AJKJHkTBh/
         RSvr8bqwCuwJxQbWz+VlZDuobtJG/cxe5U2Efr2extjyob/vQaRYqYJ/ClzTdHTR984O
         691+7BmNZL8eFvnk7JWOwD/T+EqjGkRUHcRtGxlgr2xD14/iid8uuBdhdtgGn+0FMCts
         Q/Z7BRjytIAnKZFn3+Z85cC+R7fvH+bwgrVRObDRG+3ppN8Qq1hEp1Wu8x9fi2VP3ash
         gUWu/CV01ESOAbZywyKH9d6g/Uce2mdM0TBL+vrf7PFY8MpPaeBEXFb7NK/yEWGtCtGh
         /Y5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lMlGfQcYsOkWIgxJk/RWiaBio+VGizOwATkBBqm0XI0=;
        b=tnC8bBQb5FsK7x2osGs6sAgv9AXYPtrt/PJzA6oEzeg11ws8ery6UFT67xRhwRqCs5
         4eM33NsPt4yw0sRyStrWtXppoKsElnB1qrVexcaHtCjVGtUFjlnWMZJ3aCe4xf9Z3UaI
         Pxz3zm6+Bjuod+l4V6Bm0jlRhAh6SO05lpoNclSUesHFINOyNUh3y52ssDCEnqlSTdhR
         T9Sn8VUCsI7+Kebz+DfsLJ8rvdRlmCBwzU1+1Mb008rjFdVjGfjm4OXU/7RzNl4DXG9U
         hF0PblBl/WKTeXvdAY2SgOCWuSAW8GV0YL17FXJ7Jc+Kytfmz7ajP9OK7Bb5l5m3wKbm
         9Nvw==
X-Gm-Message-State: AOAM531E0J+pw1m2ocakw86NEoqr0HMCA5Ks2LETdVHdMey453ivsNgM
        llrsDJZJtrLkKlVRkPB6vJIfrw==
X-Google-Smtp-Source: ABdhPJx9XLJQ6xCAHKllz9JUst0yO3JIpfP6cQO9WwJ2r9rPmGiCtICJ+Kxfomo5ap7ifZTriY0vhw==
X-Received: by 2002:a17:90b:3ecc:: with SMTP id rm12mr2439322pjb.75.1639609505811;
        Wed, 15 Dec 2021 15:05:05 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k18sm3903088pfc.155.2021.12.15.15.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 15:05:05 -0800 (PST)
Date:   Wed, 15 Dec 2021 23:05:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Subject: Re: [PATCH RFC] KVM: x86/mmu: fix UAF in
 paging_update_accessed_dirty_bits
Message-ID: <Ybp0naX/ZTG9FNEa@google.com>
References: <20211214232039.851405-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214232039.851405-1-tadeusz.struk@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 14, 2021, Tadeusz Struk wrote:
> Syzbot reported an use-after-free bug in update_accessed_dirty_bits().
> Fix this by checking if the memremap'ed pointer is still valid.

...

> Fixes: bd53cb35a3e9 ("X86/KVM: Handle PFNs outside of kernel reach when touching GPTEs")
> Link: https://syzkaller.appspot.com/bug?id=6cb6102a0a7b0c52060753dd62d070a1d1e71347
> Reported-by: syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
>  arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 708a5d297fe1..5cf4815d1c45 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -174,7 +174,7 @@ static int FNAME(cmpxchg_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  		pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;

Isn't this code flat out wrong?  vm_pgoff is usually the offset relative to the
file and has nothing to do with the pfn.  I see that remap_pfn_range_notrack()
stuffs "vma->vm_pgoff = pfn", but that's a weird quirk of that particular usage
of VM_PFNMAP that I'm guessing happened to align with the original usage of this
mess.  But unless there's magic I'm missing, vm_pgoff is not guaranteed to have
any relation to the pfn for any ol' VM_PFNMAP vma.

In other words, I suspect pfn and paddr are complete garbage, and adding the
access_ok() check masks that.

>  		paddr = pfn << PAGE_SHIFT;
>  		table = memremap(paddr, PAGE_SIZE, MEMREMAP_WB);
> -		if (!table) {
> +		if (!table || !access_ok(table, PAGE_SIZE)) {
>  			mmap_read_unlock(current->mm);
>  			return -EFAULT;
>  		}
> -- 
> 2.33.1
> 

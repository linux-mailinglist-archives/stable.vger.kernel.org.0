Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D03539EDC0
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 06:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhFHEln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 00:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhFHElm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 00:41:42 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06698C061574;
        Mon,  7 Jun 2021 21:39:49 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id f5so17967608eds.0;
        Mon, 07 Jun 2021 21:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LQ327vLf2sAX9sBZj4rwUXDi/YVyuwzwG/5bRkeSlQ0=;
        b=oIc3qYWdS/Aix0YmXu+hclQVy6hCkQOX88bQOG1+ihlh53aBNDvkk7iME9lD+yOowI
         j6hhdzojIMNghYHMIcLNHYZGIa03in0uTUEFgrxloNgCj7CRBw5MVdqGD3caZidCiSix
         STlpMCcMFcKFSyaIfRzlWjP8QiK0mofw8x4hHyNvKVhwmxHT1dPIc3OiDOGqV03IMvW8
         ETGNw5aoQ8QCOp1Olei8Zj0roSXfcrdGAbBuRZkNl7P3WaFQMOiaw5wMBpef2w8iuMid
         PvLpQvRGMcaO46yJcmwO1ksVumRfniQ2lSSIvv++cvHrg/DyOotNtTJMq0zJf8YYLA2s
         iUew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=LQ327vLf2sAX9sBZj4rwUXDi/YVyuwzwG/5bRkeSlQ0=;
        b=b84MlDbrfVea0fVf3w62+Slnes16qgU+DkNxZPx1L7cyfB7ABVuiasOP6YNtAFfhK4
         E4y9urWTW8lPd0Zw8wvhiWoV2eWbSXjOGVrvpA1qKNGD3DmjbVjAiBlgRPRmnRzTayV5
         lI1HTenb0aFJYMokfCbfGQfWGEsoKFtY9djH8IJlA1kzHUVAFUr5fo1Iq+psJiaHeIPj
         wk47f6u9rxbdM21OjXrc9cNcWyl40Yyn4ZPGg1Ird75IyW1kX3R7X/3en2ZM/s8jidh7
         uM9wJJrVwE+lXxjhgFyGVJR/oQqHfd+D5aUnFlAk7xPmMEMWE4lCzPQ2jVQy9qRJJuGQ
         fovg==
X-Gm-Message-State: AOAM531YK3uoTby1+CrZclwnLzylUt891k6qrYfnPslql1B03SXZTRGX
        koUvTMVAMYaYuqi4xs3szq4=
X-Google-Smtp-Source: ABdhPJy4xt0G+/1aglGwDilU0Vo8L84hZxB28vs9FoD7yiBgTCbbBgQhXaz49hJ/mhjSdKNy4JO5Kg==
X-Received: by 2002:aa7:d798:: with SMTP id s24mr19190983edq.243.1623127188453;
        Mon, 07 Jun 2021 21:39:48 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id g11sm915975eds.24.2021.06.07.21.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 21:39:47 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Tue, 8 Jun 2021 06:39:46 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org, Wanpeng Li <kernellwp@gmail.com>
Subject: Re: [PATCH 1/2] KVM: SVM: avoid infinite loop on NPF from bad address
Message-ID: <YL70kh5/vLW8gmAY@eldamar.lan>
References: <20200417163843.71624-1-pbonzini@redhat.com>
 <20200417163843.71624-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417163843.71624-2-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paolo,

On Fri, Apr 17, 2020 at 12:38:42PM -0400, Paolo Bonzini wrote:
> When a nested page fault is taken from an address that does not have
> a memslot associated to it, kvm_mmu_do_page_fault returns RET_PF_EMULATE
> (via mmu_set_spte) and kvm_mmu_page_fault then invokes svm_need_emulation_on_page_fault.
> 
> The default answer there is to return false, but in this case this just
> causes the page fault to be retried ad libitum.  Since this is not a
> fast path, and the only other case where it is taken is an erratum,
> just stick a kvm_vcpu_gfn_to_memslot check in there to detect the
> common case where the erratum is not happening.
> 
> This fixes an infinite loop in the new set_memory_region_test.
> 
> Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 7 +++++++
>  virt/kvm/kvm_main.c    | 1 +
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a91e397d6750..c86f7278509b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3837,6 +3837,13 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>  	bool smap = cr4 & X86_CR4_SMAP;
>  	bool is_user = svm_get_cpl(vcpu) == 3;
>  
> +	/*
> +	 * If RIP is invalid, go ahead with emulation which will cause an
> +	 * internal error exit.
> +	 */
> +	if (!kvm_vcpu_gfn_to_memslot(vcpu, kvm_rip_read(vcpu) >> PAGE_SHIFT))
> +		return true;
> +
>  	/*
>  	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
>  	 *
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e2f60e313c87..e7436d054305 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1602,6 +1602,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
>  {
>  	return __gfn_to_memslot(kvm_vcpu_memslots(vcpu), gfn);
>  }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
>  
>  bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
>  {
> -- 
> 2.18.2

I noticed that this patch, whilst beeing CC'ed for stable, appers to
not have been applied to stable branches back then. There was first a
mail from Sasha's bot that patches do not apply and Wanpeng Li.

Did this simply felt through the cracks here or is it not worth
backporting to older series? At least
https://bugzilla.redhat.com/show_bug.cgi?id=1947982#c3 seem to
indicate it might not be worth of if there is risk for regression if I
understand Wanpeng Li. Is this right?

Regards,
Salvatore

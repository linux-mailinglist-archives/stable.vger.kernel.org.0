Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0334218217
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 10:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgGHISD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 04:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgGHISD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 04:18:03 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A97C08C5DC;
        Wed,  8 Jul 2020 01:18:02 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id r8so37125056oij.5;
        Wed, 08 Jul 2020 01:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/qD1naS8wsd2EhVt/M+vsUBKc2VxlIMTUtCT5APBmb8=;
        b=SymsVca5pFQCCFaUMvCW+p8zXKoPW57/AifVo6loHj3G3ZMuNEdPndUSr67k3LQD6O
         IONuzo1dRqgSK2pmyDmlbqpVHGMAdsbsKkDSUXaLMcAca1HvYtgK1fVgF0u1ao4srH3L
         9eMZf/UYwCL2bEpTdphwhk/g7eflRo8nH9TacBib2eMBARWQRkBcB/H/tVX0S2a1kvqN
         81Ha4VnR7EuXeeVcoc4F7NmucsKwaWxkZy6uI5v9JRt92cwO091o9CfBZr2P15NlMBdS
         0iZYVPYAs2CBP90xbu5S+1y4Egp1hO53wrfSwx/q5SA47/I1aA4JOMtJVIgnRMnvft0U
         IvkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/qD1naS8wsd2EhVt/M+vsUBKc2VxlIMTUtCT5APBmb8=;
        b=b2PjG90NFVSSpgHcIynHEXKglrJETPB1ClBQOK1Y4I0pEw3w5sTTSeH614LR0mv0Xx
         phjgVOUUwIAtbPQUoV0ccdmBb+c/2FQ/nyjm8+n6quZAHISb8etek8xFvVAqasaEfG/j
         n3ve90SKImO6tOEA1wt/Z/p3x3reljEGX9FEFUsHro+xAgxmT/0MmJwvqHfKhi8KjmbY
         0JuNdxoFwc3U/DJxGl6ZFy6Aezr32iiHiMJ6gcvVFc5fSanT2aASiM88WRzUKSt/Mg8o
         l+XJgQL6b4k7svxf4D9Rt+/VvQ5j5tpg1dhlVjG78K0B84Eg+EJ3xAS4lQep2pHhTLmg
         Z3Xg==
X-Gm-Message-State: AOAM533QroOWtehpFOBU+MWM/26PiYlry/Ehyduveba11MlOlZvvBJ8W
        jZZkRSzm8Z6ePbJq2OMpE2z2wjd1eiAQYFcRKqk=
X-Google-Smtp-Source: ABdhPJw/tiA3BCQR7zpDMd7jSoB9EFjDAwhK4Vb03FQ74u/mEXX7r77cGZ+tStwn8KI+qeHVppi8LmNYOypyLJ7MQAY=
X-Received: by 2002:aca:d643:: with SMTP id n64mr6264105oig.33.1594196282195;
 Wed, 08 Jul 2020 01:18:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200417163843.71624-1-pbonzini@redhat.com> <20200417163843.71624-2-pbonzini@redhat.com>
In-Reply-To: <20200417163843.71624-2-pbonzini@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 8 Jul 2020 16:17:51 +0800
Message-ID: <CANRm+CyWKbSU9FZkGoPx2nff-Se3Qcfn1TXXw8exy-6nuZrirg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: SVM: avoid infinite loop on NPF from bad address
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "# v3 . 10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 18 Apr 2020 at 00:39, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
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
>         bool smap = cr4 & X86_CR4_SMAP;
>         bool is_user = svm_get_cpl(vcpu) == 3;
>
> +       /*
> +        * If RIP is invalid, go ahead with emulation which will cause an
> +        * internal error exit.
> +        */
> +       if (!kvm_vcpu_gfn_to_memslot(vcpu, kvm_rip_read(vcpu) >> PAGE_SHIFT))
> +               return true;
> +
>         /*
>          * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
>          *
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e2f60e313c87..e7436d054305 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1602,6 +1602,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
>  {
>         return __gfn_to_memslot(kvm_vcpu_memslots(vcpu), gfn);
>  }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);

This commit incurs the linux guest fails to boot once add --overcommit
cpu-pm=on or not intercept hlt instruction, any thoughts?

<...>-35787 [038] ....  2825.959082: kvm_exit: vcpu 1 reason npf rip
0xfd11d info 100000014 fd000
<...>-35788 [037] ....  2825.959082: kvm_exit: vcpu 2 reason npf rip
0xfd11d info 100000014 fd000
<...>-35789 [036] ....  2825.959082: kvm_exit: vcpu 3 reason npf rip
0xfd11d info 100000014 fd000
<...>-35788 [037] ....  2825.959082: kvm_page_fault: address fd000 error_code 14
<...>-35789 [036] ....  2825.959082: kvm_page_fault: address fd000 error_code 14
<...>-35787 [038] ....  2825.959083: kvm_page_fault: address fd000 error_code 14
<...>-35788 [037] ....  2825.959086: kvm_emulate_insn: 0:fd11d: (prot32)
<...>-35788 [037] ....  2825.959086: kvm_emulate_insn: 0:fd11d: (prot32) failed
<...>-35789 [036] ....  2825.959087: kvm_emulate_insn: 0:fd11d: (prot32)
<...>-35789 [036] ....  2825.959087: kvm_emulate_insn: 0:fd11d: (prot32) failed
<...>-35788 [037] ....  2825.959087: kvm_fpu: unload
<...>-35787 [038] ....  2825.959087: kvm_emulate_insn: 0:fd11d: (prot32)
<...>-35787 [038] ....  2825.959087: kvm_emulate_insn: 0:fd11d: (prot32) failed
<...>-35789 [036] ....  2825.959087: kvm_fpu: unload
<...>-35787 [038] ....  2825.959088: kvm_fpu: unload
<...>-35788 [037] ....  2825.959088: kvm_userspace_exit: reason
KVM_EXIT_INTERNAL_ERROR (17)
<...>-35789 [036] ....  2825.959089: kvm_userspace_exit: reason
KVM_EXIT_INTERNAL_ERROR (17)
<...>-35787 [038] ....  2825.959089: kvm_userspace_exit: reason
KVM_EXIT_INTERNAL_ERROR (17)

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9236218323
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 11:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgGHJIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 05:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgGHJIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 05:08:42 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C685C08C5DC;
        Wed,  8 Jul 2020 02:08:42 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 18so36383568otv.6;
        Wed, 08 Jul 2020 02:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/pO1lbFCUd8JVwU/a/C5IVsUOfyRnCXcTbnllnxeuBc=;
        b=ghPAhjY89wPTtIb5w/erbhv+0Fu4o6P535grpb4/02l9c5Ecua3V4upA6wSmM9SMx0
         xtWAAaSRAjVWDWKsxP32g8hKqpQBeku2BlDUNd13Co4gN0YNetcGkuKRwBg8ctlxkJFo
         CKAbwXQpXIVLXiYlbWcMgia41QD2185eniFbgyffkSDlej7W96qNLpUtpbdmx0fRmi6k
         OmIyCZ7PiNSYxyOWFHVkgnYI3YuTzx0M4PwOYnYoRGwmkQyN5VfT2Jw0EfqdKCs8qrBC
         IZrHUpN6YnhJ7cjEbifPgF3IjB8lZqbAbbiCbKKGbEYe67AlNYAYOPDkwSFDKvx91gWA
         efRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/pO1lbFCUd8JVwU/a/C5IVsUOfyRnCXcTbnllnxeuBc=;
        b=dHAxM8h+Lw3OaBOoovG9gDkVU7igPuDm0CbgWSncrx/dH9V7baU9arFO2Cgatn0ybQ
         UdEWVSQZsYwwMNOC/e+6XixRLfqj/zvvyzH9WbOuEaAHl2tKAbtosrEozl5ckXUNHHdn
         L1OyOW1UANpfmsJP0LqfEONsx9XJxf1L7cAkJXLGQrDx40XYLY8OwDdX145CU8XaXAOK
         FkdclDCNCCv3E3/g01aoDlrAkWvH07l/FATFuWR4ykGYIgcUlGmeBu+6LnK7MLxmL/7P
         iZB9rc/iLv4rsNfbDPZIDGeS6jM8IFZ/izZEJABnejoB5OAhZUAA8+LYMYi10YQxpV5S
         zOcA==
X-Gm-Message-State: AOAM533p1rGTH++S2YusA1PehNiPyZHJGDAfUsDXEBBgBmzJ5GDRk4rA
        pw7nLEf2W4rmqZ8JeNttcHSsa4wYhknER4INztlrkg==
X-Google-Smtp-Source: ABdhPJzG8uWjy+Qg3xQqO7+HHpcnCYMSI0FRT+Xb0hwMEVHj2JqTVkb2Sl5Z6vYWYiJAD/qPNTNH98MTyENK31IFEss=
X-Received: by 2002:a9d:6f0d:: with SMTP id n13mr36728254otq.254.1594199321840;
 Wed, 08 Jul 2020 02:08:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200417163843.71624-1-pbonzini@redhat.com> <20200417163843.71624-2-pbonzini@redhat.com>
 <CANRm+CyWKbSU9FZkGoPx2nff-Se3Qcfn1TXXw8exy-6nuZrirg@mail.gmail.com> <57a405b3-6836-83f0-ed97-79f637f7b456@redhat.com>
In-Reply-To: <57a405b3-6836-83f0-ed97-79f637f7b456@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 8 Jul 2020 17:08:31 +0800
Message-ID: <CANRm+CzpFt5SwnQzJjRGp3T_Q=Ws3OWBx4FPmMK79qOx1v3NBQ@mail.gmail.com>
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

On Wed, 8 Jul 2020 at 16:38, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 08/07/20 10:17, Wanpeng Li wrote:
> > On Sat, 18 Apr 2020 at 00:39, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >> When a nested page fault is taken from an address that does not have
> >> a memslot associated to it, kvm_mmu_do_page_fault returns RET_PF_EMULATE
> >> (via mmu_set_spte) and kvm_mmu_page_fault then invokes svm_need_emulation_on_page_fault.
> >>
> >> The default answer there is to return false, but in this case this just
> >> causes the page fault to be retried ad libitum.  Since this is not a
> >> fast path, and the only other case where it is taken is an erratum,
> >> just stick a kvm_vcpu_gfn_to_memslot check in there to detect the
> >> common case where the erratum is not happening.
> >>
> >> This fixes an infinite loop in the new set_memory_region_test.
> >>
> >> Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> >> ---
> >>  arch/x86/kvm/svm/svm.c | 7 +++++++
> >>  virt/kvm/kvm_main.c    | 1 +
> >>  2 files changed, 8 insertions(+)
> >>
> >> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >> index a91e397d6750..c86f7278509b 100644
> >> --- a/arch/x86/kvm/svm/svm.c
> >> +++ b/arch/x86/kvm/svm/svm.c
> >> @@ -3837,6 +3837,13 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
> >>         bool smap = cr4 & X86_CR4_SMAP;
> >>         bool is_user = svm_get_cpl(vcpu) == 3;
> >>
> >> +       /*
> >> +        * If RIP is invalid, go ahead with emulation which will cause an
> >> +        * internal error exit.
> >> +        */
> >> +       if (!kvm_vcpu_gfn_to_memslot(vcpu, kvm_rip_read(vcpu) >> PAGE_SHIFT))
> >> +               return true;
> >> +
> >>         /*
> >>          * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
> >>          *
> >> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >> index e2f60e313c87..e7436d054305 100644
> >> --- a/virt/kvm/kvm_main.c
> >> +++ b/virt/kvm/kvm_main.c
> >> @@ -1602,6 +1602,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
> >>  {
> >>         return __gfn_to_memslot(kvm_vcpu_memslots(vcpu), gfn);
> >>  }
> >> +EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
> >
> > This commit incurs the linux guest fails to boot once add --overcommit
> > cpu-pm=on or not intercept hlt instruction, any thoughts?
>
> Can you write a selftest?

Actually I don't know what's happening here(why not intercept hlt
instruction has associated with this commit), otherwise, it has
already been fixed. :)

    Wanpeng

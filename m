Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 149B7B60DD
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 11:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfIRJ46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 05:56:58 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34868 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfIRJ46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 05:56:58 -0400
Received: by mail-ot1-f68.google.com with SMTP id z6so5800418otb.2;
        Wed, 18 Sep 2019 02:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=agCnoLfjObrBaiFi132vN3HPFhFbIn5vevMgsPbBMRY=;
        b=BCWII7Yp3FfzhtAXRh2UACCuTyy+YNJyVQVkbo1sgjPEyICaqkz8GzfGt+OMZ/6EcM
         t7AqI1gmcVVy5VtHngJ8Wg2JnOzqpaRQgpGa6bfWU9S9wmRXBv1NPa5GWOrKLdwaS8vO
         tVcO8XiIq17zQvN51vupWg3sKD6stplXCaScU0yCF5zIRnZPc1TxHX5nZazC/ElFbER5
         LEJYvT+ESBdY3optZWClrcBypzeJ6BlCdzwSMwzB+2WgTH5GU7QqfsKji/RU2zP2jGRM
         RxlVrzo03k1xsbLTfI9t3jWMcBg6DUf6Lbqwu8uS9quXkUgVW091Gd1kzhIJf2NgIXfc
         jdRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=agCnoLfjObrBaiFi132vN3HPFhFbIn5vevMgsPbBMRY=;
        b=KCJjz115tpxlmoXuSVgeXBzayMhDdg4pxfeN28OI7eJk+ePGxWlcBTPzFh5JITyec6
         zUr6RWObrDLi1e9lzTNQsrYzGcWFHZmeBkEhnipeHWHjMt06w1vnUubsEF9riX5hg7Fr
         /dK4gW4/ZlvfcaF47/T+gKf8/bm1OcLkDOSv68yBT6ze/sDuRRN6GHTJfEACBxv8DS/s
         AKHHVVALtEhQLgkqU4FH4ydVWvypN3g3B6Bmr7C6+zPpcJa6WxojVoomi7zKmVAQ1BAf
         To89FZR/l18bImSv/UYJn4SPAbuZkHB6SCnAr4K78Ov7aqvVkAZZ0+DJhYZg6Kq39+tO
         +OkA==
X-Gm-Message-State: APjAAAUhacwyduEaia47E/xfEnzpjM327sOflLNRLHWyiziDNI4wcG4I
        Rphc21NgmNCjJEdCPt+8zfKwAL6OMEht2Oct2pA=
X-Google-Smtp-Source: APXvYqzpf71cnwgl/oi3HgeIc3FlwQVwUoJCWeVhTPNnMMg9BEryd2z47aGUYZmVT5smNlTU6u3xaHBw24cw7I7Ggzw=
X-Received: by 2002:a9d:224b:: with SMTP id o69mr2047549ota.45.1568800616715;
 Wed, 18 Sep 2019 02:56:56 -0700 (PDT)
MIME-Version: 1.0
References: <1568708186-20260-1-git-send-email-wanpengli@tencent.com>
 <1568708186-20260-2-git-send-email-wanpengli@tencent.com> <20190917173258.GB2876@linux.intel.com>
In-Reply-To: <20190917173258.GB2876@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 18 Sep 2019 17:56:44 +0800
Message-ID: <CANRm+CwCw0aAc8zGVK9sAN-xZxt5F8mg1eanqT6NXyA2J0b6aw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: X86: Fix userspace set broken combinations of
 CPUID and CR4
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "# v3 . 10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 18 Sep 2019 at 01:32, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Sep 17, 2019 at 04:16:25PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Reported by syzkaller:
> >
> >       WARNING: CPU: 0 PID: 6544 at /home/kernel/data/kvm/arch/x86/kvm//vmx/vmx.c:4689 handle_desc+0x37/0x40 [kvm_intel]
> >       CPU: 0 PID: 6544 Comm: a.out Tainted: G           OE     5.3.0-rc4+ #4
> >       RIP: 0010:handle_desc+0x37/0x40 [kvm_intel]
> >       Call Trace:
> >        vmx_handle_exit+0xbe/0x6b0 [kvm_intel]
> >        vcpu_enter_guest+0x4dc/0x18d0 [kvm]
> >        kvm_arch_vcpu_ioctl_run+0x407/0x660 [kvm]
> >        kvm_vcpu_ioctl+0x3ad/0x690 [kvm]
> >        do_vfs_ioctl+0xa2/0x690
> >        ksys_ioctl+0x6d/0x80
> >        __x64_sys_ioctl+0x1a/0x20
> >        do_syscall_64+0x74/0x720
> >        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > When CR4.UMIP is set, guest should have UMIP cpuid flag. Current
> > kvm set_sregs function doesn't have such check when userspace inputs
> > sregs values. SECONDARY_EXEC_DESC is enabled on writes to CR4.UMIP
> > in vmx_set_cr4 though guest doesn't have UMIP cpuid flag. The testcast
> > triggers handle_desc warning when executing ltr instruction since
> > guest architectural CR4 doesn't set UMIP. This patch fixes it by
> > adding valid CR4 and CPUID combination checking in __set_sregs.
>
> Checking CPUID will fix this specific scenario, but it doesn't resolve
> the underlying issue of __set_sregs() ignoring the return of kvm_x86_ops'
> set_cr4(), e.g. I think vmx_set_cr4() can still fail if userspace sets a
> custom MSR_IA32_VMX_CR4_FIXED0 when nested VMX is on.
>
> > syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=138efb99600000
> >
> > Reported-by: syzbot+0f1819555fbdce992df9@syzkaller.appspotmail.com
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/x86.c | 39 ++++++++++++++++++++++++---------------
> >  1 file changed, 24 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f7cfd8e..cafb4d4 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -884,34 +884,42 @@ int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_set_xcr);
> >
> > -int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> > +static int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> >  {
> > -     unsigned long old_cr4 = kvm_read_cr4(vcpu);
> > -     unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
> > -                                X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
> > -
> > -     if (cr4 & CR4_RESERVED_BITS)
> > -             return 1;
> > -
> >       if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) && (cr4 & X86_CR4_OSXSAVE))
> > -             return 1;
> > +             return -EINVAL;
> >
> >       if (!guest_cpuid_has(vcpu, X86_FEATURE_SMEP) && (cr4 & X86_CR4_SMEP))
> > -             return 1;
> > +             return -EINVAL;
> >
> >       if (!guest_cpuid_has(vcpu, X86_FEATURE_SMAP) && (cr4 & X86_CR4_SMAP))
> > -             return 1;
> > +             return -EINVAL;
> >
> >       if (!guest_cpuid_has(vcpu, X86_FEATURE_FSGSBASE) && (cr4 & X86_CR4_FSGSBASE))
> > -             return 1;
> > +             return -EINVAL;
> >
> >       if (!guest_cpuid_has(vcpu, X86_FEATURE_PKU) && (cr4 & X86_CR4_PKE))
> > -             return 1;
> > +             return -EINVAL;
> >
> >       if (!guest_cpuid_has(vcpu, X86_FEATURE_LA57) && (cr4 & X86_CR4_LA57))
> > -             return 1;
> > +             return -EINVAL;
> >
> >       if (!guest_cpuid_has(vcpu, X86_FEATURE_UMIP) && (cr4 & X86_CR4_UMIP))
> > +             return -EINVAL;
> > +
> > +     return 0;
> > +}
> > +
> > +int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> > +{
> > +     unsigned long old_cr4 = kvm_read_cr4(vcpu);
> > +     unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
> > +                                X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
> > +
> > +     if (cr4 & CR4_RESERVED_BITS)
> > +             return 1;
>
> Checking CPUID bits but allowing unconditionally reserved bits to be set
> feels wrong.
>
> Paolo, can you provide an "official" ruling on how KVM_SET_SREGS should
> interact with reserved bits?  It's not at all clear from the git history
> if skipping the checks was intentional or an oversight.
>
> The CR4_RESERVED_BITS check has been in kvm_set_cr4() since the beginning
> of time (commit 6aa8b732ca01, "[PATCH] kvm: userspace interface").
>
> The first CPUID check came later, in commit 2acf923e38fb ("KVM: VMX:
> Enable XSAVE/XRSTOR for guest"), but its changelog is decidedly unhelpful.
>
> > +
> > +     if (kvm_valid_cr4(vcpu, cr4))
> >               return 1;
> >
> >       if (is_long_mode(vcpu)) {
> > @@ -8675,7 +8683,8 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
> >       struct desc_ptr dt;
> >       int ret = -EINVAL;
> >
> > -     if (kvm_valid_sregs(vcpu, sregs))
> > +     if (kvm_valid_sregs(vcpu, sregs) ||
>
> No need for a line break.  Even better, call kvm_valid_cr4() from
> kvm_valid_sregs(), e.g. the X86_FEATURE_XSAVE check in kvm_valid_sregs()
> is now redundant and can be dropped, and "return kvm_valid_cr4(...)" from
> kvm_valid_sregs() can likely be optimized into a tail call.

handle it in new version.

    Wanpeng

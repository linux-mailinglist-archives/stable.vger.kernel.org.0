Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4057B4935
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 10:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbfIQIXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 04:23:01 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40789 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728123AbfIQIXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 04:23:01 -0400
Received: by mail-ot1-f66.google.com with SMTP id y39so2264856ota.7;
        Tue, 17 Sep 2019 01:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pAhRX1Y8hlT53IJmsS9eKDWXvMfY7PiqTbL9YMzPsQY=;
        b=DDWYxX6hEtoMmfBPsku/8mPtsbFfVqOuH6B5K6Rf5504uIFWUvA4nKyX7p9UOK5QL9
         x00eSKjYfX43V6lfKBKhbU6aD4TiaoRI8Bf195GYRbRSYcqm1AAyTMa5Wc/qzWj/GevV
         D28/qLQapOc2Bs9o/O7CMpq5wkgSVuklj54vaUnWaer7QFf+EAIxYyhJYizmV1dTIsRx
         FI8pmaCUWrzXu5/4stOiThInpHgBqPjL3Tc64msxMkJ6PjLhP75UZJHMxivCJJpLJUNL
         CbPZId75PgVF6hRNBAr3XiwFyiu6p++OiFjWFIXl2hri56vGBMQVfz4ALicIdbSvkvOB
         rn9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pAhRX1Y8hlT53IJmsS9eKDWXvMfY7PiqTbL9YMzPsQY=;
        b=U6mkni8gqVFHfKlIoZWtMJ1iHwJEXH1jXrn4noJCUyAJ/ofoVXn9sdoxr7716udtpy
         0WK7daAhF/cCxH4oZReKIUAR+tIhfUELTCdwXdUcRh4Jm+lFM+EeH8r2nK6qIh+awyl8
         r9hQx3gqG3aswc2oKfW+R4ejhUUW6VafVhfwA+nc8p48ZhmK5LO9+LxabcnqcgTUDjYz
         SLdc4Ls3Khiazclsb8keRJQIpMygF78gYEI9nyQpg8bO7TYZCJsLIMFLzydnIIe64nkD
         2QKHq6Eh7UO1f+UOI2l7tZt+fBa/KXJ7F+bFjjY+sQisqoo5agSL8UH56dkS/tmNE21w
         Wi+Q==
X-Gm-Message-State: APjAAAXxEZG2oFiMt9umDZsIFYrR0n34kB6e759gYRE9P0EZCd/zaSbe
        IdqESy/w/m/vJqKW0znmcOOROgXCy6RQ03vmhVY=
X-Google-Smtp-Source: APXvYqzVVj6XLIRKAQFw0YAZbGXg8avRlJ7jD1nt0GvxOdj6vD309EupfSe3MyuCDlpLhg5U72LmlbjcnSDQAz+lgp4=
X-Received: by 2002:a9d:aa8:: with SMTP id 37mr1771178otq.56.1568708580413;
 Tue, 17 Sep 2019 01:23:00 -0700 (PDT)
MIME-Version: 1.0
References: <1568617969-6934-1-git-send-email-wanpengli@tencent.com> <20190916191218.GM18871@linux.intel.com>
In-Reply-To: <20190916191218.GM18871@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 17 Sep 2019 16:22:48 +0800
Message-ID: <CANRm+CwhFAU6PaVYF=uBhHfQpQT0N7iJ+QvKyojOHzcsVjsfzQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Fix warning in handle_desc
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

On Tue, 17 Sep 2019 at 03:12, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Sep 16, 2019 at 03:12:49PM +0800, Wanpeng Li wrote:
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
> > sregs values. SECONDARY_EXEC_DESC is enabled on writes to CR4.UMIP in
> > vmx_set_cr4 though guest doesn't have UMIP cpuid flag. The testcast
> > triggers handle_desc warning when executing ltr instruction since guest
> > architectural CR4 doesn't set UMIP. This patch fixes it by adding check
> > for guest UMIP cpuid flag when get sreg inputs from userspace.
> >
> > Reported-by: syzbot+0f1819555fbdce992df9@syzkaller.appspotmail.com
> > Fixes: 0367f205a3b7 ("KVM: vmx: add support for emulating UMIP")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > Note: syzbot report link https://lkml.org/lkml/2019/9/11/799
> >
> >  arch/x86/kvm/x86.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f7cfd8e..83288ba 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8645,6 +8645,10 @@ static int kvm_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
> >                       (sregs->cr4 & X86_CR4_OSXSAVE))
> >               return  -EINVAL;
> >
> > +     if (!guest_cpuid_has(vcpu, X86_FEATURE_UMIP) &&
> > +                     (sregs->cr4 & X86_CR4_UMIP))
>
> Assuming vmx_set_cr4() fails because nested_cr4_valid() fails, isn't this
> a generic problem with nested VMX that just happens to be visible because
> of the WARN_ON() in handle_desc()?
>
> In general, KVM lets userspace set broken combinations of CPUID vs. CRx so
> that it doesn't dictate ordering, e.g. __set_sregs() intentionally calls
> kvm_x86_ops->set_cr4() instead of kvm_set_cr4(), which has all the CPUID
> checks.
>
> The existing OSXSAVE check in kvm_valid_sregs() is more about ensuring
> host support (see commit 6d1068b3a985, "KVM: x86: invalid opcode oops on
> SET_SREGS with OSXSAVE bit set (CVE-2012-4461)").
>
> Given that both vmx_set_cr4() and svm_set_cr4() can return failure and
> cause __set_sregs() to silently fail, what about adding a new x86 ops to
> pre-check cr4, e.g. vm_x86_ops->is_valid_cr4(), and then WARN if set_cr4()
> fails during __set_sregs()?

I'm a little lazy, just extract CPUID and CR4 combination checking and
add it to __set_sregs() in new version.

    Wanpeng

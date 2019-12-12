Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6FA11D45D
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 18:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbfLLRos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 12:44:48 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38145 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730075AbfLLRos (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 12:44:48 -0500
Received: by mail-io1-f67.google.com with SMTP id v3so3696617ioj.5
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 09:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NZUkuLltWHAaMt9PiF7re5SLQkc/j51hQPwRCUKb9Mw=;
        b=Zcvq/j0dfcg82cX+jYcHpmIcVtvtDsWFmkRO4oumpHMJBzVvRQUTs/a+SdZiryhxTt
         0zzz71YUxyr6JKp3Riotyq8Nacg2OvjaTqLG9Xqfu8ia62nzd/Ez5/pkR3q4gWDBR7Tp
         MuspoypVdYRvucBFx3gOeBzKWoabO1APnY27Go0vENPxdx97lvA1Zgo/hY0hCMr4DvbY
         gE4cuFY4cECLbNUHNggMwvoACSoA/V5htVau63pTIHbubNesuuoU3LRh/Of0K3M089hd
         /NTiWoftyfnBxI2qXB9ksSS6YIk1Y2idkO86qwlw55yX03BbTg0sUea3Q/llueiJXMZD
         cqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NZUkuLltWHAaMt9PiF7re5SLQkc/j51hQPwRCUKb9Mw=;
        b=SqNjo3bugQkgHjcI6T2xIbekG19UFQrtrj3j4iXzggWrrjCzNZQ0M0hNfMkQflUwz9
         eWKPBH0ssuKktOl3dSUD1f6Odv9VSG5JX5aKgvLnQ5evaof+we+raV4YcqLCNIXPAY1s
         B1em+j1bgDThvd8vedrs7orenfilZ1l8F6ng1dR8mKQm/XAiaSFM9a/YodhFc5ayvA3Z
         OBmdtxemTjtiQZ4vyGObmTfglj5Hapwus33Aj55g4pZ4qeBmsBBLhiDY8EeFPFg4bSKB
         UYjsD5rWWyLbzrMPen+rDBwySUilVwocd33XAlL2bZDXhfvDO5m3kfNWerfRtYsHvBnQ
         ge8w==
X-Gm-Message-State: APjAAAX0h09DJ4YT3Zwy7CfDhVfJYS6GUsXgsbzceJk9LxaNVoQnUqZ7
        JBSVKFHOF0rGkRsFFZFaIYLqFQrtV1GzK6v5dP+x0Q==
X-Google-Smtp-Source: APXvYqyP11Avt7fW6f3c7v+tjDwdWe3evb7j+D31QfTjrBzg1C5L1u2gm1VV7aaniEW69FxObtJ77JATYAKYJi6EgCc=
X-Received: by 2002:a5d:8cda:: with SMTP id k26mr4127162iot.26.1576172687645;
 Thu, 12 Dec 2019 09:44:47 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-3-pomonis@google.com>
 <314f6d96-b75f-e159-d94d-1d30a5140e40@de.ibm.com>
In-Reply-To: <314f6d96-b75f-e159-d94d-1d30a5140e40@de.ibm.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 Dec 2019 09:44:36 -0800
Message-ID: <CALMp9eTOD6r13sPZ3skz_YkSFn2ZKbsr5zbLP9LgzjpHnsebkQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/13] KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data()
 from Spectre-v1/L1TF attacks
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Marios Pomonis <pomonis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 9:31 AM Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
>
>
> On 11.12.19 21:47, Marios Pomonis wrote:
> > This fixes Spectre-v1/L1TF vulnerabilities in kvm_hv_msr_get_crash_data()
> > and kvm_hv_msr_set_crash_data().
> > These functions contain index computations that use the
> > (attacker-controlled) MSR number.
> >
> > Fixes: commit e7d9513b60e8 ("kvm/x86: added hyper-v crash msrs into kvm hyperv context")
> >
> > Signed-off-by: Nick Finco <nifi@google.com>
> > Signed-off-by: Marios Pomonis <pomonis@google.com>
> > Reviewed-by: Andrew Honig <ahonig@google.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  arch/x86/kvm/hyperv.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index 23ff65504d7e..26408434b9bc 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -809,11 +809,12 @@ static int kvm_hv_msr_get_crash_data(struct kvm_vcpu *vcpu,
> >                                    u32 index, u64 *pdata)
> >  {
> >       struct kvm_hv *hv = &vcpu->kvm->arch.hyperv;
> > +     size_t size = ARRAY_SIZE(hv->hv_crash_param);
> >
> > -     if (WARN_ON_ONCE(index >= ARRAY_SIZE(hv->hv_crash_param)))
> > +     if (WARN_ON_ONCE(index >= size))
> >               return -EINVAL;
>
> The fact that we do a WARN_ON_ONCE here, should actually tell that index is not
> user controllable. Otherwise this would indicate the possibility to trigger a
> kernel warning from a malicious user space. So
> a: we do not need this change
> or
> b: we must also fix the WARN_ON_ONCE

That isn't quite true. The issue is *speculative* execution down this path.

The call site does constrain the *actual* value of index:

case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
        return kvm_hv_msr_get_crash_data(...);

However, it is possible to train the branch predictor to go down this
path using valid indices and subsequently pass what would be an
invalid index. The CPU will speculatively follow this path and may
pull interesting data into the cache before it realizes its mistake
and corrects.

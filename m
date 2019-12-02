Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF4310EB9F
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 15:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfLBOkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 09:40:18 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38677 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbfLBOkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 09:40:18 -0500
Received: by mail-lf1-f67.google.com with SMTP id r14so11935153lfm.5;
        Mon, 02 Dec 2019 06:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MuKkyCaYPZK6q+vtj0Oj3LLvTH7hr0pT2uHjN7RG//Y=;
        b=H083x/sMnck6FZU2DLKjYSIWNiVmUd1JQbRBPIWCRU+sSdQLK/cIScO2+lKTmtuxIa
         GzNuLSQMNdmU2qqCzfsSTmEXeZRBOSjEhOFNOwqvcnRdIn1N5uwIW3AZRZKkhYPmIFro
         0aLU/dv/s/Rc2ohcSTNiLTtAPwvbHymRdvYIbvLulpbKsXITq9/Gt9auYmB90im0hofs
         0V00WPOYxEcD3sX8M9ywoW0WacDrDOtK3+qrtoN3cJ0TtnAUZgXkDcwfNoDowwfEt1TI
         2hWX5kfbxiPdE6c6HbUYOMETpoa177F8uGgU2npYVF+/A2oruoXJs+mbo9Qi5rX6Pfkw
         ankw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MuKkyCaYPZK6q+vtj0Oj3LLvTH7hr0pT2uHjN7RG//Y=;
        b=PcjZpaKFWru7/Ae3OSKNrFsmZLpNmRpQ78YMlREAZ1BnPYxQabSsk65b3mPSoWMQoJ
         MAbdtHY1c2OQVb51gltLMqJnnQfml5+gO4l8ZDBWBQdi1lzJXs0JEu0/cxlE1EVD3dlx
         TMAxdVxYxsOsC7dAyS1UrKrkEgQu1PXyks6xPh4T78A5NskbMMRSVgtU5+EPsOW885er
         cTwBv62QwMNs1fmc3NaPyMhrgWp8DkZzUmKxDAIf5kAylhpgNSvuRz+7VDibCGDvJXYz
         R/RKZOV2MAh0kqX5hyZ6FklZaaZL/hmhHJj8FK8/VBPsEa+OGLdZtKyGDELLuzv9fZX/
         XbFA==
X-Gm-Message-State: APjAAAUJt0J0/0DjIlRcigPOWYUlvwTBILtZeViJ7THZluuMzJymjv5F
        7vWyKE24c/iG+/fgfDqFFcMCEXCevdmMHpJm0mbEKTC2
X-Google-Smtp-Source: APXvYqyPFmLDrOIuV+Cs4RE1iW7MA9zfT7/FK8ojlRRNRjp4uDoxlwnO4ic/+mZIcN3tyacs9SFIZyPl298QIFKmvG8=
X-Received: by 2002:ac2:428d:: with SMTP id m13mr37630848lfh.64.1575297616009;
 Mon, 02 Dec 2019 06:40:16 -0800 (PST)
MIME-Version: 1.0
References: <20191127203114.766709977@linuxfoundation.org> <20191127203119.676489279@linuxfoundation.org>
In-Reply-To: <20191127203119.676489279@linuxfoundation.org>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Mon, 2 Dec 2019 15:40:04 +0100
Message-ID: <CA+res+QKCAn8PsSgbkqXNAF0Ov5pOkj=732=M5seWj+-JFQOwQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 067/306] KVM: nVMX: move check_vmentry_postreqs()
 call to nested_vmx_enter_non_root_mode()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2019=E5=B9=B411=E6=
=9C=8827=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8810:30=E5=86=99=E9=81=
=93=EF=BC=9A
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> [ Upstream commit 7671ce21b13b9596163a29f4712cb2451a9b97dc ]
>
> In preparation of supporting checkpoint/restore for nested state,
> commit ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_run()"=
)
> modified check_vmentry_postreqs() to only perform the guest EFER
> consistency checks when nested_run_pending is true.  But, in the
> normal nested VMEntry flow, nested_run_pending is only set after
> check_vmentry_postreqs(), i.e. the consistency check is being skipped.
>
> Alternatively, nested_run_pending could be set prior to calling
> check_vmentry_postreqs() in nested_vmx_run(), but placing the
> consistency checks in nested_vmx_enter_non_root_mode() allows us
> to split prepare_vmcs02() and interleave the preparation with
> the consistency checks without having to change the call sites
> of nested_vmx_enter_non_root_mode().  In other words, the rest
> of the consistency check code in nested_vmx_run() will be joining
> the postreqs checks in future patches.
>
> Fixes: ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_run()"=
)
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Jim Mattson <jmattson@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/x86/kvm/vmx.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index fe7fdd666f091..bdf019f322117 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -12694,6 +12694,9 @@ static int enter_vmx_non_root_mode(struct kvm_vcp=
u *vcpu, u32 *exit_qual)
>         if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active=
(vcpu))
>                 evaluate_pending_interrupts |=3D vmx_has_apicv_interrupt(=
vcpu);
>
> +       if (from_vmentry && check_vmentry_postreqs(vcpu, vmcs12, exit_qua=
l))
> +               return EXIT_REASON_INVALID_STATE;
> +
>         enter_guest_mode(vcpu);
>
>         if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
> @@ -12836,13 +12839,6 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu,=
 bool launch)
>          */
>         skip_emulated_instruction(vcpu);
>
> -       ret =3D check_vmentry_postreqs(vcpu, vmcs12, &exit_qual);
> -       if (ret) {
> -               nested_vmx_entry_failure(vcpu, vmcs12,
> -                                        EXIT_REASON_INVALID_STATE, exit_=
qual);
> -               return 1;
> -       }
> -
>         /*
>          * We're finally done with prerequisite checking, and can start w=
ith
>          * the nested entry.
> --
> 2.20.1
>
>
>
Hi all,

This commit caused many kvm-unit-tests regression, cherry-pick
following commits from 4.20 fix the regression:
d63907dc7dd1 ("KVM: nVMX: rename enter_vmx_non_root_mode to
nested_vmx_enter_non_root_mode")
a633e41e7362 ("KVM: nVMX: assimilate nested_vmx_entry_failure() into
nested_vmx_enter_non_root_mode()")

Regards,
Jack Wang
1 & 1 IONOS SE

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1445D114DC4
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 09:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfLFIyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 03:54:50 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42545 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfLFIyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 03:54:50 -0500
Received: by mail-lf1-f67.google.com with SMTP id y19so4647005lfl.9;
        Fri, 06 Dec 2019 00:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=3gYEsWmy4JuBzTSatOZIC7YaHvzWd9GrO4iSAH/St48=;
        b=mZ/H32HNjhBtmGVGVzYUoONZ3TdIjQkkOAdG0A6R0KbrKngB69GYZTX5vYNgqXTXkp
         hrHG1sPKReq2zSTcEADqVOeSQentFypuxj7zP9QUAgdexgptroVnLqnrfil5byypjKs+
         26vXMS+Ug/0jPkrtNyVV1/QSAbMs/0YbwrHiu5rEl2sT3G7brsWS9n6CV3sTxL2/temW
         xDz5E+2Jl1D2fYm6ozZu2aSsrwtRBnaiOlExIwfYkJIgC+X0w13Cq8FNQHTc+z4r+z2e
         1fbkKXx5NAf0LZxabslDnTrDJMw3ugiH5W1JB6XWjVCgFmjcv2tLYBmcTILz/DAjIrhU
         dqxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=3gYEsWmy4JuBzTSatOZIC7YaHvzWd9GrO4iSAH/St48=;
        b=XGdYgvWSiuTLnsZZ53IMgs0Gxevqm5He5MYAJCYWMf2VrVxco8Rh4M+xwvOpGzUCBB
         8oAQ3hOeqztXRF7ZoyosAtc84Q6ggVlqd96Yu8KvYTJeO467cOThfVP393ZTFhK96pxj
         +GTOsDhd+Bt1MlCCdh5l6RZABo+D+s/zav9qkUG1prNBrN6UzAF3fQTGaErce+O25KHp
         bI5O75JV1s7VdVHkgurKEWjNTdxu19k1I6WH/4AJKp4zFMoJBpB8xcdNhN2RyVG/834A
         s12tRBTECGXUGa9PAA9DJvQUnw8ZC0GcUOOKUZA6+FSgQy0aqO37H4Pj/nYbRbYjNTTx
         fgYw==
X-Gm-Message-State: APjAAAWZg0zmuqB7vDLOqF9jYwFlt9J0iRG5VDBHHjUZmrdDodkf3xoz
        ewfI3tX52dD4EZG7w+f/jSoM3R8Z4WiBkpyGJjk=
X-Google-Smtp-Source: APXvYqzJDNLegHkTWBLyYNdnUs5zFbKbLYmnQ8Kk67OLfKLg925XlaeADJQU7PgP1mVRAnZoso2rEHYtAEVS6jqPwJ4=
X-Received: by 2002:ac2:4422:: with SMTP id w2mr7575453lfl.178.1575622486717;
 Fri, 06 Dec 2019 00:54:46 -0800 (PST)
MIME-Version: 1.0
References: <20191127203114.766709977@linuxfoundation.org> <20191127203119.676489279@linuxfoundation.org>
 <CA+res+QKCAn8PsSgbkqXNAF0Ov5pOkj=732=M5seWj+-JFQOwQ@mail.gmail.com>
 <20191204175033.smve4dleem2ht7st@xps.therub.org> <CA+res+SW7o4YpUtv4-UYXP4WSPm417tgow68YM7YjOEcZ5xO3w@mail.gmail.com>
 <20191205205206.2mnr3dj2slamuhrl@xps.therub.org>
In-Reply-To: <20191205205206.2mnr3dj2slamuhrl@xps.therub.org>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Fri, 6 Dec 2019 09:54:35 +0100
Message-ID: <CA+res+RQbK2wCWtfV4bNBF3GKYqRjPOAPDfWa_+6Zjqi--p8aw@mail.gmail.com>
Subject: Re: [PATCH 4.19 067/306] KVM: nVMX: move check_vmentry_postreqs()
 call to nested_vmx_enter_non_root_mode()
To:     Jack Wang <jack.wang.usish@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
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

Dan Rue <dan.rue@linaro.org> =E4=BA=8E2019=E5=B9=B412=E6=9C=885=E6=97=A5=E5=
=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=889:52=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Dec 05, 2019 at 10:51:18AM +0100, Jack Wang wrote:
> > Dan Rue <dan.rue@linaro.org> =E4=BA=8E2019=E5=B9=B412=E6=9C=884=E6=97=
=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=886:50=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Mon, Dec 02, 2019 at 03:40:04PM +0100, Jack Wang wrote:
> > > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2019=E5=B9=
=B411=E6=9C=8827=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8810:30=E5=86=
=99=E9=81=93=EF=BC=9A
> > > > >
> > > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > >
> > > > > [ Upstream commit 7671ce21b13b9596163a29f4712cb2451a9b97dc ]
> > > > >
> > > > > In preparation of supporting checkpoint/restore for nested state,
> > > > > commit ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vm=
x_run()")
> > > > > modified check_vmentry_postreqs() to only perform the guest EFER
> > > > > consistency checks when nested_run_pending is true.  But, in the
> > > > > normal nested VMEntry flow, nested_run_pending is only set after
> > > > > check_vmentry_postreqs(), i.e. the consistency check is being ski=
pped.
> > > > >
> > > > > Alternatively, nested_run_pending could be set prior to calling
> > > > > check_vmentry_postreqs() in nested_vmx_run(), but placing the
> > > > > consistency checks in nested_vmx_enter_non_root_mode() allows us
> > > > > to split prepare_vmcs02() and interleave the preparation with
> > > > > the consistency checks without having to change the call sites
> > > > > of nested_vmx_enter_non_root_mode().  In other words, the rest
> > > > > of the consistency check code in nested_vmx_run() will be joining
> > > > > the postreqs checks in future patches.
> > > > >
> > > > > Fixes: ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vm=
x_run()")
> > > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.c=
om>
> > > > > Cc: Jim Mattson <jmattson@google.com>
> > > > > Reviewed-by: Jim Mattson <jmattson@google.com>
> > > > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > > ---
> > > > >  arch/x86/kvm/vmx.c | 10 +++-------
> > > > >  1 file changed, 3 insertions(+), 7 deletions(-)
> > > > >
> > > > > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > > > > index fe7fdd666f091..bdf019f322117 100644
> > > > > --- a/arch/x86/kvm/vmx.c
> > > > > +++ b/arch/x86/kvm/vmx.c
> > > > > @@ -12694,6 +12694,9 @@ static int enter_vmx_non_root_mode(struct=
 kvm_vcpu *vcpu, u32 *exit_qual)
> > > > >         if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apic=
v_active(vcpu))
> > > > >                 evaluate_pending_interrupts |=3D vmx_has_apicv_in=
terrupt(vcpu);
> > > > >
> > > > > +       if (from_vmentry && check_vmentry_postreqs(vcpu, vmcs12, =
exit_qual))
> > > > > +               return EXIT_REASON_INVALID_STATE;
> > > > > +
> > > > >         enter_guest_mode(vcpu);
> > > > >
> > > > >         if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CON=
TROLS))
> > > > > @@ -12836,13 +12839,6 @@ static int nested_vmx_run(struct kvm_vcp=
u *vcpu, bool launch)
> > > > >          */
> > > > >         skip_emulated_instruction(vcpu);
> > > > >
> > > > > -       ret =3D check_vmentry_postreqs(vcpu, vmcs12, &exit_qual);
> > > > > -       if (ret) {
> > > > > -               nested_vmx_entry_failure(vcpu, vmcs12,
> > > > > -                                        EXIT_REASON_INVALID_STAT=
E, exit_qual);
> > > > > -               return 1;
> > > > > -       }
> > > > > -
> > > > >         /*
> > > > >          * We're finally done with prerequisite checking, and can=
 start with
> > > > >          * the nested entry.
> > > > > --
> > > > > 2.20.1
> > > > >
> > > > >
> > > > >
> > > > Hi all,
> > > >
> > > > This commit caused many kvm-unit-tests regression, cherry-pick
> > > > following commits from 4.20 fix the regression:
> > >
> > > Hi Jack - can you be more specific about the failing tests? What type=
 of
> > > environment and which tests failed, which version of kvm-unit-tests? =
Do
> > > you have any logs available? I ask because we do run kvm-unit-tests o=
n
> > > x86 and arm64 but we did not see these regressions.
> > >
> > > Thanks,
> > > Dan
> > >
> > Hi Dan,
> >
> > I'm running at kvm-unit-tests commit b1414c5f0142 ("x86: vmx: fix
> > required alignment for posted interrupt descriptor")
> >
> > using "run_tests.sh -a -t -j8" with qemu-2.7.1
> >
> > Left side has only 78 tests ok, and right side has 112 tests ok.
>
> Thanks - so we run it with "run_tests.sh -v" and only see 43 passes in
> the best case. Besides missing -a, we see a skip for the vmx related
> tests because vmx isn't enabled in our environment.
>
> We will fix those problems in LKFT so that we can catch regressions like
> this before they are released.
>
> Dan
Sounds good.

Thanks,
Jack

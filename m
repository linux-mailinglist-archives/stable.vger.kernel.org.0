Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E33110FAA9
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 10:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbfLCJVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 04:21:49 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:32780 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLCJVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 04:21:49 -0500
Received: by mail-lj1-f194.google.com with SMTP id 21so2968010ljr.0;
        Tue, 03 Dec 2019 01:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pLfHU77WwXfBD7pMGsHDD+p0Rc83y3B7FwHLS1IWzvM=;
        b=vKNBsT21J8ZmTFIfzJUai/Q0kXssW+UxkGC9gBvpLdAWujf4C9mtZg5wyJod34zHVz
         2Xm1P/mB7YLsDu6PGRTVByJ8K42r/MZfieEAH2562lTwZ1zIkV6xnni9SX2uxggdu1KO
         zAdVLRgxSJwRk64WOb9GdRmYNGA3hHdZ6aumVb/G8F8XbB6kCmVBx68IfUo4WtPV0jaD
         +I/LqFeDEYDb+Djhq1LEKNXgCClVX7Hea6gjted+KiUC2CHunBEr6ekEihOzspcxEh3H
         9K2cGrtaZPfrXy7EN6gGeECpZMx9elUofjywOvoFhG9gXqOa0vDqw/zgGcU+YRzQMAi8
         29lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pLfHU77WwXfBD7pMGsHDD+p0Rc83y3B7FwHLS1IWzvM=;
        b=ibuaTkoZAuJeHOO44a1Dj2OSGwUmfyOByZHcuaTpTrcP+FdPaOqGTPmBCjecYYpNed
         hJ0TRGaiaGy9H5CE92w8FKZ+sxJ0zwzrfGy1Xot58cvnSnzOnwf2HaFdUtLyy7T81bHq
         PWBe0H5qiEdwaRIZRbfLteU1AJcLlhKtZaH8O1zV/EfE14Qhai5DpOClIHUA07fEFpfS
         D7SAwAJUGY5l8IkoflNf3MNP/i1MxjDUDCBxT4JKWYtHbpRNPf32MzKOWA7pGPtyyQZx
         DVe9yAwb9SkGA4HrY5gjcwHHmlRiIPcKMoDFoOrWIwLziSWMk1RNzC8EvMIsZpB2Vktp
         tcgQ==
X-Gm-Message-State: APjAAAWCj0Mk/EtiOIMOltYOSj13JC1xe5Z2JruhrnYFeLpXRwBKtz8B
        uA7HTyBi5BZClKyvDjwCd7BT9hejQWiCOX0LFGrCsqxthBs=
X-Google-Smtp-Source: APXvYqzUaC2Y5M6iTaIYz/grdfsX5k4fOA6sn7fQXdxoyfyR5Ri12SqhE0xI3/fd6au/hLyDy1kJ7OcJTAslT1GXE+0=
X-Received: by 2002:a2e:9093:: with SMTP id l19mr1668457ljg.235.1575364906310;
 Tue, 03 Dec 2019 01:21:46 -0800 (PST)
MIME-Version: 1.0
References: <20191127203114.766709977@linuxfoundation.org> <20191127203119.676489279@linuxfoundation.org>
 <CA+res+QKCAn8PsSgbkqXNAF0Ov5pOkj=732=M5seWj+-JFQOwQ@mail.gmail.com>
 <20191202145105.GA571975@kroah.com> <bccbfccd-0e96-29c3-b2ba-2b1800364b08@redhat.com>
In-Reply-To: <bccbfccd-0e96-29c3-b2ba-2b1800364b08@redhat.com>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Tue, 3 Dec 2019 10:21:35 +0100
Message-ID: <CA+res+SffBsmmeEBYfoDwyLHvL8nqW+O=ZKedWCxccmQ9X6itA@mail.gmail.com>
Subject: Re: [PATCH 4.19 067/306] KVM: nVMX: move check_vmentry_postreqs()
 call to nested_vmx_enter_non_root_mode()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> =E4=BA=8E2019=E5=B9=B412=E6=9C=882=E6=
=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=884:09=E5=86=99=E9=81=93=EF=BC=9A
>
> On 02/12/19 15:51, Greg Kroah-Hartman wrote:
> > On Mon, Dec 02, 2019 at 03:40:04PM +0100, Jack Wang wrote:
> >> Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2019=E5=B9=B4=
11=E6=9C=8827=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8810:30=E5=86=99=
=E9=81=93=EF=BC=9A
> >>>
> >>> From: Sean Christopherson <sean.j.christopherson@intel.com>
> >>>
> >>> [ Upstream commit 7671ce21b13b9596163a29f4712cb2451a9b97dc ]
> >>>
> >>> In preparation of supporting checkpoint/restore for nested state,
> >>> commit ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_ru=
n()")
> >>> modified check_vmentry_postreqs() to only perform the guest EFER
> >>> consistency checks when nested_run_pending is true.  But, in the
> >>> normal nested VMEntry flow, nested_run_pending is only set after
> >>> check_vmentry_postreqs(), i.e. the consistency check is being skipped=
.
> >>>
> >>> Alternatively, nested_run_pending could be set prior to calling
> >>> check_vmentry_postreqs() in nested_vmx_run(), but placing the
> >>> consistency checks in nested_vmx_enter_non_root_mode() allows us
> >>> to split prepare_vmcs02() and interleave the preparation with
> >>> the consistency checks without having to change the call sites
> >>> of nested_vmx_enter_non_root_mode().  In other words, the rest
> >>> of the consistency check code in nested_vmx_run() will be joining
> >>> the postreqs checks in future patches.
> >>>
> >>> Fixes: ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_ru=
n()")
> >>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >>> Cc: Jim Mattson <jmattson@google.com>
> >>> Reviewed-by: Jim Mattson <jmattson@google.com>
> >>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> >>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >>> ---
> >>>  arch/x86/kvm/vmx.c | 10 +++-------
> >>>  1 file changed, 3 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> >>> index fe7fdd666f091..bdf019f322117 100644
> >>> --- a/arch/x86/kvm/vmx.c
> >>> +++ b/arch/x86/kvm/vmx.c
> >>> @@ -12694,6 +12694,9 @@ static int enter_vmx_non_root_mode(struct kvm=
_vcpu *vcpu, u32 *exit_qual)
> >>>         if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_ac=
tive(vcpu))
> >>>                 evaluate_pending_interrupts |=3D vmx_has_apicv_interr=
upt(vcpu);
> >>>
> >>> +       if (from_vmentry && check_vmentry_postreqs(vcpu, vmcs12, exit=
_qual))
> >>> +               return EXIT_REASON_INVALID_STATE;
> >>> +
> >>>         enter_guest_mode(vcpu);
> >>>
> >>>         if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROL=
S))
> >>> @@ -12836,13 +12839,6 @@ static int nested_vmx_run(struct kvm_vcpu *v=
cpu, bool launch)
> >>>          */
> >>>         skip_emulated_instruction(vcpu);
> >>>
> >>> -       ret =3D check_vmentry_postreqs(vcpu, vmcs12, &exit_qual);
> >>> -       if (ret) {
> >>> -               nested_vmx_entry_failure(vcpu, vmcs12,
> >>> -                                        EXIT_REASON_INVALID_STATE, e=
xit_qual);
> >>> -               return 1;
> >>> -       }
> >>> -
> >>>         /*
> >>>          * We're finally done with prerequisite checking, and can sta=
rt with
> >>>          * the nested entry.
> >>> --
> >>> 2.20.1
> >>>
> >>>
> >>>
> >> Hi all,
> >>
> >> This commit caused many kvm-unit-tests regression, cherry-pick
> >> following commits from 4.20 fix the regression:
> >> d63907dc7dd1 ("KVM: nVMX: rename enter_vmx_non_root_mode to
> >> nested_vmx_enter_non_root_mode")
> >> a633e41e7362 ("KVM: nVMX: assimilate nested_vmx_entry_failure() into
> >> nested_vmx_enter_non_root_mode()")
> >
> > Now queued up, thanks!
> >
> > greg k-h
> >
>
> Why was it backported anyway?  Can everybody please just stop applying
> KVM patches to stable kernels unless CCed to stable@vger.kernel.org?
>
> I thought I had already asked Sasha to opt out of the autoselect
> nonsense after catching another bug that would have been introduced.
>
> Paolo
>
Hi Paolo,

Should we simply revert the patch, maybe also
9fe573d539a8 ("KVM: nVMX: reset cache/shadows when switching loaded VMCS")

Both of them are from one big patchset:
https://patchwork.kernel.org/cover/10616179/

Revert both patches recover the regression I see on kvm-unit-tests.

Thanks,
Jack Wang

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8283E113E8B
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 10:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfLEJvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 04:51:33 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44819 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfLEJvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 04:51:33 -0500
Received: by mail-lf1-f66.google.com with SMTP id v201so1960060lfa.11;
        Thu, 05 Dec 2019 01:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=yHjUgDXk7BzsRuratWNN1Se97NYh4vX6Ykx+O5w9BpQ=;
        b=nUHUaUQkXRL2lOSNLHYOdLoa1AgE8eX7NDtk5D0M1BihBAUyouKI3hkZYchj5svDdh
         Muxl8Yr86rVhPfMKW6gH5VaPDd0g2dWRN8/ttPOBLletxrOX8spQ/2fMrb1nPgjgLvi+
         vv7dYCysXhbcgdLP361d0fdsZFbPRN+vIuq3PP2kHdv9W4p1HagdqRmDu/tJrrX+cjmZ
         JJVh/PRRbDIXWnEH/iCbtXDpxJuaqujvMlimtYa5LigjuIu+QIrzQObH1V92rbKC2QnX
         OueCIzxiyfCR/m1tbQG4WMYD/FzV0Fgo0HXjmdOr8sI3ADhW64tAPobs+8HCvyc6jfiR
         VtfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=yHjUgDXk7BzsRuratWNN1Se97NYh4vX6Ykx+O5w9BpQ=;
        b=dsB0t9W0a4Oa/ZPD2KUrhYrFESBB9cvBZWUvNO/W6CJtMxlQaOeGyA3K2AKJ/asc+w
         kuKMVbA+wIjFlSPVqbVuOr3M8wCkyRO5RgNh8Yw04HXm+m8Ih6pRk89vFtQzbsdB05YH
         QPvJbuMJttLWB7wMYdUxvKQufucu8a4lFjKfsd7Wj3iF/MPsKRlAz226HyE9Zw5C2Ewy
         OWOYgakXkMfDG6T2GvGZDKNQ4p8KCDjbOUR80LP8rf5W8R5yDt+ynPp2YwL1pCkjSVti
         b+UGlM4U79fKvzDdd+gHachpGLyw7NU3eZz3JdZU6vYw4kbPyGZDGunrUB34n7mkCdNX
         b2CA==
X-Gm-Message-State: APjAAAURvlkNNpCvyGIIPAXwd1JgU5DL6r9pzuSF2qRPdF6HQnXFpLjY
        YnNpDTchpFkxigqFx/ohlM6ZLGUCRw3+KTap8TRNX/6+
X-Google-Smtp-Source: APXvYqxK+xhUvdpYi67ZeF0UiqdxHk844MOcORnmbFmLd/batLjFZkzQWGnjkGDjU/QKuDRz82f6QAnjW+voNIOiLkU=
X-Received: by 2002:ac2:4194:: with SMTP id z20mr4810871lfh.20.1575539489758;
 Thu, 05 Dec 2019 01:51:29 -0800 (PST)
MIME-Version: 1.0
References: <20191127203114.766709977@linuxfoundation.org> <20191127203119.676489279@linuxfoundation.org>
 <CA+res+QKCAn8PsSgbkqXNAF0Ov5pOkj=732=M5seWj+-JFQOwQ@mail.gmail.com> <20191204175033.smve4dleem2ht7st@xps.therub.org>
In-Reply-To: <20191204175033.smve4dleem2ht7st@xps.therub.org>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Thu, 5 Dec 2019 10:51:18 +0100
Message-ID: <CA+res+SW7o4YpUtv4-UYXP4WSPm417tgow68YM7YjOEcZ5xO3w@mail.gmail.com>
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

Dan Rue <dan.rue@linaro.org> =E4=BA=8E2019=E5=B9=B412=E6=9C=884=E6=97=A5=E5=
=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=886:50=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Dec 02, 2019 at 03:40:04PM +0100, Jack Wang wrote:
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2019=E5=B9=B41=
1=E6=9C=8827=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8810:30=E5=86=99=E9=
=81=93=EF=BC=9A
> > >
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > >
> > > [ Upstream commit 7671ce21b13b9596163a29f4712cb2451a9b97dc ]
> > >
> > > In preparation of supporting checkpoint/restore for nested state,
> > > commit ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_ru=
n()")
> > > modified check_vmentry_postreqs() to only perform the guest EFER
> > > consistency checks when nested_run_pending is true.  But, in the
> > > normal nested VMEntry flow, nested_run_pending is only set after
> > > check_vmentry_postreqs(), i.e. the consistency check is being skipped=
.
> > >
> > > Alternatively, nested_run_pending could be set prior to calling
> > > check_vmentry_postreqs() in nested_vmx_run(), but placing the
> > > consistency checks in nested_vmx_enter_non_root_mode() allows us
> > > to split prepare_vmcs02() and interleave the preparation with
> > > the consistency checks without having to change the call sites
> > > of nested_vmx_enter_non_root_mode().  In other words, the rest
> > > of the consistency check code in nested_vmx_run() will be joining
> > > the postreqs checks in future patches.
> > >
> > > Fixes: ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_ru=
n()")
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Cc: Jim Mattson <jmattson@google.com>
> > > Reviewed-by: Jim Mattson <jmattson@google.com>
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  arch/x86/kvm/vmx.c | 10 +++-------
> > >  1 file changed, 3 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > > index fe7fdd666f091..bdf019f322117 100644
> > > --- a/arch/x86/kvm/vmx.c
> > > +++ b/arch/x86/kvm/vmx.c
> > > @@ -12694,6 +12694,9 @@ static int enter_vmx_non_root_mode(struct kvm=
_vcpu *vcpu, u32 *exit_qual)
> > >         if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_ac=
tive(vcpu))
> > >                 evaluate_pending_interrupts |=3D vmx_has_apicv_interr=
upt(vcpu);
> > >
> > > +       if (from_vmentry && check_vmentry_postreqs(vcpu, vmcs12, exit=
_qual))
> > > +               return EXIT_REASON_INVALID_STATE;
> > > +
> > >         enter_guest_mode(vcpu);
> > >
> > >         if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROL=
S))
> > > @@ -12836,13 +12839,6 @@ static int nested_vmx_run(struct kvm_vcpu *v=
cpu, bool launch)
> > >          */
> > >         skip_emulated_instruction(vcpu);
> > >
> > > -       ret =3D check_vmentry_postreqs(vcpu, vmcs12, &exit_qual);
> > > -       if (ret) {
> > > -               nested_vmx_entry_failure(vcpu, vmcs12,
> > > -                                        EXIT_REASON_INVALID_STATE, e=
xit_qual);
> > > -               return 1;
> > > -       }
> > > -
> > >         /*
> > >          * We're finally done with prerequisite checking, and can sta=
rt with
> > >          * the nested entry.
> > > --
> > > 2.20.1
> > >
> > >
> > >
> > Hi all,
> >
> > This commit caused many kvm-unit-tests regression, cherry-pick
> > following commits from 4.20 fix the regression:
>
> Hi Jack - can you be more specific about the failing tests? What type of
> environment and which tests failed, which version of kvm-unit-tests? Do
> you have any logs available? I ask because we do run kvm-unit-tests on
> x86 and arm64 but we did not see these regressions.
>
> Thanks,
> Dan
>
Hi Dan,

I'm running at kvm-unit-tests commit b1414c5f0142 ("x86: vmx: fix
required alignment for posted interrupt descriptor")

using "run_tests.sh -a -t -j8" with qemu-2.7.1

Left side has only 78 tests ok, and right side has 112 tests ok.
root@ib1:/home/gkim/pb-ltp/install/results# diff
kvm-unit-test--2019_12_02-13h_13m_50s.log
kvm-unit-test--2019_12_02-02h_12m_26s.log
2d1
< ok smptest
6c5
< ok vmexit_vmcall
---
> ok smptest
7a7
> ok vmexit_vmcall
10d9
< ok vmexit_ipi
11a11,12
> ok vmexit_ipi
> ok vmexit_tscdeadline
14d14
< ok vmexit_tscdeadline
16,18c16
< ok vmexit_tscdeadline_immed
< ok pku # SKIP
< ok emulator
---
> ok hypercall
19a18,19
> ok emulator
> ok pku # SKIP
21c21
< ok hypercall
---
> ok vmexit_tscdeadline_immed
27a28
> ok apic
29d29
< ok apic-split
31c31
< ok s3
---
> ok xsave
34d33
< ok xsave
35a35
> ok apic-split
37d36
< ok apic
38a38
> ok s3
40c40
< not ok vmx_null
---
> ok vmx_null
42d41
< not ok vmx
44d42
< ok vmx_test_vmptrld
45a44
> ok vmx_test_vmptrld
48d46
< ok access
50c48
< ok vmx_test_vmcs_lifecycle
---
> ok access
52c50,51
< not ok vmx_vmenter
---
> ok vmx_test_vmcs_lifecycle
> ok vmx_vmenter
54,72c53,72
< not ok vmx_preemption_timer
< not ok vmx_control_field_PAT
< not ok vmx_control_field_EFER
< not ok vmx_CR_shadowing
< not ok vmx_IO_bitmap
< not ok vmx_instruction_intercept
< not ok vmx_EPT_AD_disabled
< not ok vmx_EPT_AD_enabled
< not ok vmx_PML
< not ok vmx_VPID
< not ok vmx_interrupt
< not ok vmx_debug_controls
< not ok vmx_vmmcall
< not ok vmx_MSR_switch
< not ok vmx_disable_RDTSCP
< not ok vmx_int3
< not ok vmx_into
< not ok vmx_exit_monitor_from_l2_test
< not ok vmx_v2
---
> ok vmx_control_field_PAT
> ok vmx_control_field_EFER
> ok vmx_CR_shadowing
> ok vmx_preemption_timer
> ok vmx_IO_bitmap
> ok vmx_instruction_intercept
> ok kvmclock_test
> ok vmx_EPT_AD_disabled
> ok vmx_PML
> ok vmx_EPT_AD_enabled
> ok vmx_VPID
> ok vmx_interrupt
> ok vmx_debug_controls
> ok vmx_MSR_switch
> ok vmx_disable_RDTSCP
> ok vmx_vmmcall
> ok vmx_int3
> ok vmx_into
> ok vmx_v2
> ok vmx_exit_monitor_from_l2_test
80d79
< ok vmx_ept_access_test_reserved_bits # SKIP
82c81
< ok vmx_ept_access_test_paddr_not_present_ad_disabled # SKIP
---
> ok vmx_ept_access_test_reserved_bits # SKIP
85c84
< ok kvmclock_test
---
> ok vmx_ept_access_test_paddr_not_present_ad_disabled # SKIP
87d85
< ok vmx_ept_access_test_paddr_read_write # SKIP
88a87,88
> ok vmx_ept_access_test_paddr_read_write # SKIP
> ok vmx_ept_access_test_paddr_read_execute_ad_enabled # SKIP
91,92d90
< ok vmx_ept_access_test_paddr_read_execute_ad_enabled # SKIP
< ok vmx_ept_access_test_paddr_not_present_page_fault # SKIP
94,95c92,95
< not ok vmx_vmentry_movss_shadow_test
< not ok vmx_cr_load_test
---
> ok vmx_ept_access_test_paddr_not_present_page_fault # SKIP
> ok vmx_vmentry_movss_shadow_test
> ok vmx_cr_load_test
> ok vmx_nm_test
97,104c97,102
< not ok vmx_nm_test
< not ok vmx_pending_event_test
< not ok vmx_pending_event_hlt_test
< not ok vmx_store_tsc_test
< not ok vmx_store_tsc_test
< not ok vmx_db_test
< not ok vmx_nmi_window_test
< not ok vmx_intr_window_test
---
> ok vmx_pending_event_test
> ok vmx_pending_event_hlt_test
> ok vmx_store_tsc_test
> ok vmx_store_tsc_test
> ok vmx_db_test
> ok vmx_nmi_window_test
107,109c105,108
< not ok vmx_apic_passthrough
< not ok vmx_vmcs_shadow_test
< not ok vmx_apic_passthrough_thread
---
> ok vmx_intr_window_test
> ok vmx_apic_passthrough
> ok vmx_apic_passthrough_thread
> not ok vmx_controls
111d109
< not ok intel_iommu
113c111
< not ok vmx_controls
---
> not ok intel_iommu
117a116,117
> not ok vmx
> ok vmx_vmcs_shadow_test

Hope it helps.

Thanks,
Jack

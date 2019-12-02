Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 361CF10ECD5
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 17:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfLBQGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 11:06:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727418AbfLBQGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 11:06:33 -0500
Received: from localhost (unknown [84.241.196.73])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6762A2084F;
        Mon,  2 Dec 2019 16:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575302792;
        bh=tLAqlApYip8hY+icp5gGvPR2GCxSCxU1nvhC+g4Pn6A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fxQCA2KFolO++XHLicfxkNv6yFzv1KuvwarF1oVcfmf9wmCuh83ar62YgPD7M9Uji
         XCuEZ0OpBOQyHgiDjyvtkErc9N5WuW5tVNN1F3qNsqR5xYxQ4PGc79n5dIEsFmCMXr
         Oyj+P7nAIhh4g249cr1LZN6pmu+r08SW/AFB5wwc=
Date:   Mon, 2 Dec 2019 17:06:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jack Wang <jack.wang.usish@gmail.com>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 067/306] KVM: nVMX: move check_vmentry_postreqs()
 call to nested_vmx_enter_non_root_mode()
Message-ID: <20191202160628.GB698577@kroah.com>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203119.676489279@linuxfoundation.org>
 <CA+res+QKCAn8PsSgbkqXNAF0Ov5pOkj=732=M5seWj+-JFQOwQ@mail.gmail.com>
 <20191202145105.GA571975@kroah.com>
 <bccbfccd-0e96-29c3-b2ba-2b1800364b08@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bccbfccd-0e96-29c3-b2ba-2b1800364b08@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 04:09:33PM +0100, Paolo Bonzini wrote:
> On 02/12/19 15:51, Greg Kroah-Hartman wrote:
> > On Mon, Dec 02, 2019 at 03:40:04PM +0100, Jack Wang wrote:
> >> Greg Kroah-Hartman <gregkh@linuxfoundation.org> 于2019年11月27日周三 下午10:30写道：
> >>>
> >>> From: Sean Christopherson <sean.j.christopherson@intel.com>
> >>>
> >>> [ Upstream commit 7671ce21b13b9596163a29f4712cb2451a9b97dc ]
> >>>
> >>> In preparation of supporting checkpoint/restore for nested state,
> >>> commit ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_run()")
> >>> modified check_vmentry_postreqs() to only perform the guest EFER
> >>> consistency checks when nested_run_pending is true.  But, in the
> >>> normal nested VMEntry flow, nested_run_pending is only set after
> >>> check_vmentry_postreqs(), i.e. the consistency check is being skipped.
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
> >>> Fixes: ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_run()")
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
> >>> @@ -12694,6 +12694,9 @@ static int enter_vmx_non_root_mode(struct kvm_vcpu *vcpu, u32 *exit_qual)
> >>>         if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
> >>>                 evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
> >>>
> >>> +       if (from_vmentry && check_vmentry_postreqs(vcpu, vmcs12, exit_qual))
> >>> +               return EXIT_REASON_INVALID_STATE;
> >>> +
> >>>         enter_guest_mode(vcpu);
> >>>
> >>>         if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
> >>> @@ -12836,13 +12839,6 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
> >>>          */
> >>>         skip_emulated_instruction(vcpu);
> >>>
> >>> -       ret = check_vmentry_postreqs(vcpu, vmcs12, &exit_qual);
> >>> -       if (ret) {
> >>> -               nested_vmx_entry_failure(vcpu, vmcs12,
> >>> -                                        EXIT_REASON_INVALID_STATE, exit_qual);
> >>> -               return 1;
> >>> -       }
> >>> -
> >>>         /*
> >>>          * We're finally done with prerequisite checking, and can start with
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

Sasha, can you add kvm code to the blacklist?  Odds are the fact that
this is burried down in arch/x86/ it didn't get caught by the blacklist.

thanks,

greg k-h

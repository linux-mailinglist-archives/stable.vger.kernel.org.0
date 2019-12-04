Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19540113115
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 18:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfLDRuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:50:37 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:38207 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbfLDRug (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 12:50:36 -0500
Received: by mail-yb1-f196.google.com with SMTP id l129so303190ybf.5
        for <stable@vger.kernel.org>; Wed, 04 Dec 2019 09:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TeAcDw9r1twHj7MlWZVEGGHkOn4NNgX/nZFZTFL2GrY=;
        b=AWTRPIh4806nX1sp0olNxaEw/rTmOJaREKiTvC1dn2tylnhBSeGXRUkrYHT/rLfXIm
         WbwEW3tQb78Povu626dqPs/7SgaZ1Fmb+ohDR8JDU4G/sqlcDY6mY1yN9UVuEhUa2E5t
         j4RFDFze86uCm6XSdS2okkq/WG5iLetbSt0QhXgpYlSOETKHtvZurAxaqX2eZM1v40GS
         ohC7J6DfKODtzAsxDGUhb5NK/Ul1E1vWXlMP79VQOwnmeY6NOnR+85t1vCph1kUt8bXS
         yYkaKCR0Qo91Oze2L8BxNZNWmag6FHHtkRJkBl7dTWmPgazCCLAywqullgN/I8g5ubN1
         Ys6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=TeAcDw9r1twHj7MlWZVEGGHkOn4NNgX/nZFZTFL2GrY=;
        b=Ll6XMt/6Ra0rowcfMaUdRqHWmgTu4yNvponPPnKnv6K1kSDW11+MoAag6YZjPaVMpC
         V+aNAk4je+7vtP9UYMDVYoTa4wrmEyUiL6aBRxKH3zhGbxlSEr2XhG91sOeaiND0jt2m
         esnDty2hmtimNsYSnh7YBsPhk9zEKktjEseNSVEKr0safMRHqXc25rrGVUnNBPBqTnjJ
         PQtEa0XSSrrwLtWIa9v37t2wu3iyngIqolDdTnAycpIyc8Ss8Mew0L5lBPn1iENSJ4wF
         1bTvtGzv242MZJwL36rKKk+VuyiJNoroFfEqc8UOBqtffrTlArHl3efyeri6MfDtq0Qd
         6Gjg==
X-Gm-Message-State: APjAAAU6vwZd49IoLiPKEuAO9IQUkBcfh5IBflvJ4R13zL1ZHoXrBLbZ
        cg4KXALW9SFT3E6sytsJ/Ec7Sw==
X-Google-Smtp-Source: APXvYqxwLwRW/7lCyqzNc5i9t/sg5MCcYRL0P3XngRtppb275Umm4dzEVA+W5qS0KgLrdlT/zjUCgg==
X-Received: by 2002:a25:b3ce:: with SMTP id x14mr3291798ybf.251.1575481835367;
        Wed, 04 Dec 2019 09:50:35 -0800 (PST)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id y9sm3298731ywc.19.2019.12.04.09.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 09:50:34 -0800 (PST)
Date:   Wed, 4 Dec 2019 11:50:33 -0600
From:   Dan Rue <dan.rue@linaro.org>
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 067/306] KVM: nVMX: move check_vmentry_postreqs()
 call to nested_vmx_enter_non_root_mode()
Message-ID: <20191204175033.smve4dleem2ht7st@xps.therub.org>
Mail-Followup-To: Jack Wang <jack.wang.usish@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203119.676489279@linuxfoundation.org>
 <CA+res+QKCAn8PsSgbkqXNAF0Ov5pOkj=732=M5seWj+-JFQOwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+res+QKCAn8PsSgbkqXNAF0Ov5pOkj=732=M5seWj+-JFQOwQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 03:40:04PM +0100, Jack Wang wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> 于2019年11月27日周三 下午10:30写道：
> >
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> >
> > [ Upstream commit 7671ce21b13b9596163a29f4712cb2451a9b97dc ]
> >
> > In preparation of supporting checkpoint/restore for nested state,
> > commit ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_run()")
> > modified check_vmentry_postreqs() to only perform the guest EFER
> > consistency checks when nested_run_pending is true.  But, in the
> > normal nested VMEntry flow, nested_run_pending is only set after
> > check_vmentry_postreqs(), i.e. the consistency check is being skipped.
> >
> > Alternatively, nested_run_pending could be set prior to calling
> > check_vmentry_postreqs() in nested_vmx_run(), but placing the
> > consistency checks in nested_vmx_enter_non_root_mode() allows us
> > to split prepare_vmcs02() and interleave the preparation with
> > the consistency checks without having to change the call sites
> > of nested_vmx_enter_non_root_mode().  In other words, the rest
> > of the consistency check code in nested_vmx_run() will be joining
> > the postreqs checks in future patches.
> >
> > Fixes: ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_run()")
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/x86/kvm/vmx.c | 10 +++-------
> >  1 file changed, 3 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > index fe7fdd666f091..bdf019f322117 100644
> > --- a/arch/x86/kvm/vmx.c
> > +++ b/arch/x86/kvm/vmx.c
> > @@ -12694,6 +12694,9 @@ static int enter_vmx_non_root_mode(struct kvm_vcpu *vcpu, u32 *exit_qual)
> >         if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
> >                 evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
> >
> > +       if (from_vmentry && check_vmentry_postreqs(vcpu, vmcs12, exit_qual))
> > +               return EXIT_REASON_INVALID_STATE;
> > +
> >         enter_guest_mode(vcpu);
> >
> >         if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
> > @@ -12836,13 +12839,6 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
> >          */
> >         skip_emulated_instruction(vcpu);
> >
> > -       ret = check_vmentry_postreqs(vcpu, vmcs12, &exit_qual);
> > -       if (ret) {
> > -               nested_vmx_entry_failure(vcpu, vmcs12,
> > -                                        EXIT_REASON_INVALID_STATE, exit_qual);
> > -               return 1;
> > -       }
> > -
> >         /*
> >          * We're finally done with prerequisite checking, and can start with
> >          * the nested entry.
> > --
> > 2.20.1
> >
> >
> >
> Hi all,
> 
> This commit caused many kvm-unit-tests regression, cherry-pick
> following commits from 4.20 fix the regression:

Hi Jack - can you be more specific about the failing tests? What type of
environment and which tests failed, which version of kvm-unit-tests? Do
you have any logs available? I ask because we do run kvm-unit-tests on
x86 and arm64 but we did not see these regressions.

Thanks,
Dan

> d63907dc7dd1 ("KVM: nVMX: rename enter_vmx_non_root_mode to
> nested_vmx_enter_non_root_mode")
> a633e41e7362 ("KVM: nVMX: assimilate nested_vmx_entry_failure() into
> nested_vmx_enter_non_root_mode()")
> 
> Regards,
> Jack Wang
> 1 & 1 IONOS SE

-- 
Linaro LKFT
https://lkft.linaro.org

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3858860CDB1
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 15:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiJYNhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 09:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbiJYNhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 09:37:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC7F19375E
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 06:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666705055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=exi/m0Abh7Peoy1eaDEpT6oKngaAyQ3kIL361TzbR/Y=;
        b=ZzpDNMXyeHdE7XLJiaAqzgMgsO6yN/dpjDCwoBiocdSoYzB6AKii4DdPKss2HOM5Fo7eYd
        CcJIgtKm+bBDUbkR3coXqrDr5BAEJ9y0LUfTNGRUO0IJ/zIRQglKPQuRpEHIwsaOFaej6S
        NfPDJs3iAHT3sRy9hj4xkEzMLdvfpf4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-231--THxaVnCPoG9Qn-EiE5DHQ-1; Tue, 25 Oct 2022 09:37:33 -0400
X-MC-Unique: -THxaVnCPoG9Qn-EiE5DHQ-1
Received: by mail-qk1-f200.google.com with SMTP id x22-20020a05620a259600b006b552a69231so11403704qko.18
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 06:37:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=exi/m0Abh7Peoy1eaDEpT6oKngaAyQ3kIL361TzbR/Y=;
        b=e9eDrivnFyw+zQG3DR9NJQ21rlqR/Hi54aR/bpVoxp8koJxOleQnGZJikvEQBJoeTj
         hlwez5y6QpBWlHkd8KYtFsGiy8NSW4gsgZet9Hb04yOjc4Dj5yv2iuTM+vNkJg9TVYmZ
         pMY/SbXMj+H+mhhjpVaBAmgvyKvVNxArkV+LKnLT5GQmJF368HTDve2qz0SIhMg/BOWu
         GWfF4qfeNJvW2/E7AMJv5tqSb9ECzY2slMr2AgHHSMxgWxysSdOsQez41dwBijZzEGvO
         Ii2iYM8piruayxxnkYFddm+s1iYmKuS8keD/g3FNenxh8Fzj+Fn2l9FSDiQ9VR/rqN10
         XszA==
X-Gm-Message-State: ACrzQf1bto3lpIxzd8feeO/Gn4cPscGTASrz3Kp+cccOcUGK9PJ/9bAc
        zHxAM1w4PbBYZHKWMYj7P4Kaj2m9M4kx2P5nfTNaDkCbxfFst5gh4VauB88s0GEu3401reUebss
        HoZ+xnSbS3U6n4pGN
X-Received: by 2002:a05:620a:4414:b0:6ee:76e4:1b6d with SMTP id v20-20020a05620a441400b006ee76e41b6dmr25236867qkp.360.1666705052596;
        Tue, 25 Oct 2022 06:37:32 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM68HpWeY+CJiGKYkIVSR65r7FtSbw6IzHBXldUSNhKCTbouniAxrMfvQVq6EzqpiZi7la0B2w==
X-Received: by 2002:a05:620a:4414:b0:6ee:76e4:1b6d with SMTP id v20-20020a05620a441400b006ee76e41b6dmr25236849qkp.360.1666705052322;
        Tue, 25 Oct 2022 06:37:32 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id w3-20020ac857c3000000b0039442ee69c5sm1612489qta.91.2022.10.25.06.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 06:37:31 -0700 (PDT)
Message-ID: <cc6f6e29ca844cccbefd9f2a3c0a25159ce3fecd.camel@redhat.com>
Subject: Re: [PATCH 4/4] KVM: x86: forcibly leave nested mode on vCPU reset
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Date:   Tue, 25 Oct 2022 16:37:27 +0300
In-Reply-To: <Y1FqXiBB7Bqzj8eh@google.com>
References: <20221020093055.224317-1-mlevitsk@redhat.com>
         <20221020093055.224317-5-mlevitsk@redhat.com> <Y1FqXiBB7Bqzj8eh@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-10-20 at 15:33 +0000, Sean Christopherson wrote:
> On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > While not obivous, kvm_vcpu_reset leaves the nested mode by
> 
> Please add () when referencing function, and wrap closer to ~75 chars.
> 
> > clearing 'vcpu->arch.hflags' but it does so without all the
> > required housekeeping.
> > 
> > This makes SVM and VMX continue to use vmcs02/vmcb02 while
> 
> This bug should be impossible to hit on VMX as INIT and TRIPLE_FAULT unconditionally
> cause VM-Exit, i.e. will always be forwarded to L1.

True I guess as I found out as well, in VMX the physical CPU can't be reset while
in guest mode. I'll update the changelog.

> 
> > the cpu is not in nested mode.
> 
> Can you add a blurb to call out exactly how this bug can be triggered?  Doesn't
> take much effort to suss out the "how", but it'd be nice to capture that info in
> the changelog.

I will add (in another patch) a selftest for this.

> 
> > In particular, in SVM code, it makes the 'svm_free_nested'
> > free the vmcb02, while still in use, which later triggers
> > use after free and a kernel crash.
> > 
> > This issue is assigned CVE-2022-3344
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index d86a8aae1471d3..313c4a6dc65e45 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11931,6 +11931,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >         WARN_ON_ONCE(!init_event &&
> >                      (old_cr0 || kvm_read_cr3(vcpu) || kvm_read_cr4(vcpu)));
> >  
> > +       kvm_leave_nested(vcpu);
> 
> Not a big deal, especially if/when nested_ops are turned into static_calls, but
> at the same time it's quite easy to do:
> 
>         if (is_guest_mode(vcpu))
>                 kvm_leave_nested(vcpu);
> 
> I think it's worth adding a comment explaining how this can happen, and to also
> call out that EFER is cleared on INIT, i.e. that virtualization is disabled due
> to EFER.SVME=0.  Unsurprisingly, I don't see anything in the APM that explicitly
> states what happens if INIT occurs in guest mode, i.e. it's not immediately obvious
> that forcing the vCPU back to L1 is architecturally correct.
> 
> 
> >         kvm_lapic_reset(vcpu, init_event);
> >  
> >         vcpu->arch.hflags = 0;
> 
> Maybe add a WARN above this to try and detect other potential issues?  Kinda silly,
> but it'd at least help draw attention to the importance of hflags.
> 
> E.g. this?
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4bd5f8a751de..c50fa0751a0b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11915,6 +11915,15 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>         unsigned long old_cr0 = kvm_read_cr0(vcpu);
>         unsigned long new_cr0;
>  
> +       /*
> +        * SVM doesn't unconditionally VM-Exit on INIT and SHUTDOWN, thus it's
> +        * possible to INIT the vCPU while L2 is active.  Force the vCPU back
> +        * into L1 as EFER.SVME is cleared on INIT (along with all other EFER
> +        * bits), i.e. virtualization is disabled.
> +        */


> +       if (is_guest_mode(vcpu))
> +               kvm_leave_nested(vcpu);
> +
>         /*
>          * Several of the "set" flows, e.g. ->set_cr0(), read other registers
>          * to handle side effects.  RESET emulation hits those flows and relies
> @@ -11927,6 +11936,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>         kvm_lapic_reset(vcpu, init_event);
>  
> +       WARN_ON_ONCE(is_guest_mode(vcpu) || is_smm(vcpu));
>         vcpu->arch.hflags = 0;
>  
>         vcpu->arch.smi_pending = 0;
> 

Best regards,
	Maxim Levitsky


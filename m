Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B3F6064A4
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 17:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJTPeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 11:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiJTPeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 11:34:10 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03E51B4C42
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 08:34:09 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id l19so13753036qvu.4
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 08:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cLdV6PnMuiKqKn7gplx6uvtLf96oiQWdR0P2i4ykuy0=;
        b=TQT2+C3O9UUEZA+1iAGO7fXFxtjW15uivVF5CNBDmGN2z0KWp+O2blljq7h9DyKSc5
         EvOMFs/UY84ParhE3rIwN9cVgLml7iv7F4mLfv+Cs0ujLRmntlZx1rtpA3jabG4i6fWI
         bJZ1faD95NoNYmNvr8lopzIUTC1s/fp08cBi2jq9MSen0qEwKRL/YXOsSthHh6udKfvi
         /KOIKnc+V+AZlCCynwrOiofsJ9i38TmXK72rP0fejJL+yJJq+n6SluNS6E+Qx73zVhRo
         mP7PsUSvMOwz4hfXsHZruD04/bMBgDjfHKX62X1CV66rqnJG7w5xhdF+LqyuZwUi0s7w
         kq9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cLdV6PnMuiKqKn7gplx6uvtLf96oiQWdR0P2i4ykuy0=;
        b=viZcBzjSO1QvZitIULg9w/wYDw/Mz+bfk0M+zSuZfpTfno+J06FMrB8VPeb/x/9FTn
         Oe7/ER7BNR2QqNRC3jC4pDJc40WOND+kdsjMeEXnMGVvSOXZemF/46SgokhoSeCg3kSy
         L5nLFfHcDnS47+DYMGl7QzKq5sZQD8Xbdaii4pwa6UWcIwuv5mP73JOikdHDbTRjXXn8
         kYoFs0FYvoYOLP62rc0eSGahpGYjBpW9MTB/KeLNTf3fURnLcYBdIdc9WEUxoU0doU9b
         LWgWO1EFpr02KYmd8QQ0SnhbwrPKoOkDPo7P+eNqYbdp5QD1OMDw8+fOarwtfN6T+EIs
         B6yg==
X-Gm-Message-State: ACrzQf3x5qOxfPKGzamy3ysxg4NJW2aAyvkN829XWT+ICZkf24S5vZh5
        P15i26QeFpUhdG8kjMGxOxqw0+JfDKp7hw==
X-Google-Smtp-Source: AMsMyM4SAjheRdafoKSz7GuP3WqVBUXFdEVhBe4c4GJ/YHF97KUpwVnjB7h5dCGblkpUFxePss9bpQ==
X-Received: by 2002:a17:902:9a07:b0:178:8024:1393 with SMTP id v7-20020a1709029a0700b0017880241393mr14554070plp.128.1666280038382;
        Thu, 20 Oct 2022 08:33:58 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l1-20020a63f301000000b00440416463fesm11770926pgh.27.2022.10.20.08.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 08:33:54 -0700 (PDT)
Date:   Thu, 20 Oct 2022 15:33:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [PATCH 4/4] KVM: x86: forcibly leave nested mode on vCPU reset
Message-ID: <Y1FqXiBB7Bqzj8eh@google.com>
References: <20221020093055.224317-1-mlevitsk@redhat.com>
 <20221020093055.224317-5-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020093055.224317-5-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> While not obivous, kvm_vcpu_reset leaves the nested mode by

Please add () when referencing function, and wrap closer to ~75 chars.

> clearing 'vcpu->arch.hflags' but it does so without all the
> required housekeeping.
> 
> This makes SVM and VMX continue to use vmcs02/vmcb02 while

This bug should be impossible to hit on VMX as INIT and TRIPLE_FAULT unconditionally
cause VM-Exit, i.e. will always be forwarded to L1.

> the cpu is not in nested mode.

Can you add a blurb to call out exactly how this bug can be triggered?  Doesn't
take much effort to suss out the "how", but it'd be nice to capture that info in
the changelog.

> In particular, in SVM code, it makes the 'svm_free_nested'
> free the vmcb02, while still in use, which later triggers
> use after free and a kernel crash.
> 
> This issue is assigned CVE-2022-3344
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d86a8aae1471d3..313c4a6dc65e45 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11931,6 +11931,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	WARN_ON_ONCE(!init_event &&
>  		     (old_cr0 || kvm_read_cr3(vcpu) || kvm_read_cr4(vcpu)));
>  
> +	kvm_leave_nested(vcpu);

Not a big deal, especially if/when nested_ops are turned into static_calls, but
at the same time it's quite easy to do:

	if (is_guest_mode(vcpu))
		kvm_leave_nested(vcpu);

I think it's worth adding a comment explaining how this can happen, and to also
call out that EFER is cleared on INIT, i.e. that virtualization is disabled due
to EFER.SVME=0.  Unsurprisingly, I don't see anything in the APM that explicitly
states what happens if INIT occurs in guest mode, i.e. it's not immediately obvious
that forcing the vCPU back to L1 is architecturally correct.


>  	kvm_lapic_reset(vcpu, init_event);
>  
>  	vcpu->arch.hflags = 0;

Maybe add a WARN above this to try and detect other potential issues?  Kinda silly,
but it'd at least help draw attention to the importance of hflags.

E.g. this?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4bd5f8a751de..c50fa0751a0b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11915,6 +11915,15 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
        unsigned long old_cr0 = kvm_read_cr0(vcpu);
        unsigned long new_cr0;
 
+       /*
+        * SVM doesn't unconditionally VM-Exit on INIT and SHUTDOWN, thus it's
+        * possible to INIT the vCPU while L2 is active.  Force the vCPU back
+        * into L1 as EFER.SVME is cleared on INIT (along with all other EFER
+        * bits), i.e. virtualization is disabled.
+        */
+       if (is_guest_mode(vcpu))
+               kvm_leave_nested(vcpu);
+
        /*
         * Several of the "set" flows, e.g. ->set_cr0(), read other registers
         * to handle side effects.  RESET emulation hits those flows and relies
@@ -11927,6 +11936,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
        kvm_lapic_reset(vcpu, init_event);
 
+       WARN_ON_ONCE(is_guest_mode(vcpu) || is_smm(vcpu));
        vcpu->arch.hflags = 0;
 
        vcpu->arch.smi_pending = 0;

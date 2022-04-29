Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC5D515143
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 19:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379394AbiD2RGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 13:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379392AbiD2RGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 13:06:41 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8417B0D34
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 10:03:21 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id m14-20020a17090a34ce00b001d5fe250e23so7813030pjf.3
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 10:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=RkN7JUMz0DAtONAVPRmRHnP64HBiaCnPPuSBpGqI0Eo=;
        b=APvmC5k2WUKy0VF/8OFRKt3sJeb7n0edWipqz/MuxQSpQdH6U840xRClQNgeSB0/HP
         CorEabT7uAif+i25odVZeixSMo+CrYTYX0OCnVriOtMIrhAOjQNKxMuoqgWXTAZgMl2P
         nSOmNzDXu54i8slffbv/+iAa3TqxxKOgSzJCyGmNjc48RJVfqclQY74gl/+qZEQWQaRL
         G5fGahViQBcY78yDKgrE3WecQcf8RitMoYp1YinysH+SnU/xWu61GQYEH15+arqh/kUj
         FWhXZjI9jmGQM1gJbsagSphVpJWn67RBBedRQD6AunGL/AormBN2S16j4yeB+1GMnWCZ
         r4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=RkN7JUMz0DAtONAVPRmRHnP64HBiaCnPPuSBpGqI0Eo=;
        b=ykcJpbj+GrmhHcCaumnE2+GSH8mPdmKFg+UJHmQRJiUhaUl0FJV/wrAJKnhpvnndcE
         tS7CwaXfKTvYzf9FQpbaD+5rTdPXMCqovJOjXQwFGfFHIgZBrrFf6BGCw8n7u826oCR2
         LpiCTCV3h1EPJZZGMBvMv6BrzFaJg3cCJlaU6X5cmlwvSreQYQ9Ak2pU8pQfsV/6tXVy
         iBWGF6A4KDcZ2fNfkvvx7i3gzwdnFADiEKUIqjbZMHpX85xupxrkT/05pyjNm/ixc9yH
         02qtBcRqTN9Cvh9Ztfl6PcNfVVxuEjuVJlfpBkVLOxIl9b97ksFLXRcym2UROteh6Zav
         n+OA==
X-Gm-Message-State: AOAM531kI1wfNTjIAcnrtJLVsxOoO8MXTWH5S+gHIYxASadueOV0n0oB
        ae7Cp8GIwYvY4hJjXjeM8EcOLQ==
X-Google-Smtp-Source: ABdhPJxa3u/ecjwn+3JjLKK6oRMJ5TZ6P/zhBeChiNrcd61l1FaXIYCxObf1ewlGxrCmBH+ZJBZv7Q==
X-Received: by 2002:a17:90a:ab81:b0:1ca:8a76:cdda with SMTP id n1-20020a17090aab8100b001ca8a76cddamr5005883pjq.26.1651251801115;
        Fri, 29 Apr 2022 10:03:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l5-20020a63ea45000000b003c1b2bea056sm2061378pgk.84.2022.04.29.10.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 10:03:20 -0700 (PDT)
Date:   Fri, 29 Apr 2022 17:03:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86: make vendor code check for all nested
 events
Message-ID: <YmwaVY5vERO43CRI@google.com>
References: <20220427173758.517087-1-pbonzini@redhat.com>
 <20220427173758.517087-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220427173758.517087-2-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 27, 2022, Paolo Bonzini wrote:
> Right now, the VMX preemption timer is special cased via the
> hv_timer_pending, but the purpose of the callback can be easily
> extended to observing any event that can occur only in non-root
> mode.  Interrupts, NMIs etc. are already handled properly by
> the *_interrupt_allowed callbacks, so what is missing is only
> MTF.  Check it in the newly-renamed callback, so that
> kvm_vcpu_running's call to kvm_check_nested_events
> becomes redundant.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/vmx/nested.c       | 7 ++++++-
>  arch/x86/kvm/x86.c              | 8 ++++----
>  3 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4ff36610af6a..e2e4f60159e9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1504,7 +1504,7 @@ struct kvm_x86_ops {
>  struct kvm_x86_nested_ops {
>  	void (*leave_nested)(struct kvm_vcpu *vcpu);
>  	int (*check_events)(struct kvm_vcpu *vcpu);
> -	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
> +	bool (*has_events)(struct kvm_vcpu *vcpu);
>  	void (*triple_fault)(struct kvm_vcpu *vcpu);
>  	int (*get_state)(struct kvm_vcpu *vcpu,
>  			 struct kvm_nested_state __user *user_kvm_nested_state,
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 856c87563883..54672025c3a1 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3857,6 +3857,11 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
>  	       to_vmx(vcpu)->nested.preemption_timer_expired;
>  }
>  
> +static bool vmx_has_nested_events(struct kvm_vcpu *vcpu)
> +{
> +	return nested_vmx_preemption_timer_pending(vcpu) || vmx->nested.mtf_pending;

This doesn't even compile...

arch/x86/kvm/vmx/nested.c: In function ‘vmx_has_nested_events’:
arch/x86/kvm/vmx/nested.c:3862:61: error: ‘vmx’ undeclared (first use in this function)
 3862 |         return nested_vmx_preemption_timer_pending(vcpu) || vmx->nested.mtf_pending;
      |                                                             ^~~
arch/x86/kvm/vmx/nested.c:3862:61: note: each undeclared identifier is reported only once for each function it appears in
  CC [M]  arch/x86/kvm/svm/svm_onhyperv.o
arch/x86/kvm/vmx/nested.c:3863:1: error: control reaches end of non-void function [-Werror=return-type]
 3863 | }
      | ^
cc1: all warnings being treated as errors
  LD [M]  arch/x86/kvm/kvm.o

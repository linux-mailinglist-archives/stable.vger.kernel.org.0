Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98359515262
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 19:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbiD2Rjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 13:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379726AbiD2Riv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 13:38:51 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B8F9F3B3
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 10:35:32 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 7so3145752pga.12
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 10:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=A2o+Ws1INtn1MzI5In4+SjIaL3aTcpeQBl4+z8iQMc4=;
        b=NYOSSTKbRD04TVB73Y0G8dVDDfWwHH/CPTSC7daECEsRY/h46kd7k6dLGhMDlrO1s0
         JvVKQn0GcojLy5mGg40A8qxM6FQZIPQi4E3s2mKqKKJv1jzvkw7Se89NURix2hwEHt+H
         MtTv2gISdz6cnht5Tg5kg6rrV6Fx/cSjRSn7pGTnc+7EPv9mPozYNWHGWwqgp2tXR2J9
         AGd9rij6dqLuXxB/ysKy16JHfzxL4TVnj0tTvZO4vvsqiepcOV1fqKW5w7XrakLIZ828
         TsckfsDGxa6bcewapYWOT2P0Nj7VjF3Hf6IbOd47FClYM0iOw0IF590tdnx7A93nrUyb
         RxZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=A2o+Ws1INtn1MzI5In4+SjIaL3aTcpeQBl4+z8iQMc4=;
        b=npVeGDbr9DfMAEyhX2l+qCLhheT3ahYGQFkU97cZTTAYgyQl1FL+qYaO23V2ECKsEK
         +QCPVmZuBILMHwWVKKd1WHCzlxjFj1c6gZX8u6uOjYzbBfsYGlNoJOTt1G9n7tkelt21
         XoW8yaxZ0F4yRxJVOQCKuXKmdVk/2NhZEZ3fI1VpE1P2DEuaIKLuRiE4hd7NHxMsk6l5
         iGVohlLV1jxUJiAjFRi7Ml3X9OX7ueYWYTOybEGjjfkLrYhfZLhl54GPswtSotsGdNYN
         hn82Ie2yGReYOtEthunMotLeJyLqtCGkJJoynKijAVTtzxqZ7rp/VFEOn3xfyTqnzRrh
         gAjw==
X-Gm-Message-State: AOAM530DP4yTIKX7Q2QbKCjTpdHoG0WZjB6ubhR8u0PXpuaQKEhX5al2
        LoIJm12ddGnrySVLTzXSBizfMA==
X-Google-Smtp-Source: ABdhPJySHzOFet3agObDF17Dhwfya9aBtbqQNVx7EZSgv30DDlpfHWNXSSP+dep1o8EZziq4Eyq0uA==
X-Received: by 2002:a63:1c1d:0:b0:39d:9a7c:593b with SMTP id c29-20020a631c1d000000b0039d9a7c593bmr367462pgc.157.1651253732177;
        Fri, 29 Apr 2022 10:35:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y38-20020a056a001ca600b0050dafe16d7bsm2804025pfw.26.2022.04.29.10.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 10:35:31 -0700 (PDT)
Date:   Fri, 29 Apr 2022 17:35:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86: make vendor code check for all nested
 events
Message-ID: <Ymwh4PEZHDvWyR1f@google.com>
References: <20220427173758.517087-1-pbonzini@redhat.com>
 <20220427173758.517087-2-pbonzini@redhat.com>
 <YmwaVY5vERO43CRI@google.com>
 <0b554e22-6766-8299-287c-c40240c08536@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b554e22-6766-8299-287c-c40240c08536@redhat.com>
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

On Fri, Apr 29, 2022, Paolo Bonzini wrote:
> On 4/29/22 19:03, Sean Christopherson wrote:
> > This doesn't even compile...
> > 
> > arch/x86/kvm/vmx/nested.c: In function ‘vmx_has_nested_events’:
> > arch/x86/kvm/vmx/nested.c:3862:61: error: ‘vmx’ undeclared (first use in this function)
> >   3862 |         return nested_vmx_preemption_timer_pending(vcpu) || vmx->nested.mtf_pending;
> >        |                                                             ^~~
> > arch/x86/kvm/vmx/nested.c:3862:61: note: each undeclared identifier is reported only once for each function it appears in
> >    CC [M]  arch/x86/kvm/svm/svm_onhyperv.o
> > arch/x86/kvm/vmx/nested.c:3863:1: error: control reaches end of non-void function [-Werror=return-type]
> >   3863 | }
> >        | ^
> > cc1: all warnings being treated as errors
> >    LD [M]  arch/x86/kvm/kvm.o
> 
> Yeah, it doesn't.  Of course this will need a v2, also because there are
> failures in the vmx tests.

Heh, I suspected there would be failures, I was about to type up a response to
patch 3.  MTF is subtly relying on the call from kvm_vcpu_running() to inject
the event.

From: Sean Christopherson <seanjc@google.com>
Date: Fri, 29 Apr 2022 17:30:54 +0000
Subject: [PATCH] KVM: nVMX: Make an event request when pending an MTF nested
 VM-Exit

Set KVM_REQ_EVENT when MTF becomes pending to ensure that KVM will run
through inject_pending_event() and thus vmx_check_nested_events() prior
to re-entering the guest.  MTF currently works by virtue of KVM's hack
that calls kvm_check_nested_events() from kvm_vcpu_running(), but that
hack will be removed in the near future.

Fixes: 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing instruction emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d58b763df855..4c635bc08105 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1577,10 +1577,12 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 	 */
 	if (nested_cpu_has_mtf(vmcs12) &&
 	    (!vcpu->arch.exception.pending ||
-	     vcpu->arch.exception.nr == DB_VECTOR))
+	     vcpu->arch.exception.nr == DB_VECTOR)) {
 		vmx->nested.mtf_pending = true;
-	else
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	} else {
 		vmx->nested.mtf_pending = false;
+	}
 }

 static int vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)

base-commit: 39aa5903e8c407e5128c15aeabb0717b275b007e
--


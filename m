Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEAB454F1E
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 22:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhKQVNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 16:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240111AbhKQVNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 16:13:21 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3D6C061766
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 13:10:22 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id v19so3295193plo.7
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 13:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HpUDESohLCksHYlbi/Idrt7wBDoYF2vRmhCJA2AE2Hg=;
        b=E70vxDhbL7NRBZu/n0+2xIXeHOvjed+dZ49DrMI1mxl2UWO6qwTxglE3LcXt4iXC+/
         8IBA5k06OIpMphfxCPUnGLo8Ae6u5REQcmrga2EytS/YZP7a2ym/Jd+otxwNqqRw3wWb
         m2Tc74QoagJ//GPJ8/nNHRZtI0u2MIokLtRBp2n2HzuAFWNKuyFLNL8RersdccjipyM7
         pcMhvpaZctW8oS43GTizIdUKKptZALR+5VE1LdeFzB6X02RzVaD3IYBFXxH7lEwb1J8g
         wcT0dicMzz7s/e5aObMfnWW9FeqKm4LwbJUhF42CGJJoM4dLZYA8SlUrGDOzLZKZazQN
         vR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HpUDESohLCksHYlbi/Idrt7wBDoYF2vRmhCJA2AE2Hg=;
        b=LsHPzee9WAMrDIowNQWOJX7Pg6qKlKJQ9w6bxZwKwKxCfnaABIXeIVraPSm5bPIRMr
         GWSwu1aBTCh8xBewy76EUIWdjakM+dt+iIbxgphnw6ouj0tY6IOSupUfwAoui0KbPIQX
         fsZUFznmFRl6BjvDfI4r1RttIb/Wva1kmFywUhAyVtZplEmbv/7pSo5Hm+T8sOlZ1AGI
         SIYbPMStvZ18KWO5CFybOqi/72lNX3lSR8AstEy2/X6m7xjMM6FN7iZ2gdem0Dfc+eoU
         YJ9cgoqv2Kui4Z9FWfoPj56MIEgJvyy/lVRTZ+X21HOZ3TEJxU3LX1HwvWFbXvl+awXc
         8boQ==
X-Gm-Message-State: AOAM532Jt8I7pSK3uLlyWRXe5tYFWqAze8Q5lDx6cAVuKiGKzCOsWCV6
        enmlwYt9KdIl46Kna9IQecVOeXrthFF34Q==
X-Google-Smtp-Source: ABdhPJxxmvG3bNvaQSJxBqpDV67VuDzD46C+w4ribl6R0HwF7VLCdxYwcEEpkWzGoN2RkRjO1y/x9A==
X-Received: by 2002:a17:903:11c3:b0:143:d220:fddb with SMTP id q3-20020a17090311c300b00143d220fddbmr17269018plh.5.1637183421758;
        Wed, 17 Nov 2021 13:10:21 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g5sm6196065pjt.15.2021.11.17.13.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:10:21 -0800 (PST)
Date:   Wed, 17 Nov 2021 21:10:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: check PIR even for vCPUs with disabled APICv
Message-ID: <YZVvuRdLcxZclw+1@google.com>
References: <20211117080744.995111-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117080744.995111-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021, Paolo Bonzini wrote:
> After fixing the handling of POSTED_INTR_WAKEUP_VECTOR for vCPUs with
> disabled APICv, take care of POSTED_INTR_VECTOR.  The IRTE for an assigned
> device can trigger a POSTED_INTR_VECTOR even if APICv is disabled on the
> vCPU that receives it.  In that case, the interrupt will just cause a
> vmexit and leave the ON bit set together with the PIR bit corresponding
> to the interrupt.
> 
> Right now, the interrupt would not be delivered until APICv is re-enabled.
> However, fixing this is just a matter of always doing the PIR->IRR
> synchronization, even if the vCPU does not have APICv enabled.
> 
> This is not a problem for performance, or if anything it is an
> improvement.  static_call_cond will elide the function call if APICv is
> not present or disabled, or if (as is the case for AMD hardware) it does
> not require a sync_pir_to_irr callback.

The AMD part is not accurate, SVM's sync_pir_to_irr() is wired up to point at
kvm_lapic_find_highest_irr().  That can and probably should be fixed in a separate
patch, 

And I believe apic_has_interrupt_for_ppr() needs to be updated as well.

We can handled both at once by nullifying SVM's hook and explicitly checking for
a non-NULL implementation in apic_has_interrupt_for_ppr(), which is the only path
that cares about the result of sync_pir_to_irr(), i.e. needs to do the work in
the SVM case.

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4388d22df500..1456745cf5c6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -707,7 +707,8 @@ static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
 static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
 {
        int highest_irr;
-       if (apic->vcpu->arch.apicv_active)
+
+       if (kvm_x86_ops.sync_pir_to_irr)
                highest_irr = static_call(kvm_x86_sync_pir_to_irr)(apic->vcpu);
        else
                highest_irr = apic_find_highest_irr(apic);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ccbf96876ec6..470552e68b7e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4649,7 +4649,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
        .load_eoi_exitmap = svm_load_eoi_exitmap,
        .hwapic_irr_update = svm_hwapic_irr_update,
        .hwapic_isr_update = svm_hwapic_isr_update,
-       .sync_pir_to_irr = kvm_lapic_find_highest_irr,
+       .sync_pir_to_irr = NULL,
        .apicv_post_state_restore = avic_post_state_restore,

        .set_tss_addr = svm_set_tss_addr,

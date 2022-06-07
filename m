Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD8B541792
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378438AbiFGVDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379330AbiFGVCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:02:21 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536BF62CDB
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 11:47:46 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s14so15550898plk.8
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 11:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bq3CtL8r5GfIJRMEMuTZRaNrH6+E6V3L1A1y/G7x4zc=;
        b=sDU6k8EIeE4SYgNY6ZlLksQCk0G6UMR2ghuXPDr+ezKXYMLOJy1JV6bqlaYICD6A+f
         szfP31/juK1NYkXSgNCUF3MVDOBERVY7OFSo5FGzrJJlFXN3QtrwVpPrQuheoGPrgJ2n
         8oMOx3z/d/tA/M2cwPP+6RbIDju8wuuUXjaMPRxO5hH4D4sKETHImRROElbe//aaOtpO
         OogLtnIuwKN+DcCAPGyJlFax0yhmAoZ+rpZadMYHcKoPtZu+IxTNJ5IzBobLLH7anQe5
         BJyo82k0NfaW8Na1TZ9yPTtPgjrfAAq8oZFwBN6K9DQIZ2j1A5DMsvm5naVtimv1XKxj
         9K4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bq3CtL8r5GfIJRMEMuTZRaNrH6+E6V3L1A1y/G7x4zc=;
        b=bqexJlEUkbMWimpHeZpFdEQnfE7f+DzOcxWZFH/6TiAl/uB56hwow7OgxglEvLWDtf
         5di7QBVN9hdVGYWfPvFWfqT1AVNQa+Z51xX/HHQeZjgV8Kc2zf8L4Mx7md4dBFvMbg7G
         x4pvnfGaYE+9o0Blj5K/V2XHFTHoZQyO1U55DyIEXFIm3G7bMWIYiPRKUn7kcwSKQN4u
         8/J5OG+jHEX6DyisXdG4Ohw5/v7VjdO+OTBhDMxlL2m10TdYTN+PJlmy7hGMBU19IOLR
         MBAZdb1tAfESb+Ov0ZAZK/8EjZPIp96gPkbFObui8lW/sQt7a+ZtcM3CXr30UyhLKBnB
         JQrA==
X-Gm-Message-State: AOAM533HFOvxIkrthjvoGOm5U4frTGwoUEV/tt6YX9gh7RUzRK50QjLi
        33zMyc4BajkyGdOZuWZJ3FhGYg==
X-Google-Smtp-Source: ABdhPJw2TQiN59DdW/xnGa/aGBjV90W4P/iGe+cof3kKAjRB7iSLHq2N5nUHqvDvem8J6DBDZYGOGg==
X-Received: by 2002:a17:903:3296:b0:164:13db:509 with SMTP id jh22-20020a170903329600b0016413db0509mr30245225plb.128.1654627665924;
        Tue, 07 Jun 2022 11:47:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k130-20020a628488000000b0051c03229a2bsm6037107pfd.21.2022.06.07.11.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 11:47:45 -0700 (PDT)
Date:   Tue, 7 Jun 2022 18:47:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Leonardo Bras <leobras@redhat.com>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        chang.seok.bae@intel.com, luto@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 07/28] x86/kvm/fpu: Limit guest
 user_xfeatures to supported bits of XCR0
Message-ID: <Yp+dTU4NOaIELJh8@google.com>
References: <20220301201344.18191-1-sashal@kernel.org>
 <20220301201344.18191-7-sashal@kernel.org>
 <5f2b7b93-d4c9-1d59-14df-6e8b2366ca8a@redhat.com>
 <YppVupW+IWsm7Osr@xz-m1.local>
 <2d9ba70b-ac18-a461-7a57-22df2c0165c6@redhat.com>
 <Yp5xSi6P3q187+A+@xz-m1.local>
 <9d336622-6964-454a-605f-1ca90b902836@redhat.com>
 <Yp9o+y0NcRW/0puA@google.com>
 <Yp+WUoA+6x7ZpsaM@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp+WUoA+6x7ZpsaM@xz-m1.local>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022, Peter Xu wrote:
> On Tue, Jun 07, 2022 at 03:04:27PM +0000, Sean Christopherson wrote:
> > On Tue, Jun 07, 2022, Paolo Bonzini wrote:
> > > On 6/6/22 23:27, Peter Xu wrote:
> > > > On Mon, Jun 06, 2022 at 06:18:12PM +0200, Paolo Bonzini wrote:
> > > > > > However there seems to be something missing at least to me, on why it'll
> > > > > > fail a migration from 5.15 (without this patch) to 5.18 (with this patch).
> > > > > > In my test case, user_xfeatures will be 0x7 (FP|SSE|YMM) if without this
> > > > > > patch, but 0x0 if with it.
> > > > > 
> > > > > What CPU model are you using for the VM?
> > > > 
> > > > I didn't specify it, assuming it's qemu64 with no extra parameters.
> > > 
> > > Ok, so indeed it lacks AVX and this patch can have an effect.
> > > 
> > > > > For example, if the source lacks this patch but the destination has it,
> > > > > the source will transmit YMM registers, but the destination will fail to
> > > > > set them if they are not available for the selected CPU model.
> > > > > 
> > > > > See the commit message: "As a bonus, it will also fail if userspace tries to
> > > > > set fpu features (with the KVM_SET_XSAVE ioctl) that are not compatible to
> > > > > the guest configuration.  Such features will never be returned by
> > > > > KVM_GET_XSAVE or KVM_GET_XSAVE2."
> > > > 
> > > > IIUC you meant we should have failed KVM_SET_XSAVE when they're not aligned
> > > > (probably by failing validate_user_xstate_header when checking against the
> > > > user_xfeatures on dest host). But that's probably not my case, because here
> > > > KVM_SET_XSAVE succeeded, it's just that the guest gets a double fault after
> > > > the precopy migration completes (or for postcopy when the switchover is
> > > > done).
> > > 
> > > Difficult to say what's happening without seeing at least the guest code
> > > around the double fault (above you said "fail a migration" and I thought
> > > that was a different scenario than the double fault), and possibly which was
> > > the first exception that contributed to the double fault.
> > 
> > Regardless of why the guest explodes in the way it does, is someone planning on
> > bisecting this (if necessary?) and sending a backport to v5.15?  There's another
> > bug report that is more than likely hitting the same bug.
> 
> What's the bisection you mentioned?  I actually did a bisection and I also
> checked reverting Leo's change can also fix this issue.  Or do you mean
> something else?

Oooooh, sorry!  I got completely turned around.  You ran into a bug with the
fix.  I thought that you were hitting the same issues as Mike where migrating
between hosts with different capabilities is broken in v5.15, but works in v5.18.

> > https://lore.kernel.org/all/48353e0d-e771-8a97-21d4-c65ff3bc4192@sentex.net
> 
> That is kvm64, and I agree it could be the same problem since both qemu64
> and kvm64 models do not have any xsave feature bit declared in cpuid 0xd,
> so potentially we could be migrating some fpu states to it even with
> user_xfeatures==0 on dest host.
> 
> So today I continued the investigation, and I think what's really missing
> is qemu seems to be ignoring the user_xfeatures check for KVM_SET_XSAVE and
> continues even if it returns -EINVAL.  IOW, I'm wondering whether we should
> fail properly and start to check kvm_arch_put_registers() retcode.  But
> that'll be a QEMU fix, and it'll at least not causing random faults
> (e.g. double faults) in guest but we should fail the migration gracefully.
> 
> Sean: a side note is that I can also easily trigger one WARN_ON_ONCE() in
> your commit 98c25ead5eda5 in kvm_arch_vcpu_ioctl_run():
> 
> 	WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
> 
> It'll be great if you'd like to check that up.

Ugh, userspace can force KVM_MP_STATE_UNINITIALIZED via KVM_SET_MP_STATE.  Looks
like QEMU does that when emulating RESET.

Logically, a full RESET of the xAPIC seems like the right thing to do.  I think
we can get away with that without breaking ABI?  And kvm_lapic_reset() has a
related bug where it stops the HR timer but not doesn't handle the HV timer :-/

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e69b83708f05..948aba894245 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2395,7 +2395,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
                return;

        /* Stop the timer in case it's a reset to an active apic */
-       hrtimer_cancel(&apic->lapic_timer.timer);
+       cancel_apic_timer(&apic->lapic_timer.timer);

        /* The xAPIC ID is set at RESET even if the APIC was already enabled. */
        if (!init_event)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 540651cd28d7..ed2c7cb1642d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10912,6 +10912,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
             mp_state->mp_state == KVM_MP_STATE_INIT_RECEIVED))
                goto out;

+       if (mp_state->mp_state == KVM_MP_STATE_UNINITIALIZED)
+               kvm_lapic_reset(vcpu, false);
+
        if (mp_state->mp_state == KVM_MP_STATE_SIPI_RECEIVED) {
                vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
                set_bit(KVM_APIC_SIPI, &vcpu->arch.apic->pending_events);

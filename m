Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFD0275A86
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 16:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgIWOoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 10:44:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27728 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgIWOoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 10:44:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600872247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hZV6Rl3pzuWTu8K0XZSsjhnbMs5n7lELZyAMnMKE1AU=;
        b=BixxUhAElWRvB/KMOdQDdHJRZ74czRP3E9a7hLXTMCsQZ1aC6sqSB+qaAIGU01OUXFje/Y
        1OrvOE6QDTyrUWjxN92g9s7dGcO+stQaMJzuai2eps5Xwu6EMjWSKo736X+n/R/xIXbhfg
        21QPZ21fceFu1ZDSzBoGboCBc4oC5eM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-dmtImddANG6SxfnGNWMhyg-1; Wed, 23 Sep 2020 10:44:04 -0400
X-MC-Unique: dmtImddANG6SxfnGNWMhyg-1
Received: by mail-wm1-f70.google.com with SMTP id s24so12419wmh.1
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 07:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hZV6Rl3pzuWTu8K0XZSsjhnbMs5n7lELZyAMnMKE1AU=;
        b=pqiCcmkkNoHxSa0JhrKHh3s9dFoJ0LK5gSpBR08PVjlRFJ26dFxXma86cvPfBdGvYO
         zW9PujVJ+buUsumRzplmwwShbrN7oR/CvE439kSiZupO6D23Q/7MHq55+AneWefiP2nJ
         jYlXQaaYUJkOKZV5z/aa9Lc3R5jf2h5W65bWfxOzidmhtZYLNI0KtQu58+nUCHqHzPhx
         sIDEbPeqm1L2O+Rm9j0w48jxTLbXfxfBFDm+PU60dz1qpCW+j7Q9iFhMqrBKqd0amThe
         r97xAY6vrdHpo6EnXnX7iH9cgjvnN1ab/FXFsU5vv/XQVJ48V6FK7OKG5v/+vsqiPhxD
         hByA==
X-Gm-Message-State: AOAM5319kUbMUXtQYnOXo1Iv2Ag2W/Wb57hc3xwmN0YzX01g2mlQFYNh
        2GAoad512Z7qELIGmJJ/DMaeyOBDjLyOBAqty2teH7eykLO2Ogmh1HBD7TrcQ789071K+akZPWR
        NbIA7WmpS7EMR/f/0
X-Received: by 2002:a7b:c8cc:: with SMTP id f12mr6616006wml.169.1600872243336;
        Wed, 23 Sep 2020 07:44:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPAQellEZUZF72VIdYMcsW/EzzotsPHDCJiCtkHgYTe6yTNEWmo8eqUjiIAtQnD8uYlNyQTw==
X-Received: by 2002:a7b:c8cc:: with SMTP id f12mr6615982wml.169.1600872243078;
        Wed, 23 Sep 2020 07:44:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id a10sm3540wmj.38.2020.09.23.07.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 07:44:02 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Morph notification vector IRQ on nested
 VM-Enter to pending PI
To:     Sasha Levin <sashal@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     stable@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
References: <20200812175129.12172-1-sean.j.christopherson@intel.com>
 <20200826135402.AC1B3221E2@mail.kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <454c167d-687a-d4cb-3170-b32886904739@redhat.com>
Date:   Wed, 23 Sep 2020 16:44:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826135402.AC1B3221E2@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Queued, thanks.

I cannot think of a "nicer" way to do this, we could perhaps move

+		vmx->nested.pi_pending = true;
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+		kvm_apic_clear_irr(vcpu, vmx->nested.posted_intr_nv);

to a separate function (possibly with the IRR clear made conditional, so
that we can reuse the function for regular posted interrupt injection)
but that is it.

Paolo

On 26/08/20 15:54, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: 705699a13994 ("KVM: nVMX: Enable nested posted interrupt processing").
> 
> The bot has tested the following trees: v5.8.2, v5.7.16, v5.4.59, v4.19.140, v4.14.193, v4.9.232, v4.4.232.
> 
> v5.8.2: Build OK!
> v5.7.16: Build OK!
> v5.4.59: Failed to apply! Possible dependencies:
>     59508b303e4e ("KVM: X86: Move irrelevant declarations out of ioapic.h")
>     5c69d5c113f1 ("KVM: X86: Fix callers of kvm_apic_match_dest() to use correct macros")
> 
> v4.19.140: Failed to apply! Possible dependencies:
>     0b0a31badb2d ("KVM: x86: hyperv: valid_bank_mask should be 'u64'")
>     214ff83d4473 ("KVM: x86: hyperv: implement PV IPI send hypercalls")
>     2cefc5feb80c ("KVM: x86: hyperv: optimize kvm_hv_flush_tlb() for vp_index == vcpu_idx case")
>     360cae313702 ("KVM: PPC: Book3S HV: Nested guest entry via hypercall")
>     59508b303e4e ("KVM: X86: Move irrelevant declarations out of ioapic.h")
>     5c69d5c113f1 ("KVM: X86: Fix callers of kvm_apic_match_dest() to use correct macros")
>     89329c0be8bd ("KVM: PPC: Book3S HV: Clear partition table entry on vm teardown")
>     8e3f5fc1045d ("KVM: PPC: Book3S HV: Framework and hcall stubs for nested virtualization")
>     a812297c4fd9 ("KVM: x86: hyperv: optimize 'all cpus' case in kvm_hv_flush_tlb()")
>     aa069a996951 ("KVM: PPC: Book3S HV: Add a VM capability to enable nested virtualization")
>     e6b6c483ebe9 ("KVM: x86: hyperv: fix 'tlb_lush' typo")
>     f21dd494506a ("KVM: x86: hyperv: optimize sparse VP set processing")
> 
> v4.14.193: Failed to apply! Possible dependencies:
>     0234bf885236 ("KVM: x86: introduce ISA specific SMM entry/exit callbacks")
>     05cade71cf3b ("KVM: nSVM: fix SMI injection in guest mode")
>     44883f01fe6a ("KVM: x86: ensure all MSRs can always be KVM_GET/SET_MSR'd")
>     59508b303e4e ("KVM: X86: Move irrelevant declarations out of ioapic.h")
>     5acc5c063196 ("KVM: Introduce KVM_MEMORY_ENCRYPT_OP ioctl")
>     5c69d5c113f1 ("KVM: X86: Fix callers of kvm_apic_match_dest() to use correct macros")
>     69eaedee411c ("KVM: Introduce KVM_MEMORY_ENCRYPT_{UN,}REG_REGION ioctl")
>     72d7b374b14d ("KVM: x86: introduce ISA specific smi_allowed callback")
>     a2e164e7f45a ("x86/kvm/hyper-v: add reenlightenment MSRs support")
>     cc3d967f7e32 ("KVM: SVM: detect opening of SMI window using STGI intercept")
>     f21dd494506a ("KVM: x86: hyperv: optimize sparse VP set processing")
>     faeb7833eee0 ("kvm: x86: hyperv: guest->host event signaling via eventfd")
> 
> v4.9.232: Failed to apply! Possible dependencies:
>     004172bdad64 ("sched/core: Remove unnecessary #include headers")
>     174cd4b1e5fb ("sched/headers: Prepare to move signal wakeup & sigpending methods from <linux/sched.h> into <linux/sched/signal.h>")
>     3aa53859d23e ("KVM: Documentation: document MCE ioctls")
>     3ca0ff571b09 ("locking/mutex: Rework mutex::owner")
>     4036e3874a1c ("KVM: s390: ioctls to get and set guest storage attributes")
>     44883f01fe6a ("KVM: x86: ensure all MSRs can always be KVM_GET/SET_MSR'd")
>     59508b303e4e ("KVM: X86: Move irrelevant declarations out of ioapic.h")
>     5acc5c063196 ("KVM: Introduce KVM_MEMORY_ENCRYPT_OP ioctl")
>     5c69d5c113f1 ("KVM: X86: Fix callers of kvm_apic_match_dest() to use correct macros")
>     69eaedee411c ("KVM: Introduce KVM_MEMORY_ENCRYPT_{UN,}REG_REGION ioctl")
>     a2e164e7f45a ("x86/kvm/hyper-v: add reenlightenment MSRs support")
>     ae7e81c077d6 ("sched/headers: Prepare for new header dependencies before moving code to <uapi/linux/sched/types.h>")
>     b3c045d33218 ("KVM: lapic: remove unnecessary KVM_REQ_EVENT on PPR update")
>     c92701322711 ("KVM: PPC: Book3S HV: Add userspace interfaces for POWER9 MMU")
>     ea8b1c4a6019 ("drivers: psci: PSCI checker module")
>     eb90f3417a0c ("KVM: vmx: speed up TPR below threshold vmexits")
>     ef1ead0c3b1d ("KVM: PPC: Book3S HV: HPT resizing documentation and reserved numbers")
>     f21dd494506a ("KVM: x86: hyperv: optimize sparse VP set processing")
>     faeb7833eee0 ("kvm: x86: hyperv: guest->host event signaling via eventfd")
> 
> v4.4.232: Failed to apply! Possible dependencies:
>     1e6e2755b635 ("KVM: x86: Misc LAPIC changes to expose helper functions")
>     520040146a0a ("KVM: x86: Use vector-hashing to deliver lowest-priority interrupts")
>     5c919412fe61 ("kvm/x86: Hyper-V synthetic interrupt controller")
>     6308630bd3db ("kvm/x86: split ioapic-handled and EOI exit bitmaps")
>     b3c045d33218 ("KVM: lapic: remove unnecessary KVM_REQ_EVENT on PPR update")
>     d62caabb41f3 ("kvm/x86: per-vcpu apicv deactivation support")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 


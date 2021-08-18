Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0373F0B67
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 21:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbhHRTGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 15:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhHRTGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 15:06:18 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B25C0613CF
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 12:05:43 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id e9so2440369vst.6
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 12:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9CV1B2mH8PK4XbUS0fPPBFZHJZg1PKiQmC6aaYtPD7k=;
        b=jlC/SdCD3at4dNG9kwSjwhqtOpbuTijAXLqLPHWLUEMhf2AvMCdfIZ+/0CUUgvBS5m
         70xiWmtQq58RG8dRBT2p4w4Dq0K135uW+5foCGQy4cdg4AlrF3vmPu87Lk/RQWuHEv0F
         zkeHKX6vol4QAexO0QKEnFFJDdHZobyH7A5Rq2f3aVQeg4nGwFhrxHpFZeJrg8jZENCW
         6Rzr+wt2lDFbrnjJpEVbMzf+tjTI+hzyZKypDgwf7ywF+n7Zb7U6HIOthtbc90P2NcAe
         9pAQRlZVFq6PeW0GAghT+3Mdgl9E3HCcDHERiMWFCc+/KeTiOmM+OjcCLqo9lruPQaYz
         CdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9CV1B2mH8PK4XbUS0fPPBFZHJZg1PKiQmC6aaYtPD7k=;
        b=RtHqRa/E2/CfXRj67ifuZp3Q4U96ZMsb8QJ67GPkMJ587DNitAq8qw5j1nPyxK0QlX
         5oo5nIrNLHw05zkRX4pgVkZtAwZPoPYmowgnRSNrpEgI00ZMuuZywMEEc0xC/axB2m3E
         IWppBy3SYoes+LOcEShGbv/d9/vMYnyzR01cPXt2NlE8BQbIj3bUp+7AQg/AGsEhceEn
         jhhA5GAuR8t1ef9vnzQY2XqJh+qyCtPN08smY7v4J0A799iIseX2ZVq9KuvdXZL+mhBY
         XgHjZK3lFamPDusHVVamvNY+WPVtIVnUxX6k51r9wxTQCXGOWHQDXMA5Vxw9sbxIYm8w
         FY8g==
X-Gm-Message-State: AOAM532MVVGfaZ0ZoPIKDCJo+aRZ3o40LKi5oOgq3t+qwAOuzZYb4cQo
        vzMT2yJx/XItcWrxtDp6/IOvqtZkvDRJ0FIRb9uhzg==
X-Google-Smtp-Source: ABdhPJzxU71p18xMzChBvv1uRBdKk5rlC4hzgstASnkvOKd+KGr7ohhYYBMh0iPqs21uTd7beQSd7ILYgInPHYYKiRo=
X-Received: by 2002:a67:2e43:: with SMTP id u64mr9474774vsu.30.1629313542587;
 Wed, 18 Aug 2021 12:05:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210818181432.432256-1-maz@kernel.org>
In-Reply-To: <20210818181432.432256-1-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 18 Aug 2021 12:05:32 -0700
Message-ID: <CAJHc60zUZS3K4q88QYwP2CkGn7ywt-_fedjk7OK_W7cdQRJvxA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic: Resample HW pending state on deactivation
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ricardo Koller <ricarkol@google.com>, kernel-team@android.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 18, 2021 at 11:14 AM Marc Zyngier <maz@kernel.org> wrote:
>
> When a mapped level interrupt (a timer, for example) is deactivated
> by the guest, the corresponding host interrupt is equally deactivated.
> However, the fate of the pending state still needs to be dealt
> with in SW.
>
> This is specially true when the interrupt was in the active+pending
> state in the virtual distributor at the point where the guest
> was entered. On exit, the pending state is potentially stale
> (the guest may have put the interrupt in a non-pending state).
>
> If we don't do anything, the interrupt will be spuriously injected
> in the guest. Although this shouldn't have any ill effect (spurious
> interrupts are always possible), we can improve the emulation by
> detecting the deactivation-while-pending case and resample the
> interrupt.
>
> Fixes: e40cc57bac79 ("KVM: arm/arm64: vgic: Support level-triggered mapped interrupts")
> Reported-by: Raghavendra Rao Ananta <rananta@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kvm/vgic/vgic-v2.c | 25 ++++++++++++++++++-------
>  arch/arm64/kvm/vgic/vgic-v3.c | 25 ++++++++++++++++++-------
>  2 files changed, 36 insertions(+), 14 deletions(-)
>
Tested-by: Raghavendra Rao Ananta <rananta@google.com>

Thanks,
Raghavendra
> diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
> index 2c580204f1dc..3e52ea86a87f 100644
> --- a/arch/arm64/kvm/vgic/vgic-v2.c
> +++ b/arch/arm64/kvm/vgic/vgic-v2.c
> @@ -60,6 +60,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>                 u32 val = cpuif->vgic_lr[lr];
>                 u32 cpuid, intid = val & GICH_LR_VIRTUALID;
>                 struct vgic_irq *irq;
> +               bool deactivated;
>
>                 /* Extract the source vCPU id from the LR */
>                 cpuid = val & GICH_LR_PHYSID_CPUID;
> @@ -75,7 +76,8 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>
>                 raw_spin_lock(&irq->irq_lock);
>
> -               /* Always preserve the active bit */
> +               /* Always preserve the active bit, note deactivation */
> +               deactivated = irq->active && !(val & GICH_LR_ACTIVE_BIT);
>                 irq->active = !!(val & GICH_LR_ACTIVE_BIT);
>
>                 if (irq->active && vgic_irq_is_sgi(intid))
> @@ -105,6 +107,12 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>                  * device state could have changed or we simply need to
>                  * process the still pending interrupt later.
>                  *
> +                * We could also have entered the guest with the interrupt
> +                * active+pending. On the next exit, we need to re-evaluate
> +                * the pending state, as it could otherwise result in a
> +                * spurious interrupt by injecting a now potentially stale
> +                * pending state.
> +                *
>                  * If this causes us to lower the level, we have to also clear
>                  * the physical active state, since we will otherwise never be
>                  * told when the interrupt becomes asserted again.
> @@ -115,12 +123,15 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>                 if (vgic_irq_is_mapped_level(irq)) {
>                         bool resample = false;
>
> -                       if (val & GICH_LR_PENDING_BIT) {
> -                               irq->line_level = vgic_get_phys_line_level(irq);
> -                               resample = !irq->line_level;
> -                       } else if (vgic_irq_needs_resampling(irq) &&
> -                                  !(irq->active || irq->pending_latch)) {
> -                               resample = true;
> +                       if (unlikely(vgic_irq_needs_resampling(irq))) {
> +                               if (!(irq->active || irq->pending_latch))
> +                                       resample = true;
> +                       } else {
> +                               if ((val & GICH_LR_PENDING_BIT) ||
> +                                   (deactivated && irq->line_level)) {
> +                                       irq->line_level = vgic_get_phys_line_level(irq);
> +                                       resample = !irq->line_level;
> +                               }
>                         }
>
>                         if (resample)
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 66004f61cd83..74f9aefffd5e 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -46,6 +46,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>                 u32 intid, cpuid;
>                 struct vgic_irq *irq;
>                 bool is_v2_sgi = false;
> +               bool deactivated;
>
>                 cpuid = val & GICH_LR_PHYSID_CPUID;
>                 cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
> @@ -68,7 +69,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>
>                 raw_spin_lock(&irq->irq_lock);
>
> -               /* Always preserve the active bit */
> +               /* Always preserve the active bit, note deactivation */
> +               deactivated = irq->active && !(val & ICH_LR_ACTIVE_BIT);
>                 irq->active = !!(val & ICH_LR_ACTIVE_BIT);
>
>                 if (irq->active && is_v2_sgi)
> @@ -98,6 +100,12 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>                  * device state could have changed or we simply need to
>                  * process the still pending interrupt later.
>                  *
> +                * We could also have entered the guest with the interrupt
> +                * active+pending. On the next exit, we need to re-evaluate
> +                * the pending state, as it could otherwise result in a
> +                * spurious interrupt by injecting a now potentially stale
> +                * pending state.
> +                *
>                  * If this causes us to lower the level, we have to also clear
>                  * the physical active state, since we will otherwise never be
>                  * told when the interrupt becomes asserted again.
> @@ -108,12 +116,15 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>                 if (vgic_irq_is_mapped_level(irq)) {
>                         bool resample = false;
>
> -                       if (val & ICH_LR_PENDING_BIT) {
> -                               irq->line_level = vgic_get_phys_line_level(irq);
> -                               resample = !irq->line_level;
> -                       } else if (vgic_irq_needs_resampling(irq) &&
> -                                  !(irq->active || irq->pending_latch)) {
> -                               resample = true;
> +                       if (unlikely(vgic_irq_needs_resampling(irq))) {
> +                               if (!(irq->active || irq->pending_latch))
> +                                       resample = true;
> +                       } else {
> +                               if ((val & ICH_LR_PENDING_BIT) ||
> +                                   (deactivated && irq->line_level)) {
> +                                       irq->line_level = vgic_get_phys_line_level(irq);
> +                                       resample = !irq->line_level;
> +                               }
>                         }
>
>                         if (resample)
> --
> 2.30.2
>

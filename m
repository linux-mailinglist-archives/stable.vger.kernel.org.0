Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFFA3F0BF7
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 21:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhHRTlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 15:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233872AbhHRTlc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 15:41:32 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E4EC06179A
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 12:40:55 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id n7so7229701ljq.0
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 12:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q6+vD/Bnma2e6Trh4huFu+B0sfIPuUgIZs2tPcEJfAQ=;
        b=XGiRKLPl7vDuYMdoVHAsKGg6g8vXwsJKQQsPQA/8l0WpCgIHD37c3LYRBILsJ2GpUI
         PB7Cb7JFzNoxxp9hpkASPLK2x/S1mmzP3ZjERSrp58zQB07HkoZnuRto6cic3AqJQbhX
         y76kKBAzc5zfwEX82leZwMJFQBcah9ojQfTkDrvREPlqVcHx1M5CQeIbkP+WUgluwlMJ
         Xi16fBTHKjqF/aM4FAB9iF169JMMPpXJAjmqVTCnk59z/MImHG5Irj0bCilupZj7MD6u
         AtQI1PEc9tUu0eC/LY2u5mSVguS7lnR7k4Hgoy63K7H8P/c9HEjqNP/7iWRaLXxori6Y
         iI2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q6+vD/Bnma2e6Trh4huFu+B0sfIPuUgIZs2tPcEJfAQ=;
        b=YvT1ojw/xWIXJrtWhmSWlHmrgwMUzPof4Sn75DZQCeFA+Ouc/fOLGN/BW3Xni+51gF
         SaVijgEn2XAUPycZbwxYzKNpZym24DY2EtMhL+AkJN0Dsvyupgux9YHEQE97vZMq5IeW
         rnAAkcBTXZzAcA702UHttV1NsED+EMrwLt6d9HCG3DwSPY7Ykh0Q3cv/0cRakIfafyFc
         17RgD/NuiMjwc0b3lfkAQcbRz+frPS+BwMGyoMw1hh0Ezh/Vg+MHhBTurZRKU9tgRo3S
         2Ecn1SWefdvxbQ5+9QlkGIphaHZaI1mU9U68YYOac+vEeuOGAk+Y+WhHDEkutmjgDrXf
         +xAQ==
X-Gm-Message-State: AOAM532FoF9a/g5U7mEgxQrJTfx8vMWoidUkvtizdEdmqDApBI3bjPMO
        iVVoHMdPAoQ2QeHUFVyahrQSX/UcFQExMaaz2uj6NA==
X-Google-Smtp-Source: ABdhPJxrD+XuX8eAfWllsW3ODtUZyuvIfj8TmpggSk0RGyDarRBBtgoCJliqN4IAvuYDkQ8VMB6LtXgrrXPj5bJhnbE=
X-Received: by 2002:a2e:a782:: with SMTP id c2mr9239281ljf.388.1629315653719;
 Wed, 18 Aug 2021 12:40:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210818181432.432256-1-maz@kernel.org> <CAJHc60zUZS3K4q88QYwP2CkGn7ywt-_fedjk7OK_W7cdQRJvxA@mail.gmail.com>
In-Reply-To: <CAJHc60zUZS3K4q88QYwP2CkGn7ywt-_fedjk7OK_W7cdQRJvxA@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 18 Aug 2021 12:40:42 -0700
Message-ID: <CAOQ_QsgGiGSfEq1QGfePiRF-=spCuR6XZ2QXfUsZ1zWds0ftag@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic: Resample HW pending state on deactivation
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Ricardo Koller <ricarkol@google.com>, kernel-team@android.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Marc,

On Wed, Aug 18, 2021 at 12:05 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> On Wed, Aug 18, 2021 at 11:14 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > When a mapped level interrupt (a timer, for example) is deactivated
> > by the guest, the corresponding host interrupt is equally deactivated.
> > However, the fate of the pending state still needs to be dealt
> > with in SW.
> >
> > This is specially true when the interrupt was in the active+pending
> > state in the virtual distributor at the point where the guest
> > was entered. On exit, the pending state is potentially stale
> > (the guest may have put the interrupt in a non-pending state).
> >
> > If we don't do anything, the interrupt will be spuriously injected
> > in the guest. Although this shouldn't have any ill effect (spurious
> > interrupts are always possible), we can improve the emulation by
> > detecting the deactivation-while-pending case and resample the
> > interrupt.
> >
> > Fixes: e40cc57bac79 ("KVM: arm/arm64: vgic: Support level-triggered mapped interrupts")
> > Reported-by: Raghavendra Rao Ananta <rananta@google.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Cc: stable@vger.kernel.org
> > ---
> >  arch/arm64/kvm/vgic/vgic-v2.c | 25 ++++++++++++++++++-------
> >  arch/arm64/kvm/vgic/vgic-v3.c | 25 ++++++++++++++++++-------
> >  2 files changed, 36 insertions(+), 14 deletions(-)
> >
> Tested-by: Raghavendra Rao Ananta <rananta@google.com>
>
> Thanks,
> Raghavendra
> > diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
> > index 2c580204f1dc..3e52ea86a87f 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v2.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v2.c
> > @@ -60,6 +60,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
> >                 u32 val = cpuif->vgic_lr[lr];
> >                 u32 cpuid, intid = val & GICH_LR_VIRTUALID;
> >                 struct vgic_irq *irq;
> > +               bool deactivated;
> >
> >                 /* Extract the source vCPU id from the LR */
> >                 cpuid = val & GICH_LR_PHYSID_CPUID;
> > @@ -75,7 +76,8 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
> >
> >                 raw_spin_lock(&irq->irq_lock);
> >
> > -               /* Always preserve the active bit */
> > +               /* Always preserve the active bit, note deactivation */
> > +               deactivated = irq->active && !(val & GICH_LR_ACTIVE_BIT);
> >                 irq->active = !!(val & GICH_LR_ACTIVE_BIT);
> >
> >                 if (irq->active && vgic_irq_is_sgi(intid))
> > @@ -105,6 +107,12 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
> >                  * device state could have changed or we simply need to
> >                  * process the still pending interrupt later.
> >                  *
> > +                * We could also have entered the guest with the interrupt
> > +                * active+pending. On the next exit, we need to re-evaluate
> > +                * the pending state, as it could otherwise result in a
> > +                * spurious interrupt by injecting a now potentially stale
> > +                * pending state.
> > +                *
> >                  * If this causes us to lower the level, we have to also clear
> >                  * the physical active state, since we will otherwise never be
> >                  * told when the interrupt becomes asserted again.
> > @@ -115,12 +123,15 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
> >                 if (vgic_irq_is_mapped_level(irq)) {
> >                         bool resample = false;
> >
> > -                       if (val & GICH_LR_PENDING_BIT) {
> > -                               irq->line_level = vgic_get_phys_line_level(irq);
> > -                               resample = !irq->line_level;
> > -                       } else if (vgic_irq_needs_resampling(irq) &&
> > -                                  !(irq->active || irq->pending_latch)) {
> > -                               resample = true;
> > +                       if (unlikely(vgic_irq_needs_resampling(irq))) {
> > +                               if (!(irq->active || irq->pending_latch))
> > +                                       resample = true;
> > +                       } else {
> > +                               if ((val & GICH_LR_PENDING_BIT) ||
> > +                                   (deactivated && irq->line_level)) {
> > +                                       irq->line_level = vgic_get_phys_line_level(irq);
> > +                                       resample = !irq->line_level;
> > +                               }
> >                         }
> >
> >                         if (resample)
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > index 66004f61cd83..74f9aefffd5e 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > @@ -46,6 +46,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> >                 u32 intid, cpuid;
> >                 struct vgic_irq *irq;
> >                 bool is_v2_sgi = false;
> > +               bool deactivated;
> >
> >                 cpuid = val & GICH_LR_PHYSID_CPUID;
> >                 cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
> > @@ -68,7 +69,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> >
> >                 raw_spin_lock(&irq->irq_lock);
> >
> > -               /* Always preserve the active bit */
> > +               /* Always preserve the active bit, note deactivation */
> > +               deactivated = irq->active && !(val & ICH_LR_ACTIVE_BIT);
> >                 irq->active = !!(val & ICH_LR_ACTIVE_BIT);
> >
> >                 if (irq->active && is_v2_sgi)
> > @@ -98,6 +100,12 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> >                  * device state could have changed or we simply need to
> >                  * process the still pending interrupt later.
> >                  *
> > +                * We could also have entered the guest with the interrupt
> > +                * active+pending. On the next exit, we need to re-evaluate
> > +                * the pending state, as it could otherwise result in a
> > +                * spurious interrupt by injecting a now potentially stale
> > +                * pending state.
> > +                *
> >                  * If this causes us to lower the level, we have to also clear
> >                  * the physical active state, since we will otherwise never be
> >                  * told when the interrupt becomes asserted again.
> > @@ -108,12 +116,15 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> >                 if (vgic_irq_is_mapped_level(irq)) {
> >                         bool resample = false;
> >
> > -                       if (val & ICH_LR_PENDING_BIT) {
> > -                               irq->line_level = vgic_get_phys_line_level(irq);
> > -                               resample = !irq->line_level;
> > -                       } else if (vgic_irq_needs_resampling(irq) &&
> > -                                  !(irq->active || irq->pending_latch)) {
> > -                               resample = true;
> > +                       if (unlikely(vgic_irq_needs_resampling(irq))) {
> > +                               if (!(irq->active || irq->pending_latch))
> > +                                       resample = true;
> > +                       } else {
> > +                               if ((val & ICH_LR_PENDING_BIT) ||
> > +                                   (deactivated && irq->line_level)) {
> > +                                       irq->line_level = vgic_get_phys_line_level(irq);
> > +                                       resample = !irq->line_level;
> > +                               }

The vGICv3 and vGICv2 implementations look identical here, should we
have a helper that keeps the code common between the two?

Otherwise, the functional change LGTM, so:

Reviewed-by: Oliver Upton <oupton@google.com>

> >                         }
> >
> >                         if (resample)
> > --
> > 2.30.2
> >

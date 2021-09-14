Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C6F40BBB8
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 00:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbhINWlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 18:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbhINWlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 18:41:10 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06787C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 15:39:52 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id bq5so1726833lfb.9
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 15:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+ZE2BawIU65HDTYQakuJiXPZQ2/PmXQG0jqaaUOAG3k=;
        b=km4VCJqBJmlVrj14YwftblNq9T/nY2fuwDrkz+OhI7AfiWKEFvprziUIS0ZOjuM/r1
         8rxYGKwS/d6aXpYDdHFdy4d2N3J7jWuPzxGWgiIZai5+lCRRzoN9k+WXSwwv5IJEurpY
         119iNHScaih4bf0g9YH2D305Pa803HfX3UsoNjpavJrU5E2ULDGpaGPWaCROWaBtdvK3
         pNm3MwpfjUw+kjMWPsGvANFpvvA8Z4CFutIWC15ANrQGgr30wpbFLRFdTfYpOtiPbiWG
         nztIWzEbKol4gpNCt10dWnsPsC2BiAptgVpJ2TtstWNXd4eaa9gIEzxrUsqZQcqAsexj
         q0pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+ZE2BawIU65HDTYQakuJiXPZQ2/PmXQG0jqaaUOAG3k=;
        b=xLj459AoK0zyYyMJEnArv2N3Gi8bUY94Iom+axMEC0OvvOVS0kP7249qehIq86s3SR
         BYPqPiTu5/XPXYGkWU4HdhPIpsbCRcbjveOeuGUcwlB4VgW3CmYmMCx+UBq5FSD90pQp
         KOsJbIgywK3jwWz/Ttd1vfPSBsxUiMEUCIdlcTmJEv0E5Lfua4DMUauJnsbUB/1zhk9m
         2cBFC7qeC3MhObwCouzbTcHpQi5I8JCYW4B2y6iefHq67Z518MFCfUoJWQBGpuVCHfMc
         Rtf4ya0HYeQXGUqWwCKLR3slJEMHqYE+4a57DSkBGXW0Y5ep/KPtWSyS/aHmGeUYezuZ
         ir3w==
X-Gm-Message-State: AOAM533hl680MOZhReJDT+u00utFjb3tTxYua/t1NADO0MPm8tEHZdIk
        J6nhfjDaO2V1vqaegr1hUoWqSGmNZCabLBwTWCFJnw==
X-Google-Smtp-Source: ABdhPJxDxDrtWmPmN+FLHlNZw8mZA3aFHQX5XQpuMJbH10sfPsxgt8RqC6wuCf4rlESxpvmaBV314+yphKvuMEeSM2E=
X-Received: by 2002:ac2:483b:: with SMTP id 27mr8966677lft.644.1631659190112;
 Tue, 14 Sep 2021 15:39:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210914200639.3305617-1-pgonda@google.com> <YUEVQDEvLbdJF+sj@google.com>
In-Reply-To: <YUEVQDEvLbdJF+sj@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 14 Sep 2021 16:39:38 -0600
Message-ID: <CAMkAt6rSsKuzE__pAodiJR9wFU-B3942+kdkQG-3M+jxhVco2w@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Acquire vcpu mutex when updating VMSA
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 3:34 PM Sean Christopherson <seanjc@google.com> wro=
te:
>
> On Tue, Sep 14, 2021, Peter Gonda wrote:
> > Adds mutex guard to the VMSA updating code. Also adds a check to skip a
> > vCPU if it has already been LAUNCH_UPDATE_VMSA'd which should allow
> > userspace to retry this ioctl until all the vCPUs can be successfully
> > LAUNCH_UPDATE_VMSA'd. Because this operation cannot be undone we cannot
> > unwind if one vCPU fails.
> >
> > Fixes: ad73109ae7ec ("KVM: SVM: Provide support to launch and run an SE=
V-ES guest")
> >
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > Cc: Marc Orr <marcorr@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Brijesh Singh <brijesh.singh@amd.com>
> > Cc: kvm@vger.kernel.org
> > Cc: stable@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  arch/x86/kvm/svm/sev.c | 24 +++++++++++++++++++-----
> >  1 file changed, 19 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 75e0b21ad07c..9a2ebd0328ca 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -598,22 +598,29 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
> >  static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd =
*argp)
> >  {
> >       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> > -     struct sev_data_launch_update_vmsa vmsa;
> > +     struct sev_data_launch_update_vmsa vmsa =3D {0};
> >       struct kvm_vcpu *vcpu;
> >       int i, ret;
> >
> >       if (!sev_es_guest(kvm))
> >               return -ENOTTY;
> >
> > -     vmsa.reserved =3D 0;
> > -
>
> Zeroing all of 'vmsa' is an unrelated chagne and belongs in a separate pa=
tch.  I
> would even go so far as to say it's unnecessary, even field of the struct=
 is
> explicitly written before it's consumed.

I'll remove this.

>
> >       kvm_for_each_vcpu(i, vcpu, kvm) {
> >               struct vcpu_svm *svm =3D to_svm(vcpu);
> >
> > +             ret =3D mutex_lock_killable(&vcpu->mutex);
> > +             if (ret)
> > +                     goto out_unlock;
>
> Rather than multiple unlock labels, move the guts of the loop to a wrappe=
r.
> As discussed off list, this really should be a vCPU-scoped ioctl, but tha=
t ship
> has sadly sailed :-(  We can at least imitate that by making the VM-scope=
d ioctl
> nothing but a wrapper.
>
> > +
> > +             /* Skip to the next vCPU if this one has already be updat=
ed. */
>
> s/be/been
>
> Uber nit, there may not be a next vCPU.  It'd be more slightly more accur=
ate to
> say something like "Do nothing if this vCPU has already been updated".
>
> > +             ret =3D sev_es_sync_vmsa(svm);
> > +             if (svm->vcpu.arch.guest_state_protected)
> > +                     goto unlock;
>
> This belongs in a separate patch, too.  It also introduces a bug (arguabl=
y two)
> in that it adds a duplicate call to sev_es_sync_vmsa().  The second bug i=
s that
> if sev_es_sync_vmsa() fails _and_ the vCPU is already protected, this wil=
l cause
> that failure to be squashed.

I'll move skipping logic to a seperate patch

>
> In the end, I think the least gross implementation will look something li=
ke this,
> implemented over two patches (one for the lock, one for the protected che=
ck).
>
> static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcp=
u,
>                                     int *error)
> {
>         struct sev_data_launch_update_vmsa vmsa;
>         struct vcpu_svm *svm =3D to_svm(vcpu);
>         int ret;
>
>         /*
>          * Do nothing if this vCPU has already been updated.  This is all=
owed
>          * to let userspace retry LAUNCH_UPDATE_VMSA if the command fails=
 on a
>          * later vCPU.
>          */
>         if (svm->vcpu.arch.guest_state_protected)
>                 return 0;
>
>         /* Perform some pre-encryption checks against the VMSA */
>         ret =3D sev_es_sync_vmsa(svm);
>         if (ret)
>                 return ret;
>
>         /*
>          * The LAUNCH_UPDATE_VMSA command will perform in-place
>          * encryption of the VMSA memory content (i.e it will write
>          * the same memory region with the guest's key), so invalidate
>          * it first.
>          */
>         clflush_cache_range(svm->vmsa, PAGE_SIZE);
>
>         vmsa.reserved =3D 0;
>         vmsa.handle =3D to_kvm_svm(kvm)->sev_info.handle;
>         vmsa.address =3D __sme_pa(svm->vmsa);
>         vmsa.len =3D PAGE_SIZE;
>         return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, erro=
r);
> }
>
> static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *ar=
gp)
> {
>         struct kvm_vcpu *vcpu;
>         int i, ret;
>
>         if (!sev_es_guest(kvm))
>                 return -ENOTTY;
>
>         kvm_for_each_vcpu(i, vcpu, kvm) {
>                 ret =3D mutex_lock_killable(&vcpu->mutex);
>                 if (ret)
>                         return ret;
>
>                 ret =3D __sev_launch_update_vmsa(kvm, vcpu, &argp->error)=
;
>
>                 mutex_unlock(&vcpu->mutex);
">                 if (ret)
>                         return ret;
>         }
>         return 0;
> }

That looks reasonable to me. I didn't know if changes headed for LTS
should be smaller so I avoided doing this refactor. From:
https://www.kernel.org/doc/html/v4.11/process/stable-kernel-rules.html#stab=
le-kernel-rules
seems to say less than 100 lines is ideal. I guess this could also be
a "theoretical race condition=E2=80=9D anyways so maybe not for LTS anyways=
.
Thoughts?

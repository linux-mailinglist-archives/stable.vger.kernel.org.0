Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1530040CF83
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 00:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbhIOWld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 18:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbhIOWld (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 18:41:33 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AB8C061764
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 15:40:13 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id l17-20020a4ae391000000b00294ad0b1f52so1432000oov.10
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 15:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vTTDSV/kjsYRHR1Kuk9wSFmd8MZbOFtLrSslZk5uGeA=;
        b=BPyy68HrjLORebyiIp/eUWsmGEsVD76RTMcrg3YCKz2SyzB9uLhoogiYjU9f4OSXhG
         0B8fVYu9SJAxmv5OqHhZ25lX2LAj9dV9sH6D5C0e+1MNU+LVE2iyLH5kqx9X6yjqjOJM
         V4EUsDnC41/HEnuVwavnNgbrLS7Yl9VE5jMUmSAeK3uOLPNzta8Lv4Vy9T36oYIzaBrB
         N1ktLbZbklBZbhBhWLzEilGJdpJaUhT5IrnXaJsulhwDRP/jZnFkoOmj3uPKipOwebrA
         t8zHpK1l7bO7ujz5F9MHW0XfdxCbk9yOxhlyojv335J2LPRpuU2cHUNVeOvEoWc3iEbJ
         iA9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vTTDSV/kjsYRHR1Kuk9wSFmd8MZbOFtLrSslZk5uGeA=;
        b=CRUxaFrR9Im9a+pssXdeaCtYrPp/5xpeLlvH3xoHlgV2VyrwQabWAxuDTA+3uwglsH
         C9WaDNgwxPG8A/ssRRXyFyBl0Ih/gx4XobIgZ9dIvcblEHCtvWnQLyf3xJqGvU7QBqZT
         8O+eef16Nd3yXSPTQm204+Fk/gXW2RY7fGiZOj5Tx3uSYyd9o70MhHxuxEfkaDS7ps6s
         KjnNKcX8c5dYwkyOM/sh5NpC98hFinTrrrTbU5usFazcHt2QaIhHE2rNKDW0zY70o6Sa
         a0r2xggQXLXmr9jv7ar24vWpGXauB8tlOA7GZhvHSnvRK51nmMVF0bGZODqqcs/2Z+zm
         rCcQ==
X-Gm-Message-State: AOAM5333CCtYY4JNiP5HyGeq7ONUDhVxKRDPaWhOqeoES/qwFYPOvhkj
        g51mVi1P9XGTHbOEN+5TOAhqtWakAbpz36rpNBv/fQ==
X-Google-Smtp-Source: ABdhPJwIzm6ysG/OmdA7xXr1eYFwGHchBmJl1cjKDMBiKoOdLAnnTjaGHy2C0uo6kzJWPfPb0p/ezHn5sJW+72zyxrA=
X-Received: by 2002:a4a:b402:: with SMTP id y2mr1938436oon.6.1631745612700;
 Wed, 15 Sep 2021 15:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210915171755.3773766-1-pgonda@google.com>
In-Reply-To: <20210915171755.3773766-1-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 15 Sep 2021 15:40:01 -0700
Message-ID: <CAA03e5E=qi4+4c0SUv7u4P4ouJOTN9XUmD_Q2h-kBtBhwKLVDA@mail.gmail.com>
Subject: Re: [PATCH V2] KVM: SEV: Acquire vcpu mutex when updating VMSA
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 10:18 AM Peter Gonda <pgonda@google.com> wrote:
>
> Adds vcpu mutex guard to the VMSA updating code. Refactors out
> __sev_launch_update_vmsa() function to deal with per vCPU parts
> of sev_launch_update_vmsa().

Can you expand the changelog, and perhaps add a comment into the
source code as well, to explain what grabbing the mutex protects us
from? I assume that it's a poorly behaved user-space, rather than a
race condition in a well-behaved user-space VMM, but I'm not certain.

Other than that, the patch itself seems fine to me.

>
> Fixes: ad73109ae7ec ("KVM: SVM: Provide support to launch and run an SEV-ES guest")
>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>
> V2
>  * Refactor per vcpu work to separate function.
>  * Remove check to skip already initialized VMSAs.
>  * Removed vmsa struct zeroing.
>
> ---
>  arch/x86/kvm/svm/sev.c | 53 ++++++++++++++++++++++++------------------
>  1 file changed, 30 insertions(+), 23 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75e0b21ad07c..766510fe3abb 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -595,43 +595,50 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>         return 0;
>  }
>
> -static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
> +                                   int *error)
>  {
> -       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>         struct sev_data_launch_update_vmsa vmsa;
> +       struct vcpu_svm *svm = to_svm(vcpu);
> +       int ret;
> +
> +       /* Perform some pre-encryption checks against the VMSA */
> +       ret = sev_es_sync_vmsa(svm);
> +       if (ret)
> +               return ret;
> +
> +       /*
> +        * The LAUNCH_UPDATE_VMSA command will perform in-place encryption of
> +        * the VMSA memory content (i.e it will write the same memory region
> +        * with the guest's key), so invalidate it first.
> +        */
> +       clflush_cache_range(svm->vmsa, PAGE_SIZE);
> +
> +       vmsa.reserved = 0;
> +       vmsa.handle = to_kvm_svm(kvm)->sev_info.handle;
> +       vmsa.address = __sme_pa(svm->vmsa);
> +       vmsa.len = PAGE_SIZE;
> +       return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
> +}
> +
> +static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
>         struct kvm_vcpu *vcpu;
>         int i, ret;
>
>         if (!sev_es_guest(kvm))
>                 return -ENOTTY;
>
> -       vmsa.reserved = 0;
> -
> -       kvm_for_each_vcpu(i, vcpu, kvm) {
> -               struct vcpu_svm *svm = to_svm(vcpu);
> -
> -               /* Perform some pre-encryption checks against the VMSA */
> -               ret = sev_es_sync_vmsa(svm);
> +       kvm_for_each_vcpu(i, vcpu, kvm) {
> +               ret = mutex_lock_killable(&vcpu->mutex);
>                 if (ret)
>                         return ret;
>
> -               /*
> -                * The LAUNCH_UPDATE_VMSA command will perform in-place
> -                * encryption of the VMSA memory content (i.e it will write
> -                * the same memory region with the guest's key), so invalidate
> -                * it first.
> -                */
> -               clflush_cache_range(svm->vmsa, PAGE_SIZE);
> +               ret = __sev_launch_update_vmsa(kvm, vcpu, &argp->error);
>
> -               vmsa.handle = sev->handle;
> -               vmsa.address = __sme_pa(svm->vmsa);
> -               vmsa.len = PAGE_SIZE;
> -               ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa,
> -                                   &argp->error);
> +               mutex_unlock(&vcpu->mutex);
>                 if (ret)
>                         return ret;
> -
> -               svm->vcpu.arch.guest_state_protected = true;
>         }
>
>         return 0;
> --
> 2.33.0.464.g1972c5931b-goog
>

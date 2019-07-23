Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2A9170E48
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 02:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbfGWAmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 20:42:33 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45721 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728573AbfGWAmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 20:42:32 -0400
Received: by mail-ot1-f65.google.com with SMTP id x21so3803099otq.12;
        Mon, 22 Jul 2019 17:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+4vwd05Ashr+MqpzyT1dsjrUNcGE/G6qFLXOudh/Hcw=;
        b=tS5W2IfRrrGrMZexz8n/YQ6mx8QKZ1mJHQy0cQlM9aKQ9z1yWW/4W8baHJAAbLmZY2
         IqTmGccIg1lgn87FA7/PUxbrVBbltdxf+PrbNrxBXmf/WwIf3f5UMmcQ3VUQcnlAP57n
         S5dGfN0VTkgVXe2AnuZ6kGUVp42XO2AyEHDSbnvkRIu1VuyLe8y2vHVQwktobGQNJOj7
         +adae8DrjX3BXdEf4USncr0e4QrUKeUOh3GmeYVhuxFofjc9H9YmmUHPI0eJ9U6OJuWS
         8BEjU9tyrZUHiBuQnG08eFXGJgr2I9Azonm3KMVpDItO7+u7Ibo2kMb4cvWhyeswN0Hx
         a3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+4vwd05Ashr+MqpzyT1dsjrUNcGE/G6qFLXOudh/Hcw=;
        b=CLK4MpRsbCiaiLiQCMGJnFwnNEl9ZlhIDsvWMtf06DTBVadbKT5+PoPTfuf2XSOMTs
         9qZP6l/wuoVmciI2xNInCUNljsrb4TNKg7Sgix6256MkCpw1gaAdwf0kIqw0cYPp138I
         BOWEVzsz+WP5JkG/j9DOq3yOCZqL/rVgz0qsjohsxGx5XyGU3gIMNuPXB8LJOaCgbDV4
         lfY5tCxDfj0lqbPTdI/lOIU9fC/VO5AoopGDvMKGXVn94n7VbAvZ4mrYdju6Cu+SUVBZ
         xIS3P79zekNpuGzz2876d0i7EnkNPBih6250H4aJk8x2B/xKPxxbV3N952z8eNh8fPTD
         XdoQ==
X-Gm-Message-State: APjAAAUas150W8+xBBvarma3WeMvqFP/Ok1I6AIbrP7+hQiTU9PU1GZ6
        Ud3nWnrWY+/TKAjYFCNk0/a3cKRNCSMGqBoiTdrmb1wX
X-Google-Smtp-Source: APXvYqwWu6I5XECni0tNYIHokCOv9ywgFgatg/ZnPNaFsVRspnZ75JjEnxmzZVdOBp3MC5oJeEaqrTr7Gq2jqhkQKyc=
X-Received: by 2002:a9d:6959:: with SMTP id p25mr40100956oto.118.1563842551951;
 Mon, 22 Jul 2019 17:42:31 -0700 (PDT)
MIME-Version: 1.0
References: <1563796594-25317-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1563796594-25317-1-git-send-email-pbonzini@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 23 Jul 2019 08:42:27 +0800
Message-ID: <CANRm+CyPGO=_OYCFbj00iR0Be7Pv0MCqSzgg5=-YwGiMgUV2wg@mail.gmail.com>
Subject: Re: [PATCH] Revert "kvm: x86: Use task structs fpu field for user"
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        "# v3 . 10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Jul 2019 at 20:49, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> This reverts commit 240c35a3783ab9b3a0afaba0dde7291295680a6b
> ("kvm: x86: Use task structs fpu field for user", 2018-11-06).
> The commit is broken and causes QEMU's FPU state to be destroyed
> when KVM_RUN is preempted.
>
> Fixes: 240c35a3783a ("kvm: x86: Use task structs fpu field for user")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 7 ++++---
>  arch/x86/kvm/x86.c              | 4 ++--
>  2 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0cc5b611a113..b2f1ffb937af 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -607,15 +607,16 @@ struct kvm_vcpu_arch {
>
>         /*
>          * QEMU userspace and the guest each have their own FPU state.
> -        * In vcpu_run, we switch between the user, maintained in the
> -        * task_struct struct, and guest FPU contexts. While running a VCPU,
> -        * the VCPU thread will have the guest FPU context.
> +        * In vcpu_run, we switch between the user and guest FPU contexts.
> +        * While running a VCPU, the VCPU thread will have the guest FPU
> +        * context.
>          *
>          * Note that while the PKRU state lives inside the fpu registers,
>          * it is switched out separately at VMENTER and VMEXIT time. The
>          * "guest_fpu" state here contains the guest FPU context, with the
>          * host PRKU bits.
>          */
> +       struct fpu user_fpu;
>         struct fpu *guest_fpu;
>
>         u64 xcr0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 58305cf81182..cf2afdf8facf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8270,7 +8270,7 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
>  {
>         fpregs_lock();
>
> -       copy_fpregs_to_fpstate(&current->thread.fpu);
> +       copy_fpregs_to_fpstate(&vcpu->arch.user_fpu);
>         /* PKRU is separately restored in kvm_x86_ops->run.  */
>         __copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
>                                 ~XFEATURE_MASK_PKRU);
> @@ -8287,7 +8287,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
>         fpregs_lock();
>
>         copy_fpregs_to_fpstate(vcpu->arch.guest_fpu);
> -       copy_kernel_to_fpregs(&current->thread.fpu.state);
> +       copy_kernel_to_fpregs(&vcpu->arch.user_fpu.state);
>
>         fpregs_mark_activate();
>         fpregs_unlock();

Looks good to me.

Regards,
Wanpeng Li

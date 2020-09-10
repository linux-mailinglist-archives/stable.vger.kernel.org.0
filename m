Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9896264A95
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 19:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgIJQzX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 10 Sep 2020 12:55:23 -0400
Received: from mail-ej1-f68.google.com ([209.85.218.68]:39054 "EHLO
        mail-ej1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgIJQxK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 12:53:10 -0400
Received: by mail-ej1-f68.google.com with SMTP id p9so9739262ejf.6;
        Thu, 10 Sep 2020 09:52:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ns0+fwvubeXR2dgCJl7CUrqaFL9rI3gtmSpPCYooM7w=;
        b=GwVjNo/HjzCQecgt926hHxFYjQH6uES8NfD1J4xEVKbUKDwrPx3DVAtX1+n++NbVvN
         ialk7vXkw6L1U0jBjBHSh2co7lJ4kXRZML9FVIhx1TxdHOfcoTFddyIorraT5c+QEiJy
         8NfK+l04XG9zWdExQOBfSF6RJmwpvdKcIRuaDKntrS6nR0m9BBUdF02gQ180IUsbdfhy
         pwk8H12/vx1o131B8E18cCjw2wxmK2ncP0d+k8l5MlXgyVkhSRye+bdABMHhvE8Y1JJl
         IxFpx41oQoTK/XP/PP8r3UlraaFQpd32zxAK/TylGarrGMLowMd+eNTbh01BDTtfQhqt
         wGTA==
X-Gm-Message-State: AOAM533O0iWun4zJJ0id73IS3GLDILB7g/415mg58S254TmnxpKHQ8r1
        oqjOGz1kydnf0UVcMI1tLN0ZkMsaV+TuBpQ0oyc=
X-Google-Smtp-Source: ABdhPJwWjBLSznSbqH6VN0qlhPnRWyhcPhoLowXCrtx2cKAq7jDbvKLnBqXL/VvULAhgROVYl3ZC1JCAIOX5Ilol460=
X-Received: by 2002:a17:906:d936:: with SMTP id rn22mr9851468ejb.4.1599756767403;
 Thu, 10 Sep 2020 09:52:47 -0700 (PDT)
MIME-Version: 1.0
References: <1599734031-28746-1-git-send-email-chenhc@lemote.com>
In-Reply-To: <1599734031-28746-1-git-send-email-chenhc@lemote.com>
From:   =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Date:   Thu, 10 Sep 2020 18:52:36 +0200
Message-ID: <CAAdtpL5ns9s3Ld=hghRmLeyGcOy3j23NSD54hvvO4dq7_CzJgw@mail.gmail.com>
Subject: Re: [PATCH] KVM: MIPS: Change the definition of kvm type
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Huth <thuth@redhat.com>, kvm <kvm@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 10, 2020 at 12:34 PM Huacai Chen <chenhc@lemote.com> wrote:
>
> MIPS defines two kvm types:
>
>  #define KVM_VM_MIPS_TE          0
>  #define KVM_VM_MIPS_VZ          1
>
> In Documentation/virt/kvm/api.rst it is said that "You probably want to
> use 0 as machine type", which implies that type 0 be the "automatic" or
> "default" type. And, in user-space libvirt use the null-machine (with
> type 0) to detect the kvm capability, which returns "KVM not supported"
> on a VZ platform.
>
> I try to fix it in QEMU but it is ugly:
> https://lists.nongnu.org/archive/html/qemu-devel/2020-08/msg05629.html

I'm not sure this is helpful information to keep in the commit message.

Otherwise:
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>

>
> And Thomas Huth suggests me to change the definition of kvm type:
> https://lists.nongnu.org/archive/html/qemu-devel/2020-09/msg03281.html

Suggested-by: Thomas Huth <thuth@redhat.com>

>
> So I define like this:
>
>  #define KVM_VM_MIPS_AUTO        0
>  #define KVM_VM_MIPS_VZ          1
>  #define KVM_VM_MIPS_TE          2
>
> Since VZ and TE cannot co-exists, using type 0 on a TE platform will
> still return success (so old user-space tools have no problems on new
> kernels); the advantage is that using type 0 on a VZ platform will not
> return failure. So, the only problem is "new user-space tools use type
> 2 on old kernels", but if we treat this as a kernel bug, we can backport
> this patch to old stable kernels.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/kvm/mips.c     | 2 ++
>  include/uapi/linux/kvm.h | 5 +++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index d7ba3f9..9efeb67 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -138,6 +138,8 @@ extern void kvm_init_loongson_ipi(struct kvm *kvm);
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
>         switch (type) {
> +       case KVM_VM_MIPS_AUTO:
> +               break;
>  #ifdef CONFIG_KVM_MIPS_VZ
>         case KVM_VM_MIPS_VZ:
>  #else
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 29ba8e8..cfc1ae2 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -790,9 +790,10 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_VM_PPC_HV 1
>  #define KVM_VM_PPC_PR 2
>
> -/* on MIPS, 0 forces trap & emulate, 1 forces VZ ASE */
> -#define KVM_VM_MIPS_TE         0
> +/* on MIPS, 0 indicates auto, 1 forces VZ ASE, 2 forces trap & emulate */
> +#define KVM_VM_MIPS_AUTO       0
>  #define KVM_VM_MIPS_VZ         1
> +#define KVM_VM_MIPS_TE         2
>
>  #define KVM_S390_SIE_PAGE_OFFSET 1
>
> --
> 2.7.0
>

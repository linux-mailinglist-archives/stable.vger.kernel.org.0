Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E8A264526
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 13:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgIJLJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 07:09:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38875 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730418AbgIJK50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 06:57:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599735443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q7OoL5c8F8caEV9G3lP66ZZoFPOTGb9Q98C58zV6G2E=;
        b=TLcDJZpZHLvoxQTYrapoA6tXHmhsfgAY5HGa6NdcdU7RNz5mHRqvYWncXP4r1VOwRHPKWI
        5M0M874rL2WfkmtL9lFeDrpvyfokSNziHj958nbpBLM5UAmJmEjbdq/3jwS/gQzYELEjx5
        RPLgixmsXssnmjxw3kvjQmXufaEF8N4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-GvjiXVIrNq-hP6FRXCfEBg-1; Thu, 10 Sep 2020 06:57:14 -0400
X-MC-Unique: GvjiXVIrNq-hP6FRXCfEBg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B07CC802B7C;
        Thu, 10 Sep 2020 10:57:12 +0000 (UTC)
Received: from thuth.remote.csb (unknown [10.40.194.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52AE260BF4;
        Thu, 10 Sep 2020 10:57:08 +0000 (UTC)
Subject: Re: [PATCH] KVM: MIPS: Change the definition of kvm type
To:     Huacai Chen <chenhc@lemote.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
References: <1599734031-28746-1-git-send-email-chenhc@lemote.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e7b88a26-cb59-fccd-878a-9c197187489d@redhat.com>
Date:   Thu, 10 Sep 2020 12:57:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1599734031-28746-1-git-send-email-chenhc@lemote.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/09/2020 12.33, Huacai Chen wrote:
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
> 
> And Thomas Huth suggests me to change the definition of kvm type:
> https://lists.nongnu.org/archive/html/qemu-devel/2020-09/msg03281.html
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
>  	switch (type) {
> +	case KVM_VM_MIPS_AUTO:
> +		break;
>  #ifdef CONFIG_KVM_MIPS_VZ
>  	case KVM_VM_MIPS_VZ:
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
> -#define KVM_VM_MIPS_TE		0
> +/* on MIPS, 0 indicates auto, 1 forces VZ ASE, 2 forces trap & emulate */
> +#define KVM_VM_MIPS_AUTO	0
>  #define KVM_VM_MIPS_VZ		1
> +#define KVM_VM_MIPS_TE		2
>  
>  #define KVM_S390_SIE_PAGE_OFFSET 1

Thanks, I think that's the right way to go if we don't want mips to
behave completely different compared to the other architectures (e.g.
powerpc is also using 0 as "automatic" type in arch/powerpc/kvm/powerpc.c).

Reviewed-by: Thomas Huth <thuth@redhat.com>


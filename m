Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772E73CB342
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235441AbhGPHfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235208AbhGPHfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 03:35:19 -0400
X-Greylist: delayed 317 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Jul 2021 00:32:24 PDT
Received: from forward106o.mail.yandex.net (forward106o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D106EC06175F;
        Fri, 16 Jul 2021 00:32:24 -0700 (PDT)
Received: from iva5-76c5c16f2a53.qloud-c.yandex.net (iva5-76c5c16f2a53.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:7bae:0:640:76c5:c16f])
        by forward106o.mail.yandex.net (Yandex) with ESMTP id 454C65062347;
        Fri, 16 Jul 2021 10:27:05 +0300 (MSK)
Received: from iva1-bc1861525829.qloud-c.yandex.net (iva1-bc1861525829.qloud-c.yandex.net [2a02:6b8:c0c:a0e:0:640:bc18:6152])
        by iva5-76c5c16f2a53.qloud-c.yandex.net (mxback/Yandex) with ESMTP id YjDptLVuBB-R5H0RC3R;
        Fri, 16 Jul 2021 10:27:05 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1626420425;
        bh=ibwhoL1eSkERw80Wa+H3P1m75bC+Y/fdfK3KDFajLS8=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=c2Xm/eKFF5UgHEnny3tmw7nHfTULIfIVJijV7uecarWPoay+qBsL+ACX65M9lQ613
         49RHsyzBPNT0PeRuhAFO0MVzOXY3NYTz+gOMln7au4Z6oxPBZiQt8Lb7hFAHJCZoJe
         /2GqSvy51AIrTghdTe4ADpAYYlc37WBF/Qmrzoa8=
Authentication-Results: iva5-76c5c16f2a53.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva1-bc1861525829.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id peBL5hNod9-R42qL6US;
        Fri, 16 Jul 2021 10:27:04 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH] KVM: x86: accept userspace interrupt only if no event is
 injected
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210714213846.854837-1-pbonzini@redhat.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <6f2305c0-77a8-42af-f5e9-2664119b6b2e@yandex.ru>
Date:   Fri, 16 Jul 2021 10:27:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210714213846.854837-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


15.07.2021 00:38, Paolo Bonzini пишет:
> Once an exception has been injected, any side effects related to
> the exception (such as setting CR2 or DR6) have been taked

"taken"? Probably a typo.


>   place.
> Therefore, once KVM sets the VM-entry interruption information
> field or the AMD EVENTINJ field, the next VM-entry must deliver that
> exception.
>
> Pending interrupts are processed after injected exceptions, so
> in theory it would not be a problem to use KVM_INTERRUPT when
> an injected exception is present.  However, DOSBox

dosemu2 to be precise.


>   is using
> run->ready_for_interrupt_injection to detect interrupt windows
> and then using KVM_SET_SREGS/KVM_SET_REGS to inject the
> interrupt manually.  For this to work, the interrupt window
> must be delayed after the completion of the previous event
> injection.
>
> Cc: stable@vger.kernel.org
> Reported-by: Stas Sergeev <stsp2@yandex.ru>
> Tested-by: Stas Sergeev <stsp2@yandex.ru>
> Fixes: 71cc849b7093 ("KVM: x86: Fix split-irqchip vs interrupt injection window request")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/x86.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fe3aaf195292..7fbab29b3569 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4342,6 +4342,9 @@ static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
>   
>   static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
>   {
> +	if (kvm_event_needs_reinjection(vcpu))
> +		return false;
> +

kvm_event_needs_reinjection() seems
to miss exception.pending check.
Don't we need it too?

Also perhaps a comment would be good
to have to avoid it from disappearing again,
as obviously kvm devs tend to overlook
the possibility of injecting interrupts by hands.


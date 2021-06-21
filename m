Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A202D3AE8F7
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 14:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbhFUMYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 08:24:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229651AbhFUMYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 08:24:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624278114;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VhDAKKgaNDrSL7iSXcPu9LD5gECJffFFHIw26sWyyR0=;
        b=UT/zzBhrfPKOIepc8sfyswrTvP8Dbbg+sN5TpUMplx1z87HrVLlOgtWmUXb7PFveja7/he
        jL7xTKSTuLXcpbwnYLOjDnPU0zTpcR6YvNvxIPO8P6pVJ36VJ4y250z4Vr7/TZYpMSLfFK
        My+siWxZZ3zy+IhLxa/5gBpA+vttBdY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-fmLAQRGZPXu7ZSlzCVKkKw-1; Mon, 21 Jun 2021 08:21:53 -0400
X-MC-Unique: fmLAQRGZPXu7ZSlzCVKkKw-1
Received: by mail-wr1-f69.google.com with SMTP id h17-20020adff4d10000b029011a7b7961dbso6162687wrp.15
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 05:21:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VhDAKKgaNDrSL7iSXcPu9LD5gECJffFFHIw26sWyyR0=;
        b=AAesY5ABC4PH3aT1JBKJ1pTY2IfIpRbI2zF58jmmQ8MwW03S77t4NNj/EeYbUrMQf9
         h4bvvtIY6F54jdslEbmV71QfpeazGXEz89vvwFTG2oQfYLxIGyI9MSAwZ2tyjh791Dtg
         +TX0I/gbR9V5YA8Yu7W41dPQjNmfrbc2BoNeC/1coIjm87oO8beJYg3RxyPfZY2FYTsz
         gB3h/lDucCKrdFZg65Jg0wvksF6JcLPK7XEjSehYHeIXchS7tK5Xc2SUjCOIP2mg7Gk7
         WO+F65Wt8RfcnKQoyHShZsJSUYOU1GUyUXhqIcmnrm/PRHVD8WsZYjeuIJmEGsgE0CaM
         gFSw==
X-Gm-Message-State: AOAM533GL2oLkjLc0k5TYpgRT79TZ25S7b1eurRcdGZU0DD66bjf7fqc
        0OTKGelzKKV9vqwx9gQJ0rnN9pJs3oirm0nIXqx+5igRgj7SPKBd6sTCD+XZzrXW0w8kOPD8wOS
        evDjyPlHjGte8nsfg
X-Received: by 2002:a7b:ce8e:: with SMTP id q14mr12106030wmj.33.1624278110399;
        Mon, 21 Jun 2021 05:21:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFLQpGIAVfisiyTY6nyCXRe3QRWDsB4/y9R3ja660K2K9yyGgRerGQ+R2pQj2G1e1aEWhFSw==
X-Received: by 2002:a7b:ce8e:: with SMTP id q14mr12106002wmj.33.1624278110220;
        Mon, 21 Jun 2021 05:21:50 -0700 (PDT)
Received: from [192.168.43.95] ([37.173.110.237])
        by smtp.gmail.com with ESMTPSA id l23sm16824154wmc.5.2021.06.21.05.21.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 05:21:49 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH] KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read
To:     eric.auger.pro@gmail.com, stable@vger.kernel.org, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210621121839.792649-1-eric.auger@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <f8e6aab9-651c-9ef1-2621-6d61374704cc@redhat.com>
Date:   Mon, 21 Jun 2021 14:21:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210621121839.792649-1-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 6/21/21 2:18 PM, Eric Auger wrote:
> When reading the base address of the a REDIST region
> through KVM_VGIC_V3_ADDR_TYPE_REDIST we expect the
> redistributor region list to be populated with a single
> element.
>
> However list_first_entry() expects the list to be non empty.
> Instead we should use list_first_entry_or_null which effectively
> returns NULL if the list is empty.
>
> Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
> Cc: <Stable@vger.kernel.org> # v4.19
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reported-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20210412150034.29185-1-eric.auger@redhat.com

Maybe I should I prefixed the patch with [stable-4.19]. This is already
on master and in various stable but did not apply on 4.19

Thanks

Eric
> ---
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 6ada2432e37c..71d92096776e 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -95,8 +95,8 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  			r = vgic_v3_set_redist_base(kvm, 0, *addr, 0);
>  			goto out;
>  		}
> -		rdreg = list_first_entry(&vgic->rd_regions,
> -					 struct vgic_redist_region, list);
> +		rdreg = list_first_entry_or_null(&vgic->rd_regions,
> +						 struct vgic_redist_region, list);
>  		if (!rdreg)
>  			addr_ptr = &undef_value;
>  		else


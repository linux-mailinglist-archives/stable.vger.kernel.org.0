Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FCF3AEC9B
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 17:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhFUPkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 11:40:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230059AbhFUPkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 11:40:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624289916;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/PT2H+5rBlFaNgMWz3m8mH4Pq2q3IOb/grR2Heyyj5M=;
        b=hg54baL/bSFu4+S6F9O2B5Ku5saGYLcZaSBiEaXL5Nm2dZIT9UQzqOSYKTTYlKr9vajaTr
        heNpMubXVkdlvTurQtR3AWuTLMvg25zR3s3KXsa0YHR7FHDe+d+pAtZV3JlO6C2FAgidRL
        Gj2yoMBH4QQEEyKYbeR8UYjslAwU4N8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-rh6qJDDUMySj9y_kbue6jA-1; Mon, 21 Jun 2021 11:38:35 -0400
X-MC-Unique: rh6qJDDUMySj9y_kbue6jA-1
Received: by mail-wm1-f69.google.com with SMTP id p22-20020a7bcc960000b02901de8f2ae18aso135209wma.8
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 08:38:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=/PT2H+5rBlFaNgMWz3m8mH4Pq2q3IOb/grR2Heyyj5M=;
        b=agIKjHZwwqcu5RkyqUpYEwPVVUS8iWVnlIphjtKNrUfUO12k7pzQFNPK2Z691NK0uZ
         7j1ZJjMPENr1WJPgJTq1nFXQfqnOZLHMXpjG+YAlAS7oUJM9rmB9jUSM+brNiuf9gsa0
         /J6Pa2+hZipKA8N/Rosa/kVbrHAwmpocvsfAC/8ip0XOrYrQftlTAblQvxFRNTytBYWI
         jjRRq+jSumuxfypp8MgPbM4Yod+tFsykeh0EJgmwJ+6nr324GFCpEgZUgxDniLpDHIhX
         ssIWWKT0BdEwIm3l/INd/JPDBUaMqcqyglRksozmhZ06iTjU7B0AKn+sIjKAazW7Kwgp
         hzBQ==
X-Gm-Message-State: AOAM5325WyNigcYCIp8E0KsqlgU3B34jepzpAiWGMHuAD7ZHeGNVO40M
        +dMtmWbBNPY4un6lavTgZ+PX7DcEbHkqomr5Yi4zs1tI62qTs5xFQWSrCW6FKiYHvj8xlCCuXPK
        tpwUc+cONbH4L1OVl
X-Received: by 2002:a05:6000:1001:: with SMTP id a1mr26918929wrx.418.1624289914095;
        Mon, 21 Jun 2021 08:38:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBmisgDmIC43EwBLz2kszOmTyi7ROWV2l0j77EjN7RpHdmMIn2XY6HwlfXesCj3PgXQh5ttw==
X-Received: by 2002:a05:6000:1001:: with SMTP id a1mr26918915wrx.418.1624289913893;
        Mon, 21 Jun 2021 08:38:33 -0700 (PDT)
Received: from [192.168.43.95] ([37.173.110.237])
        by smtp.gmail.com with ESMTPSA id n13sm19466650wrg.75.2021.06.21.08.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 08:38:33 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH for-stable-5.4] KVM: arm/arm64: Fix
 KVM_VGIC_V3_ADDR_TYPE_REDIST read
To:     Greg KH <greg@kroah.com>
Cc:     eric.auger.pro@gmail.com, stable@vger.kernel.org, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210621124232.793383-1-eric.auger@redhat.com>
 <YNCvA4qDuc2Tlmi0@kroah.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <acd4fdcb-d6d4-755b-6f9d-9acf4b08d564@redhat.com>
Date:   Mon, 21 Jun 2021 17:38:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YNCvA4qDuc2Tlmi0@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 6/21/21 5:23 PM, Greg KH wrote:
> On Mon, Jun 21, 2021 at 02:42:32PM +0200, Eric Auger wrote:
>> When reading the base address of the a REDIST region
>> through KVM_VGIC_V3_ADDR_TYPE_REDIST we expect the
>> redistributor region list to be populated with a single
>> element.
>>
>> However list_first_entry() expects the list to be non empty.
>> Instead we should use list_first_entry_or_null which effectively
>> returns NULL if the list is empty.
>>
>> Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
>> Cc: <Stable@vger.kernel.org> # v5.4
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Reported-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Link: https://lore.kernel.org/r/20210412150034.29185-1-eric.auger@redhat.com
>> ---
>>  virt/kvm/arm/vgic/vgic-kvm-device.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
> Both now queued up, thanks.
>
> Next time, give us a hint as to what the upstream commit id is, so that
> we do not have to dig it up ourselves :)
Sure I will.

Thanks!

Eric
>
> thanks,
>
> greg k-h
>


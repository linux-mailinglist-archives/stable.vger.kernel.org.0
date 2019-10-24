Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E3FE27CF
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 03:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405818AbfJXBrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 21:47:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42757 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfJXBrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 21:47:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id f14so13196715pgi.9
        for <stable@vger.kernel.org>; Wed, 23 Oct 2019 18:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l4mk6xdzcdFwbnFZaJqBOaEwkFm4xUTf8OpC4c8be40=;
        b=rQHcmHFFFmraME4Dhk1CzyWCn4h3Jc0aU7IsKp5PM5KSt9LfoN2Y/JnN5ot88WjgC6
         4Kvq+mC0WiN93Ow9PL70uZ7qURzfjBNmjcm7B5cyKko+Wh/pKhOPpb+pcFcVOIbBmNcc
         yj9soIHqbgww7pnY/nzqZdCqCrHhW/HA4PuNCdjHZhyQLccr4oW93Iz624IScsxa/URb
         /BDyAEn4Naq4P/Tc06kKgEbcxm0j7oE8BxqcvksNPl1qHT4CSXD7j2192IQ3q3O+IJ8r
         fHeQM5xgRfnJhXadzqM89pMqO6P+MAjmxwKlcKypGxu3Kac9vJ/iuNDjE7Ob0E9dxsCc
         c1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=l4mk6xdzcdFwbnFZaJqBOaEwkFm4xUTf8OpC4c8be40=;
        b=eMHDCXKMXmwcZ3JybJe5zpE0v62rCfIhuvSXryI/WsBHFlEP/tEExxZzsdgJ7kygnQ
         8bb5evowDyeCKGjJXwzOYCM8caAB7+RMkq1XdDSygexdDVzfQgtiKtZO2cPqSkHfAqAH
         zz8GpuUDLcfPRF9XS1DY0mCLzYhyOGMe+03j+ECMqapmjlUHFCrsIgiB7XXhenaapJqg
         xLA1+NsANnTHpZj/bPOjipwDi8w0GOGkWgd9aOp/hcvV6FRqN1Yf82WNRCZXdUIj/z+Y
         dHIUB5vOvXyybSO6O+ldn0HC2CKW0yYmQJA54022IeCKrsyfD/RViF2sY7MDRnFb+nL9
         u7Bg==
X-Gm-Message-State: APjAAAU05EkFoQq0FJ9KQHpUq0E+GPkjCYHB3jBagPXozpdVyo4N2AIb
        zrm64sDCAjfcyefQW6O0jJxBtPF2VOc=
X-Google-Smtp-Source: APXvYqwI8+jaTROvm8Pbr+xhoH6wWtSDvm07HkhyQoUlon1JL5bdolS1hSNhKqPRjRUQ6W0aZgLjQA==
X-Received: by 2002:a63:dc45:: with SMTP id f5mr13563549pgj.250.1571881653936;
        Wed, 23 Oct 2019 18:47:33 -0700 (PDT)
Received: from [10.61.2.175] ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id d2sm151318pgf.10.2019.10.23.18.47.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2019 18:47:33 -0700 (PDT)
Subject: Re: [PATCH] powerpc/boot: Fix the initrd being overwritten under qemu
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     Segher Boessenkool <segher@kernel.crashing.org>,
        Oliver O'Halloran <oohall@gmail.com>
Cc:     linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20191023013635.2512-1-oohall@gmail.com>
 <20191023112102.GN28442@gate.crashing.org>
 <90a0f702-6891-cd14-f190-5682d7c3778e@ozlabs.ru>
Autocrypt: addr=aik@ozlabs.ru; keydata=
 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
Message-ID: <93379f35-4c64-6992-cab5-01705f528912@ozlabs.ru>
Date:   Thu, 24 Oct 2019 12:47:25 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <90a0f702-6891-cd14-f190-5682d7c3778e@ozlabs.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 24/10/2019 12:31, Alexey Kardashevskiy wrote:
> 
> 
> On 23/10/2019 22:21, Segher Boessenkool wrote:
>> On Wed, Oct 23, 2019 at 12:36:35PM +1100, Oliver O'Halloran wrote:
>>> When booting under OF the zImage expects the initrd address and size to be
>>> passed to it using registers r3 and r4. SLOF (guest firmware used by QEMU)
>>> currently doesn't do this so the zImage is not aware of the initrd
>>> location.  This can result in initrd corruption either though the zImage
>>> extracting the vmlinux over the initrd, or by the vmlinux overwriting the
>>> initrd when relocating itself.
>>>
>>> QEMU does put the linux,initrd-start and linux,initrd-end properties into
>>> the devicetree to vmlinux to find the initrd. We can work around the SLOF
>>> bug by also looking those properties in the zImage.
>>
>> This is not a bug.  What boot protocol requires passing the initrd start
>> and size in GPR3, GPR4?
> 
> So far I was unable to identify it...
> 
>> The CHRP binding (what SLOF implements) requires passing two zeroes here.
>> And ePAPR requires passing the address of a device tree and a zero, plus
>> something in GPR6 to allow distinguishing what it does.
>>
>> As Alexey says, initramfs works just fine, so please use that?  initrd was
>> deprecated when this code was written already.
> 
> I did not say about anything working fine :)
> 
> In my case I was using a new QEMU which does full FDT on client-arch-support and that thing would put the original
> linux,initrd-start/end to the FDT even though the initrd was unpacked and the properties were changes in SLOF. With that
> fixed, this is an alternative fix for SLOF but I am not pushing it out as I have no idea about the bindings and this
> also breaks "vmlinux".


ah no, that works for vmlinux as well. Hm.


> 
> 
> diff --git a/slof/fs/client.fs b/slof/fs/client.fs
> index 8a7f6ac4326d..138177e4c2a3 100644
> --- a/slof/fs/client.fs
> +++ b/slof/fs/client.fs
> @@ -45,6 +45,17 @@ VARIABLE  client-callback \ Address of client's callback function
>    >r  ciregs >r7 !  ciregs >r6 !  client-entry-point @ ciregs >r5 !
>    \ Initialise client-stack-pointer
>    cistack ciregs >r1 !
> +
> +  s" linux,initrd-end" get-chosen IF decode-int -rot 2drop ELSE 0 THEN
> +  s" linux,initrd-start" get-chosen IF decode-int -rot 2drop ELSE 0 THEN
> +  2dup - dup IF
> +    ciregs >r4 !
> +    ciregs >r3 !
> +    drop
> +  ELSE
> +    3drop
> +  THEN
> +
> 
> 

-- 
Alexey

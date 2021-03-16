Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBEF33D39A
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 13:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhCPMQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 08:16:10 -0400
Received: from mail-40131.protonmail.ch ([185.70.40.131]:12573 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhCPMQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 08:16:02 -0400
Date:   Tue, 16 Mar 2021 12:15:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tmb.nu;
        s=protonmail; t=1615896960;
        bh=AN1iVoDnrXSaWtJKAGtgjDpy289O3XZjKfNs+R5E3C8=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=BsyfJflOEnS2UQQDY7QmzysjXtc8V+BXepYbZRwjmdNFXlAj/GhOn5wh0zjh0/OCE
         qh0kw+zpsj8caifRPrRwbLbSgIsXepvogjot9DEtN5FigyxXVHQqENs78HSHIjvpfw
         JWoXOh/u0HtbqEiRGj5IL/4eS2vpnssVH6ANRpy8=
To:     Ard Biesheuvel <ardb@kernel.org>
From:   Thomas Backlund <tmb@tmb.nu>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Reply-To: Thomas Backlund <tmb@tmb.nu>
Subject: Re: stable request
Message-ID: <1e6eb02b-e699-d1ff-9cfb-4ef77255e244@tmb.nu>
In-Reply-To: <CAMj1kXEM76Dejv1fTZ-1EmXpSsE-ZtKWf19dPNTSBRuPcAkreA@mail.gmail.com>
References: <d5c825ba-cdcb-29eb-c434-83ef4db05ee0@tmb.nu> <CAMj1kXEM76Dejv1fTZ-1EmXpSsE-ZtKWf19dPNTSBRuPcAkreA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Den 16.3.2021 kl. 12:17, skrev Ard Biesheuvel:
> On Tue, 16 Mar 2021 at 10:21, Thomas Backlund <tmb@tmb.nu> wrote:
>> Den 16.3.2021 kl. 08:37, skrev Ard Biesheuvel:
>>> Please consider backporting commit
>>>
>>> 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1
>>> crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
>>>
>>> to stable. It addresses a rather substantial retpoline-related
>>> performance regression in the AES-NI XTS code, which is a widely used
>>> disk encryption algorithm on x86.
>>>
>> To get all the nice bits, we added the following in Mageia 5.10 / 5.11
>> series kerenels (the 2 first is needed to get the third to apply/build
>> nicely):
>>
> I will leave it up to the -stable maintainers to decide, but I will
> point out that none of the additional patches fix any bugs, so this
> may violate the stable kernel rules. In fact, I deliberately split the
> XTS changes into two  patches so that the first one could be
> backported individually.


Yes, I understand that.

but commit

86ad60a65f29dd862a11c22bb4b5be28d6c5cef1
crypto: x86/aes-ni-xts - use direct calls to and 4-way stride

only applies cleanly on 5.11.


So if it's wanted in 5.10 you need the 2 others too... unless you intend to=
 provide a tested backport...
and IIRC GregKH prefers 1:1 matching of patches between -stable and linus t=
ree unless they are too intrusive.


As for the last one I seem to remember comments that it too was part of the=
 "affects performance", but I might be remembering wrong... and since you a=
re Author of them I assume you know better about the facts :)


That's why I listed them as an extra "hopefully helfpful" info and datapoin=
t that they work...
We have been carrying them in 5.10 series since we rebased to 5.10.8 on Jan=
uary 17th, 2021


but in the end it's up to the -stable maintainers as you point out...

--
Thomas

> --
> Ard.
>
>
>> applied in this order:
>>
>>   From 032d049ea0f45b45c21f3f02b542aa18bc6b6428 Mon Sep 17 00:00:00 2001
>> From: Uros Bizjak <ubizjak@gmail.com>
>> Date: Fri, 27 Nov 2020 10:44:52 +0100
>> Subject: [PATCH] crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%r=
eg
>>
>>   From ddf169a98f01d6fd46295ec0dd4c1d6385be65d4 Mon Sep 17 00:00:00 2001
>> From: Ard Biesheuvel <ardb@kernel.org>
>> Date: Tue, 8 Dec 2020 00:34:02 +0100
>> Subject: [PATCH] crypto: aesni - implement support for cts(cbc(aes))
>>
>>   From 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1 Mon Sep 17 00:00:00 2001
>> From: Ard Biesheuvel <ardb@kernel.org>
>> Date: Thu, 31 Dec 2020 17:41:54 +0100
>> Subject: [PATCH] crypto: x86/aes-ni-xts - use direct calls to and 4-way
>> stride
>>
>>   From 2481104fe98d5b016fdd95d649b1235f21e491ba Mon Sep 17 00:00:00 2001
>> From: Ard Biesheuvel <ardb@kernel.org>
>> Date: Thu, 31 Dec 2020 17:41:55 +0100
>> Subject: [PATCH] crypto: x86/aes-ni-xts - rewrite and drop indirections
>> via glue helper
>>
>> --
>> Thomas
>>


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2F62C8EED
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 21:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbgK3UTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 15:19:32 -0500
Received: from mout.web.de ([212.227.15.14]:45297 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729311AbgK3UTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Nov 2020 15:19:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1606767454;
        bh=KzC7zyFk9a9J+Nu244hAYKfVWqs3d3WUY6h75xZfNzM=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=SuLHekPapqE/fPOiTEi/xrhgYnhVn1LE4rMTIhLM7PDjV9c+7WaFhC5CPJ3SDmYi3
         Mw9WOS7Qf52FBJkD3E79aYQ0O5IGYQ0iW0ITp/ZFo2nUCGvuzR16Yc4szK8YDaASUQ
         S9py3yZJcd4ccdaw9lOysmLb4vp4tbuUdtGc5JXA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [10.0.0.110] ([185.159.157.20]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LakkS-1kLoXO1Lgm-00kOBq; Mon, 30
 Nov 2020 21:17:34 +0100
Subject: Re: [PATCH] Input: atmel_mxt_ts - Fix lost interrupts
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Linux Input <linux-input@vger.kernel.org>,
        Nick Dyer <nick.dyer@itdev.co.uk>,
        Jiada Wang <jiada_wang@mentor.com>,
        stable <stable@vger.kernel.org>
References: <20201128123720.929948-1-linus.walleij@linaro.org>
 <20201129025328.GH2034289@dtor-ws>
 <CACRpkdY8r5_EYAtWLL2vZQ8ULf6rG-VfgDe=7oveJQwiRXxTNg@mail.gmail.com>
 <20201130080108.GN2034289@dtor-ws>
From:   Andre Muller <andre.muller@web.de>
Message-ID: <49253725-7c3d-fce9-7000-6061ebe736bc@web.de>
Date:   Mon, 30 Nov 2020 21:18:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201130080108.GN2034289@dtor-ws>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:bh97UPmGfcHcoTyHjuBV0ADWo4zMrcWuQOdCiuQb8bn/SYOBDZy
 rNZLg8IyrHYcCJpykGKssEw1ptE4isF1EK0x7gEz8rH3UcUsqePAe0bkIB3FbZSzy2MC9Jp
 mAZaPAsG/hIVtdrCgaoYxTBlX+8xch0e1gnJOoO0JvCDt+FhA7qePaZ0FV9Srn8ySu9fDC7
 KSfDMEjmyNst6408KMH5g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hyGGXwkbfVI=:jHvye0207q4LF7J1uVw/C8
 YWBOU51BvyMphgUa+rBjtZ8KgmT9UIa9Y/gln8O1aTHPu1ulfdJzFaA9na4d0zt/dSK9+XITs
 s/uo0n1nF7U9H2OlPr5zVrOENuPCDdDmy6D2EgCxrLTevPrpCrSC+0kfGiitcK+Xmbn9dY4kC
 2KpFjyN701rPoPF+WSJ0v/cT5KrzjrkJQypykaEJY+66G4Z4kSsEIrCvUB7SgZSPFKu0cbpg+
 uGlDb3ZbSbcYBrQZelaZ9QyxOOOvmrOtl1nkuSBdSN3wK2bOPC1mATZbC3E6965i4QTQB8kpZ
 OiK5bMwLxZrv3lfMKlXrDhtaqymQDv0PzaQMbHOk0vtPdmZhX/ifNGC/CQ0Ta+Rbg10oIMwzb
 lFPiregZQouTE8b7j4P/kDkjHNCbRF0U+srA5CtEsVLrVtro4gFnk43V3h8JlGdDEIaBXqYqF
 1PyYDb2DVIIp5k7TQ4vbrgxwHQNs8VpBVK4x2h1oPKuVi4H7UKJBglNSoPQYyGSnVkSOMF/1o
 Rfy3U6dfIQAjwpQUWyzyiPkPDNSYYyHbDyO9mwx9+B8uv6xAV+ixfEl2YS/n4sQ8TA8mK/sn2
 6U1vh5GxnugWANpCC6NBmj13GgRtS1oXwaRvj3tJbbsjyHcWdrLDZGEvqsq1BXnIq089VvfXR
 s7bPecaUth4t+uNu9K689M/Up69mhhR4PH26BEcAkvh72d4ygw6N6BqourVeyHkibnEW0NKJJ
 kqul+otoRFhw9ljMQln2fMKVOxV3iaOliR6ptwqqjhhJ+jPbgeZC8IfMhkxkpTIhAQKWQxlZd
 JkAqdgWHHxhGVOSQE3w08Lqx4sSYB7SDmcdQNAlIcmZNPNxLU7RThejbphF09ETIEyD1u1PLH
 C5WCIDu+HAcAqQz/eAsA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/11/2020 09.01, Dmitry Torokhov wrote:
> On Sun, Nov 29, 2020 at 10:13:06PM +0100, Linus Walleij wrote:
>> On Sun, Nov 29, 2020 at 3:53 AM Dmitry Torokhov
>> <dmitry.torokhov@gmail.com> wrote:
>>> On Sat, Nov 28, 2020 at 01:37:20PM +0100, Linus Walleij wrote:
>>
>>>> @@ -1297,8 +1297,6 @@ static int mxt_check_retrigen(struct mxt_data *=
data)
>>>>        int val;is
>>>>        struct irq_data *irqd;
>>>>
>>>> -     data->use_retrigen_workaround =3D false;
>>>> -
>>>
>>> So this will result in data->use_retrigen_workaround staying "true" fo=
r
>>> level interrupts, which is not needed, as with those we will never los=
e
>>> an edge. So I think your patch can be reduced to simply setting
>>> data->use_retrigen_workaround to true in mxt_probe() and leaving
>>> mxt_check_retrigen() without any changes.
>>
>> I did that first but then I realized that since there is an
>> errorpath in mxt_check_retrigen() and it starts by disabling
>> the workaround so in an error occurs in
>> __mxt_read_reg() it will be left disabled.
>
> If __mxt_read_reg() fails then we will bail out and leave the device not
> operable, so leaving the workaround disabled does not change anything.
>
>>
>> But I see that I fail to account for the level-trigging
>> case where it should disable the workaround and
>> bail out so I anyway need to revise the patch.
>>
>>> However I wonder if it would not be better to simply call
>>> mxt_check_retrigen() before calling mxt_acquire_irq() in mxt_probe()
>>> instead of after.
>>
>> I don't fully understand this driver, but it seems the information
>> whether retrigen is available only appears after talking to the
>> device a bit, checking firmware and "objects" available on the
>> device and then it may already be too late.
>
> No, because the workaround is checked only in mxt_acquire_irq() which is
> called immediately preceding the check for RETRIGEN. And since
> __mxt_read_reg() is a wrapper around i2c_transfer() and does not need
> IRQs to be enalbed, we can move stuff around. Could you please check if
> the following works for you:
>
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/to=
uchscreen/atmel_mxt_ts.c
> index dde364dfb79d..2b3fff0822fe 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -2185,11 +2185,11 @@ static int mxt_initialize(struct mxt_data *data)
>   		msleep(MXT_FW_RESET_TIME);
>   	}
>
> -	error =3D mxt_acquire_irq(data);
> +	error =3D mxt_check_retrigen(data);
>   	if (error)
>   		return error;
>
> -	error =3D mxt_check_retrigen(data);
> +	error =3D mxt_acquire_irq(data);
>   	if (error)
>   		return error;

This swap also fixes the driver for me. So both Linus' and your approach w=
ork here.

The log says
[    0.212647] atmel_mxt_ts i2c-ATML0000:01: Family: 164 Variant: 17 Firmw=
are V1.0.AA Objects: 32
[    0.212804] atmel_mxt_ts i2c-ATML0000:01: Enabling RETRIGEN workaround
[    0.228469] atmel_mxt_ts i2c-ATML0000:01: Direct firmware load for maxt=
ouch.cfg failed with error -2
[    0.229979] atmel_mxt_ts i2c-ATML0000:01: Touchscreen size X960Y540
[    0.230023] input: Atmel maXTouch Touchpad as /devices/pci0000:00/INT34=
32:00/i2c-0/i2c-ATML0000:01/input/input4
[    0.236080] atmel_mxt_ts i2c-ATML0001:01: Family: 164 Variant: 13 Firmw=
are V1.0.AA Objects: 41
[    0.236478] atmel_mxt_ts i2c-ATML0001:01: Enabling RETRIGEN workaround
[    0.256034] atmel_mxt_ts i2c-ATML0001:01: Direct firmware load for maxt=
ouch.cfg failed with error -2
[    0.257608] atmel_mxt_ts i2c-ATML0001:01: Touchscreen size X2559Y1699
[    0.257642] input: Atmel maXTouch Touchscreen as /devices/pci0000:00/IN=
T3433:00/i2c-1/i2c-ATML0001:01/input/input5

Thank you,
Andre


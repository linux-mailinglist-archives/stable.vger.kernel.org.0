Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16E2341486
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 06:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbhCSFH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 01:07:57 -0400
Received: from out28-5.mail.aliyun.com ([115.124.28.5]:56792 "EHLO
        out28-5.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbhCSFHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 01:07:19 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07522347|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.068958-0.000902345-0.93014;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047208;MF=zhouyu@wanyeetech.com;NM=1;PH=DS;RN=8;RT=8;SR=0;TI=SMTPD_---.Jn74g0w_1616130428;
Received: from 192.168.88.129(mailfrom:zhouyu@wanyeetech.com fp:SMTPD_---.Jn74g0w_1616130428)
          by smtp.aliyun-inc.com(10.147.41.178);
          Fri, 19 Mar 2021 13:07:10 +0800
Subject: Re: [PATCH v7 RESEND] MIPS: force use FR=0 or FRE for FPXX binaries
To:     YunQiang Su <wzssyqa@gmail.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        YunQiang Su <yunqiang.su@cipunited.com>,
        linux-mips <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        stable@vger.kernel.org
References: <20210312104859.16337-1-yunqiang.su@cipunited.com>
 <20210315145850.GA12494@alpha.franken.de>
 <alpine.DEB.2.21.2103172345020.21463@angie.orcam.me.uk>
 <CAKcpw6UwYXYMCGw1C+nrRQLcqouxXCgdkDLZfK4fNFz+nVwZiQ@mail.gmail.com>
From:   Zhou Yanjie <zhouyu@wanyeetech.com>
Message-ID: <81f800a5-77c7-e5f6-f77c-0bd1f4694dab@wanyeetech.com>
Date:   Fri, 19 Mar 2021 13:07:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAKcpw6UwYXYMCGw1C+nrRQLcqouxXCgdkDLZfK4fNFz+nVwZiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2021/3/19 上午9:38, YunQiang Su wrote:
> Maciej W. Rozycki <macro@orcam.me.uk> 于2021年3月18日周四 上午7:16写道：
>> On Mon, 15 Mar 2021, Thomas Bogendoerfer wrote:
>>
>>>> In Golang, now we add the FP32 annotation, so the future golang programs
>>>> won't have this problem. While for the existing binaries, we need a
>>>> kernel workaround.
>>> what about just rebuilding them ? They are broken, so why should we fix
>>> broken user binaries with kernel hacks ?
>>   I agree.
>>
>>   I went ahead and double-checked myself what the situation is here since I
>> could not have otherwise obtained the answer to the question I asked, and
>> indeed as I suspected even the simplest Go program will include a dynamic
>> libgo reference (`libgo.so.17' with the snapshot of GCC 11 I have built
>> for the MIPS target).  So a userland workaround is as simple as relinking
>> this single library for the FP32 model.  This will make the dynamic loader
>> force the FR=0 mode for all the executables that load the library.
>>
> In fact gccgo has no problem here at all.
> The problem is about Google's golang: golang.org
>
>>   Since as YunQiang says they're going to rebuild Golang with FP32
>> annotation anyway, which will naturally apply to the dynamic libgo library
>> as well, this will fix the problem with the existing binaries in the
>> current distribution.  Given that this is actually a correct fix (another
>> one is required for the linker bug) I see no reason to clutter the kernel
>> with a hack.  Especially as users will have to update a component anyway,
>> in this case the Go runtime rather than the kernel (which is better even,
>> as you don't have to reboot).
>>
> Normally Go has no runtime. For Debian, we patched golang-1.15, and all
> go objects in Debian bullseye will be OK.
>
> While, the objects in Debian buster or previous version or other distribution
> may still broken.
>
> The user may need to run these application on a kernel with O32_FP64
> support enabled.


Yes, Ingenic X2000 processor has encountered this problem. In fact, all 
MIPS32r5 and MIPS32r6 processors may encounter this problem (because 
O32_FP64 is selected by default on MIPS32r5 and MIPS32r6), and we have 
indeed encountered this when running docker on debian10, our solution is 
similar to the current Yunqiang's method.


Thanks and best regards!


>>   Once Golang has been modernised to use the FPXX mode the problem will go
>> away, and given the frequent version bumps in libgo's soname the current
>> breakage won't be an issue for whatever future version of Debian includes
>> it as the whole distribution will of course have been rebuilt against the
>> new library and any old broken executables kept by the user with a system
>> upgrade will continue using the old FP32 dynamic library.
>>
> Yes. As show on commit-msg, the patches for Golang have been accepted.
> https://go-review.googlesource.com/c/go/+/239217
> https://go-review.googlesource.com/c/go/+/237058
>
> The bad news is  that (Google's) Go has no runtime.
>
>>>> Currently, FR=1 mode is used for all FPXX binary, it makes some wrong
>>>> behivour of the binaries. Since FPXX binary can work with both FR=1 and FR=0,
>>>> we force it to use FR=0 or FRE (for R6 CPU).
>>> I'm not sure, if I want to take this patch.
>>>
>>> Maciej, what's your take on this ?
>>   Given what I have written previously and especially above I maintain my
>> objection.  I don't understand why we're supposed to do people's homework
>> though and solve their problems.
>>
>>    Maciej
>
>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C897380912
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 13:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbhENMAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 08:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbhENMAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 08:00:05 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558BDC061574;
        Fri, 14 May 2021 04:58:53 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id o26-20020a1c4d1a0000b0290146e1feccdaso2303710wmh.0;
        Fri, 14 May 2021 04:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aCQ7Xti4PZasTG5XmR78Be2WTvCnA6stEZ6OIez+DO8=;
        b=hvgDeFxdax+NDVnn7GjHSsv5ovdVpKDKzRxyHuLZFge8HXhtM1zYd/uoGMKcVMBsBG
         xL6LF7a7H9ZF5Bbpf9665XCE5UShHwZPvKj6v8furjKeTyTsmZtsUmmsqWpUqSw8lhm/
         rDwTN6U+eiKNOG1T6nhV91Ab7FUTn70tTw1KKIeT4rNAfKC60J2LnWwaMF0eiFvKszUP
         7qvXsVG0Gi8jh7H2deqaDxTBfxXoYXyJTmSmA6irYCp1Se+vo3rDr4lG3AuS4LZ6HOJQ
         CONjS9+HLdj/pPPnVQi5rr5t+FFFAwDw3tIP1r3jSXP5T4+LLvarDLvXEdmN1VetC/MC
         GH7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aCQ7Xti4PZasTG5XmR78Be2WTvCnA6stEZ6OIez+DO8=;
        b=gYIyNG2wC5zovKM7OXG/4mVUyIPVzgM+jbFEsQDH+YIUUGOmk2u1/RQyQLT1RtMCdQ
         m6WIP1qKBIAnZCSOLdKziNrMwNQxbT87XBbPEluhdazDXfGGpASFwjJU0hy2jpCzpboU
         zvg0OA0LJDE3cIB9z7zatTjCkgvjkQEmMeiNKA8SlSpTYGPp8/0A8sP91z0XyhHZsNnX
         vp3cKFhT7NOhjDa9VWGesW5DYAVWeTtpsbf6X3Ul8ShJca0HrRJz4I1dAv9o2gUcHv4t
         rh6gzs1HKF+7SKdYKMPJL5mMKu3D73eZ1o4ucKgwk3++OeL5yWtbk3feTAvKVx7bKqZu
         CCjg==
X-Gm-Message-State: AOAM533gp8Wg4+MfYFNgBhljc7PkwyL/Na1B4ia3sW/SAx7XMGB2bZuJ
        EAe8KtY91pJel5B80F2NXqDqAE8v38c=
X-Google-Smtp-Source: ABdhPJxJcWpIatDjv4qP3+6HFs5PtIFhum46hfqDCzSYDKPmcqaM//DX+T/yKDmuALnbO1uiotvbGQ==
X-Received: by 2002:a1c:7c03:: with SMTP id x3mr9282653wmc.168.1620993531485;
        Fri, 14 May 2021 04:58:51 -0700 (PDT)
Received: from [192.168.2.202] (pd9e5a369.dip0.t-ipconnect.de. [217.229.163.105])
        by smtp.gmail.com with ESMTPSA id o21sm6292260wrf.91.2021.05.14.04.58.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 04:58:51 -0700 (PDT)
Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
To:     Sachi King <nakato@nakato.io>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        David Laight <David.Laight@aculab.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20210512210459.1983026-1-luzmaximilian@gmail.com>
 <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com>
 <e43d9a823c9e44bab0cdbf32a000c373@AcuMS.aculab.com> <3034083.sOBWI1P7ec@yuki>
From:   Maximilian Luz <luzmaximilian@gmail.com>
Message-ID: <5c08541a-2615-f075-a189-0462f1005007@gmail.com>
Date:   Fri, 14 May 2021 13:58:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <3034083.sOBWI1P7ec@yuki>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/14/21 9:41 PM, Sachi King wrote:
> On Thursday, May 13, 2021 8:36:27 PM AEST David Laight wrote:
>>> -----Original Message-----
>>> From: Maximilian Luz <luzmaximilian@gmail.com>
>>> Sent: 13 May 2021 11:12
>>> To: David Laight <David.Laight@ACULAB.COM>; Thomas Gleixner
>>> <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; Borislav Petkov
>>> <bp@alien8.de>
>>> Cc: H. Peter Anvin <hpa@zytor.com>; Sachi King <nakato@nakato.io>;
>>> x86@kernel.org; linux-kernel@vger.kernel.org; stable@vger.kernel.org
>>> Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
>>>
>>> On 5/13/21 10:10 AM, David Laight wrote:
>>>
>>>> From: Maximilian Luz
>>>>
>>>>> Sent: 12 May 2021 22:05
>>>>>
>>>>>
>>>>>
>>>>> The legacy PIC on the AMD variant of the Microsoft Surface Laptop 4
>>>>> has
>>>>> some problems on boot. For some reason it consistently does not
>>>>> respond
>>>>> on the first try, requiring a couple more tries before it finally
>>>>> responds.
>>>>
>>>>
>>>>
>>>> That seems very strange, something else must be going on that causes the
>>>> grief.
>>>> The 8259 will be built into to the one of the cpu support
>>>> chips.
>>>> I can't imagine that requires anything special.
>>>
>>>
>>> Right, it's definitely strange. Both Sachi (I imagine) and I don't know
>>> much about these devices, so we're open for suggestions.
>>
>>
>> I found a copy of the datasheet (I don't seem to have the black book):
>>
>> https://pdos.csail.mit.edu/6.828/2010/readings/hardware/8259A.pdf
>>
>> The PC hardware has two 8259 in cascade mode.
>> (Cascaded using an interrupt that wasn't really using in the original
>> 8088 PC which only had one 8259.)
>>
>> I wonder if the bios has actually initialised is properly.
>> Some initialisation writes have to be done to set everything up.
> 
> I suspect by the displayed behaviour you are correct and that it has
> not.  I'm struggling to figure out who to talk to to see that is
> something that can be fixed in the firmware.

I'd assume that _some_ sort of interrupt setup is done by the BIOS/UEFI.
The UEFI on those devices is fairly well-featured, with touch support
via SPI and all. Furthermore, keyboard (also supported in the device's
UEFI) is handled via a custom UART protocol. Unless they rely on polling
for all of that, I believe they'd have to set up some interrupts.

Although, as you mention later on, that could also be handled via the
IOAPIC and the PIC is actually not supposed to be used. Maybe some
legacy component that never got tested and just broke with some new
hardware/firmware revision without anyone noticing? And since Linux
still seems to rely on that, we might be the first to notice.

Regards,
Max

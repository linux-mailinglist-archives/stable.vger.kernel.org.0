Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E84C3813E0
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 00:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbhENWtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 18:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhENWtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 18:49:00 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6021C06174A;
        Fri, 14 May 2021 15:47:47 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n17-20020a7bc5d10000b0290169edfadac9so2107019wmk.1;
        Fri, 14 May 2021 15:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3sv6+sy6PPyQ0Uy7YaZsaRssphjHxRbRKJe2gYyNEm4=;
        b=qCQAJEPQVoVk4DsbU0zQUCM/XhX+Q96mX0Z137mcADPsf76OMYDKc/Da95ZZkuhf8u
         vwg78ZnmIhfb3qpNWfl4ovLfDy7fxY+MHngvynA41dnb/gbYkQu6kPUvX4dKwJGFUYaC
         JdBf7WxzA+hTgq5hcPIfA/1qO+PnSSMl0mnMHIvpVTtNlWK8XoiwAMC5NmsGIt63vQwa
         YfuAsdSbFdByOyDnxG52ijn4J500u98SEEHwUiUdfR7WE3z4VexoND2haPVo1oVs9CGW
         m7oC5FAtOxJqY6sH1HgbUgsye4Bp9Atv8WgxSdWfFOpUq1WsjWvHoSPMkE9HkKxOFMgA
         dD6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3sv6+sy6PPyQ0Uy7YaZsaRssphjHxRbRKJe2gYyNEm4=;
        b=YA3QYGNKV/NmOW0iWNBlcbB5RoEcVdsZ8FGwP56hfXIeyREqduGz1jydu1zFKFfo1A
         iib9yDtymKL/J54suwnenht75Ted6qEmb9qx2N84aGGzZCj7GUeLQMlWEE9E3inQ4Dv6
         9mo1IZD2jfcCL6CnARG8nkg/n0AMu5Kk/5st5DxSBySOT5EGsL8g5ZMoRSL9sXO+BXKN
         xUmqbA5HR65/krXJg5DNBqSs4v7/8d9sa7yGWwxRtWJSiJdVRcbvV1sHPEoTmAPjxg3Y
         HO1/UyDHPzlV171CMdXfOXCaduEKn69HuTViWXTdyIImC8TaA/UsmG8pWP+41pDnvJRx
         tubg==
X-Gm-Message-State: AOAM531vVwxdlUvK5VqBrlNOZi13ADCa4VRq+GO/vjAaTmt+WiY1ictC
        BjtMTfmfQBl907V/Y3zEQjBKu96C9Bk=
X-Google-Smtp-Source: ABdhPJyWDtULJ6dqVycOKAKJ41tvBm9xgxIXe7faKsSHAU/f0/nIeD8awCqvGHH5XpqkTK9usA9X/g==
X-Received: by 2002:a1c:e908:: with SMTP id q8mr52032966wmc.136.1621032465798;
        Fri, 14 May 2021 15:47:45 -0700 (PDT)
Received: from [192.168.2.202] (pd9e5a369.dip0.t-ipconnect.de. [217.229.163.105])
        by smtp.gmail.com with ESMTPSA id m22sm12910664wml.40.2021.05.14.15.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 15:47:45 -0700 (PDT)
Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
To:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sachi King <nakato@nakato.io>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        David Laight <David.Laight@aculab.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20210512210459.1983026-1-luzmaximilian@gmail.com>
 <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com>
 <e43d9a823c9e44bab0cdbf32a000c373@AcuMS.aculab.com> <3034083.sOBWI1P7ec@yuki>
 <5c08541a-2615-f075-a189-0462f1005007@gmail.com>
 <87im3l43w9.ffs@nanos.tec.linutronix.de>
 <c26954e1-bb2f-086a-9c7f-68382978efe7@zytor.com>
From:   Maximilian Luz <luzmaximilian@gmail.com>
Message-ID: <087c418e-53fb-b3a6-0d9b-e738e4c821c7@gmail.com>
Date:   Sat, 15 May 2021 00:47:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c26954e1-bb2f-086a-9c7f-68382978efe7@zytor.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/14/21 7:35 PM, H. Peter Anvin wrote:
> On 5/14/21 10:32 AM, Thomas Gleixner wrote:
>>
>> That's a valid assumption. As I said, we can make IOAPIC work even w/o
>> PIC. I'll have a look how much PIC assumptions are still around.
>>
> 
> As far as I read, the problem isn't actually the absence of a PIC (we definitely boot systems without PICs all the time now), but rather that the PIC is advertised in ACPI but is buggy or absent; a similar platform with different firmware doesn't have problem.
> 
> If my understanding of the thread is correct, it's quirk fodder.

I believe the theory was that, while the PIC is advertised in ACPI, it
might be expected to not be used and only present for some legacy reason
(therefore untested and buggy). Which I believe led to the question
whether we shouldn't prefer IOAPIC on systems like that in general. So I
guess it comes down to how you define "systems like that". By Tomas'
comment, I guess it should be possible to implement this as "systems
that should prefer IOAPIC over legacy PIC" quirk.

I guess all modern machines should have an IOAPIC, so it might also be
preferable to expand that definition, maybe over time and with enough
testing.

If possible, I think that would be preferable to the "just retry until
it works" kind of workaround.

As Sachi mentioned in her reply:

> I'm not sure the i8259 is needed on the device, as the interrupts
> appear to function on the device if I bypass the nr_legacy_irqs() check
> while the legacy_pic is set to the null_legacy_pic.
> 
> The null_legacy_pic however specifies having 0 irqs, and the io_apic
> does not allow us to set the pin attributes unless the pin we are
> attempting to set is less than nr_legacy_irqs.
> 
> The IOAPIC seems to take responsibility for the 0-15 interrupts on this
> specific hardware, should we maybe be ignoring the i8259 and looking
> into allowing interrupts 0-15 to be setup even when the legacy_pic is
> not available?

Just my two cents, please keep in mind that I'm out of my depth here.

Regards,
Max

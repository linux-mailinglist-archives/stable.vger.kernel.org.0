Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E94D3F10D5
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 04:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbhHSC5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 22:57:48 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:59888
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235670AbhHSC5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 22:57:48 -0400
Received: from [10.101.195.16] (61-220-137-34.HINET-IP.hinet.net [61.220.137.34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 1AFA73F0A4;
        Thu, 19 Aug 2021 02:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629341832;
        bh=zd24ShjETIBb3VdsEFylti7pguDbAOi+crz0HQGHSPc=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=sZRwWLcmTNKZ+eLpQC1oPIeeoCPMEIxzVhNKR1ZdYNsGD7vQ1ul4Ks2tfcHnMJs4Q
         /gPy85i9BQ8bwZI1+eaSwjqTT7IyxAxh+EyFeMXxaOO/NqY9bEuIRzgJwRYmX0fpFU
         Dg11y2VgTFNV9OoJ0GBiIyTMH0hdVEWddJ/pT/MEE+s2kznKFJzuSIgmxzaRQTU0+B
         cy1Eu0Qe2YKmo67Fk8utcgpaW7yh9VlgkHJkMZLKqCZ9/pfQBQqvJN1q6ARcYZK9dG
         TaHrLVvn+F0OuzuIk1ns2YYL+wGPa+UOgfzlfLA34gV+5KUE2S6s0e8iqC2oQifGoi
         UQ/ph7Xg0H+mQ==
Subject: Re: the commit c434e5e48dc4 (rsi: Use resume_noirq for SDIO)
 introduced driver crash in the 4.15 kernel
To:     Marek Vasut <marex@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        =?UTF-8?Q?Guido_G=c3=bcnther?= <agx@sigxcpu.org>
References: <2b77868b-c1e6-9f30-9640-5c82a82f5b31@canonical.com>
 <YRybjZdFngJr9R8i@kroah.com> <6abb6c93-b9d6-c173-7fe1-fcf3b0abd615@denx.de>
From:   Hui Wang <hui.wang@canonical.com>
Message-ID: <4a29398d-4253-201d-11bb-30a5c511f7b2@canonical.com>
Date:   Thu, 19 Aug 2021 10:57:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6abb6c93-b9d6-c173-7fe1-fcf3b0abd615@denx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 8/18/21 5:04 PM, Marek Vasut wrote:
> On 8/18/21 7:33 AM, Greg Kroah-Hartman wrote:
>> On Wed, Aug 18, 2021 at 12:06:15PM +0800, Hui Wang wrote:
>>> Hi Marex,
>>>
>>> We backported this patch to ubuntu 4.15.0-generic kernel, and found 
>>> this
>>> patch introduced the rsi driver crashing when running system resume 
>>> on the
>>> Dell 300x IoT platform (100% rate). Below is the log, After seeing 
>>> this log,
>>> the rsi wifi can't work anymore, need to run 'rmmod rsi_sdio;modprobe
>>> rsi_sdio" to make it work again.
>>>
>>> So do you know what is missing apart from this patch or this patch 
>>> is not
>>> suitable for 4.15 kernel at all?
>>
>> Does 4.19.191 work for this system?  Why not just use that or newer
>> instead?
>
> I haven't seen this on linux-stable 5.4.y or 5.10.y, if that 
> information is of any use.
>
> But I have to admit, I am tempted to mark the whole driver as BROKEN 
> and submit that for stable backports.
>
> Because that is what it is, it is buggy, broken, and the hardware 
> lacks any documentation. I spent an insane amount of time talking to 
> RedPine Signals / SiLabs trying to get help with basic things like 
> association problems against various APs, no result there. I tried 
> getting hardware docs from them so I can fix the driver myself, no 
> result either. So far I tried to pick various fixes from their 
> downstream driver and submit them, but that is massively time 
> consuming and the changes there are not separated or documented, it is 
> just one large chunk of code.
>
> As far as I can tell, they also have no interest in fixing the driver 
> or helping others with fixing it, so maybe we should just mark it as 
> broken ... :-(

Hi Marek,

Got it, thanks for sharing it.

Hi Greg,

I just tested the 4.19.191, got the same result, the wifi will crash 
after resume under 4.19.191:

admin@HW6VB02:~$ uname -a
Linux HW6VB02 4.19.191 #1 SMP Thu Aug 19 10:19:32 CST 2021 x86_64 x86_64 
x86_64 GNU/Linux

[   59.682908] sdhci-acpi INT33BB:00: pre_suspend failed for 
non-removable host: -38
[   59.682917] Freezing user space processes ... (elapsed 0.003 seconds) 
done.
[   59.686063] OOM killer disabled.
[   59.686065] Freezing remaining freezable tasks ... (elapsed 0.001 
seconds) done.
[   59.687385] Suspending console(s) (use no_console_suspend to debug)
[   59.687931] rsi_91x: ===> Interface DOWN <===
[   70.068983] mmc1: Controller never released inhibit bit(s).
[   70.068992] mmc1: sdhci: ============ SDHCI REGISTER DUMP ===========
[   70.069002] mmc1: sdhci: Sys addr:  0xffffffff | Version: 0x0000ffff
[   70.069009] mmc1: sdhci: Blk size:  0x0000ffff | Blk cnt: 0x0000ffff
[   70.069016] mmc1: sdhci: Argument:  0xffffffff | Trn mode: 0x0000ffff
[   70.069023] mmc1: sdhci: Present:   0xffffffff | Host ctl: 0x000000ff
[   70.069030] mmc1: sdhci: Power:     0x000000ff | Blk gap: 0x000000ff
[   70.069036] mmc1: sdhci: Wake-up:   0x000000ff | Clock: 0x0000ffff
[   70.069043] mmc1: sdhci: Timeout:   0x000000ff | Int stat: 0xffffffff


So let us revert this commit from 4.19.y?

Thanks,

Hui.


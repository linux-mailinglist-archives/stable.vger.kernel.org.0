Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071B03F1797
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 12:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238250AbhHSK6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 06:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238284AbhHSK6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 06:58:33 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D061C061575
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 03:57:56 -0700 (PDT)
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id E6E6D82C24;
        Thu, 19 Aug 2021 12:57:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1629370674;
        bh=3SmDflSJB3g+ms1TMoGW9ZFyLpED0vqFJdPS8Rd1GPw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=kEze73CBl6LZxSfyIY4EkT7PKJqm2NxFysoRDMzckVxiGvM+UgALeeSbApiIWKd87
         0rcMQokBmZLZMrwuuhyk70G2L421Yp089Cduhd5hyZ2UD30aPvz0dYFR3pKwoGgyaa
         hFbw1iQLHQL7ZlpHd2bgg5fPIXbswOlEIGpb7hHkdqvfBEqrtMugMTInnvKLn6x1RY
         ZhNgew3yQSMY4zG8+xl7wD6+tZBMhNBT2LIck7yIWDe3U8EZItwXnHiggeTlNDzUdW
         MmSa8PtCR53sLyWWhY67PqqkKGIUdVLc2ZMAIJu9qfPfyqBRtiglfG9m/fqbH2b/BO
         BUhnVXS+3QR1Q==
Subject: Re: the commit c434e5e48dc4 (rsi: Use resume_noirq for SDIO)
 introduced driver crash in the 4.15 kernel
To:     Hui Wang <hui.wang@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        =?UTF-8?Q?Guido_G=c3=bcnther?= <agx@sigxcpu.org>
References: <2b77868b-c1e6-9f30-9640-5c82a82f5b31@canonical.com>
 <YRybjZdFngJr9R8i@kroah.com> <6abb6c93-b9d6-c173-7fe1-fcf3b0abd615@denx.de>
 <4a29398d-4253-201d-11bb-30a5c511f7b2@canonical.com>
 <YR3svHFF1vheoQyb@kroah.com> <eb9d1eeb-e1d3-6cde-41d7-450a60839425@denx.de>
 <4a508cab-aa2f-5e3f-7465-a91859aa246f@canonical.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <2406b072-7330-6715-5e67-98c70d94c5b7@denx.de>
Date:   Thu, 19 Aug 2021 12:57:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <4a508cab-aa2f-5e3f-7465-a91859aa246f@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/19/21 10:52 AM, Hui Wang wrote:
> 
> On 8/19/21 3:49 PM, Marek Vasut wrote:
>> On 8/19/21 7:31 AM, Greg Kroah-Hartman wrote:
>>> On Thu, Aug 19, 2021 at 10:57:03AM +0800, Hui Wang wrote:
>>>>
>>>> On 8/18/21 5:04 PM, Marek Vasut wrote:
>>>>> On 8/18/21 7:33 AM, Greg Kroah-Hartman wrote:
>>>>>> On Wed, Aug 18, 2021 at 12:06:15PM +0800, Hui Wang wrote:
>>>>>>> Hi Marex,
>>>>>>>
>>>>>>> We backported this patch to ubuntu 4.15.0-generic kernel, and
>>>>>>> found this
>>>>>>> patch introduced the rsi driver crashing when running system
>>>>>>> resume on the
>>>>>>> Dell 300x IoT platform (100% rate). Below is the log, After
>>>>>>> seeing this log,
>>>>>>> the rsi wifi can't work anymore, need to run 'rmmod 
>>>>>>> rsi_sdio;modprobe
>>>>>>> rsi_sdio" to make it work again.
>>>>>>>
>>>>>>> So do you know what is missing apart from this patch or this
>>>>>>> patch is not
>>>>>>> suitable for 4.15 kernel at all?
>>>>>>
>>>>>> Does 4.19.191 work for this system?  Why not just use that or newer
>>>>>> instead?
>>>>>
>>>>> I haven't seen this on linux-stable 5.4.y or 5.10.y, if that 
>>>>> information
>>>>> is of any use.
>>>>>
>>>>> But I have to admit, I am tempted to mark the whole driver as 
>>>>> BROKEN and
>>>>> submit that for stable backports.
>>>>>
>>>>> Because that is what it is, it is buggy, broken, and the hardware 
>>>>> lacks
>>>>> any documentation. I spent an insane amount of time talking to RedPine
>>>>> Signals / SiLabs trying to get help with basic things like association
>>>>> problems against various APs, no result there. I tried getting 
>>>>> hardware
>>>>> docs from them so I can fix the driver myself, no result either. So 
>>>>> far
>>>>> I tried to pick various fixes from their downstream driver and submit
>>>>> them, but that is massively time consuming and the changes there 
>>>>> are not
>>>>> separated or documented, it is just one large chunk of code.
>>>>>
>>>>> As far as I can tell, they also have no interest in fixing the 
>>>>> driver or
>>>>> helping others with fixing it, so maybe we should just mark it as 
>>>>> broken
>>>>> ... :-(
>>>>
>>>> Hi Marek,
>>>>
>>>> Got it, thanks for sharing it.
>>>>
>>>> Hi Greg,
>>>>
>>>> I just tested the 4.19.191, got the same result, the wifi will crash 
>>>> after
>>>> resume under 4.19.191:
>>>>
>>>> admin@HW6VB02:~$ uname -a
>>>> Linux HW6VB02 4.19.191 #1 SMP Thu Aug 19 10:19:32 CST 2021 x86_64 
>>>> x86_64
>>>> x86_64 GNU/Linux
>>>>
>>>> [   59.682908] sdhci-acpi INT33BB:00: pre_suspend failed for 
>>>> non-removable
>>>> host: -38
>>>> [   59.682917] Freezing user space processes ... (elapsed 0.003 
>>>> seconds)
>>>> done.
>>>> [   59.686063] OOM killer disabled.
>>>> [   59.686065] Freezing remaining freezable tasks ... (elapsed 0.001
>>>> seconds) done.
>>>> [   59.687385] Suspending console(s) (use no_console_suspend to debug)
>>>> [   59.687931] rsi_91x: ===> Interface DOWN <===
>>>> [   70.068983] mmc1: Controller never released inhibit bit(s).
>>>> [   70.068992] mmc1: sdhci: ============ SDHCI REGISTER DUMP 
>>>> ===========
>>>> [   70.069002] mmc1: sdhci: Sys addr:  0xffffffff | Version: 0x0000ffff
>>>> [   70.069009] mmc1: sdhci: Blk size:  0x0000ffff | Blk cnt: 0x0000ffff
>>>> [   70.069016] mmc1: sdhci: Argument:  0xffffffff | Trn mode: 
>>>> 0x0000ffff
>>>> [   70.069023] mmc1: sdhci: Present:   0xffffffff | Host ctl: 
>>>> 0x000000ff
>>>> [   70.069030] mmc1: sdhci: Power:     0x000000ff | Blk gap: 0x000000ff
>>>> [   70.069036] mmc1: sdhci: Wake-up:   0x000000ff | Clock: 0x0000ffff
>>>> [   70.069043] mmc1: sdhci: Timeout:   0x000000ff | Int stat: 
>>>> 0xffffffff
>>>>
>>>>
>>>> So let us revert this commit from 4.19.y?
>>>
>>> If you revert it, does it work properly?  What about in Linus's tree?
> 
> I reverted the commit in the 4.19.191, then the wifi could work both 
> before and after the system resume. I tested the mainline kernel 
> linux-5.13, before suspend, the wifi could work, after suspend, the 
> whole system can't wakeup, and I couldn't recover the system since I 
> can't access the machine physically. I did all test via ssh remotely. So 
> there is no testing result for Linus' tree.

I suspect you just hit the issue this patch was trying to fix then.

If you have console access, use no_console_suspend to see the backtrace 
on wake up.

>> I suspect in that case, sdio_claim_host() will spin indefinitely and 
>> never finish, see the c434e5e48dc4e ("rsi: Use resume_noirq for SDIO") 
>> commit message.
> At least, we never seen this issue in the kernel 4.15, without the 
> commit of c434e5e48dc4e ("rsi: Use resume_noirq for SDIO"), the wifi and 
> bluetooth works well before and after suspend.

I suspect you might've just been lucky with that, because it seems RSI 
did hit it too (see below). This could also be something which triggers 
only on specific controller drivers (?).

>>
>> Note that I did my tests on ARM MMCI (stm32mp1 variant).
> The platform I am testing is a X86 one, and the sdhci controller driver 
> is sdhci_acpi.c.

Do you have an RSI module which can be plugged into an SD card slot 
there , or is that RSI module soldered-on on some devkit/board ?

Mine is the later, soldered on a SoM, so I have hard time testing on 
other SDIO controllers.

>> This "[   70.068983] mmc1: Controller never released inhibit bit(s)" 
>> looks suspicious in the log above.
>>
>> Also, newer versions of the RSI downstream driver [1] as of 390542d 
>> ("Updated Readme.txt file") simply comment out 
>> rsi_sdio_enable_interrupts() in rsi/rsi_91x_sdio.c rsi_resume(), which 
>> looks like RSI ran into the same problem, but "fixed" it differently. 
>> I think that approach RSI took is wrong and it just hid the issue.
>>
>> [1] git://github.com/SiliconLabs/RS911X-nLink-OSD

The bottom line is, I would really prefer to figure out what the problem 
that you see on the Linux 5.13.y is and fix that and backport that fix, 
so the suspend/resume works correctly for everyone ; rather than revert 
a patch without really understanding the underlying problem.

Sadly, the RSI driver is buggy.

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967696D447A
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 14:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDCMdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 08:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDCMdz (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 3 Apr 2023 08:33:55 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7550C83;
        Mon,  3 Apr 2023 05:33:53 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id CE7C4604FA;
        Mon,  3 Apr 2023 14:33:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1680525230; bh=eb0AyjBPMDuThx+hjXzeYamp4yHJ0OrViP+dPg5QOvw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=vDyN+JS0aqaXu8dyTvE9oJjedU6VyTGirtDDKBv7WBmInVKjsWYdxJycvU2lIjQ6k
         hUS7Py4R7TNLNHsDZC/l1K/FevmBsJged2HKTQEEr4tYRY3gV6jsuXtGJDY/ANbJqK
         yQ/pGcclzDcttY5GFXHw08S2ZrV4W0atNg0wlZgkxoRzQbQWfPdBI/37vY64mFTH5l
         nm8OIyyShTnqktCLJXOGAc7tXd4sFMPqNYshSCNFiGUpkOseHDRXVOHWQqguDdhUEB
         ZTlvtUQ5xwShkyrW9CemdtFdkbVF1M/wGi8EktCsrEBFvOIcuFGaGFpdl/YkUZbCyh
         wOnKzUKXvHcQQ==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wXwnEofxtDMs; Mon,  3 Apr 2023 14:33:47 +0200 (CEST)
Received: from [10.0.1.57] (grf-nat.grf.hr [161.53.83.23])
        by domac.alu.hr (Postfix) with ESMTPSA id 92EF2604F7;
        Mon,  3 Apr 2023 14:33:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1680525227; bh=eb0AyjBPMDuThx+hjXzeYamp4yHJ0OrViP+dPg5QOvw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=T8Wj6NmMNdlwYmraISn1lF0H2hNnehVn+Gjw4FM1M0HAfXCNaZk9IbBospl3sCpeF
         I7pIutTC/isdWYburofzoqt8uFjJ0J5OzaoGTSWbiKBtDQA5z5JigeaXXMcuLCBxQX
         FILhCCrpWx8857OPTORPJ/lS3LuEb2C8iyy9rz8OWlHd4bbwMedkR2zFM7KcwJaSmc
         qRgWWK1jO77E10EtqBHs4Quksyf5LLFtLijt+bzCiXOKV/kO/fPglwxxHNKUzOnHwk
         e2P5H/Tik9AoT09o8wCwjFI0SbjVPvmrq19hX3tJSYvD6dm/YkhcE48Y8YCGbRKQXI
         SYI+9MbDDj2Fw==
Message-ID: <fe801be6-8592-75d3-9cf0-d91c6a9bf2d0@alu.unizg.hr>
Date:   Mon, 3 Apr 2023 14:33:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 3/3] xhci: Free the command allocated for setting LPM if
 we return early
Content-Language: en-US, hr
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-usb@vger.kernel.org, Stable@vger.kernel.org
References: <20230330143056.1390020-1-mathias.nyman@linux.intel.com>
 <20230330143056.1390020-4-mathias.nyman@linux.intel.com>
 <2219a894-eb79-70a4-2b92-2b7ee7e1e966@alu.unizg.hr>
 <2023040352-case-barterer-ccd1@gregkh>
 <eb08643a-eae1-dd59-ba89-bf593405c09f@alu.unizg.hr>
 <711ff3f6-d449-c835-7c0b-4f7a1527a2f7@alu.unizg.hr>
 <2023040339-eastbound-boggle-02ca@gregkh>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <2023040339-eastbound-boggle-02ca@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3.4.2023. 10:28, Greg KH wrote:
> On Mon, Apr 03, 2023 at 10:01:22AM +0200, Mirsad Goran Todorovac wrote:
>> On 3.4.2023. 9:57, Mirsad Goran Todorovac wrote:
>>> On 3.4.2023. 9:24, Greg KH wrote:
>>>> On Mon, Apr 03, 2023 at 09:17:21AM +0200, Mirsad Goran Todorovac wrote:
>>>>> Hi, Mathias!
>>>>>
>>>>> On 30.3.2023. 16:30, Mathias Nyman wrote:
>>>>>> The command allocated to set exit latency LPM values need to be freed in
>>>>>> case the command is never queued. This would be the case if there is no
>>>>>> change in exit latency values, or device is missing.
>>>>>>
>>>>>> Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>>>>>> Link: https://lore.kernel.org/linux-usb/24263902-c9b3-ce29-237b-1c3d6918f4fe@alu.unizg.hr
>>>>>> Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>>>>>> Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
>>>>>> Cc: <Stable@vger.kernel.org>
>>>>>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>>>>>> ---
>>>>>>     drivers/usb/host/xhci.c | 1 +
>>>>>>     1 file changed, 1 insertion(+)
>>>>>>
>>>>>> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
>>>>>> index bdb6dd819a3b..6307bae9cddf 100644
>>>>>> --- a/drivers/usb/host/xhci.c
>>>>>> +++ b/drivers/usb/host/xhci.c
>>>>>> @@ -4442,6 +4442,7 @@ static int __maybe_unused xhci_change_max_exit_latency(struct xhci_hcd *xhci,
>>>>>>         if (!virt_dev || max_exit_latency == virt_dev->current_mel) {
>>>>>>             spin_unlock_irqrestore(&xhci->lock, flags);
>>>>>> +        xhci_free_command(xhci, command);
>>>>>>             return 0;
>>>>>>         }
>>>>>
>>>>> There seems to be a problem with applying this patch with "git am", as it
>>>>> gives the following:
>>>>>
>>>>> commit ff9de97baa02cb9362b7cb81e95bc9be424cab89
>>>>> Author: @ <@>
>>>>> Date:   Mon Apr 3 08:42:33 2023 +0200
>>>>>
>>>>>       The command allocated to set exit latency LPM values need to be freed in
>>>>>       case the command is never queued. This would be the case if there is no
>>>>>       change in exit latency values, or device is missing.
>>>>>
>>>>>       Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
>>>>>       Cc: <Stable@vger.kernel.org>
>>>>>       Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>>>>
>>>> This is already commit f6caea485555 ("xhci: Free the command allocated
>>>> for setting LPM if we return early") in Linus's tree, do you not see it
>>>> there?
>>>>
>>>> And how exactly did you save the message to apply it with 'git am'?  It
>>>> worked for me.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>> git am ../mathias-xhci.mail
>>>
>>> mtodorov@domac:~/linux/kernel/linux_torvalds$ cat ../mathias-xhci.mail
>>> From: Mathias Nyman @ 2023-03-27  9:50 UTC (permalink / raw)
>>>     To: mirsad.todorovac, linux-usb, linux-kernel
>>>     Cc: gregkh, ubuntu-devel-discuss, stern, arnd, Mathias Nyman, Stable
>>>
>>> The command allocated to set exit latency LPM values need to be freed in
>>> case the command is never queued. This would be the case if there is no
>>> change in exit latency values, or device is missing.
>>>
>>> Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
>>> Cc: <Stable@vger.kernel.org>
>>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> 
> That is very odd, your mail program is not getting the full mbox
> information here at all.  Try downloading it from lore.kernel.org as a
> raw message:
> 	https://lore.kernel.org/all/20230330143056.1390020-4-mathias.nyman@linux.intel.com/raw
> and applying that?
> 
>>> ---
>>>    drivers/usb/host/xhci.c | 1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
>>> index bdb6dd819a3b..6307bae9cddf 100644
>>> --- a/drivers/usb/host/xhci.c
>>> +++ b/drivers/usb/host/xhci.c
>>> @@ -4442,6 +4442,7 @@ static int __maybe_unused xhci_change_max_exit_latency(struct xhci_hcd *xhci,
>>>
>>>           if (!virt_dev || max_exit_latency == virt_dev->current_mel) {
>>>                   spin_unlock_irqrestore(&xhci->lock, flags);
>>> +               xhci_free_command(xhci, command);
>>>                   return 0;
>>>           }
>>>
>>> -- 
>>> 2.25.1
>>>
>>> Sorry, no commit f6caea485555 in the "git pull":
>>>
>>> mtodorov@domac:~/linux/kernel/linux_torvalds$ git log --oneline | grep f6caea485555
>>> mtodorov@domac:~/linux/kernel/linux_torvalds$ git log --oneline | head -10
>>> 10de4cefccf7 memstick: fix memory leak if card device is never registered
>>> feeedf59897c platform/x86: think-lmi: Clean up display of current_value on Thinkstation
>>> 86cebdbfb8d2 platform/x86: think-lmi: Fix memory leaks when parsing ThinkStation WMI strings
>>> ff9de97baa02 The command allocated to set exit latency LPM values need
>>> to be freed in case the command is never queued. This would be the case
>>> if there is no change in exit latency values, or device is missing.
>>> 2ac6d07f1a81 platform/x86: think-lmi: Fix memory leak when showing current settings
>>> 7e364e56293b Linux 6.3-rc5
>>> 6ab608fe852b Merge tag 'for-6.3-rc4-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
>>> f95b8ea79c47 Revert "venus: firmware: Correct non-pix start and end addresses"
>>> a10ca0950afe Merge tag 'driver-core-6.3-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
>>> 95d0b9d89d78 Merge tag 'powerpc-6.3-4' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux
>>> You have mail in /var/mail/mtodorov
>>> mtodorov@domac:~/linux/kernel/linux_torvalds$
>>>
>>> I don't see it here either. But it is not critical (no security issue).
>>>
>>> Have a nice day!
>>
>> P.S.
>>
>> Correction.
>>
>> Yes, I found it here:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f6caea4855553a8b99ba3ec23ecdb5ed8262f26c
>>
>> "Notice: this object is not reachable from any branch."
>>
>> I see Murphy's law in action :-)
> 
> Ah, sorry, no, my fault, it's in my usb.git tree and hasn't been sent to
> Linus yet, that will happen later this week.  It is also in the
> linux-next tree if you want to look there.
> 
> thanks,

Not at all. Thank you for the hint for the new Lore link.

The new build also compiled w/o problems and the leak appears patched in the
original setting that triggered it in the first place:

[root@pc-mtodorov kernel]# uname -rms
Linux 6.3.0-rc5-mt-20230401-00007-g268a637be362 x86_64
[root@pc-mtodorov kernel]# echo scan > /sys/kernel/debug/kmemleak
[root@pc-mtodorov kernel]# cat /sys/kernel/debug/kmemleak
[root@pc-mtodorov kernel]# echo scan > /sys/kernel/debug/kmemleak
[root@pc-mtodorov kernel]# cat /sys/kernel/debug/kmemleak
[root@pc-mtodorov kernel]# echo scan > /sys/kernel/debug/kmemleak
[root@pc-mtodorov kernel]# cat /sys/kernel/debug/kmemleak
[root@pc-mtodorov kernel]#

However, there is a lot of homework to catch up on the Linux kernel drivers
for me ... This was beginner's luck to find.

Given enough time and at high enough improbability level, a bunch of monkeys
could have found it ;-)

Regards,
Mirsad

-- 
Mirsad Todorovac
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb
Republic of Croatia, the European Union

Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu


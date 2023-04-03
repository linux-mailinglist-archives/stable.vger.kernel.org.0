Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278AE6D3E84
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 09:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbjDCH6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 03:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjDCH6A (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 3 Apr 2023 03:58:00 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751CC7687;
        Mon,  3 Apr 2023 00:57:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id E60AF604F2;
        Mon,  3 Apr 2023 09:57:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1680508673; bh=npcvRlKenao0elOCCaduyMvW/IlxrNmXvf40wC8lN2I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=0nkJeQFlcE6BxLro4TiO27/EmPfDUtHRO6Wq4DiIOAfFaIkaH1eD+EX5U0LBdhtS7
         8KZ88vrf/QY9Eaw6S2PrLFdMXZyMg/ncgBRE2y4JIR0rDykiOl+WglBtpMNk7JjBKV
         D0lowpr2wEtq0UsSmP/Tx7AND3t/lmsRVsU+EN2NQU0pwwFzKadjpr2rQQx9EPgFkP
         cYnsR3n7YhwDa9TlHKF2Sj8tOBu5j5si3c7eksT1xzYBSzMekougfqwomZMfnWIMJz
         6HzuYgM3RCG4/xg4w6PZ4GIC910Y29dU+k07I/PgbSn4TJ0TxIqXqjPK8OpahrG3M6
         1/4b/QdhayqZA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1WqrTfdiopT9; Mon,  3 Apr 2023 09:57:51 +0200 (CEST)
Received: from [10.0.1.57] (grf-nat.grf.hr [161.53.83.23])
        by domac.alu.hr (Postfix) with ESMTPSA id 28A65604F0;
        Mon,  3 Apr 2023 09:57:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1680508671; bh=npcvRlKenao0elOCCaduyMvW/IlxrNmXvf40wC8lN2I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=BnNvjrkFn8P2wYH4IJwNfnoGGBfxeJ7EiAQFO6Cwpl0AIZz99sjL3cU0ijGBirVdP
         Wh5rIPyz0HmCJoDsl4jW9A940tjXXr+9DT4XCi+4XYg+ce3+ScBmqrhuv+uLYaw5K2
         2xTk5G+Nijk/nAV2gSmuPzNh76o5IgX0Inl+AhQvuRCpgjzsW+WubHKJW4crAuJ2JH
         CJGvf5BGRQcO1qXCJatC357UvTd8kzFQRY9mzCMUGeHCr3tU+Zo/MVJQhOZxWAnxfO
         oQMuOMh/wsXahLPsDfIItRj9gvjTQaZbzpHSlebyX+ilyg30OxHLrTaYRENV/BCMHC
         JaoNgcC6Z275A==
Message-ID: <eb08643a-eae1-dd59-ba89-bf593405c09f@alu.unizg.hr>
Date:   Mon, 3 Apr 2023 09:57:49 +0200
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
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <2023040352-case-barterer-ccd1@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3.4.2023. 9:24, Greg KH wrote:
> On Mon, Apr 03, 2023 at 09:17:21AM +0200, Mirsad Goran Todorovac wrote:
>> Hi, Mathias!
>>
>> On 30.3.2023. 16:30, Mathias Nyman wrote:
>>> The command allocated to set exit latency LPM values need to be freed in
>>> case the command is never queued. This would be the case if there is no
>>> change in exit latency values, or device is missing.
>>>
>>> Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>>> Link: https://lore.kernel.org/linux-usb/24263902-c9b3-ce29-237b-1c3d6918f4fe@alu.unizg.hr
>>> Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>>> Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
>>> Cc: <Stable@vger.kernel.org>
>>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>>> ---
>>>    drivers/usb/host/xhci.c | 1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
>>> index bdb6dd819a3b..6307bae9cddf 100644
>>> --- a/drivers/usb/host/xhci.c
>>> +++ b/drivers/usb/host/xhci.c
>>> @@ -4442,6 +4442,7 @@ static int __maybe_unused xhci_change_max_exit_latency(struct xhci_hcd *xhci,
>>>    	if (!virt_dev || max_exit_latency == virt_dev->current_mel) {
>>>    		spin_unlock_irqrestore(&xhci->lock, flags);
>>> +		xhci_free_command(xhci, command);
>>>    		return 0;
>>>    	}
>>
>> There seems to be a problem with applying this patch with "git am", as it
>> gives the following:
>>
>> commit ff9de97baa02cb9362b7cb81e95bc9be424cab89
>> Author: @ <@>
>> Date:   Mon Apr 3 08:42:33 2023 +0200
>>
>>      The command allocated to set exit latency LPM values need to be freed in
>>      case the command is never queued. This would be the case if there is no
>>      change in exit latency values, or device is missing.
>>
>>      Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
>>      Cc: <Stable@vger.kernel.org>
>>      Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> 
> This is already commit f6caea485555 ("xhci: Free the command allocated
> for setting LPM if we return early") in Linus's tree, do you not see it
> there?
> 
> And how exactly did you save the message to apply it with 'git am'?  It
> worked for me.
> 
> thanks,
> 
> greg k-h

git am ../mathias-xhci.mail

mtodorov@domac:~/linux/kernel/linux_torvalds$ cat ../mathias-xhci.mail
From: Mathias Nyman @ 2023-03-27  9:50 UTC (permalink / raw)
   To: mirsad.todorovac, linux-usb, linux-kernel
   Cc: gregkh, ubuntu-devel-discuss, stern, arnd, Mathias Nyman, Stable

The command allocated to set exit latency LPM values need to be freed in
case the command is never queued. This would be the case if there is no
change in exit latency values, or device is missing.

Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
  drivers/usb/host/xhci.c | 1 +
  1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index bdb6dd819a3b..6307bae9cddf 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4442,6 +4442,7 @@ static int __maybe_unused xhci_change_max_exit_latency(struct xhci_hcd *xhci,

         if (!virt_dev || max_exit_latency == virt_dev->current_mel) {
                 spin_unlock_irqrestore(&xhci->lock, flags);
+               xhci_free_command(xhci, command);
                 return 0;
         }

--
2.25.1

Sorry, no commit f6caea485555 in the "git pull":

mtodorov@domac:~/linux/kernel/linux_torvalds$ git log --oneline | grep f6caea485555
mtodorov@domac:~/linux/kernel/linux_torvalds$ git log --oneline | head -10
10de4cefccf7 memstick: fix memory leak if card device is never registered
feeedf59897c platform/x86: think-lmi: Clean up display of current_value on Thinkstation
86cebdbfb8d2 platform/x86: think-lmi: Fix memory leaks when parsing ThinkStation WMI strings
ff9de97baa02 The command allocated to set exit latency LPM values need to be freed in case the command is never queued. This would 
be the case if there is no change in exit latency values, or device is missing.
2ac6d07f1a81 platform/x86: think-lmi: Fix memory leak when showing current settings
7e364e56293b Linux 6.3-rc5
6ab608fe852b Merge tag 'for-6.3-rc4-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
f95b8ea79c47 Revert "venus: firmware: Correct non-pix start and end addresses"
a10ca0950afe Merge tag 'driver-core-6.3-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
95d0b9d89d78 Merge tag 'powerpc-6.3-4' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux
You have mail in /var/mail/mtodorov
mtodorov@domac:~/linux/kernel/linux_torvalds$

I don't see it here either. But it is not critical (no security issue).

Have a nice day!

Best regards,
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


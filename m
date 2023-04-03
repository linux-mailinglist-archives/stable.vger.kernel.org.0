Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE996D4028
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 11:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbjDCJU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 05:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbjDCJUr (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 3 Apr 2023 05:20:47 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2843E44AC;
        Mon,  3 Apr 2023 02:20:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id A7F68604FA;
        Mon,  3 Apr 2023 11:20:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1680513624; bh=YwMDWlermRYUB+ohGE2pB+S5andxsxN1vsjRKD2AOZU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=az7mOw17rlc+H7p/rz6e0IM2E28pveY3nRjdMz9SS8eQmo/8+l0/+OH3NBZw/GvIB
         522cIK/o+OoYAAURQ4YDYP0Uq6+McAUVwPlS3697bYNY0G3QSY8SHCh3ycK4mFJuRC
         ZxQuRw7FT7av/SAW3mGUpvnH/unex8UwzawXc4E4sxOAYEQ5NOgEEt+CjkVA8q2DVR
         4TtTblwc9LHGU3KNzWl/UyTmqCGSu/axtm0nByb4QDxFSiCROPfvlfqj51i0szqw8m
         Oa5iscPY+Ha5b1+RwEvMkCwr5mcdYudtc7g/t60MbMfbGwxliMtoiZ58+JSdKpaOkS
         2MCXrWaUNMbQg==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LSp7U_GhOtvV; Mon,  3 Apr 2023 11:20:22 +0200 (CEST)
Received: from [10.0.1.57] (grf-nat.grf.hr [161.53.83.23])
        by domac.alu.hr (Postfix) with ESMTPSA id D3D15604F7;
        Mon,  3 Apr 2023 11:20:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1680513622; bh=YwMDWlermRYUB+ohGE2pB+S5andxsxN1vsjRKD2AOZU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=0jvVvtRxGyCkvVqYoPM2xkLrLeqlW0UQNELz4K5xlw0lq+uKuWjoidCwveCYsh5Na
         N84HG7zO+gzeAl4BCvjR8sssEEIddgJU57PffcJ/8gKltSy3HoWEUb1tGm2AoCTU/Y
         ArxMsUXhAmVDE5RWTwL5Esd/nlngYG6Doz4kba+DKdqrD87KDV1SGiW2aJ9jXxE9sI
         sND5DsuTE0raZe310NyP6KvfrgI5AvZa3ojFkFt45fFbN4Gd8LEejQJxv5j/vQoqvp
         d3Uc2VhmJrbWuXjtwYZPPy0FfF6V6K7pIx5U/T1MSk/CB0BMfgPFaCEVf7VqY3Nbti
         L5g8PeMeqOvAA==
Message-ID: <155279c4-3d44-1419-2b8d-a189a2177f0e@alu.unizg.hr>
Date:   Mon, 3 Apr 2023 11:20:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] xhci: Free the command allocated for setting LPM if we
 return early
Content-Language: en-US, hr
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, ubuntu-devel-discuss@lists.ubuntu.com,
        stern@rowland.harvard.edu, arnd@arndb.de, Stable@vger.kernel.org
References: <b86fcdbd-f1c6-846f-838f-b7679ec4e2b4@linux.intel.com>
 <20230327095019.1017159-1-mathias.nyman@linux.intel.com>
 <d84fe574-e6cc-ad77-a44c-1eb8df3f2b6b@alu.unizg.hr>
 <46a9abc1-6121-032f-4416-261af73ac05c@linux.intel.com>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <46a9abc1-6121-032f-4416-261af73ac05c@linux.intel.com>
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

On 28.3.2023. 9:57, Mathias Nyman wrote:
> On 28.3.2023 1.25, Mirsad Goran Todorovac wrote:
>> On 27. 03. 2023. 11:50, Mathias Nyman wrote:
>>> The command allocated to set exit latency LPM values need to be freed in
>>> case the command is never queued. This would be the case if there is no
>>> change in exit latency values, or device is missing.
>>>
>>> Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
>>> Cc: <Stable@vger.kernel.org>
>>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>>> ---
>>>   drivers/usb/host/xhci.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
>>> index bdb6dd819a3b..6307bae9cddf 100644
>>> --- a/drivers/usb/host/xhci.c
>>> +++ b/drivers/usb/host/xhci.c
>>> @@ -4442,6 +4442,7 @@ static int __maybe_unused xhci_change_max_exit_latency(struct xhci_hcd *xhci,
>>>       if (!virt_dev || max_exit_latency == virt_dev->current_mel) {
>>>           spin_unlock_irqrestore(&xhci->lock, flags);
>>> +        xhci_free_command(xhci, command);
>>>           return 0;
>>>       }
>>
>> After more testing, I can confirm that your patch fixes the leak in the original
>> environment.
> 
> Thanks for testing.
> Can I add the tags below to the patch?
> 
> Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> 
> Thanks
> Mathias

Sure, thanks for the thought. Sorry, my Thunderbird has hidden your message,
I saw it only on Lore and accidentally.

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


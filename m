Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38AD2F821B
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 18:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbhAORWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 12:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727876AbhAORWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 12:22:08 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA1EC0613C1;
        Fri, 15 Jan 2021 09:21:27 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id v67so14253781lfa.0;
        Fri, 15 Jan 2021 09:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QMmi0FiVN5Cp+wQqEnMWwUuN5A0IFrb/oyH6nkhKchE=;
        b=jG1XP3AcqNCblv1qXe5AjSjMBYYK5Kz59EVyhMXaPHZ0dBEPvgBjpishmsxGgts2Bs
         btCo+2EP5lMzugLeGBR7GOPppvRpZMWOZkr9BvMk2Hq6GFhJfG3FrryLLfjp588kW+8h
         xAmhRpLqzSxd4L4IVDIt+ys0k4ZCrCdflxAoMCle/PbzDd1ygAcC8YPU76kOSgeXCmG1
         iRKHI6vl/NgtEZ1KLriVeB7NMoXmFrgnQSfFP2kMYK+K+4WiziCPLcjO4jTx7lBMdlMe
         RrCfenHCAXFtEfq88MFD9NvEfjmigfEwqDcu8F8+0gwXw/ysJl1fX99MadcloLjlLd7V
         WMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QMmi0FiVN5Cp+wQqEnMWwUuN5A0IFrb/oyH6nkhKchE=;
        b=sBDMWXyyLCxjRGoO9jh8GnLoTZhtv1mUP3fYVqTiEWoz+99eLaB2lbwd4ASdNZDq5C
         YpaWP1YvQIFKFyxo8NKMx2JaaUl6e+/KvQr1zT3GrIfsqg441+ZZFhiFYke6lEmNfwJz
         XSFdSzbaoPylL6dXd4Ifs1AwT11/lnkFdXzpUE6WvjkkPEcdGiB8sRiHk5V44ywmFHzI
         pPHZPTwsuT+l7i88Ww//G7rl5qR9giizPyJrD+cxTbP5Ru3GP96lJ/zJ5hDrgjzDUFse
         X4uStXYbj+8Qm/jZyZWe3efdTINomN25OnxYOtGARA2didoLzppRG93ESh5g22TieN42
         uZOA==
X-Gm-Message-State: AOAM532M7atSwVC5hhoYWBG3xd5i8lG972T0R9b9FBssG6x1uikYwhrV
        0LXvIyFvrjZMvkWiKkIzX3LO6JXZvGo=
X-Google-Smtp-Source: ABdhPJy4NpPDHIUkWz8c0QwaaqaiZwWyk3xmk8Bbh5vDr/Ll94AaVLDJP0qbWcMdDUyp+32ET6A2kw==
X-Received: by 2002:ac2:4e92:: with SMTP id o18mr5557431lfr.576.1610731286280;
        Fri, 15 Jan 2021 09:21:26 -0800 (PST)
Received: from [192.168.1.101] ([178.176.73.247])
        by smtp.gmail.com with ESMTPSA id n7sm526185lfu.123.2021.01.15.09.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 09:21:25 -0800 (PST)
Subject: Re: [PATCH 1/2] xhci: make sure TRB is fully written before giving it
 to the controller
To:     David Laight <David.Laight@ACULAB.COM>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ross Zwisler <zwisler@google.com>
References: <20210115161907.2875631-1-mathias.nyman@linux.intel.com>
 <20210115161907.2875631-2-mathias.nyman@linux.intel.com>
 <42c6632e-28f1-9aae-e1a6-3525bb493c58@gmail.com>
 <b70e0bb512d44f00ac5f8380ba450ba6@AcuMS.aculab.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <f439cf12-106f-3634-397f-dc17a4d0e94d@gmail.com>
Date:   Fri, 15 Jan 2021 20:21:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <b70e0bb512d44f00ac5f8380ba450ba6@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/15/21 7:50 PM, David Laight wrote:
> From: Sergei Shtylyov
>> Sent: 15 January 2021 16:40
>>
>> On 1/15/21 7:19 PM, Mathias Nyman wrote:
>>
>>> Once the command ring doorbell is rung the xHC controller will parse all
>>> command TRBs on the command ring that have the cycle bit set properly.
>>>
>>> If the driver just started writing the next command TRB to the ring when
>>> hardware finished the previous TRB, then HW might fetch an incomplete TRB
>>> as long as its cycle bit set correctly.
>>>
>>> A command TRB is 16 bytes (128 bits) long.
>>> Driver writes the command TRB in four 32 bit chunks, with the chunk
>>> containing the cycle bit last. This does however not guarantee that
>>> chunks actually get written in that order.
>>>
>>> This was detected in stress testing when canceling URBs with several
>>> connected USB devices.
>>> Two consecutive "Set TR Dequeue pointer" commands got queued right
>>> after each other, and the second one was only partially written when
>>> the controller parsed it, causing the dequeue pointer to be set
>>> to bogus values. This was seen as error messages:
>>>
>>> "Mismatch between completed Set TR Deq Ptr command & xHCI internal state"
>>>
>>> Solution is to add a write memory barrier before writing the cycle bit.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Tested-by: Ross Zwisler <zwisler@google.com>
>>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>>> ---
>>>  drivers/usb/host/xhci-ring.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
>>> index 5677b81c0915..cf0c93a90200 100644
>>> --- a/drivers/usb/host/xhci-ring.c
>>> +++ b/drivers/usb/host/xhci-ring.c
>>> @@ -2931,6 +2931,8 @@ static void queue_trb(struct xhci_hcd *xhci, struct xhci_ring *ring,
>>>  	trb->field[0] = cpu_to_le32(field1);
>>>  	trb->field[1] = cpu_to_le32(field2);
>>>  	trb->field[2] = cpu_to_le32(field3);
>>> +	/* make sure TRB is fully written before giving it to the controller */
>>> +	wmb();
>>
>>    Have you tried the lighter barrier, dma_wmb()? IIRC, it exists for these exact cases...
> 
> Isn't dma_wmb() needed between the last memory write and the io_write to the doorbell?

   No.

> Here we need to ensure the two memory writes aren't re-ordered.

   No, we need all 3 ring memory writes to be ordered such that they all happen before the 4th
write. It's not wonder this bug hasn't been noticed before -- x86 has strong write ordering
unlike ARM/etc.

> Apart from alpha isn't a barrier() likely to be enough for that.

   Not sure -- we don't have any barriers before the equivalents of a doorbell write
in e.g. the Renesas Ehter driver.

> It is worth checking that the failing compiles didn't have the writes reordered.

  The writes are reordered not because of the compiler -- the read/write reordering is a
CPU feature (on at least non-x86). :-)

> 	David
> 
>>
>>>  	trb->field[3] = cpu_to_le32(field4);
>>>
>>>  	trace_xhci_queue_trb(ring, trb);

MBR, Sergei

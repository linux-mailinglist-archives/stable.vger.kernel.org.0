Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F662F9F1D
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391316AbhARMHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:07:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:30186 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391295AbhARMHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 07:07:30 -0500
IronPort-SDR: AuqK7DJC/m8mh5r8HUl0X2L31e2KpPCPJ3wstVOf7592UlcOS5JZWP+NIh2R9/umRJmicENfbb
 RCVTRZADsN8w==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="165883719"
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="165883719"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 04:05:42 -0800
IronPort-SDR: Y35sGjFKWBRa/zI0yMJ5zuAaIGCvHq35cZq9+9eEqJnXLWxKuS6DzkgT0Ma7TZuYZde7qqRIH9
 YnFAS/Z4fo6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="346855257"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.170]) ([10.237.72.170])
  by fmsmga007.fm.intel.com with ESMTP; 18 Jan 2021 04:05:40 -0800
Subject: Re: [PATCH 1/2] xhci: make sure TRB is fully written before giving it
 to the controller
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ross Zwisler <zwisler@google.com>
References: <20210115161907.2875631-1-mathias.nyman@linux.intel.com>
 <20210115161907.2875631-2-mathias.nyman@linux.intel.com>
 <42c6632e-28f1-9aae-e1a6-3525bb493c58@gmail.com>
 <b70e0bb512d44f00ac5f8380ba450ba6@AcuMS.aculab.com>
 <f439cf12-106f-3634-397f-dc17a4d0e94d@gmail.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Autocrypt: addr=mathias.nyman@linux.intel.com; prefer-encrypt=mutual; keydata=
 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 fiD/
Message-ID: <2722043c-208b-c965-e6cf-8474c698df2c@linux.intel.com>
Date:   Mon, 18 Jan 2021 14:07:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f439cf12-106f-3634-397f-dc17a4d0e94d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.1.2021 19.21, Sergei Shtylyov wrote:
> On 1/15/21 7:50 PM, David Laight wrote:
>> From: Sergei Shtylyov
>>> Sent: 15 January 2021 16:40
>>>
>>> On 1/15/21 7:19 PM, Mathias Nyman wrote:
>>>
>>>> Once the command ring doorbell is rung the xHC controller will parse all
>>>> command TRBs on the command ring that have the cycle bit set properly.
>>>>
>>>> If the driver just started writing the next command TRB to the ring when
>>>> hardware finished the previous TRB, then HW might fetch an incomplete TRB
>>>> as long as its cycle bit set correctly.
>>>>
>>>> A command TRB is 16 bytes (128 bits) long.
>>>> Driver writes the command TRB in four 32 bit chunks, with the chunk
>>>> containing the cycle bit last. This does however not guarantee that
>>>> chunks actually get written in that order.
>>>>
>>>> This was detected in stress testing when canceling URBs with several
>>>> connected USB devices.
>>>> Two consecutive "Set TR Dequeue pointer" commands got queued right
>>>> after each other, and the second one was only partially written when
>>>> the controller parsed it, causing the dequeue pointer to be set
>>>> to bogus values. This was seen as error messages:
>>>>
>>>> "Mismatch between completed Set TR Deq Ptr command & xHCI internal state"
>>>>
>>>> Solution is to add a write memory barrier before writing the cycle bit.
>>>>
>>>> Cc: <stable@vger.kernel.org>
>>>> Tested-by: Ross Zwisler <zwisler@google.com>
>>>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>>>> ---
>>>>  drivers/usb/host/xhci-ring.c | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
>>>> index 5677b81c0915..cf0c93a90200 100644
>>>> --- a/drivers/usb/host/xhci-ring.c
>>>> +++ b/drivers/usb/host/xhci-ring.c
>>>> @@ -2931,6 +2931,8 @@ static void queue_trb(struct xhci_hcd *xhci, struct xhci_ring *ring,
>>>>  	trb->field[0] = cpu_to_le32(field1);
>>>>  	trb->field[1] = cpu_to_le32(field2);
>>>>  	trb->field[2] = cpu_to_le32(field3);
>>>> +	/* make sure TRB is fully written before giving it to the controller */
>>>> +	wmb();
>>>
>>>    Have you tried the lighter barrier, dma_wmb()? IIRC, it exists for these exact cases...
>>

True, good point, dma_wmb() should be enough here.
In fact most other wmb()s in xhci could be turned into dma_wmb().

Looks like Greg already picked this so maybe a later patch to usb-next that does this
wmb() -> dma_wmb() optimization where possible.

>> Isn't dma_wmb() needed between the last memory write and the io_write to the doorbell?
> 
>    No.

Transfer trbs already have a wmb in giveback_first_trb() 
So no need in that case.

For command trbs it's unlikely but not impossible.
The issue we are solving here is xHC controller parsing two commands after a doorbell ring.
First one was the intended, properly written command. Second was a out-of order
partially written command. driver didn't even ring the doorbell for the second command yet.

There are a couple operations between trb last memory write and command doorbell ring.
a wmb() in that place would solve a case where memory write is so out of order and delayed
that xHC controller reads and reacts to the doorbell ring, and reads the command ring
before the memory write to the command ring is done. Unlikely but not impossible.

No such issues seen so far, but maybe a dma_wmb() in xhci_ring_cmd_db() wouldn't hurt.

-Mathias

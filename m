Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1122EAC03
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 14:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbhAENgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 08:36:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbhAENgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 08:36:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F37C225AC;
        Tue,  5 Jan 2021 13:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609853728;
        bh=ER7oX2qdsWqz4DG0yItHR0XwIVuxNomoqXYtb296gG8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=LF1L4Zd9vxvl98aYLL2yIjBOrqixIhlmhZqqd6FXgteRWE8tNVbiMtMctJmRU+V+g
         8Uzq/0c5eH9PyZb4UPpn4LkbG3PbFWbXz2M7Go8wS3EOOXDuneaZklU4me9bzCf83/
         9Nn/0I/wCDwuivahELoowdDmd52EyrLmjlgcfwzqkyYk29lyapRU8OTCMMUsWhoa1L
         dVhI+dHkCx5TkgzFm+Z1m0JFFC4VREzp9G/3MxBXIOuwkuWuw8ed7GtTtB2KHoFRtY
         q/2rEXqnJTckfAZjq5J/xQYMn9Hl3JwIM7NrleY0tjVzU+cbCr6v4aU6pkeeIObqip
         BkUe918LvXoCw==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: dwc3: gadget: Clear wait flag on dequeue
In-Reply-To: <b5ce8d29-7013-126b-cea0-353941a1909d@synopsys.com>
References: <b81cd5b5281cfbfdadb002c4bcf5c9be7c017cfd.1609828485.git.Thinh.Nguyen@synopsys.com>
 <87turvczg4.fsf@kernel.org>
 <b5ce8d29-7013-126b-cea0-353941a1909d@synopsys.com>
Date:   Tue, 05 Jan 2021 15:35:23 +0200
Message-ID: <87h7nvcxr8.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
>> Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
>>> If an active transfer is dequeued, then the endpoint is freed to start a
>>> new transfer. Make sure to clear the endpoint's transfer wait flag for
>>> this case.
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: e0d19563eb6c ("usb: dwc3: gadget: Wait for transfer completion")
>>> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>>> ---
>>>  Changes in v2:
>>>  - Only clear the wait flag if the selected request is of an active transfer.
>>>    Otherwise, any dequeue will change the endpoint's state even if it's for
>>>    some random request.
>>>
>>>  drivers/usb/dwc3/gadget.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
>>> index 78cb4db8a6e4..9a00dcaca010 100644
>>> --- a/drivers/usb/dwc3/gadget.c
>>> +++ b/drivers/usb/dwc3/gadget.c
>>> @@ -1763,6 +1763,8 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
>>>  			list_for_each_entry_safe(r, t, &dep->started_list, list)
>>>  				dwc3_gadget_move_cancelled_request(r);
>>>  
>>> +			dep->flags &= ~DWC3_EP_WAIT_TRANSFER_COMPLETE;
>> I'm not sure this is correct. This could create a race condition between
>> clearing this bit and getting the transfer complete interrupt. It also
>> seems to break the assumptions made by
>> dwc3_gadget_endpoint_trbs_complete() (actually its users), specially
>> regarding ISOC endpoints.
>>
>> Have you verified all transfer types with this commit?
>>
>
> It shouldn't race. It's protected by the spinlock irq and it doesn't
> matter whether dwc3_gadget_endpoint_trbs_complete() or this dequeue
> function clears it first. The flag DWC3_EP_WAIT_TRANSFER_COMPLETE is
> only applicable to stream transfer as the driver needs to wait for 1
> stream to finish before starting another.
>
> This is verified with our test environment (which includes UASP CV and
> others).

Fair enough, I'll take your word for it :-)

Acked-by: Felipe Balbi <balbi@kernel.org>

-- 
balbi

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E2A3F29DB
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 12:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239046AbhHTKFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 06:05:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237855AbhHTKFI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 06:05:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04CCE610CB;
        Fri, 20 Aug 2021 10:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629453871;
        bh=JDnp7UIPiqVNjPvMlnATziLdqexyPnGYwwb24ozdIxY=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=sI0dYDkntHeODz5fJCMMNRNXWma7Qu1dapE1Uuj+36DvhmchUtAixomwoc19xT6a9
         KQOyG044YP8ND39iir0lM4Q8EV+YPnEMvDVdZeo11igvPbehPnXQvgf0HxknhNfVJA
         Bc7iwcnjlYbVcKDgckcz7yakwZNl5xBHAmlGZzih0UeM5FvUxgveZVQJ1Qn4YDKr8i
         f1Cc/J2DfIg6RPNBMxgFFxlttXRGPxWOwLelTabN4xdrsPdMLJlcRtjczXxs1QooZY
         qimw3FNDPfXrr3TJeNqsonjShJwm8045E/EbPY1g66/hd3N9j2mPVjyPj+0yxeoeOJ
         xT5yNQyPU7UKQ==
References: <e91e975affb0d0d02770686afc3a5b9eb84409f6.1629335416.git.Thinh.Nguyen@synopsys.com>
 <87h7fmf14r.fsf@kernel.org>
 <bba2b747-dc16-5ad8-b80b-c8fb6b11a3d3@synopsys.com>
User-agent: mu4e 1.6.3; emacs 27.2
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Fix dwc3_calc_trbs_left()
Date:   Fri, 20 Aug 2021 13:04:15 +0300
In-reply-to: <bba2b747-dc16-5ad8-b80b-c8fb6b11a3d3@synopsys.com>
Message-ID: <87bl5sfn4k.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:

> Felipe Balbi wrote:
>> 
>> Hi,
>> 
>> Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
>>> We can't depend on the TRB's HWO bit to determine if the TRB ring is
>>> "full". A TRB is only available when the driver had processed it, not
>>> when the controller consumed and relinquished the TRB's ownership to the
>>> driver. Otherwise, the driver may overwrite unprocessed TRBs. This can
>>> happen when many transfer events accumulate and the system is slow to
>>> process them and/or when there are too many small requests.
>>>
>>> If a request is in the started_list, that means there is one or more
>>> unprocessed TRBs remained. Check this instead of the TRB's HWO bit
>>> whether the TRB ring is full.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Fixes: c4233573f6ee ("usb: dwc3: gadget: prepare TRBs on update transfers too")
>>> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>>> ---
>>>  drivers/usb/dwc3/gadget.c | 16 ++++++++--------
>>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
>>> index 84fe57ef5a49..1e6ddbc986ba 100644
>>> --- a/drivers/usb/dwc3/gadget.c
>>> +++ b/drivers/usb/dwc3/gadget.c
>>> @@ -940,19 +940,19 @@ static struct dwc3_trb *dwc3_ep_prev_trb(struct dwc3_ep *dep, u8 index)
>>>  
>>>  static u32 dwc3_calc_trbs_left(struct dwc3_ep *dep)
>>>  {
>>> -	struct dwc3_trb		*tmp;
>>>  	u8			trbs_left;
>>>  
>>>  	/*
>>> -	 * If enqueue & dequeue are equal than it is either full or empty.
>>> -	 *
>>> -	 * One way to know for sure is if the TRB right before us has HWO bit
>>> -	 * set or not. If it has, then we're definitely full and can't fit any
>>> -	 * more transfers in our ring.
>>> +	 * If the enqueue & dequeue are equal then the TRB ring is either full
>>> +	 * or empty. It's considered full when there are DWC3_TRB_NUM-1 of TRBs
>>> +	 * pending to be processed by the driver.
>>>  	 */
>>>  	if (dep->trb_enqueue == dep->trb_dequeue) {
>>> -		tmp = dwc3_ep_prev_trb(dep, dep->trb_enqueue);
>>> -		if (tmp->ctrl & DWC3_TRB_CTRL_HWO)
>>> +		/*
>>> +		 * If there is any request remained in the started_list at
>>> +		 * this point, that means there is no TRB available.
>>> +		 */
>>> +		if (!list_empty(&dep->started_list))
>>>  			return 0;
>> 
>> we could also do away with calc_trbs_left() completely if we just add an
>> actual counter that gets incremented decremented together with the
>> enqueue/dequeue pointers. Since we have 256 TRBs per endpoint and only
>> 255 are usable, this means we can do away with a single u8 per
>> endpoint. Perhaps that could be done as a second step after this fix is
>> merged?
>> 
>
> Yes, that would simplify the logic. We can do that after merging this fix.

sounds good:

Acked-by: Felipe Balbi <balbi@kernel.org>

-- 
balbi

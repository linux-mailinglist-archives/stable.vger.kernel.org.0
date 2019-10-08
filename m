Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A78E2CF4BC
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 10:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730411AbfJHIN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 04:13:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:50936 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730384AbfJHIN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 04:13:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 01:13:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,270,1566889200"; 
   d="scan'208";a="218208996"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.170]) ([10.237.72.170])
  by fmsmga004.fm.intel.com with ESMTP; 08 Oct 2019 01:13:56 -0700
Subject: Re: [PATCH 8/8] xhci: Fix NULL pointer dereference in
 xhci_clear_tt_buffer_complete()
To:     Johan Hovold <johan@kernel.org>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        "# v5 . 3" <stable@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <1570190373-30684-1-git-send-email-mathias.nyman@linux.intel.com>
 <1570190373-30684-9-git-send-email-mathias.nyman@linux.intel.com>
 <20191007140245.GD13531@localhost>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <c0b1f81f-db1a-8f12-6880-a686cb9c35a7@linux.intel.com>
Date:   Tue, 8 Oct 2019 11:15:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191007140245.GD13531@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7.10.2019 17.02, Johan Hovold wrote:
> [ +CC: Alan ]
> 
> On Fri, Oct 04, 2019 at 02:59:33PM +0300, Mathias Nyman wrote:
>> udev stored in ep->hcpriv might be NULL if tt buffer is cleared
>> due to a halted control endpoint during device enumeration
>>
>> xhci_clear_tt_buffer_complete is called by hub_tt_work() once it's
>> scheduled,  and by then usb core might have freed and allocated a
>> new udev for the next enumeration attempt.
>>
>> Fixes: ef513be0a905 ("usb: xhci: Add Clear_TT_Buffer")
>> Cc: <stable@vger.kernel.org> # v5.3
>> Reported-by: Johan Hovold <johan@kernel.org>
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>> ---
>>   drivers/usb/host/xhci.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
>> index 00f3804f7aa7..517ec3206f6e 100644
>> --- a/drivers/usb/host/xhci.c
>> +++ b/drivers/usb/host/xhci.c
>> @@ -5238,8 +5238,16 @@ static void xhci_clear_tt_buffer_complete(struct usb_hcd *hcd,
>>   	unsigned int ep_index;
>>   	unsigned long flags;
>>   
>> +	/*
>> +	 * udev might be NULL if tt buffer is cleared during a failed device
>> +	 * enumeration due to a halted control endpoint. Usb core might
>> +	 * have allocated a new udev for the next enumeration attempt.
>> +	 */
>> +
>>   	xhci = hcd_to_xhci(hcd);
>>   	udev = (struct usb_device *)ep->hcpriv;
>> +	if (!udev)
>> +		return;
> 
> I didn't have time to look into this myself last week, or comment on the
> patch before Greg picked it up, but this clearly isn't the right fix.
> 
> As your comment suggests, ep->hcpriv may indeed be NULL here if USB core
> have allocated a new udev. But this only happens after USB has freed the
> old usb_device and the new one happens to get the same address.
> 

You're right, that fix doesn't solve the actual issue, it avoids a few specific
null pointer dereference cases, but leaves both root cause and several other
use-after-free cases open.

> Note that even the usb_host_endpoint itself (ep) has then been freed and
> reallocated since it is member of struct usb_device, and it is the
> use-after-free that needs fixing.
> 
> I've even been able to trigger another NULL-deref in this function
> before a new udev has been allocated, due to the virt dev having been
> freed by xhci_free_dev as part of usb_release_dev:
> 
> It seems the xhci clear-tt implementation was incomplete since it did
> not take care to wait for any ongoing work before disabling the
> endpoint. EHCI does this in ehci_endpoint_disable(), but xhci doesn't
> even implement that callback.
> 

So it seems, it might be possible to remove pending clear_tt work for
most endpoints in the .drop_endpoint callbacks, but ep0 is different,
it isn't dropped, we might need to implement the endpoint_disable()
callback for this.

> As this may be something you could end up hitting in other paths as
> well, perhaps we should even consider reverting the offending commit
> pending a more complete implementation?

Possibly, if we can't find a working solution early enough in this release cycle

-Mathias

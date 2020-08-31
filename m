Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC02F257B46
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 16:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHaO2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 10:28:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:20493 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgHaO2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 10:28:37 -0400
IronPort-SDR: 25xijYiSmbIYaEHSqDmy35n8hbNjsOgOzChJvCh7PIRI1EWXAForBfXw1kfxQjA+TP1NpZm+Hm
 GleDcVnx5mEQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9730"; a="144717006"
X-IronPort-AV: E=Sophos;i="5.76,375,1592895600"; 
   d="scan'208";a="144717006"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 07:28:35 -0700
IronPort-SDR: aQ6ftvyJRozk3OdQPOIsh9bD4+YfnR5m9xpWemfJ1AWGsMXxAKb8dSsOJL99vIAZ8Z/1b177bc
 w5FJ0cruTn2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,375,1592895600"; 
   d="scan'208";a="445733539"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.170]) ([10.237.72.170])
  by orsmga004.jf.intel.com with ESMTP; 31 Aug 2020 07:28:33 -0700
Subject: Re: [PATCH] usb: Fix out of sync data toggle if a configured device
 is reconfigured
To:     Felipe Balbi <balbi@kernel.org>, gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
        mthierer@gmail.com, stable <stable@vger.kernel.org>
References: <20200831114649.24183-1-mathias.nyman@linux.intel.com>
 <87tuwj9g7a.fsf@kernel.org>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Openpgp: preference=signencrypt
Autocrypt: addr=mathias.nyman@linux.intel.com; prefer-encrypt=mutual; keydata=
 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 fiD/
Message-ID: <cefa03ae-dc74-ede7-6412-6e45d09e5f2c@linux.intel.com>
Date:   Mon, 31 Aug 2020 17:31:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <87tuwj9g7a.fsf@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31.8.2020 15.02, Felipe Balbi wrote:
> 
> Hi,
> 
> Mathias Nyman <mathias.nyman@linux.intel.com> writes:
>> Userspace drivers that use a SetConfiguration() request to "lightweight"
>> reset a already configured usb device might cause data toggles to get out
>         ^
>         an

true

> 
>> of sync between the device and host, and the device becomes unusable.
>>
>> The xHCI host requires endpoints to be dropped and added back to reset the
>> toggle. USB core avoids these otherwise extra steps if the current active
>> configuration is the same as the new requested configuration.
>>
>> A SetConfiguration() request will reset the device side data toggles.
>> Make sure usb core drops and adds back the endpoints in this case.
>>
>> To avoid code duplication split the current usb_disable_device() function
>> and reuse the endpoint specific part.
> 
> it looks like the refactoring is unrelated to the bug fix, perhaps? But
> then again, it would mean adding more duplication just for the sake of
> keeping bug fixes as pure bug fixes. No strong opinion.
> 

I like it like this :) 
Avoids code duplication, and is simple enough for stable releases compared
to complete usb_set_configuration() and usb_reset_configuration(), which was an option. 

>> Cc: stable <stable@vger.kernel.org>
> 
> missing fixes?

Not really, this has just never really worked, nothing broke it.
Closest would be one of the patches that add usb3 specific code to
usb_reset_configuration() in 2.6 kernel.

> 
>> Tested-by: Martin Thierer <mthierer@gmail.com>
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>> ---
>>  drivers/usb/core/message.c | 92 ++++++++++++++++++--------------------
>>  1 file changed, 43 insertions(+), 49 deletions(-)
>>
>> diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
>> index 6197938dcc2d..a1f67efc261f 100644
>> --- a/drivers/usb/core/message.c
>> +++ b/drivers/usb/core/message.c
>> @@ -1205,6 +1205,35 @@ void usb_disable_interface(struct usb_device *dev, struct usb_interface *intf,
>>  	}
>>  }
>>  
>> +/*
>> + * usb_disable_device_endpoints -- Disable all endpoints for a device
>> + * @dev: the device whose endpoints are being disabled
>> + * @skip_ep0: 0 to disable endpoint 0, 1 to skip it.
>> + */
>> +static void usb_disable_device_endpoints(struct usb_device *dev, int skip_ep0)
>> +{
>> +	struct usb_hcd *hcd = bus_to_hcd(dev->bus);
>> +	int i;
>> +
>> +	if (hcd->driver->check_bandwidth) {
>> +
> 
> maybe remove this blank line?

yes, this one was unintentional.

> 
>> +		/* First pass: Cancel URBs, leave endpoint pointers intact. */
>> +		for (i = skip_ep0; i < 16; ++i) {
>> +			usb_disable_endpoint(dev, i, false);
>> +			usb_disable_endpoint(dev, i + USB_DIR_IN, false);
>> +		}
> 
> maybe a blank line here?

Here I didn't want to alter the original style, like the next one. 

> 
>> +		/* Remove endpoints from the host controller internal state */
>> +		mutex_lock(hcd->bandwidth_mutex);
>> +		usb_hcd_alloc_bandwidth(dev, NULL, NULL, NULL);
>> +		mutex_unlock(hcd->bandwidth_mutex);
>> +	}
> 
> maybe a blank line here?
> 
>> +	/* Second pass: remove endpoint pointers */
>> +	for (i = skip_ep0; i < 16; ++i) {
>> +		usb_disable_endpoint(dev, i, true);
>> +		usb_disable_endpoint(dev, i + USB_DIR_IN, true);
>> +	}
>> +}
>> +
>>  /**
>>   * usb_disable_device - Disable all the endpoints for a USB device
>>   * @dev: the device whose endpoints are being disabled
>> @@ -1522,6 +1536,9 @@ EXPORT_SYMBOL_GPL(usb_set_interface);
>>   * The caller must own the device lock.
>>   *
>>   * Return: Zero on success, else a negative error code.
>> + *
>> + * If this routine fails the device will probably be in an unusable state
>> + * with endpoints disabled, and interfaces only partially enabled.
> 
> should you force U3 in that case?
> 

It didn't use to in the failing case, nor does usb_set_configuration() on failure.
I assumed the caller would handle a failure in their preferred way.
Probably reset the device, or perhaps as you suggest set it to U3 with
a usb_autosuspend_device()?

-Mathias

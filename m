Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52B526F940
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 11:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgIRJ0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 05:26:48 -0400
Received: from aibo.runbox.com ([91.220.196.211]:58386 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgIRJ0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 05:26:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=bcqGkR+PC73TSSTw1U8fz7wJqvsiaEbsoEiBiCjdPAc=; b=bjQC/ukOv50gKcCMnJkjB1B+Ce
        cxuUvZvTuwwPpSo1rfgjcccB9/tGna4AY8ck8FPyUBuJBbwKtLollbg89ldhb04dCNz3zeBrN2RuH
        xIFkGFC6J5lk8pR/KK84QImxxEnHekWvydfVzXp5kxu3VTfb2IFdGj/q/JSretBzx++YYJblLdUUS
        kRXtp/F98OWL6EzPK9nZdVVANEoCj1G/uEk6exmPmBzd51MO6uN2T8XS+Auio/WLku68QNF9yT33X
        aTmgnXxAD69aKRWu+HUvTGjhIX6MGGiKqC/Q0YYEBieQLFu+NQTE063g9PChPTPN8LDKRweipABNN
        Ij6qF54Q==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kJCfC-0000D4-JY; Fri, 18 Sep 2020 11:26:42 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kJCfB-0000Zc-Nt; Fri, 18 Sep 2020 11:26:41 +0200
Subject: Re: [PATCH 2/3] usbcore/driver: Fix incorrect downcast
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bastien Nocera <hadess@hadess.net>,
        Andrey Konovalov <andreyknvl@google.com>,
        syzkaller@googlegroups.com
References: <a6e14983a8849d5f75a43f403c7cc721b6e4a420.camel@hadess.net>
 <20200917144151.355848-1-m.v.b@runbox.com>
 <20200917144151.355848-2-m.v.b@runbox.com>
 <20200917150101.GA1088823@rowland.harvard.edu>
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
Message-ID: <7b2e6134-ef86-ac44-0d53-36070e8e8fed@runbox.com>
Date:   Fri, 18 Sep 2020 12:26:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200917150101.GA1088823@rowland.harvard.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17/09/2020 18.01, Alan Stern wrote:
> On Thu, Sep 17, 2020 at 05:41:50PM +0300, M. Vefa Bicakci wrote:
>> This commit resolves a minor bug in the selection/discovery of more
>> specific USB device drivers for devices that are currently bound to
>> generic USB device drivers.
>>
>> The bug is related to the way a candidate USB device driver is
>> compared against the generic USB device driver. The code in
>> is_dev_usb_generic_driver() assumes that the device driver in question
>> is a USB device driver by calling to_usb_device_driver(dev->driver)
>> to downcast; however I have observed that this assumption is not always
>> true, through code instrumentation.
>>
>> Given that USB device drivers are bound to struct device instances with
>> of the type &usb_device_type, this commit checks the return value of
>> is_usb_device() before the call to is_dev_usb_generic_driver(), and
>> therefore ensures that incorrect type downcasts do not occur. The use
>> of is_usb_device() was suggested by Bastien Nocera.
>>
>> This bug was found while investigating Andrey Konovalov's report
>> indicating USB/IP subsystem's misbehaviour with the generic USB device
>> driver matching code.
>>
>> Fixes: d5643d2249 ("USB: Fix device driver race")
>> Link: https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/
>> Cc: <stable@vger.kernel.org> # 5.8
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: Bastien Nocera <hadess@hadess.net>
>> Cc: Andrey Konovalov <andreyknvl@google.com>
>> Cc: <syzkaller@googlegroups.com>
>> Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
>> ---
>>   drivers/usb/core/driver.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
>> index 950044a6e77f..ba7acd6e7cc4 100644
>> --- a/drivers/usb/core/driver.c
>> +++ b/drivers/usb/core/driver.c
>> @@ -919,7 +919,7 @@ static int __usb_bus_reprobe_drivers(struct device *dev, void *data)
>>   	struct usb_device *udev;
>>   	int ret;
>>   
>> -	if (!is_dev_usb_generic_driver(dev))
>> +	if (!is_usb_device(dev) || !is_dev_usb_generic_driver(dev))
>>   		return 0;
>>   
>>   	udev = to_usb_device(dev);
>> -- 
>> 2.26.2
> 
> Why not simplify the whole thing by testing the underlying driver
> pointer?
> 
> 	/* Don't reprobe if current driver isn't usb_generic_driver */
> 	if (dev->driver != &usb_generic_driver.drvwrap.driver)
> 		return 0;
> 
> Then is_dev_usb_generic_driver can be removed entirely.

Alan, sorry for the delay, and thanks for the review! I had not thought
of this. I will apply the changes you have suggested with the next version
of the patch series.

Thanks again,

Vefa

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8039549C75F
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 11:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239852AbiAZKXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 05:23:45 -0500
Received: from mailgw.kylinos.cn ([123.150.8.42]:57874 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229517AbiAZKXo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jan 2022 05:23:44 -0500
X-UUID: 36ae1a71b7094682906f579959aa6dce-20220126
X-CPASD-INFO: a848a1cacdb948c69cbffc1f3d057405@qohuWI5jkZGPhKSFg3uucFmUkpaWj1G
        1dZ5QZWVkXFWVhH5xTWJsXVKBfG5QZWNdYVN_eGpQYl9gZFB5i3-XblBgXoZgUZB3sHpuWJFfkw==
X-CPASD-FEATURE: 0.0
X-CLOUD-ID: a848a1cacdb948c69cbffc1f3d057405
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,EXT:0.0,OB:0.0,URL:-5,T
        VAL:143.0,ESV:0.0,ECOM:-5.0,ML:0.0,FD:0.0,CUTS:288.0,IP:-2.0,MAL:0.0,ATTNUM:0
        .0,PHF:-5.0,PHC:-5.0,SPF:4.0,EDMS:-3,IPLABEL:4480.0,FROMTO:0,AD:0,FFOB:0.0,CF
        OB:0.0,SPC:0.0,SIG:-5,AUF:11,DUF:31851,ACD:176,DCD:278,SL:0,AG:0,CFC:0.801,CF
        SR:0.034,UAT:0,RAF:2,VERSION:2.3.4
X-CPASD-ID: 36ae1a71b7094682906f579959aa6dce-20220126
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1, 1
X-UUID: 36ae1a71b7094682906f579959aa6dce-20220126
X-User: xiehongyu1@kylinos.cn
Received: from [192.168.123.123] [(116.128.244.169)] by nksmu.kylinos.cn
        (envelope-from <xiehongyu1@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES128-GCM-SHA256 128/128)
        with ESMTP id 169201271; Wed, 26 Jan 2022 18:36:22 +0800
Message-ID: <c7f6a8bb-76b6-cd2d-7551-b599a8276f5c@kylinos.cn>
Date:   Wed, 26 Jan 2022 18:22:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH -next] xhci: fix two places when dealing with return value
 of function xhci_check_args
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Hongyu Xie <xy521521@gmail.com>
Cc:     mathias.nyman@intel.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, 125707942@qq.com, stable@vger.kernel.org
References: <20220126094126.923798-1-xy521521@gmail.com>
 <YfEZFtf9K8pFC8Mw@kroah.com>
From:   =?UTF-8?B?6LCi5rOT5a6H?= <xiehongyu1@kylinos.cn>
In-Reply-To: <YfEZFtf9K8pFC8Mw@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

1."What problem?
r8152_submit_rx needs to detach netdev if -ENODEV happened, but -ENODEV 
will never happen
because xhci_urb_enqueue only returns -EINVAL if the return value of 
xhci_check_args <= 0. So
r8152_submit_rx will will call napi_schedule to re-submit that urb, and 
this will cause infinite urb
submission.
The whole point is, if xhci_check_args returns value A, 
xhci_urb_enqueque shouldn't return any
other value, because that will change some driver's behavior(like r8152.c).

2."So if 0 is returned, you will now return that here, is that ok?
That is a change in functionality.
But this can only ever be the case for a root hub, is that ok?"

It's the same logic, but now xhci_urb_enqueue can return -ENODEV if xHC 
is halted.
If it happens on a root hub,  xhci_urb_enqueue won't be called.

3."Again, this means all is good?  Why is this being called for a root hub?"

It is the same logic with the old one, but now 
xhci_check_streams_endpoint can return -ENODEV if xHC is halted.


thanks

Hongyu Xie


On Tue, 25 Jan 2022 at 22:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org>  wrote:

> On Wed, Jan 26, 2022 at 05:41:26PM +0800, Hongyu Xie wrote:
>> From: Hongyu Xie <xiehongyu1@kylinos.cn>
>>
>> xhci_check_args returns 4 types of value, -ENODEV, -EINVAL, 1 and 0.
>> xhci_urb_enqueue and xhci_check_streams_endpoint return -EINVAL if
>> the return value of xhci_check_args <= 0.
>> This will cause a problem.
> What problem?
>
>> For example, r8152_submit_rx calling usb_submit_urb in
>> drivers/net/usb/r8152.c.
>> r8152_submit_rx will never get -ENODEV after submiting an urb
>> when xHC is halted,
>> because xhci_urb_enqueue returns -EINVAL in the very beginning.
>>
>> Fixes: 203a86613fb3 ("xhci: Avoid NULL pointer deref when host dies.")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
>> ---
>>   drivers/usb/host/xhci.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
>> index dc357cabb265..a7a55dd206fe 100644
>> --- a/drivers/usb/host/xhci.c
>> +++ b/drivers/usb/host/xhci.c
>> @@ -1604,9 +1604,12 @@ static int xhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
>>   	struct urb_priv	*urb_priv;
>>   	int num_tds;
>>   
>> -	if (!urb || xhci_check_args(hcd, urb->dev, urb->ep,
>> -					true, true, __func__) <= 0)
>> +	if (!urb)
>>   		return -EINVAL;
>> +	ret = xhci_check_args(hcd, urb->dev, urb->ep,
>> +					true, true, __func__);
>> +	if (ret <= 0)
>> +		return ret;
> So if 0 is returned, you will now return that here, is that ok?
> That is a change in functionality.
>
> But this can only ever be the case for a root hub, is that ok?
>
>>   
>>   	slot_id = urb->dev->slot_id;
>>   	ep_index = xhci_get_endpoint_index(&urb->ep->desc);
>> @@ -3323,7 +3326,7 @@ static int xhci_check_streams_endpoint(struct xhci_hcd *xhci,
>>   		return -EINVAL;
>>   	ret = xhci_check_args(xhci_to_hcd(xhci), udev, ep, 1, true, __func__);
>>   	if (ret <= 0)
>> -		return -EINVAL;
>> +		return ret;
> Again, this means all is good?  Why is this being called for a root hub?
>
> thanks,
>
> greg k-h

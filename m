Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA57649F1FE
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 04:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345823AbiA1DtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 22:49:25 -0500
Received: from mailgw.kylinos.cn ([123.150.8.42]:40173 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345802AbiA1DtZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Jan 2022 22:49:25 -0500
X-UUID: facb723e0da54eb09d073fef8ee6ec25-20220128
X-CPASD-INFO: 70958ec4a68e43d3a33cd22ff1ff1fb9
        @gIBzVWWXkWSNVnqxg3avbYFkY5OUXlK1qGuGll-
        WjlmVhH5xTWJsXVKBfG5QZWNdYVN_eGpQYl9gZFB5i3-XblBgXoZgUZB3hnJzVWiTkw==
X-CPASD-FEATURE: 0.0
X-CLOUD-ID: 70958ec4a68e43d3a33cd22ff1ff1fb9
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,EXT:0.0,OB:0.0,URL:-5,T
        VAL:143.0,ESV:0.0,ECOM:-5.0,ML:0.0,FD:0.0,CUTS:198.0,IP:-2.0,MAL:0.0,ATTNUM:0
        .0,PHF:-5.0,PHC:-5.0,SPF:4.0,EDMS:-3,IPLABEL:4480.0,FROMTO:0,AD:0,FFOB:0.0,CF
        OB:0.0,SPC:0.0,SIG:-5,AUF:13,DUF:32000,ACD:177,DCD:279,SL:0,AG:0,CFC:0.231,CF
        SR:0.192,UAT:0,RAF:2,VERSION:2.3.4
X-CPASD-ID: facb723e0da54eb09d073fef8ee6ec25-20220128
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1, 1
X-UUID: facb723e0da54eb09d073fef8ee6ec25-20220128
X-User: xiehongyu1@kylinos.cn
Received: from [172.20.4.10] [(116.128.244.169)] by nksmu.kylinos.cn
        (envelope-from <xiehongyu1@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES128-GCM-SHA256 128/128)
        with ESMTP id 1692616607; Fri, 28 Jan 2022 12:01:59 +0800
Message-ID: <ce40f4cd-a110-80b1-f766-e94dd8cedc7e@kylinos.cn>
Date:   Fri, 28 Jan 2022 11:48:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH -next] xhci: fix two places when dealing with return value
 of function xhci_check_args
Content-Language: en-US
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Hongyu Xie <xy521521@gmail.com>, mathias.nyman@intel.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        125707942@qq.com, stable@vger.kernel.org
References: <20220126094126.923798-1-xy521521@gmail.com>
 <YfEZFtf9K8pFC8Mw@kroah.com>
 <c7f6a8bb-76b6-cd2d-7551-b599a8276f5c@kylinos.cn>
 <YfEnbRW3oU0ouGqH@kroah.com>
 <e86972d3-e4a0-ad81-45ea-21137e3bfcb6@kylinos.cn>
 <7af5b318-b1ac-0c74-1782-04ba50a3b5fa@linux.intel.com>
From:   =?UTF-8?B?6LCi5rOT5a6H?= <xiehongyu1@kylinos.cn>
In-Reply-To: <7af5b318-b1ac-0c74-1782-04ba50a3b5fa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mathias,

On 2022/1/27 17:43, Mathias Nyman wrote:
> On 26.1.2022 14.49, Hongyu Xie wrote:
>
>>> Anyway, why is this unique to this one driver?  Why does it not show up
>>> for any other driver?
>> The whole thing is not about a particular driver. The thing is xhci_urb_enqueue shouldn't change the return value of xhci_check_args from -ENODEV to -EINVAL. Many other drivers only check if the return value of xchi_check_args is <= 0.
> Agree, lets return -ENODEV when appropriate.
>
>>>> The whole point is, if xhci_check_args returns value A, xhci_urb_enqueque
>>>> shouldn't return any
>>>> other value, because that will change some driver's behavior(like r8152.c).
>>> But you are changing how the code currently works.  Are you sure you
>>> want to have this "succeed" if this is on a root hub?
>> Yes, I'm changing how the code currently works but not on a root hub.
>>>> 2."So if 0 is returned, you will now return that here, is that ok?
>>>> That is a change in functionality.
>>>> But this can only ever be the case for a root hub, is that ok?"
>>>>
>>>> It's the same logic, but now xhci_urb_enqueue can return -ENODEV if xHC is
>>>> halted.
>>>> If it happens on a root hub,  xhci_urb_enqueue won't be called.
>>>>
>>>> 3."Again, this means all is good?  Why is this being called for a root hub?"
>>>>
>>>> It is the same logic with the old one, but now xhci_check_streams_endpoint
>>>> can return -ENODEV if xHC is halted.
>>> This still feels wrong to me, but I'll let the maintainer decide, as I
>>> don't understand why a root hub is special here.
>> Thanks please. usb_submit_urb will call usb_hcd_submit_urb. And usb_hcd_submit_urb will call rh_urb_enqueue if it's on a root hub instead of calling hcd->driver->urb_enqueue(which is xhci_urb_enqueue in this case).
> xhci_urb_enqueue() shouldn't be called for roothub urbs, but if it is then we
> should continue to return -EINVAL

xhci_urb_enqueue() won't be called for roothub urbs, only for none 
roothub urbs(see usb_hcd_submit_urb()).

So xhci_urb_enqueue() will not get 0 from xhci_check_args().

Still return -EINVAL if xhci_check_args() returns 0 in xhci_urb_enqueue()?

>
> xhci_check_args() should be rewritten later, but first we want a targeted fix
> that can go to stable.
>
> Your original patch would be ok after following modification:
> if (ret <= 0)
> 	return ret ? ret : -EINVAL;

I have two questions:

     1) Why return -EINVAL for roothub urbs?

     2) Should I change all the return statements about 
xhci_check_args() in drivers/usb/host/xhci.c?

     There are 6 of them.

>
> Thanks
> -Mathias

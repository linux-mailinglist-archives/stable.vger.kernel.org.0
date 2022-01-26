Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C700649CA07
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 13:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbiAZMt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 07:49:27 -0500
Received: from mailgw.kylinos.cn ([123.150.8.42]:24530 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229551AbiAZMt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jan 2022 07:49:27 -0500
X-UUID: b0221adf955c438ab4957d8a102d3e6d-20220126
X-CPASD-INFO: 17d2329a9048481a95955493be5e55a2@eoeeUmBkZ5FlUHaEg3t8m1lmaWVlYFm
        CpJ9VlWNljVKVhH5xTWVlZl5UfYBqVWVbZV9ZenRqUmFeaFxTi3akdmpQYIRkXW10d4ambFNiZ5E=
X-CPASD-FEATURE: 0.0
X-CLOUD-ID: 17d2329a9048481a95955493be5e55a2
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,EXT:0.0,OB:0.0,URL:0.5,
        TVAL:141.0,ESV:0.0,ECOM:0.0,ML:0.0,FD:0.0,CUTS:188.0,IP:-2.0,MAL:0.0,ATTNUM:0
        .0,PHF:1.0,PHC:0.0,SPF:4.0,EDMS:-3,IPLABEL:-2.0,FROMTO:0,AD:0,FFOB:0.0,CFOB:0
        .0,SPC:0.0,SIG:-5,AUF:12,DUF:31857,ACD:176,DCD:278,SL:0,AG:0,CFC:0.266,CFSR:0
        .205,UAT:0,RAF:2,VERSION:2.3.4
X-CPASD-ID: b0221adf955c438ab4957d8a102d3e6d-20220126
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1, 1
X-UUID: b0221adf955c438ab4957d8a102d3e6d-20220126
X-User: xiehongyu1@kylinos.cn
Received: from [192.168.0.106] [(120.227.33.40)] by nksmu.kylinos.cn
        (envelope-from <xiehongyu1@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES128-GCM-SHA256 128/128)
        with ESMTP id 293382729; Wed, 26 Jan 2022 21:02:02 +0800
Message-ID: <e86972d3-e4a0-ad81-45ea-21137e3bfcb6@kylinos.cn>
Date:   Wed, 26 Jan 2022 20:49:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH -next] xhci: fix two places when dealing with return value
 of function xhci_check_args
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Hongyu Xie <xy521521@gmail.com>, mathias.nyman@intel.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        125707942@qq.com, stable@vger.kernel.org
References: <20220126094126.923798-1-xy521521@gmail.com>
 <YfEZFtf9K8pFC8Mw@kroah.com>
 <c7f6a8bb-76b6-cd2d-7551-b599a8276f5c@kylinos.cn>
 <YfEnbRW3oU0ouGqH@kroah.com>
From:   Hongyu Xie <xiehongyu1@kylinos.cn>
In-Reply-To: <YfEnbRW3oU0ouGqH@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 2022/1/26 18:50, Greg KH wrote:
> A: http://en.wikipedia.org/wiki/Top_post
> Q: Were do I find info about this thing called top-posting?
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
>
> A: No.
> Q: Should I include quotations after my reply?
>
> http://daringfireball.net/2007/07/on_top
>
> On Wed, Jan 26, 2022 at 06:22:45PM +0800, 谢泓宇 wrote:
>> 1."What problem?
>> r8152_submit_rx needs to detach netdev if -ENODEV happened, but -ENODEV will
>> never happen
>> because xhci_urb_enqueue only returns -EINVAL if the return value of
>> xhci_check_args <= 0. So
>> r8152_submit_rx will will call napi_schedule to re-submit that urb, and this
>> will cause infinite urb
>> submission.
> Odd line-wrapping...
Sorry about my last reply.
>
> Anyway, why is this unique to this one driver?  Why does it not show up
> for any other driver?
The whole thing is not about a particular driver. The thing is 
xhci_urb_enqueue shouldn't change the return value of xhci_check_args 
from -ENODEV to -EINVAL. Many other drivers only check if the return 
value of xchi_check_args is <= 0.
>
>> The whole point is, if xhci_check_args returns value A, xhci_urb_enqueque
>> shouldn't return any
>> other value, because that will change some driver's behavior(like r8152.c).
> But you are changing how the code currently works.  Are you sure you
> want to have this "succeed" if this is on a root hub?
Yes, I'm changing how the code currently works but not on a root hub.
>
>> 2."So if 0 is returned, you will now return that here, is that ok?
>> That is a change in functionality.
>> But this can only ever be the case for a root hub, is that ok?"
>>
>> It's the same logic, but now xhci_urb_enqueue can return -ENODEV if xHC is
>> halted.
>> If it happens on a root hub,  xhci_urb_enqueue won't be called.
>>
>> 3."Again, this means all is good?  Why is this being called for a root hub?"
>>
>> It is the same logic with the old one, but now xhci_check_streams_endpoint
>> can return -ENODEV if xHC is halted.
> This still feels wrong to me, but I'll let the maintainer decide, as I
> don't understand why a root hub is special here.

Thanks please. usb_submit_urb will call usb_hcd_submit_urb. And 
usb_hcd_submit_urb will call rh_urb_enqueue if it's on a root hub 
instead of calling hcd->driver->urb_enqueue(which is xhci_urb_enqueue in 
this case).

>
> thanks,
>
> greg k-h

thanks,

Hongyu Xie


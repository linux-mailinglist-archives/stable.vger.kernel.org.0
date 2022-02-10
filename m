Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CDE4B01D7
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 02:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiBJBUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 20:20:25 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiBJBUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 20:20:21 -0500
Received: from nksmu.kylinos.cn (mailgw.kylinos.cn [123.150.8.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C92E84;
        Wed,  9 Feb 2022 17:20:18 -0800 (PST)
X-UUID: f752996293804c03af1205c5fae73d9a-20220210
X-CPASD-INFO: 10bbcf6a07a64175b9b2a3889822b914@eoCcgpCYZJFcV6OCg3SCb4JqkmKRX1i
        He3JSYpBpXVSVhH5xTWJsXVKBfG5QZWNdYVN_eGpQYl9gZFB5i3-XblBgXoZgUZB3gHKcgpOUZg==
X-CPASD-FEATURE: 0.0
X-CLOUD-ID: 10bbcf6a07a64175b9b2a3889822b914
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,EXT:0.0,OB:0.0,URL:-5,T
        VAL:133.0,ESV:0.0,ECOM:-5.0,ML:0.0,FD:0.0,CUTS:151.0,IP:-2.0,MAL:0.0,ATTNUM:0
        .0,PHF:-5.0,PHC:-5.0,SPF:4.0,EDMS:-3,IPLABEL:4480.0,FROMTO:0,AD:0,FFOB:0.0,CF
        OB:0.0,SPC:0.0,SIG:-5,AUF:15,DUF:32547,ACD:190,DCD:292,SL:0,AG:0,CFC:0.522,CF
        SR:0.063,UAT:0,RAF:2,VERSION:2.3.4
X-CPASD-ID: f752996293804c03af1205c5fae73d9a-20220210
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1, 1
X-UUID: f752996293804c03af1205c5fae73d9a-20220210
X-User: xiehongyu1@kylinos.cn
Received: from [172.20.4.10] [(116.128.244.169)] by nksmu.kylinos.cn
        (envelope-from <xiehongyu1@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES128-GCM-SHA256 128/128)
        with ESMTP id 1501960626; Thu, 10 Feb 2022 09:17:13 +0800
Message-ID: <59231732-82a3-3a0c-db0c-eec252b35d3b@kylinos.cn>
Date:   Thu, 10 Feb 2022 09:04:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH -next v2] xhci: fix two places when dealing with return
 value of function xhci_check_args
Content-Language: en-US
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Hongyu Xie <xy521521@gmail.com>, gregkh@linuxfoundation.org,
        mathias.nyman@intel.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220209025234.25230-1-xy521521@gmail.com>
 <89d59749-8ca3-b30b-4da6-a6e567528d1b@linux.intel.com>
From:   =?UTF-8?B?6LCi5rOT5a6H?= <xiehongyu1@kylinos.cn>
In-Reply-To: <89d59749-8ca3-b30b-4da6-a6e567528d1b@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        NICE_REPLY_A,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2022/2/9 17:29, Mathias Nyman wrote:
> On 9.2.2022 4.52, Hongyu Xie wrote:
>> From: Hongyu Xie <xiehongyu1@kylinos.cn>
>>
>> xhci_check_args returns 4 types of value, -ENODEV, -EINVAL, 1 and 0.
>> xhci_urb_enqueue and xhci_check_streams_endpoint return -EINVAL if
>> the return value of xhci_check_args <= 0.
>> This will cause a problem.
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
> Thanks, added to queue.
> Changed the commit message and header a bit:
>
> "xhci: Prevent futile URB re-submissions due to incorrect return value.
>      
> The -ENODEV return value from xhci_check_args() is incorrectly changed
> to -EINVAL in a couple places before propagated further.
>      
> xhci_check_args() returns 4 types of value, -ENODEV, -EINVAL, 1 and 0.
> xhci_urb_enqueue and xhci_check_streams_endpoint return -EINVAL if
> the return value of xhci_check_args <= 0.
> This causes problems for example r8152_submit_rx, calling usb_submit_urb
> in drivers/net/usb/r8152.c.
> r8152_submit_rx will never get -ENODEV after submiting an urb when xHC
> is halted because xhci_urb_enqueue returns -EINVAL in the very beginning."
>
> Let me know if you disagree with this.
>
> Thanks
> -Mathias

Sounds good to me.

Do I have to send another patch with commit message and header changed?

Thanks

Hongyu Xie


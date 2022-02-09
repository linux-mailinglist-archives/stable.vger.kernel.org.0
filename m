Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59844AE793
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 04:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244310AbiBIDD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 22:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243525AbiBIDC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 22:02:27 -0500
X-Greylist: delayed 306 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 19:02:22 PST
Received: from nksmu.kylinos.cn (mailgw.kylinos.cn [123.150.8.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30527C0612B8;
        Tue,  8 Feb 2022 19:02:19 -0800 (PST)
X-UUID: 1c6fefd360b84325acd0c6a5b21f4fbf-20220209
X-CPASD-INFO: a079444d41a24f238cb4d3f7f296489f@qoBxWWFmYpRgUaN-g6l9bViUkmSUX4a
        GqGxZZmJoZYaVhH5xTWJsXVKBfG5QZWNdYVN_eGpQYl9gZFB5i3-XblBgXoZgUZB3sHJxWWRiZA==
X-CPASD-FEATURE: 0.0
X-CLOUD-ID: a079444d41a24f238cb4d3f7f296489f
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,EXT:0.0,OB:0.0,URL:-5,T
        VAL:143.0,ESV:0.0,ECOM:-5.0,ML:0.0,FD:0.0,CUTS:189.0,IP:-2.0,MAL:0.0,ATTNUM:0
        .0,PHF:-5.0,PHC:-5.0,SPF:4.0,EDMS:-3,IPLABEL:-2.0,FROMTO:0,AD:0,FFOB:0.0,CFOB
        :0.0,SPC:0.0,SIG:-5,AUF:14,DUF:32487,ACD:189,DCD:291,SL:0,AG:0,CFC:0.22,CFSR:
        0.104,UAT:0,RAF:2,VERSION:2.3.4
X-CPASD-ID: 1c6fefd360b84325acd0c6a5b21f4fbf-20220209
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1, 1
X-UUID: 1c6fefd360b84325acd0c6a5b21f4fbf-20220209
X-User: xiehongyu1@kylinos.cn
Received: from [192.168.123.123] [(111.48.58.12)] by nksmu.kylinos.cn
        (envelope-from <xiehongyu1@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES128-GCM-SHA256 128/128)
        with ESMTP id 1336843540; Wed, 09 Feb 2022 10:59:31 +0800
Message-ID: <4f1bd7fb-050b-ddb3-da69-1e6d32a5a7a1@kylinos.cn>
Date:   Wed, 9 Feb 2022 10:47:04 +0800
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
 <ce40f4cd-a110-80b1-f766-e94dd8cedc7e@kylinos.cn>
 <6da59964-ce0e-c202-8a9c-a753a1908f3e@linux.intel.com>
From:   =?UTF-8?B?6LCi5rOT5a6H?= <xiehongyu1@kylinos.cn>
In-Reply-To: <6da59964-ce0e-c202-8a9c-a753a1908f3e@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        NICE_REPLY_A,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mathias,

On 2022/1/28 17:48, Mathias Nyman wrote:
> Hi
>
> On 28.1.2022 5.48, 谢泓宇 wrote:
>> Hi Mathias,
>>
>>> xhci_urb_enqueue() shouldn't be called for roothub urbs, but if it is then we
>>> should continue to return -EINVAL
>> xhci_urb_enqueue() won't be called for roothub urbs, only for none roothub urbs(see usb_hcd_submit_urb()).>
>> So xhci_urb_enqueue() will not get 0 from xhci_check_args().
>>
>> Still return -EINVAL if xhci_check_args() returns 0 in xhci_urb_enqueue()?
>>
> Yes. That is what it used to return.
> This is more about code maintaining practice than this specific patch.
>
> Only make the necessary change to fix a bug, especially if the patch is going
> to stable kernels.
> The change to return success ("0") instead of -EINVAL in xhci_urb_enqueue() for
> roothub URBs is irrelevant in fixing your issue.
>
> Debugging future issues is a lot harder when there are small undocumented
> unrelated functional changes scattered around bugfixing patches.
>
> Other reason is that even if you can be almost certain xhci_urb_enqueue() won't
> be called for roothub urbs for this kernel version, it's possible some old stable
> kernel code looks very different, and this change can break that stable version.
>
> Seemingly odd checks in code can indicate the old original code was flawed, and
> quickly worked around by adding the odd check.
> That kernel version might still depend on this odd check even if newer versions
> are fixed properly.
>
>>> xhci_check_args() should be rewritten later, but first we want a targeted fix
>>> that can go to stable.
>>>
>>> Your original patch would be ok after following modification:
>>> if (ret <= 0)
>>>      return ret ? ret : -EINVAL;
>> I have two questions:
>>
>>      1) Why return -EINVAL for roothub urbs?
> - For all reasons stated above
> - Because it used to, and changing it doesn't fix anything
> - Because urbs sent to xhci_urb_enqueue() should have a valid urb->dev->parent,
>    if they don't have it then they are INVALID
>
>>      2) Should I change all the return statements about xhci_check_args() in drivers/usb/host/xhci.c?
>>
>>      There are 6 of them.
> Only make sure your patch doesn't change the functionality unnecessarily.
> There are two places where we return -EINVAL if xhci_check_args() returns 0:
> xhci_urb_enqueue() and xhci_check_streams_endpoint()
> Keep that functionality.
>
> Thanks
> Mathias

I'll fix these in v2.

Thanks

Hongyu Xie


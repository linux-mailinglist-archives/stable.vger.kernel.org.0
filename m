Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6754B6C16
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 13:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbiBOMeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 07:34:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbiBOMeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 07:34:10 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FA9107D8A;
        Tue, 15 Feb 2022 04:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644928440; x=1676464440;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=sLQI5ORTV1kV1cuQi+Z9yl6vQkfQ2zOAURuoBBuhF7w=;
  b=lBmUB/el/aMVXw62ECxl4AvrKplJaNq7v8ZKwx40mRJcJIYsnk0+MyCA
   4/ZkB5KRrfV72PISpG0dtpkfb02MqxQ9rZEcvmkBlgau+VgYqi4R6UeVW
   tQ4bwGjAHyBLBCaqAR4TM+uyG5+/8dyphY2slyuUkwA4YNyXMTqBgzGi3
   1Iiwf24N5QIJSfc4lejii4eMGyZrQaT/jUY4BgWRZ2TvXezlmoKguTiyb
   qnqk+bW45PgyH9Yyn3w9T8/vObuSNb9ZBddjgZsmkvQbUXhAKU/yF3j4r
   3URSRaScYIJT5dfGZ9gl2XCKsgBkSsyFhiTEzTPk9cBCfIGbryABdQF+i
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="274914725"
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="274914725"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 04:34:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="570801911"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by orsmga001.jf.intel.com with ESMTP; 15 Feb 2022 04:33:58 -0800
Subject: Re: [PATCH v6] xhci: re-initialize the HC during resume if HCE was
 set
To:     Puma Hsu <pumahsu@google.com>
Cc:     mathias.nyman@intel.com, Greg KH <gregkh@linuxfoundation.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Albert Wang <albertccwang@google.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220129093036.488231-1-pumahsu@google.com>
 <413ce7e5-1c35-c3d0-a89e-a3c7f03b4db7@linux.intel.com>
 <CAGCq0La83AKrdk4w2b6wJLZVB0oKB7_AH3iqc4R0K1vDnqrX9A@mail.gmail.com>
 <86bd1bef-2f07-8dee-a125-be208903204e@linux.intel.com>
 <CAGCq0LZfYbqyFO8C5zct4cuUVEvs8CMN3g6MYO14_cLGdm-ATQ@mail.gmail.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <61c27edd-644f-decb-2255-30ee55637280@linux.intel.com>
Date:   Tue, 15 Feb 2022 14:35:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAGCq0LZfYbqyFO8C5zct4cuUVEvs8CMN3g6MYO14_cLGdm-ATQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.2.2022 14.05, Puma Hsu wrote:
> On Thu, Feb 10, 2022 at 7:08 PM Mathias Nyman
> <mathias.nyman@linux.intel.com> wrote:
>>
>> On 8.2.2022 9.11, Puma Hsu wrote:
>>> On Thu, Feb 3, 2022 at 3:11 AM Mathias Nyman
>>> <mathias.nyman@linux.intel.com> wrote:
>>>>
>>>> On 29.1.2022 11.30, Puma Hsu wrote:
>>>>> When HCE(Host Controller Error) is set, it means an internal
>>>>> error condition has been detected. Software needs to re-initialize
>>>>> the HC, so add this check in xhci resume.
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Puma Hsu <pumahsu@google.com>
>>>>> ---
>>>>> v2: Follow Sergey Shtylyov <s.shtylyov@omp.ru>'s comment.
>>>>> v3: Add stable@vger.kernel.org for stable release.
>>>>> v4: Refine the commit message.
>>>>> v5: Add a debug log. Follow Mathias Nyman <mathias.nyman@linux.intel.com>'s comment.
>>>>> v6: Fix the missing declaration for str.
>>>>>
>>>>>  drivers/usb/host/xhci.c | 7 +++++--
>>>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
>>>>> index dc357cabb265..6f1198068004 100644
>>>>> --- a/drivers/usb/host/xhci.c
>>>>> +++ b/drivers/usb/host/xhci.c
>>>>> @@ -1091,6 +1091,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
>>>>>       int                     retval = 0;
>>>>>       bool                    comp_timer_running = false;
>>>>>       bool                    pending_portevent = false;
>>>>> +     char                    str[XHCI_MSG_MAX];
>>>>>
>>>>>       if (!hcd->state)
>>>>>               return 0;
>>>>> @@ -1146,8 +1147,10 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
>>>>>               temp = readl(&xhci->op_regs->status);
>>>>>       }
>>>>>
>>>>> -     /* If restore operation fails, re-initialize the HC during resume */
>>>>> -     if ((temp & STS_SRE) || hibernated) {
>>>>> +     /* If restore operation fails or HC error is detected, re-initialize the HC during resume */
>>>>> +     if ((temp & (STS_SRE | STS_HCE)) || hibernated) {
>>>>> +             xhci_warn(xhci, "re-initialize HC during resume, USBSTS:%s\n",
>>>>> +                       xhci_decode_usbsts(str, temp));
>>>>>
>>>>>               if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
>>>>>                               !(xhci_all_ports_seen_u0(xhci))) {
>>>>>
>>>>
>>>> Ended up modifying this patch a bit more than I first intended,
>>>> - don't print warning in hibernation case, only error.
>>>> - maybe using a lot of stack for a debug string isn't really needed.
>>>> - make sure we read the usbsts register before checking for the HCE bit.
>>>>
>>>> Does the below work for you? If yes, and you agree I'll apply it instead
>>>
>>> Hi Mathias,
>>> Yes, your patch works for me, thanks!
>>> Will you submit a new patch? or should I update to a new version?
>>> Thanks.
>>
>> I'll submit it
> 
> Hi Mathias,
> Could I know when you will submit the new patch?
> We will sync the patch to our project.
> Thank you for your effort!

Just did, thanks for the reminder.

-Mathias

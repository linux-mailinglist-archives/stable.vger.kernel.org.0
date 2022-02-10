Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674AA4B07F6
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 09:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237265AbiBJIRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 03:17:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237266AbiBJIRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 03:17:48 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D075DA9;
        Thu, 10 Feb 2022 00:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644481070; x=1676017070;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=oy1isJLYwtuPuNrEw0LtVuMelYGGRN0YXlD3NuT4aUc=;
  b=W0KuWYrJOfARnNftxF3GKLkUKlp6SY2VhXeUU+6oYOMM20nFsVW2LMFa
   5pxlFhm4Rve8hFXtjbCuceDg41pxlsgiOQ/d+pWLChjJGWG+dUKkXSVN2
   ZjQ7Ybo74wEDftJu7C9x1ruHnbkE/HSSQ/46VCF2eFwiKCjURNR5CK1YS
   G6D7Ei5pbc/seVcompwdQyWkFx22H7dXKhDX8IR3RN8kIjV2OnlL8W4VA
   OMQyNkkLMix/PbcdIWTMARyq7oEV69t3+66R2E7Snw4nkDw7hXmMQkZmD
   tnLlTDcfff0Akzb71e7bG2dNeA1gq5X7pvzKzcR/SyOshbYlWUaY7fxXh
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="229407980"
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="229407980"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 00:17:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="568562945"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by orsmga001.jf.intel.com with ESMTP; 10 Feb 2022 00:17:24 -0800
Subject: Re: [PATCH -next v2] xhci: fix two places when dealing with return
 value of function xhci_check_args
To:     =?UTF-8?B?6LCi5rOT5a6H?= <xiehongyu1@kylinos.cn>,
        Hongyu Xie <xy521521@gmail.com>, gregkh@linuxfoundation.org,
        mathias.nyman@intel.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220209025234.25230-1-xy521521@gmail.com>
 <89d59749-8ca3-b30b-4da6-a6e567528d1b@linux.intel.com>
 <59231732-82a3-3a0c-db0c-eec252b35d3b@kylinos.cn>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <1e4bdc41-abcf-a082-140a-3dcead7073c6@linux.intel.com>
Date:   Thu, 10 Feb 2022 10:18:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <59231732-82a3-3a0c-db0c-eec252b35d3b@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.2.2022 3.04, 谢泓宇 wrote:
> Hi,
> 
> On 2022/2/9 17:29, Mathias Nyman wrote:
>> On 9.2.2022 4.52, Hongyu Xie wrote:
>>> From: Hongyu Xie <xiehongyu1@kylinos.cn>
>>>
>>> xhci_check_args returns 4 types of value, -ENODEV, -EINVAL, 1 and 0.
>>> xhci_urb_enqueue and xhci_check_streams_endpoint return -EINVAL if
>>> the return value of xhci_check_args <= 0.
>>> This will cause a problem.
>>> For example, r8152_submit_rx calling usb_submit_urb in
>>> drivers/net/usb/r8152.c.
>>> r8152_submit_rx will never get -ENODEV after submiting an urb
>>> when xHC is halted,
>>> because xhci_urb_enqueue returns -EINVAL in the very beginning.
>>>
>>> Fixes: 203a86613fb3 ("xhci: Avoid NULL pointer deref when host dies.")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
>>> ---
>> Thanks, added to queue.
>> Changed the commit message and header a bit:
>>
>> "xhci: Prevent futile URB re-submissions due to incorrect return value.
>>      The -ENODEV return value from xhci_check_args() is incorrectly changed
>> to -EINVAL in a couple places before propagated further.
>>      xhci_check_args() returns 4 types of value, -ENODEV, -EINVAL, 1 and 0.
>> xhci_urb_enqueue and xhci_check_streams_endpoint return -EINVAL if
>> the return value of xhci_check_args <= 0.
>> This causes problems for example r8152_submit_rx, calling usb_submit_urb
>> in drivers/net/usb/r8152.c.
>> r8152_submit_rx will never get -ENODEV after submiting an urb when xHC
>> is halted because xhci_urb_enqueue returns -EINVAL in the very beginning."
>>
>> Let me know if you disagree with this.
>>
>> Thanks
>> -Mathias
> 
> Sounds good to me.
> 
> Do I have to send another patch with commit message and header changed?
> 
> Thanks
> 
> Hongyu Xie
> 

No need, I'll submit it.

-Mathias

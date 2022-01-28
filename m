Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FCA49F69D
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 10:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347707AbiA1Jra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 04:47:30 -0500
Received: from mga03.intel.com ([134.134.136.65]:15409 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238349AbiA1Jra (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jan 2022 04:47:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643363250; x=1674899250;
  h=to:cc:references:from:subject:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Fq9sQu/cN/lUsmIqrFTexk8KVRNWRRIf2vdhORwEjNA=;
  b=Qf3oLsjHRAf/su0eHffVmM+qMudN9axNyeuXp7+DAQV+kRHRJqrDie1n
   sOIjpUUpqFhBPBK37gBj+78iRis4+AUZA8hi8XttIlKnF8tJgXN1B68eu
   lNLmcBj6zo8aDfC6AidMgdWkRCfYFr+Ju9HgYHDsV21TGddo4CCRk9oDf
   NE/NSyvhnZjjautVbn17kCmZZAizxh4yVIw6tHNcWKYmgHYy/ZMQHcvEk
   6iUXZr93l3uw2qfF0OWX79N8JG60Na63Iu02Dc7dy5QGkeHVRsWMC5XGj
   gZ9k/x+9NAbsHIY8T6t2FVCLlv7idYhs7fhv3Q07IPfjcVWdI6ljY4LYy
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10240"; a="247035970"
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="247035970"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 01:47:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="564147519"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by orsmga001.jf.intel.com with ESMTP; 28 Jan 2022 01:47:26 -0800
To:     =?UTF-8?B?6LCi5rOT5a6H?= <xiehongyu1@kylinos.cn>,
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
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH -next] xhci: fix two places when dealing with return value
 of function xhci_check_args
Message-ID: <6da59964-ce0e-c202-8a9c-a753a1908f3e@linux.intel.com>
Date:   Fri, 28 Jan 2022 11:48:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ce40f4cd-a110-80b1-f766-e94dd8cedc7e@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On 28.1.2022 5.48, 谢泓宇 wrote:
> Hi Mathias,
> 
>> xhci_urb_enqueue() shouldn't be called for roothub urbs, but if it is then we
>> should continue to return -EINVAL
> 
> xhci_urb_enqueue() won't be called for roothub urbs, only for none roothub urbs(see usb_hcd_submit_urb()).> 
> So xhci_urb_enqueue() will not get 0 from xhci_check_args().
> 
> Still return -EINVAL if xhci_check_args() returns 0 in xhci_urb_enqueue()?
> 

Yes. That is what it used to return. 
This is more about code maintaining practice than this specific patch.

Only make the necessary change to fix a bug, especially if the patch is going
to stable kernels. 
The change to return success ("0") instead of -EINVAL in xhci_urb_enqueue() for 
roothub URBs is irrelevant in fixing your issue.

Debugging future issues is a lot harder when there are small undocumented
unrelated functional changes scattered around bugfixing patches.

Other reason is that even if you can be almost certain xhci_urb_enqueue() won't
be called for roothub urbs for this kernel version, it's possible some old stable
kernel code looks very different, and this change can break that stable version.

Seemingly odd checks in code can indicate the old original code was flawed, and
quickly worked around by adding the odd check.
That kernel version might still depend on this odd check even if newer versions
are fixed properly.

>>
>> xhci_check_args() should be rewritten later, but first we want a targeted fix
>> that can go to stable.
>>
>> Your original patch would be ok after following modification:
>> if (ret <= 0)
>>     return ret ? ret : -EINVAL;
> 
> I have two questions:
> 
>     1) Why return -EINVAL for roothub urbs?

- For all reasons stated above
- Because it used to, and changing it doesn't fix anything
- Because urbs sent to xhci_urb_enqueue() should have a valid urb->dev->parent,
  if they don't have it then they are INVALID

> 
>     2) Should I change all the return statements about xhci_check_args() in drivers/usb/host/xhci.c?
> 
>     There are 6 of them.

Only make sure your patch doesn't change the functionality unnecessarily.
There are two places where we return -EINVAL if xhci_check_args() returns 0:
xhci_urb_enqueue() and xhci_check_streams_endpoint()
Keep that functionality.

Thanks
Mathias

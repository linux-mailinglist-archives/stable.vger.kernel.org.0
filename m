Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFB749DE44
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 10:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238742AbiA0JmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 04:42:07 -0500
Received: from mga05.intel.com ([192.55.52.43]:47056 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238735AbiA0JmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Jan 2022 04:42:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643276527; x=1674812527;
  h=to:cc:references:from:subject:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=djY3xch7vPOo6t9rLWfXPw5PY5fSqNMg5UzbPQHL0bc=;
  b=Fr5gtKAf4egwCp/ODryu8C4mpCG5mmbFIlN+R7vX09BQd9Qo8KtJ/RNi
   p0CcQZ0fvsWFYsSDkjuHW4B00l8n9F8h0rD4tFMMGUmRKTNnJibkHI8u5
   /5++fNmgi5+eE/PjZcag2P/J59BiZJ8erRA63kIBquOP7wigtFAaNNiK0
   V0/e52a7Jvg2Q64bxaZZcjVu5s2x1aUXF/P/UefFplZ17EC4YvrQHLP7H
   HJW+2OsSt8WHKZWtqPiawoWosEO+BzWrXfy8nSvI+fjDWT4jg33BOXo8T
   SBdidxnv7DKDEx3Z4wcVejJaOVxaECmPqqy/1oNsyURsWydgc0r19x2FQ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="333156716"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="333156716"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 01:42:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="563725468"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by orsmga001.jf.intel.com with ESMTP; 27 Jan 2022 01:42:01 -0800
To:     Hongyu Xie <xiehongyu1@kylinos.cn>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Hongyu Xie <xy521521@gmail.com>, mathias.nyman@intel.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        125707942@qq.com, stable@vger.kernel.org
References: <20220126094126.923798-1-xy521521@gmail.com>
 <YfEZFtf9K8pFC8Mw@kroah.com>
 <c7f6a8bb-76b6-cd2d-7551-b599a8276f5c@kylinos.cn>
 <YfEnbRW3oU0ouGqH@kroah.com>
 <e86972d3-e4a0-ad81-45ea-21137e3bfcb6@kylinos.cn>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH -next] xhci: fix two places when dealing with return value
 of function xhci_check_args
Message-ID: <7af5b318-b1ac-0c74-1782-04ba50a3b5fa@linux.intel.com>
Date:   Thu, 27 Jan 2022 11:43:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <e86972d3-e4a0-ad81-45ea-21137e3bfcb6@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26.1.2022 14.49, Hongyu Xie wrote:

>> Anyway, why is this unique to this one driver?  Why does it not show up
>> for any other driver?
> The whole thing is not about a particular driver. The thing is xhci_urb_enqueue shouldn't change the return value of xhci_check_args from -ENODEV to -EINVAL. Many other drivers only check if the return value of xchi_check_args is <= 0.

Agree, lets return -ENODEV when appropriate.

>>
>>> The whole point is, if xhci_check_args returns value A, xhci_urb_enqueque
>>> shouldn't return any
>>> other value, because that will change some driver's behavior(like r8152.c).
>> But you are changing how the code currently works.  Are you sure you
>> want to have this "succeed" if this is on a root hub?
> Yes, I'm changing how the code currently works but not on a root hub.
>>
>>> 2."So if 0 is returned, you will now return that here, is that ok?
>>> That is a change in functionality.
>>> But this can only ever be the case for a root hub, is that ok?"
>>>
>>> It's the same logic, but now xhci_urb_enqueue can return -ENODEV if xHC is
>>> halted.
>>> If it happens on a root hub,  xhci_urb_enqueue won't be called.
>>>
>>> 3."Again, this means all is good?  Why is this being called for a root hub?"
>>>
>>> It is the same logic with the old one, but now xhci_check_streams_endpoint
>>> can return -ENODEV if xHC is halted.
>> This still feels wrong to me, but I'll let the maintainer decide, as I
>> don't understand why a root hub is special here.
> 
> Thanks please. usb_submit_urb will call usb_hcd_submit_urb. And usb_hcd_submit_urb will call rh_urb_enqueue if it's on a root hub instead of calling hcd->driver->urb_enqueue(which is xhci_urb_enqueue in this case).

xhci_urb_enqueue() shouldn't be called for roothub urbs, but if it is then we
should continue to return -EINVAL 

xhci_check_args() should be rewritten later, but first we want a targeted fix
that can go to stable.

Your original patch would be ok after following modification:
if (ret <= 0)
	return ret ? ret : -EINVAL;

Thanks
-Mathias

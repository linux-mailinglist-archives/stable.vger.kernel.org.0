Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A5849088F
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 13:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239821AbiAQMUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 07:20:47 -0500
Received: from mga14.intel.com ([192.55.52.115]:35821 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236978AbiAQMUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jan 2022 07:20:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642422047; x=1673958047;
  h=to:cc:references:from:subject:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=bDk7Xh2Uwl1ciemzd6BPTU50WsyNshlNM0SSyDlnoag=;
  b=CRKKsHYyF+v8oymy98oBTrRI6yr92xUw29kMYaXvsZttR1fGZ7wa4yLq
   zxw6wxn/zVxyul2VgdjsuDwH6xT5pqmIeYZLm58+tGtninn4yhJyx2kZ1
   hdR63fYSxRTO7qeshT2xp8wvduXryrJFhTMXUxqUZcT/zI7XCEp4bgr0P
   2OWg6oduV2gVqzo4kyz2xUwSQFcQMhBhYmKD4MONcXAamnYjnC8EN/C0f
   hd8A11tjphepDXA7zh0+a+Qm/Oa18McbeCmajmKy1yjKM+SkS9qcIIs+J
   0BhEWXpyMwruL9FhvInJnuVjxZoBQNIJZjtW/7eCyTJkI+pmdDQ+zrLFT
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10229"; a="244810402"
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="244810402"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 04:20:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="625175556"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by orsmga004.jf.intel.com with ESMTP; 17 Jan 2022 04:20:43 -0800
To:     Puma Hsu <pumahsu@google.com>, Greg KH <gregkh@linuxfoundation.org>
Cc:     mathias.nyman@intel.com, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Albert Wang <albertccwang@google.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20211229112551.3483931-1-pumahsu@google.com>
 <Yd1tUKhyZf26OVNQ@kroah.com>
 <CAGCq0LZb8nQDvcz=LswWi4qKd-65ys6iPjTKh=46dVtYLDEUVw@mail.gmail.com>
 <Yd/g/ywBWZG7gF8v@kroah.com>
 <CAGCq0LZ3i8VaMfRWNKvH_-ms0TgNqKA6f+Zx7M=iz1t_-smW+g@mail.gmail.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH v3] xhci: re-initialize the HC during resume if HCE was
 set
Message-ID: <fe411488-c67c-62ab-4709-98621b9f199b@linux.intel.com>
Date:   Mon, 17 Jan 2022 14:22:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAGCq0LZ3i8VaMfRWNKvH_-ms0TgNqKA6f+Zx7M=iz1t_-smW+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>>> This seems like a big hammer for when the host controller throws an
>>>> error.  Why is this the only place that it should be checked for?  What
>>>> caused the error that can now allow it to be fixed?
>>>
>>> I believe this is not the only place that the host controller may set
>>> HCE, the host controller may set HCE anytime it sees an error in my
>>> opinion, not only in suspend or resume.
>>
>> Then where else should it be checked?  Where else will your silicon set
>> this bit as part of the normal operating process?
> 
> We observed this flag while resume in our silicon so far. According to the XHCI
> specification 4.24.1, “Software should implement an algorithm for checking the
> HCE flag if the xHC is not responding.”, so maybe it would be better
> to implement
> a new API to recover host controller whenever the driver side finds no response
> from host controller in the future.
> 

As all the code to reset the host during resume already exists, and is well tried
due to issues in resume being so common, I think it makes sense to add the HCE case 
here as well. It's a simple fix that makes the life of users better.

That said we shouldn't hide the reason for reset like this.
Print a debug message telling about the HCE so that everybody working with xHCI
can see it and start fixing the rootcause.

Another HCE check could be added to command timeout code, but just to show a
warning for now.
Reset might not always clear HCE, and we don't want to be stuck in a reset loop.
This check  could be a separate patch

-Mathias

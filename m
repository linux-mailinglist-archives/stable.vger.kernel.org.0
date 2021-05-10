Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE49377E42
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhEJIeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:34:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:42326 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhEJIeD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 04:34:03 -0400
IronPort-SDR: 7ijODCU5M6GnOcM9l/OGgmtYoS0LHGYz39FUWEUS/j9ifonRg6mxl+rFPItaIfKfTu0PFDkm7D
 tA+CRdRsdMXg==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="284626354"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="284626354"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:32:59 -0700
IronPort-SDR: EI6UBs0GHV3icPsMda52IPH37BYgVnWhaaGj5zqVCose/og3/4GEBs4LFn3kLp+v2Feg7yeNcq
 l7DNyidfXprg==
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="470722622"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.212.136]) ([10.254.212.136])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:32:56 -0700
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com, maz@kernel.org,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, cohuck@redhat.com,
        stable@vger.kernel.org
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
 <b309c02d-9570-6400-9a0c-63030aed7ff7@redhat.com>
 <a659fc6f-2c7a-23d2-9c34-0044d5a31861@intel.com>
 <e5d63867-7a4a-963f-9fbd-741ccd3ec360@redhat.com>
 <b822cde1-7970-dac0-26cc-da1daa0b622f@intel.com>
Message-ID: <feee2889-6e91-46f3-123f-826a9c4ef43c@intel.com>
Date:   Mon, 10 May 2021 16:32:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <b822cde1-7970-dac0-26cc-da1daa0b622f@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/10/2021 3:09 PM, Zhu, Lingshan wrote:
>
>
> On 5/10/2021 12:34 PM, Jason Wang wrote:
>>
>> 在 2021/5/10 上午11:00, Zhu, Lingshan 写道:
>>>
>>>
>>> On 5/10/2021 10:43 AM, Jason Wang wrote:
>>>>
>>>> 在 2021/5/8 下午3:11, Zhu Lingshan 写道:
>>>>> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
>>>>>
>>>>> The reverted commit may cause VM freeze on arm64 platform.
>>>>> Because on arm64 platform, stop a consumer will suspend the VM,
>>>>> the VM will freeze without a start consumer
>>>>>
>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>
>>>>
>>>> Acked-by: Jason Wang <jasowang@redhat.com>
>>>>
>>>> Please resubmit with the formal process of stable 
>>>> (stable-kernel-rules.rst).
>>> sure, I will re-submit it to stable kernel once it is merged into 
>>> Linus tree.
>>>
>>> Thanks
>>
>>
>> I think it's better to resubmit (option 1), see how 
>> stable-kernel-rules.rst said:
>>
>> ""
>>
>> :ref:`option_1` is **strongly** preferred, is the easiest and most 
>> common.
>> :ref:`option_2` and :ref:`option_3` are more useful if the patch 
>> isn't deemed
>> worthy at the time it is applied to a public git tree (for instance, 
>> because
>> it deserves more regression testing first).
>>
>> """
>>
>> Thanks
> OK, works for me, I will add cc stable, and resubmit it soon
>
> Thanks!
I just seeMarc has already added "Cc: stable@vger.kernel.org", and he 
would take the patch in his tree,
so I think no need to resend.

Thanks,
Zhu Lingshan
>>
>>
>>>>
>>>> Thanks
>>>>
>>>>
>>>>> ---
>>>>>   virt/lib/irqbypass.c | 16 ++++++----------
>>>>>   1 file changed, 6 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
>>>>> index c9bb3957f58a..28fda42e471b 100644
>>>>> --- a/virt/lib/irqbypass.c
>>>>> +++ b/virt/lib/irqbypass.c
>>>>> @@ -40,21 +40,17 @@ static int __connect(struct 
>>>>> irq_bypass_producer *prod,
>>>>>       if (prod->add_consumer)
>>>>>           ret = prod->add_consumer(prod, cons);
>>>>>   -    if (ret)
>>>>> -        goto err_add_consumer;
>>>>> -
>>>>> -    ret = cons->add_producer(cons, prod);
>>>>> -    if (ret)
>>>>> -        goto err_add_producer;
>>>>> +    if (!ret) {
>>>>> +        ret = cons->add_producer(cons, prod);
>>>>> +        if (ret && prod->del_consumer)
>>>>> +            prod->del_consumer(prod, cons);
>>>>> +    }
>>>>>         if (cons->start)
>>>>>           cons->start(cons);
>>>>>       if (prod->start)
>>>>>           prod->start(prod);
>>>>> -err_add_producer:
>>>>> -    if (prod->del_consumer)
>>>>> -        prod->del_consumer(prod, cons);
>>>>> -err_add_consumer:
>>>>> +
>>>>>       return ret;
>>>>>   }
>>>>
>>>
>>
>


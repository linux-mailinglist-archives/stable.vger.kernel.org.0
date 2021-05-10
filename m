Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F286377CF1
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 09:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhEJHLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 03:11:02 -0400
Received: from mga06.intel.com ([134.134.136.31]:35503 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhEJHLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 03:11:02 -0400
IronPort-SDR: tB5UBB5572ApdpQmqxgJhfz/e60o2QKOojwptGdVqlRdioJznMkj1qxMUq7HaeAXjAsQXGn1P2
 GlA66FE/kFdQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="260395544"
X-IronPort-AV: E=Sophos;i="5.82,286,1613462400"; 
   d="scan'208";a="260395544"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 00:09:56 -0700
IronPort-SDR: o0cXtX7zzu3uW9T2hJ+jaCGwDlWLBh+AsAvwRMc7EH2cGJ2bNXhLg1+iE3YSh74xWeRrtgnppO
 4P3A9+apSpHw==
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="470697844"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.212.136]) ([10.254.212.136])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 00:09:50 -0700
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com, maz@kernel.org,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, cohuck@redhat.com,
        stable@vger.kernel.org
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
 <b309c02d-9570-6400-9a0c-63030aed7ff7@redhat.com>
 <a659fc6f-2c7a-23d2-9c34-0044d5a31861@intel.com>
 <e5d63867-7a4a-963f-9fbd-741ccd3ec360@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <b822cde1-7970-dac0-26cc-da1daa0b622f@intel.com>
Date:   Mon, 10 May 2021 15:09:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <e5d63867-7a4a-963f-9fbd-741ccd3ec360@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/10/2021 12:34 PM, Jason Wang wrote:
>
> 在 2021/5/10 上午11:00, Zhu, Lingshan 写道:
>>
>>
>> On 5/10/2021 10:43 AM, Jason Wang wrote:
>>>
>>> 在 2021/5/8 下午3:11, Zhu Lingshan 写道:
>>>> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
>>>>
>>>> The reverted commit may cause VM freeze on arm64 platform.
>>>> Because on arm64 platform, stop a consumer will suspend the VM,
>>>> the VM will freeze without a start consumer
>>>>
>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>
>>>
>>> Acked-by: Jason Wang <jasowang@redhat.com>
>>>
>>> Please resubmit with the formal process of stable 
>>> (stable-kernel-rules.rst).
>> sure, I will re-submit it to stable kernel once it is merged into 
>> Linus tree.
>>
>> Thanks
>
>
> I think it's better to resubmit (option 1), see how 
> stable-kernel-rules.rst said:
>
> ""
>
> :ref:`option_1` is **strongly** preferred, is the easiest and most 
> common.
> :ref:`option_2` and :ref:`option_3` are more useful if the patch isn't 
> deemed
> worthy at the time it is applied to a public git tree (for instance, 
> because
> it deserves more regression testing first).
>
> """
>
> Thanks
OK, works for me, I will add cc stable, and resubmit it soon

Thanks!
>
>
>>>
>>> Thanks
>>>
>>>
>>>> ---
>>>>   virt/lib/irqbypass.c | 16 ++++++----------
>>>>   1 file changed, 6 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
>>>> index c9bb3957f58a..28fda42e471b 100644
>>>> --- a/virt/lib/irqbypass.c
>>>> +++ b/virt/lib/irqbypass.c
>>>> @@ -40,21 +40,17 @@ static int __connect(struct irq_bypass_producer 
>>>> *prod,
>>>>       if (prod->add_consumer)
>>>>           ret = prod->add_consumer(prod, cons);
>>>>   -    if (ret)
>>>> -        goto err_add_consumer;
>>>> -
>>>> -    ret = cons->add_producer(cons, prod);
>>>> -    if (ret)
>>>> -        goto err_add_producer;
>>>> +    if (!ret) {
>>>> +        ret = cons->add_producer(cons, prod);
>>>> +        if (ret && prod->del_consumer)
>>>> +            prod->del_consumer(prod, cons);
>>>> +    }
>>>>         if (cons->start)
>>>>           cons->start(cons);
>>>>       if (prod->start)
>>>>           prod->start(prod);
>>>> -err_add_producer:
>>>> -    if (prod->del_consumer)
>>>> -        prod->del_consumer(prod, cons);
>>>> -err_add_consumer:
>>>> +
>>>>       return ret;
>>>>   }
>>>
>>
>


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA20377A41
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 05:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhEJDB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 23:01:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:21244 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229670AbhEJDB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 May 2021 23:01:56 -0400
IronPort-SDR: 6qd5Kxqh9nrymG/viMa26NW014kv8W0uhu9kGerF8fhXvP+feoRvsBJcZO1UgVKhSKWCPBH2KE
 mWqf6P+KYYtA==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="284581979"
X-IronPort-AV: E=Sophos;i="5.82,286,1613462400"; 
   d="scan'208";a="284581979"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2021 20:00:52 -0700
IronPort-SDR: uhZUQngbuGEQq0E1Bk7Pmkzto28JvYBFdcwQNt85aUpzZFrDhbnyklFDUPSNkQ4wyJETH7Xnd5
 t9ejrt3/uhrg==
X-IronPort-AV: E=Sophos;i="5.82,286,1613462400"; 
   d="scan'208";a="435941124"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.212.136]) ([10.254.212.136])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2021 20:00:49 -0700
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com, maz@kernel.org,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, cohuck@redhat.com,
        stable@vger.kernel.org
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
 <b309c02d-9570-6400-9a0c-63030aed7ff7@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <a659fc6f-2c7a-23d2-9c34-0044d5a31861@intel.com>
Date:   Mon, 10 May 2021 11:00:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <b309c02d-9570-6400-9a0c-63030aed7ff7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/10/2021 10:43 AM, Jason Wang wrote:
>
> 在 2021/5/8 下午3:11, Zhu Lingshan 写道:
>> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
>>
>> The reverted commit may cause VM freeze on arm64 platform.
>> Because on arm64 platform, stop a consumer will suspend the VM,
>> the VM will freeze without a start consumer
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>
>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> Please resubmit with the formal process of stable 
> (stable-kernel-rules.rst).
sure, I will re-submit it to stable kernel once it is merged into Linus 
tree.

Thanks
>
> Thanks
>
>
>> ---
>>   virt/lib/irqbypass.c | 16 ++++++----------
>>   1 file changed, 6 insertions(+), 10 deletions(-)
>>
>> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
>> index c9bb3957f58a..28fda42e471b 100644
>> --- a/virt/lib/irqbypass.c
>> +++ b/virt/lib/irqbypass.c
>> @@ -40,21 +40,17 @@ static int __connect(struct irq_bypass_producer 
>> *prod,
>>       if (prod->add_consumer)
>>           ret = prod->add_consumer(prod, cons);
>>   -    if (ret)
>> -        goto err_add_consumer;
>> -
>> -    ret = cons->add_producer(cons, prod);
>> -    if (ret)
>> -        goto err_add_producer;
>> +    if (!ret) {
>> +        ret = cons->add_producer(cons, prod);
>> +        if (ret && prod->del_consumer)
>> +            prod->del_consumer(prod, cons);
>> +    }
>>         if (cons->start)
>>           cons->start(cons);
>>       if (prod->start)
>>           prod->start(prod);
>> -err_add_producer:
>> -    if (prod->del_consumer)
>> -        prod->del_consumer(prod, cons);
>> -err_add_consumer:
>> +
>>       return ret;
>>   }
>


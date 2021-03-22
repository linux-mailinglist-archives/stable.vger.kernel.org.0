Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E05343F8E
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 12:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhCVLXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 07:23:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230010AbhCVLWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 07:22:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616412160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H7FM+EfpOKgcYU35xLw4tXyD/liddu9m0RQO74OmR04=;
        b=WaJ5ww7RUC0bytBsSIUHUpyV+8ff8mgbfNZZfmR+sgfOlhdI4PMUvvbtSOKnGz8rpVuNsu
        gIvdJ7kJcXCViTTkoZheMUSyV5znbjB5U3vKvS9jGoLlZhTgvL8UaJpwzjnIKd8thkULcn
        v/dIRnzODWaJPbUOxG+FV2MgkRtxMDo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-7RJwYWYiMDyDj_DdUXUzCA-1; Mon, 22 Mar 2021 07:22:34 -0400
X-MC-Unique: 7RJwYWYiMDyDj_DdUXUzCA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAE141034AE7;
        Mon, 22 Mar 2021 11:22:32 +0000 (UTC)
Received: from [10.36.115.54] (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D4751B49E;
        Mon, 22 Mar 2021 11:22:30 +0000 (UTC)
Subject: Re: [PATCH v1 1/2] s390/kvm: split kvm_s390_real_to_abs
From:   David Hildenbrand <david@redhat.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
References: <20210319193354.399587-1-imbrenda@linux.ibm.com>
 <20210319193354.399587-2-imbrenda@linux.ibm.com>
 <fa583ab0-36ac-47a7-7fa3-4ce88c518488@redhat.com>
 <f76f770c-908e-4f4f-f060-15f4d30652d8@redhat.com> <YFh7nGfVZRD15Cbp@osiris>
 <c394c3ce-2d13-b3d1-c886-22478fee7dcb@redhat.com>
Organization: Red Hat GmbH
Message-ID: <71822096-fb31-e2ca-0cac-c6b4400a8118@redhat.com>
Date:   Mon, 22 Mar 2021 12:22:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <c394c3ce-2d13-b3d1-c886-22478fee7dcb@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22.03.21 12:16, David Hildenbrand wrote:
> On 22.03.21 12:12, Heiko Carstens wrote:
>> On Mon, Mar 22, 2021 at 10:53:46AM +0100, David Hildenbrand wrote:
>>>>> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
>>>>> index daba10f76936..7c72a5e3449f 100644
>>>>> --- a/arch/s390/kvm/gaccess.h
>>>>> +++ b/arch/s390/kvm/gaccess.h
>>>>> @@ -18,17 +18,14 @@
>>>>>      /**
>>>>>       * kvm_s390_real_to_abs - convert guest real address to guest absolute address
>>>>> - * @vcpu - guest virtual cpu
>>>>> + * @prefix - guest prefix
>>>>>       * @gra - guest real address
>>>>>       *
>>>>>       * Returns the guest absolute address that corresponds to the passed guest real
>>>>> - * address @gra of a virtual guest cpu by applying its prefix.
>>>>> + * address @gra of by applying the given prefix.
>>>>>       */
>>>>> -static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
>>>>> -						 unsigned long gra)
>>>>> +static inline unsigned long _kvm_s390_real_to_abs(u32 prefix, unsigned long gra)
>>>>
>>>> <bikeshedding>
>>>> Just a matter of taste, but maybe this could be named differently?
>>>> kvm_s390_real2abs_prefix() ? kvm_s390_prefix_real_to_abs()?
>>>> </bikeshedding>
>>>
>>> +1, I also dislike these "_.*" style functions here.
>>
>> Yes, let's bikeshed then :)
>>
>> Could you then please try to rename page_to* and everything that looks
>> similar to page2* please? I'm wondering what the response will be..
> 
> Oh, we're bikeshedding about anything now? Cool.

(I agree that real2abs is not such a good idea ;) )

-- 
Thanks,

David / dhildenb


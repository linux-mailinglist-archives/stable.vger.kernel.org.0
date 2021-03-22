Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBEB343D49
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 10:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhCVJy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 05:54:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229920AbhCVJx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 05:53:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616406836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FCCQ8UUUQzYPGaH8sFXIOUR2ctThH6mgA4zrevSovz4=;
        b=FGOGYda8FFLEVq7kdO8CcW9+IqkTVIlPWeZEikuTixHB0tgYYTxnFea4qyzDDoKHMvk6qg
        1YYG7YmfX7sXzVWejr3w5rDh8rpZ79UQP7p4/t9GbKgj2j9b8CXLw+bkuaW6zxPLx2d33u
        CXqk4VvFMaa5fQjkKcljkbpxF04vTNg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-lYlkg8qoOSmjh5qn1GBTyA-1; Mon, 22 Mar 2021 05:53:54 -0400
X-MC-Unique: lYlkg8qoOSmjh5qn1GBTyA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 287DE8B5DC2;
        Mon, 22 Mar 2021 09:53:53 +0000 (UTC)
Received: from [10.36.115.54] (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2311060C04;
        Mon, 22 Mar 2021 09:53:48 +0000 (UTC)
Subject: Re: [PATCH v1 1/2] s390/kvm: split kvm_s390_real_to_abs
To:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
References: <20210319193354.399587-1-imbrenda@linux.ibm.com>
 <20210319193354.399587-2-imbrenda@linux.ibm.com>
 <fa583ab0-36ac-47a7-7fa3-4ce88c518488@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <f76f770c-908e-4f4f-f060-15f4d30652d8@redhat.com>
Date:   Mon, 22 Mar 2021 10:53:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <fa583ab0-36ac-47a7-7fa3-4ce88c518488@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20.03.21 05:57, Thomas Huth wrote:
> On 19/03/2021 20.33, Claudio Imbrenda wrote:
>> A new function _kvm_s390_real_to_abs will apply prefixing to a real address
>> with a given prefix value.
>>
>> The old kvm_s390_real_to_abs becomes now a wrapper around the new function.
>>
>> This is needed to avoid code duplication in vSIE.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>    arch/s390/kvm/gaccess.h | 23 +++++++++++++++++------
>>    1 file changed, 17 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
>> index daba10f76936..7c72a5e3449f 100644
>> --- a/arch/s390/kvm/gaccess.h
>> +++ b/arch/s390/kvm/gaccess.h
>> @@ -18,17 +18,14 @@
>>    
>>    /**
>>     * kvm_s390_real_to_abs - convert guest real address to guest absolute address
>> - * @vcpu - guest virtual cpu
>> + * @prefix - guest prefix
>>     * @gra - guest real address
>>     *
>>     * Returns the guest absolute address that corresponds to the passed guest real
>> - * address @gra of a virtual guest cpu by applying its prefix.
>> + * address @gra of by applying the given prefix.
>>     */
>> -static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
>> -						 unsigned long gra)
>> +static inline unsigned long _kvm_s390_real_to_abs(u32 prefix, unsigned long gra)
> 
> <bikeshedding>
> Just a matter of taste, but maybe this could be named differently?
> kvm_s390_real2abs_prefix() ? kvm_s390_prefix_real_to_abs()?
> </bikeshedding>

+1, I also dislike these "_.*" style functions here.

Reviewed-by: David Hildenbrand <david@redhat.com>

> 
> Anyway:
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 


-- 
Thanks,

David / dhildenb


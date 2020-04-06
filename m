Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3153819F6D2
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 15:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgDFNWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 09:22:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54966 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728284AbgDFNWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 09:22:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586179368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=0TkjC5HYtOTtrZU10KhI3fNnM2TQOrHn3T1iEG5p4N0=;
        b=SlGpdErROdNdEQp8nyP3mlpVISAYbv4VfhjMxIoKVNudc0/9kNi4oDBVvdwCQHqFJt7O9y
        phC1RlZrZOP3S79yGau9ba+KmrhaWQphIqVUwsuK4rD2BEvQsQ1XLwFQ4uwsag+cGiV3Yk
        Bv13bfSBUcI14/VVHIHJcyTw39DOcow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-8GbgfZv4OjyHvo_4yLZtZw-1; Mon, 06 Apr 2020 09:22:46 -0400
X-MC-Unique: 8GbgfZv4OjyHvo_4yLZtZw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BC4B1937FC1;
        Mon,  6 Apr 2020 13:22:45 +0000 (UTC)
Received: from [10.36.114.88] (ovpn-114-88.ams2.redhat.com [10.36.114.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 414C6118E29;
        Mon,  6 Apr 2020 13:22:43 +0000 (UTC)
Subject: Re: [PATCH v1 2/5] KVM: s390: vsie: Fix delivery of addressing
 exceptions
To:     Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, stable@vger.kernel.org
References: <20200402184819.34215-1-david@redhat.com>
 <20200402184819.34215-3-david@redhat.com>
 <0cd2822e-8486-d386-6c00-faadaa573e5e@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <527f7bdf-d8f9-59b4-e70a-54e358ee9e26@redhat.com>
Date:   Mon, 6 Apr 2020 15:22:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <0cd2822e-8486-d386-6c00-faadaa573e5e@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06.04.20 15:17, Christian Borntraeger wrote:
> 
> 
> On 02.04.20 20:48, David Hildenbrand wrote:
>> Whenever we get an -EFAULT, we failed to read in guest 2 physical
>> address space. Such addressing exceptions are reported via a program
>> intercept to the nested hypervisor.
>>
>> We faked the intercept, we have to return to guest 2. Instead, right
>> now we would be returning -EFAULT from the intercept handler, eventually
>> crashing the VM.
>>
>> Addressing exceptions can only happen if the g2->g3 page tables
>> reference invalid g2 addresses (say, either a table or the final page is
>> not accessible - so something that basically never happens in sane
>> environments.
>>
>> Identified by manual code inspection.
>>
>> Fixes: a3508fbe9dc6 ("KVM: s390: vsie: initial support for nested virtualization")
>> Cc: <stable@vger.kernel.org> # v4.8+
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>  arch/s390/kvm/vsie.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> index 076090f9e666..4f6c22d72072 100644
>> --- a/arch/s390/kvm/vsie.c
>> +++ b/arch/s390/kvm/vsie.c
>> @@ -1202,6 +1202,7 @@ static int vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>>  		scb_s->iprcc = PGM_ADDRESSING;
>>  		scb_s->pgmilc = 4;
>>  		scb_s->gpsw.addr = __rewind_psw(scb_s->gpsw, 4);
>> +		rc = 1;
> 
> 
> kvm_s390_handle_vsie has 
> 
>  return rc < 0 ? rc : 0;
> 
> 
> so rc = 0 would result in the same behaviour, correct?

yes

> Since we DO handle everything as we should, why rc = 1 ?

rc == 1 is the internal representation of "we have to go back into g2".
rc == 0, in contrast, means "we can go back into g2 (via a NULL
intercept) or continue executing g3". Returning rc == 1 instead of rc ==
0 at this point is just consistency.

-- 
Thanks,

David / dhildenb


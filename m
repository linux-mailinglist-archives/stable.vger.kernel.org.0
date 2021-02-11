Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5EB318BDB
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 14:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhBKNT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 08:19:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28995 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231722AbhBKNR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 08:17:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613049358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p4kjSj6IqX+6LexeNsu4OvUsCWjUNloaXb9pUNsIyFw=;
        b=MJToyGgFG2Vf6AeQUlxzbnC92QCLBfT1TIAyFZnW5aF2DWbzrKujFimXNg0xFSQiyayMJ3
        FFQLJaW/fmI2G5/5ph7WjnRl2pmePxBTDNIq/MsLyqxF0UvsmCjefg8cv2NchMiVkxUDfN
        nNKHVsqSUFApEEd2NZkW2M26v/rC9xM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-BERIYeOFOlOJTvK6dhNGqg-1; Thu, 11 Feb 2021 08:15:52 -0500
X-MC-Unique: BERIYeOFOlOJTvK6dhNGqg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C498C107ACE4;
        Thu, 11 Feb 2021 13:15:50 +0000 (UTC)
Received: from [10.36.114.52] (ovpn-114-52.ams2.redhat.com [10.36.114.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16C492C01B;
        Thu, 11 Feb 2021 13:15:48 +0000 (UTC)
Subject: Re: [PATCH v3 1/2] s390/kvm: extend kvm_s390_shadow_fault to return
 entry pointer
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
References: <20210209154302.1033165-1-imbrenda@linux.ibm.com>
 <20210209154302.1033165-2-imbrenda@linux.ibm.com>
 <2a65f089-1728-7bc7-a2a8-a2c089a01cec@redhat.com>
 <20210211135756.249b535b@ibm-vm>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <1fb901ef-7c42-7753-fe78-0251ca4715d3@redhat.com>
Date:   Thu, 11 Feb 2021 14:15:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210211135756.249b535b@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11.02.21 13:57, Claudio Imbrenda wrote:
> On Thu, 11 Feb 2021 10:18:56 +0100
> David Hildenbrand <david@redhat.com> wrote:
> 
>> On 09.02.21 16:43, Claudio Imbrenda wrote:
>>> Extend kvm_s390_shadow_fault to return the pointer to the valid leaf
>>> DAT table entry, or to the invalid entry.
>>>
>>> Also return some flags in the lower bits of the address:
>>> DAT_PROT: indicates that DAT protection applies because of the
>>>             protection bit in the segment (or, if EDAT, region)
>>> tables NOT_PTE: indicates that the address of the DAT table entry
>>> returned does not refer to a PTE, but to a segment or region table.
>>>    
>>
>> I've been thinking about one possible issue, but I think it's not
>> actually an issue. Just sharing so others can verify:
>>
>> In case our guest uses huge pages / gigantic pages / ASCE R, we
>> create fake page tables (GMAP_SHADOW_FAKE_TABLE).
>>
>> So, it could be that kvm_s390_shadow_fault()->gmap_shadow_pgt_lookup()
>> succeeds, however, we have a fake PTE in our hands. We lost the
>> actual guest STE/RTE address. (I think it could be recovered somehow
>> via page->index, thought)
>>
>> But I guess, if there is a fake PTE, then there is not acutally
>> something that could go wrong in gmap_shadow_page() anymore that could
>> lead us in responding something wrong to the guest. We can only really
>> fail with -EINVAL, -ENOMEM or -EFAULT.
> 
> this was also my reasoning
> 
>> So if the guest changed anything in the meantime (e.g., zap a
>> segment), we would have unshadowed the whole fake page table
>> hierarchy and would simply retry.
>>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> Cc: stable@vger.kernel.org
>>> ---
>>>    arch/s390/kvm/gaccess.c | 30 +++++++++++++++++++++++++-----
>>>    arch/s390/kvm/gaccess.h |  5 ++++-
>>>    arch/s390/kvm/vsie.c    |  8 ++++----
>>>    3 files changed, 33 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
>>> index 6d6b57059493..e0ab83f051d2 100644
>>> --- a/arch/s390/kvm/gaccess.c
>>> +++ b/arch/s390/kvm/gaccess.c
>>> @@ -976,7 +976,9 @@ int kvm_s390_check_low_addr_prot_real(struct
>>> kvm_vcpu *vcpu, unsigned long gra)
>>>     * kvm_s390_shadow_tables - walk the guest page table and create
>>> shadow tables
>>>     * @sg: pointer to the shadow guest address space structure
>>>     * @saddr: faulting address in the shadow gmap
>>> - * @pgt: pointer to the page table address result
>>> + * @pgt: pointer to the beginning of the page table for the given
>>> address if
>>> + *       successful (return value 0), or to the first invalid DAT
>>> entry in
>>> + *       case of exceptions (return value > 0)
>>>     * @fake: pgt references contiguous guest memory block, not a
>>> pgtable */
>>>    static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long
>>> saddr, @@ -1034,6 +1036,7 @@ static int
>>> kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>>> rfte.val = ptr; goto shadow_r2t;
>>>    		}
>>> +		*pgt = ptr + vaddr.rfx * 8;
>>>    		rc = gmap_read_table(parent, ptr + vaddr.rfx * 8,
>>> &rfte.val);
>>
>> Using
>>
>> gmap_read_table(parent, *pgt, &rfte.val);
>>
>> or similar with a local variable might then be even clearer. But no
>> strong opinion.
> 
> that's also something I had thought about, in the end this minimizes
> the number of lines / variables while still being readable
> 
>>>    		if (rc)
>>>    			return rc;
>>> @@ -1060,6 +1063,7 @@ static int kvm_s390_shadow_tables(struct gmap
>>> *sg, unsigned long saddr, rste.val = ptr;
>>>    			goto shadow_r3t;
>>>    		}
>>> +		*pgt = ptr + vaddr.rsx * 8;
>>>    		rc = gmap_read_table(parent, ptr + vaddr.rsx * 8,
>>> &rste.val); if (rc)
>>>    			return rc;
>>> @@ -1087,6 +1091,7 @@ static int kvm_s390_shadow_tables(struct gmap
>>> *sg, unsigned long saddr, rtte.val = ptr;
>>>    			goto shadow_sgt;
>>>    		}
>>> +		*pgt = ptr + vaddr.rtx * 8;
>>>    		rc = gmap_read_table(parent, ptr + vaddr.rtx * 8,
>>> &rtte.val); if (rc)
>>>    			return rc;
>>> @@ -1123,6 +1128,7 @@ static int kvm_s390_shadow_tables(struct gmap
>>> *sg, unsigned long saddr, ste.val = ptr;
>>>    			goto shadow_pgt;
>>>    		}
>>> +		*pgt = ptr + vaddr.sx * 8;
>>>    		rc = gmap_read_table(parent, ptr + vaddr.sx * 8,
>>> &ste.val); if (rc)
>>>    			return rc;
>>> @@ -1157,6 +1163,8 @@ static int kvm_s390_shadow_tables(struct gmap
>>> *sg, unsigned long saddr,
>>>     * @vcpu: virtual cpu
>>>     * @sg: pointer to the shadow guest address space structure
>>>     * @saddr: faulting address in the shadow gmap
>>> + * @datptr: will contain the address of the faulting DAT table
>>> entry, or of
>>> + *          the valid leaf, plus some flags
>>>     *
>>>     * Returns: - 0 if the shadow fault was successfully resolved
>>>     *	    - > 0 (pgm exception code) on exceptions while
>>> faulting @@ -1165,11 +1173,11 @@ static int
>>> kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>>>     *	    - -ENOMEM if out of memory
>>>     */
>>>    int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
>>> -			  unsigned long saddr)
>>> +			  unsigned long saddr, unsigned long
>>> *datptr) {
>>>    	union vaddress vaddr;
>>>    	union page_table_entry pte;
>>> -	unsigned long pgt;
>>> +	unsigned long pgt = 0;
>>>    	int dat_protection, fake;
>>>    	int rc;
>>>    
>>> @@ -1191,8 +1199,20 @@ int kvm_s390_shadow_fault(struct kvm_vcpu
>>> *vcpu, struct gmap *sg, pte.val = pgt + vaddr.px * PAGE_SIZE;
>>>    		goto shadow_page;
>>>    	}
>>> -	if (!rc)
>>> -		rc = gmap_read_table(sg->parent, pgt + vaddr.px *
>>> 8, &pte.val); +
>>> +	switch (rc) {
>>> +	case PGM_SEGMENT_TRANSLATION:
>>> +	case PGM_REGION_THIRD_TRANS:
>>> +	case PGM_REGION_SECOND_TRANS:
>>> +	case PGM_REGION_FIRST_TRANS:
>>> +		pgt |= NOT_PTE;
>>> +		break;
>>> +	case 0:
>>> +		pgt += vaddr.px * 8;
>>> +		rc = gmap_read_table(sg->parent, pgt, &pte.val);
>>> +	}
>>> +	if (*datptr)
>>> +		*datptr = pgt | dat_protection * DAT_PROT;
>>>    	if (!rc && pte.i)
>>>    		rc = PGM_PAGE_TRANSLATION;
>>>    	if (!rc && pte.z)
>>> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
>>> index f4c51756c462..fec26bbb17ba 100644
>>> --- a/arch/s390/kvm/gaccess.h
>>> +++ b/arch/s390/kvm/gaccess.h
>>> @@ -359,7 +359,10 @@ void ipte_unlock(struct kvm_vcpu *vcpu);
>>>    int ipte_lock_held(struct kvm_vcpu *vcpu);
>>>    int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu,
>>> unsigned long gra);
>>> +#define DAT_PROT 2
>>> +#define NOT_PTE 4
>>
>> What if our guest is using ASCE.R ?
> 
> then we don't care.
> 
> if the guest is using ASCE.R, then shadowing will always succeed, and
> the VSIE MVPG handler will retry right away.
> 
> if you are worried about the the lowest order bit, it can only be set
> if a specific feature is enabled in the host, and KVM doesn't use /
> support it, so the guest can't use it for its guest.

Got it, thanks! :)

Reviewed-by: David Hildenbrand <david@redhat.com>


-- 
Thanks,

David / dhildenb


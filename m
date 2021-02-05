Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEF031160F
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhBEWuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:50:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23242 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232402AbhBEM5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 07:57:47 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 115ChbGs184882;
        Fri, 5 Feb 2021 07:56:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GuKnSk6zgz6x3RRwM1PuFt1p4xUh+BgE7xXxBuGDMwo=;
 b=a64uTI5+QrU6b3uY/JRa5eO8Im6Ol/27palTJjlZD5Xpyh0bz7JZZxCps0eG/TgKlomu
 i0v4ktKiMw5hXdjAIwHGQsWWIS/xWKXMFlalMZ6KIyXF+LCvIYXXjehWibsj6YmbLlSb
 Kujo0A1utvK8QjsNgzuk+yDcrjq8Vo/I8Z6dBfADOxA4QiAFS4iURm0f/jaItxgx8SWW
 X1GJcZ0s+G0axMeNFn24lPTdIj8TO5+ciIevyMGM+WcZfLf8AeTYw2Nnjdp6vaXyvaQf
 azxGi9Bl9GQ2TylV4vOnY6EdmwKffH6sHxWTSHM1IT1f2vDJrgl4AmtKTruoeDhCRkUA 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36h6998b1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 07:56:59 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 115ChtEa186171;
        Fri, 5 Feb 2021 07:56:58 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36h6998b14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 07:56:58 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 115CWqU6019693;
        Fri, 5 Feb 2021 12:56:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 36cy38nx2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 12:56:56 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 115Cusos41026016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Feb 2021 12:56:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDBA1AE053;
        Fri,  5 Feb 2021 12:56:53 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BD83AE051;
        Fri,  5 Feb 2021 12:56:53 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.52.212])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Feb 2021 12:56:53 +0000 (GMT)
Subject: Re: [PATCH v2 1/2] s390/kvm: extend kvm_s390_shadow_fault to return
 entry pointer
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        david@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
References: <20210202180028.876888-1-imbrenda@linux.ibm.com>
 <20210202180028.876888-2-imbrenda@linux.ibm.com>
 <16522b25-a590-fbc4-0eb6-3537d8032577@linux.ibm.com>
 <20210205131555.0b4f32d1@ibm-vm>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <9eb63005-a11f-a56a-d7e1-c65dd9e8d9a2@linux.ibm.com>
Date:   Fri, 5 Feb 2021 13:56:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210205131555.0b4f32d1@ibm-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-05_07:2021-02-05,2021-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102050083
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/5/21 1:15 PM, Claudio Imbrenda wrote:
> On Thu, 4 Feb 2021 17:34:00 +0100
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 2/2/21 7:00 PM, Claudio Imbrenda wrote:
>>> Extend kvm_s390_shadow_fault to return the pointer to the valid leaf
>>> DAT table entry, or to the invalid entry.
>>>
>>> Also return some flags in the lower bits of the address:
>>> DAT_PROT: indicates that DAT protection applies because of the
>>>           protection bit in the segment (or, if EDAT, region) tables
>>> NOT_PTE: indicates that the address of the DAT table entry returned
>>>          does not refer to a PTE, but to a segment or region table.
>>>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> Cc: stable@vger.kernel.org
>>> ---
>>>  arch/s390/kvm/gaccess.c | 26 ++++++++++++++++++++++----
>>>  arch/s390/kvm/gaccess.h |  5 ++++-
>>>  arch/s390/kvm/vsie.c    |  8 ++++----
>>>  3 files changed, 30 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
>>> index 6d6b57059493..2d7bcbfb185e 100644
>>> --- a/arch/s390/kvm/gaccess.c
>>> +++ b/arch/s390/kvm/gaccess.c
>>> @@ -1034,6 +1034,7 @@ static int kvm_s390_shadow_tables(struct gmap
>>> *sg, unsigned long saddr, rfte.val = ptr;
>>>  			goto shadow_r2t;
>>>  		}
>>> +		*pgt = ptr + vaddr.rfx * 8;  
>>
>> So pgt either is a table entry if rc > 0 or a pointer to the first pte
>> on rc == 0 after this change?
> 
> yes
> 
>> Hrm, if it is really based on RCs than I might be able to come to
>> terms with having two things in a ptr with the name pgt. But it needs
>> a comment change.
> 
> will do.
> 
>>>  		rc = gmap_read_table(parent, ptr + vaddr.rfx * 8,
>>> &rfte.val); if (rc)
>>>  			return rc;
>>> @@ -1060,6 +1061,7 @@ static int kvm_s390_shadow_tables(struct gmap
>>> *sg, unsigned long saddr, rste.val = ptr;
>>>  			goto shadow_r3t;
>>>  		}
>>> +		*pgt = ptr + vaddr.rsx * 8;
>>>  		rc = gmap_read_table(parent, ptr + vaddr.rsx * 8,
>>> &rste.val); if (rc)
>>>  			return rc;
>>> @@ -1087,6 +1089,7 @@ static int kvm_s390_shadow_tables(struct gmap
>>> *sg, unsigned long saddr, rtte.val = ptr;
>>>  			goto shadow_sgt;
>>>  		}
>>> +		*pgt = ptr + vaddr.rtx * 8;
>>>  		rc = gmap_read_table(parent, ptr + vaddr.rtx * 8,
>>> &rtte.val); if (rc)
>>>  			return rc;
>>> @@ -1123,6 +1126,7 @@ static int kvm_s390_shadow_tables(struct gmap
>>> *sg, unsigned long saddr, ste.val = ptr;
>>>  			goto shadow_pgt;
>>>  		}
>>> +		*pgt = ptr + vaddr.sx * 8;
>>>  		rc = gmap_read_table(parent, ptr + vaddr.sx * 8,
>>> &ste.val); if (rc)
>>>  			return rc;
>>> @@ -1157,6 +1161,8 @@ static int kvm_s390_shadow_tables(struct gmap
>>> *sg, unsigned long saddr,
>>>   * @vcpu: virtual cpu
>>>   * @sg: pointer to the shadow guest address space structure
>>>   * @saddr: faulting address in the shadow gmap
>>> + * @pteptr: will contain the address of the faulting DAT table
>>> entry, or of
>>> + *          the valid leaf, plus some flags  
>>
>> pteptr is not the right name if it can be two things
> 
> it cannot be two things there, kvm_s390_shadow_fault always returns a
> DAT _entry_ (pte, segment, region).

And that's exactly what I meant, it's not a pteptr i.e. not a (pte_t *)
as the name would suggest.


> 
>>>   *
>>>   * Returns: - 0 if the shadow fault was successfully resolved
>>>   *	    - > 0 (pgm exception code) on exceptions while
>>> faulting @@ -1165,11 +1171,11 @@ static int
>>> kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>>>   *	    - -ENOMEM if out of memory
>>>   */
>>>  int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
>>> -			  unsigned long saddr)
>>> +			  unsigned long saddr, unsigned long
>>> *pteptr) {
>>>  	union vaddress vaddr;
>>>  	union page_table_entry pte;
>>> -	unsigned long pgt;
>>> +	unsigned long pgt = 0;
>>>  	int dat_protection, fake;
>>>  	int rc;
>>>  
>>> @@ -1191,8 +1197,20 @@ int kvm_s390_shadow_fault(struct kvm_vcpu
>>> *vcpu, struct gmap *sg, pte.val = pgt + vaddr.px * PAGE_SIZE;
>>>  		goto shadow_page;
>>>  	}
>>> -	if (!rc)
>>> -		rc = gmap_read_table(sg->parent, pgt + vaddr.px *
>>> 8, &pte.val); +
>>> +	switch (rc) {
>>> +	case PGM_SEGMENT_TRANSLATION:
>>> +	case PGM_REGION_THIRD_TRANS:
>>> +	case PGM_REGION_SECOND_TRANS:
>>> +	case PGM_REGION_FIRST_TRANS:
>>> +		pgt |= NOT_PTE;  
>>
>> GACC_TRANSL_ENTRY_INV ?
> 
> no, this is only for non-pte entries
> 
>>> +		break;
>>> +	case 0:
>>> +		pgt += vaddr.px * 8;
>>> +		rc = gmap_read_table(sg->parent, pgt, &pte.val);
>>> +	}
>>> +	if (*pteptr)
>>> +		*pteptr = pgt | dat_protection * DAT_PROT;
>>>  	if (!rc && pte.i)
>>>  		rc = PGM_PAGE_TRANSLATION;
>>>  	if (!rc && pte.z)
>>> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
>>> index f4c51756c462..66a6e2cec97a 100644
>>> --- a/arch/s390/kvm/gaccess.h
>>> +++ b/arch/s390/kvm/gaccess.h
>>> @@ -359,7 +359,10 @@ void ipte_unlock(struct kvm_vcpu *vcpu);
>>>  int ipte_lock_held(struct kvm_vcpu *vcpu);
>>>  int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu,
>>> unsigned long gra); 
>>> +#define DAT_PROT 2  
>>
>> GACC_TRANSL_ENTRY_PROT
> 
> this is also only for non-pte entries
> 
>>> +#define NOT_PTE 4
>>> +
>>>  int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap
>>> *shadow,
>>> -			  unsigned long saddr);
>>> +			  unsigned long saddr, unsigned long
>>> *pteptr); 
>>>  #endif /* __KVM_S390_GACCESS_H */
>>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>>> index c5d0a58b2c29..7db022141db3 100644
>>> --- a/arch/s390/kvm/vsie.c
>>> +++ b/arch/s390/kvm/vsie.c
>>> @@ -619,10 +619,10 @@ static int map_prefix(struct kvm_vcpu *vcpu,
>>> struct vsie_page *vsie_page) /* with mso/msl, the prefix lies at
>>> offset *mso* */ prefix += scb_s->mso;
>>>  
>>> -	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, prefix);
>>> +	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, prefix,
>>> NULL); if (!rc && (scb_s->ecb & ECB_TE))
>>>  		rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
>>> -					   prefix + PAGE_SIZE);
>>> +					   prefix + PAGE_SIZE,
>>> NULL); /*
>>>  	 * We don't have to mprotect, we will be called for all
>>> unshadows.
>>>  	 * SIE will detect if protection applies and trigger a
>>> validity. @@ -913,7 +913,7 @@ static int handle_fault(struct
>>> kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>>> current->thread.gmap_addr, 1); 
>>>  	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
>>> -				   current->thread.gmap_addr);
>>> +				   current->thread.gmap_addr,
>>> NULL); if (rc > 0) {
>>>  		rc = inject_fault(vcpu, rc,
>>>  				  current->thread.gmap_addr,
>>> @@ -935,7 +935,7 @@ static void handle_last_fault(struct kvm_vcpu
>>> *vcpu, {
>>>  	if (vsie_page->fault_addr)
>>>  		kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
>>> -				      vsie_page->fault_addr);
>>> +				      vsie_page->fault_addr,
>>> NULL);  
>>
>> Ok
>>
>>>  	vsie_page->fault_addr = 0;
>>>  }
>>>  
>>>   
>>
> 


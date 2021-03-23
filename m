Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455783462FE
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 16:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhCWPfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 11:35:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29292 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232877AbhCWPfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 11:35:00 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12NFWo8H031208;
        Tue, 23 Mar 2021 11:35:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KjLkT4N18SFcZanss0DEyng5L7usWGXP/LckbmHjCv0=;
 b=qmhjhTO4eSjSe3ku7rtwbFdP8+jJn1y7vJAHzs5Thw1PVj/qjlJPJc8PYdZt19/uGOCK
 2doYKLfcqCqpB/RlpCJcHbHp9ydt0goYrQqzSA6VMtrDZUE3Gz18CypdK+Hxp7QkR6Eb
 vkh+xb1+KKEUrpC2YZ2+VplE7AGkYyFTNHbfy52TKFsr3xc1OnRU5y0Y90xKL3e/71Zz
 JjJMBcAv9rW5TdQFIS1JedN87r9uuhPSRM/5bV21k9zxBieb82dH0WikdWbpQzNGtMZ1
 CYS7M6Z/gjlS/KMsEBJgwQvr63t2Y3m5Rihs4DbXSUbaibootCJ8OTjhQssIs3SbU+al RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37dx4b644a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 11:35:00 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12NFX5Ll035845;
        Tue, 23 Mar 2021 11:35:00 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37dx4b6418-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 11:34:59 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12NFLbbt016915;
        Tue, 23 Mar 2021 15:34:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 37df68b379-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 15:34:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12NFYrDi40370450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 15:34:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94637A4066;
        Tue, 23 Mar 2021 15:34:53 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B5F0A4054;
        Tue, 23 Mar 2021 15:34:53 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.5.141])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Mar 2021 15:34:52 +0000 (GMT)
Subject: Re: [PATCH v2 2/2] s390/kvm: VSIE: fix MVPG handling for prefixing
 and MSO
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
References: <20210322140559.500716-1-imbrenda@linux.ibm.com>
 <20210322140559.500716-3-imbrenda@linux.ibm.com>
 <433933f5-1b6e-ea58-618d-3c844edc73a6@de.ibm.com>
 <830ca8c6-4d21-b1ed-ccaf-e0c12237849e@redhat.com>
 <9293b208-0f1d-fb58-290c-66a8ae30d60c@de.ibm.com>
 <20210323162152.3356dc19@ibm-vm>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <9e0e7fc1-e6c4-0329-aa42-f8ffc30f2c71@de.ibm.com>
Date:   Tue, 23 Mar 2021 16:34:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210323162152.3356dc19@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_06:2021-03-22,2021-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230114
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 23.03.21 16:21, Claudio Imbrenda wrote:
> On Tue, 23 Mar 2021 16:16:18 +0100
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> On 23.03.21 16:11, David Hildenbrand wrote:
>>> On 23.03.21 16:07, Christian Borntraeger wrote:
>>>>
>>>>
>>>> On 22.03.21 15:05, Claudio Imbrenda wrote:
>>>>> Prefixing needs to be applied to the guest real address to
>>>>> translate it into a guest absolute address.
>>>>>
>>>>> The value of MSO needs to be added to a guest-absolute address in
>>>>> order to obtain the host-virtual.
>>>>>
>>>>> Fixes: 223ea46de9e79 ("s390/kvm: VSIE: correctly handle MVPG when
>>>>> in VSIE") Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>>> Reported-by: Janosch Frank <frankja@linux.ibm.com>
>>>>> ---
>>>>>     arch/s390/kvm/vsie.c | 6 +++++-
>>>>>     1 file changed, 5 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>>>>> index 48aab6290a77..ac86f11e46dc 100644
>>>>> --- a/arch/s390/kvm/vsie.c
>>>>> +++ b/arch/s390/kvm/vsie.c
>>>>> @@ -1002,7 +1002,7 @@ static u64 vsie_get_register(struct
>>>>> kvm_vcpu *vcpu, struct vsie_page *vsie_page, static int
>>>>> vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page
>>>>> *vsie_page) { struct kvm_s390_sie_block *scb_s =
>>>>> &vsie_page->scb_s;
>>>>> -    unsigned long pei_dest, pei_src, src, dest, mask;
>>>>> +    unsigned long pei_dest, pei_src, dest, src, mask, mso,
>>>>> prefix; u64 *pei_block = &vsie_page->scb_o->mcic;
>>>>>         int edat, rc_dest, rc_src;
>>>>>         union ctlreg0 cr0;
>>>>> @@ -1010,9 +1010,13 @@ static int vsie_handle_mvpg(struct
>>>>> kvm_vcpu *vcpu, struct vsie_page *vsie_page) cr0.val =
>>>>> vcpu->arch.sie_block->gcr[0]; edat = cr0.edat &&
>>>>> test_kvm_facility(vcpu->kvm, 8); mask =
>>>>> _kvm_s390_logical_to_effective(&scb_s->gpsw, PAGE_MASK);
>>>>> +    mso = scb_s->mso & ~(1UL << 20);
>>>>              shouldnt that be ~((1UL << 20 ) -1)
> 
> oops
> 
>>>
>>> Looking at shadow_scb(), we can simply take scb_s->mso unmodified.
>>
>> Right, I think I can fix this up (and get rid of the local mso
> 
> I think that's easier/simpler
> 
>> variable) when queueing. Or shall Claudio send a new version of the
>> patch?
> 

queued (with fixup). Please note: can you use "KVM: s390:" instead of "s390/kvm" for the future patches.

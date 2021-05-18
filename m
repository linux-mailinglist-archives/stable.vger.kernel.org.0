Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93A3387FC3
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 20:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351612AbhERSmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 14:42:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5846 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1343747AbhERSmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 14:42:13 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IIX1oq108596;
        Tue, 18 May 2021 14:40:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mpWbosnb8VVA/+zebGzaWvCztpF3Pmo6b6Ffz3h8D6M=;
 b=GF1/CQ0tO7HVUVmSFIWDhZWNZWdEV0xZ4a8E7W7KXNCMZ5YLE0BE6OGhsSSiw20gHdfH
 PI5uZ7r4deC86VMPHTe5cIN4iyVMuRvajJtFwo3jFYBBdxOCfo9/zOaz/dUrF8w+H2Eq
 HIJNbDDkIqCCxSnyzsyiQTUFlgPjt23KQW0hyobg7/ZE/XXjzEmYaILXHCQ5FxceVtJk
 d8Wt3msGRApKaPmKBJp/Nk1KkvOHnTbh+fxRYU9xmvSmCbS1TSd0jz2HErDNpTEnr7LD
 xc1Bivj/843L+OBwmhh3IwZzhKkJwVH6N3DoSfTN2PQQXqgaVEvrXZhC0wtp8WF/zGKK aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38mjp0gnht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 14:40:53 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IIWx49108491;
        Tue, 18 May 2021 14:40:52 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38mjp0gnhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 14:40:52 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IIR09h009449;
        Tue, 18 May 2021 18:40:52 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02wdc.us.ibm.com with ESMTP id 38jyu21u94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 18:40:52 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IIepXV16908594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 18:40:51 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9A0BAC067;
        Tue, 18 May 2021 18:40:51 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E057AC064;
        Tue, 18 May 2021 18:40:51 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.177.219])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 18 May 2021 18:40:51 +0000 (GMT)
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        jgg@nvidia.com, alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
 <20210512203536.4209c29c.pasic@linux.ibm.com>
 <4c156ab8-da49-4867-f29c-9712c2628d44@linux.ibm.com>
 <20210513194541.58d1628a.pasic@linux.ibm.com>
 <243086e2-08a0-71ed-eb7e-618a62b007e4@linux.ibm.com>
 <20210514021500.60ad2a22.pasic@linux.ibm.com>
 <594374f6-8cf6-4c22-0bac-3b224c55bbb6@linux.ibm.com>
 <20210517211030.368ca64b.pasic@linux.ibm.com>
 <966a60ad-bdde-68d0-ae2f-06121c6ad970@de.ibm.com>
 <9ebd5fd8-b093-e5bc-e680-88fa7a9b085c@linux.ibm.com>
 <494af62b-dc9a-ef2c-1869-d8f5ed239504@de.ibm.com>
 <00c86767-ce8b-7050-f665-75f33fabe118@linux.ibm.com>
 <d426bb7e-39d8-6eaf-047e-05eb70cdaeb7@de.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <d413938b-3fcf-836d-adab-92340ff63eff@linux.ibm.com>
Date:   Tue, 18 May 2021 14:40:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <d426bb7e-39d8-6eaf-047e-05eb70cdaeb7@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZfqPp2KACaBZ4PrxRs_5pB4luxdWLoU9
X-Proofpoint-ORIG-GUID: EOeZv6PZOHf2JNy4zPOU4sbQIDdZkMty
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_09:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105180128
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/18/21 2:22 PM, Christian Borntraeger wrote:
>
>
> On 18.05.21 20:14, Tony Krowiak wrote:
>>
>>
>> On 5/18/21 9:59 AM, Christian Borntraeger wrote:
>>>
>>>
>>> On 18.05.21 15:42, Tony Krowiak wrote:
>>>>
>>>>
>>>> On 5/18/21 5:30 AM, Christian Borntraeger wrote:
>>>>>
>>>>>
>>>>> On 17.05.21 21:10, Halil Pasic wrote:
>>>>>> On Mon, 17 May 2021 09:37:42 -0400
>>>>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>>>>
>>>>>>>>
>>>>>>>> Because of this, I don't think the rest of your argument is valid.
>>>>>>>
>>>>>>> Okay, so your concern is that between the point in time the
>>>>>>> vcpu->kvm->arch.crypto.pqap_hook pointer is checked in
>>>>>>> priv.c and the point in time the handle_pqap() function
>>>>>>> in vfio_ap_ops.c is called, the memory allocated for the
>>>>>>> matrix_mdev containing the struct kvm_s390_module_hook
>>>>>>> may get freed, thus rendering the function pointer invalid.
>>>>>>> While not impossible, that seems extremely unlikely to
>>>>>>> happen. Can you articulate a scenario where that could
>>>>>>> even occur?
>>>>>>
>>>>>> Malicious userspace. We tend to do the pqap aqic just once
>>>>>> in the guest right after the queue is detected. I do agree
>>>>>> it ain't very likely to happen during normal operation. But why are
>>>>>> you asking?
>>>>>
>>>>> Would it help, if the code in priv.c would read the hook once
>>>>> and then only work on the copy? We could protect that with rcu
>>>>> and do a synchronize rcu in vfio_ap_mdev_unset_kvm after
>>>>> unsetting the pointer?
>>>>
>>>> I'll look into this.
>>>
>>> I think it could work. in priv.c use rcu_readlock, save the
>>> pointer, do the check and call, call rcu_read_unlock.
>>> In vfio_ap use rcu_assign_pointer to set the pointer and
>>> after setting it to zero call sychronize_rcu.
>>>
>>> Halil, I think we can do this as an addon patch as it makes
>>> sense to have this callback pointer protected independent of
>>> this patch. Agree?
>>
>> I agree that this is a viable option; however, this does not
>> guarantee that the matrix_mdev is not freed thus rendering
>> the function pointer to the interception handler invalid unless
>> that is also included within the rcu_readlock/rcu_read_unlock.
>
> The trick should be the sychronize_rcu. This will put the deleting
> code (vfio_ap_mdev_unset_kvm) to sleep until the rcu read section
> has finished. So if you first set the pointer to zero, then call
> synchronize_rcu the code will only progress until all users of
> the old poiner have finished.

Yes, that is my understanding too.

>
>> That is not possible given the matrix_mdev is freed within
>> the remove callback and the pointer to the structure that
>> contains the interception handler function pointer is cleared
>> in the vfio_ap_mdev_unset_kvm() function. I am working on
>> a patch and should be able to post it before EOD or first thing
>> tomorrow.
>>


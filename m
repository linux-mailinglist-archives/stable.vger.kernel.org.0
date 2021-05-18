Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D19387F59
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 20:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhERSP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 14:15:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229652AbhERSP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 14:15:26 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14II4IfL119167;
        Tue, 18 May 2021 14:14:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Hb1S33DB4cwbzzdrXp1MdMWeQN6Uj465PyTHwToqkAM=;
 b=keLbMtE4ph8SU/x9Q6DPWtfunqRS03zOd9isfVibTDqij8e09uvBqfL4vv+7vToEBASt
 aNrfDt7jDvUurhOAUvkB0rKDu6O2r1+3HXPlGUFN2NRh3F4cHXR+/YBWbuwPwSbJ2rWQ
 ITgt/7Sd0DqWkQ7NK2L/1UfLJGZS9pA3RfvBSxikv+R2bZCGHdpwQvsXIBriKE4dM/ci
 wdF3mu0JS1j7jz/myWCBdkU0SWloqiIuTVTDYHxHZDLxRYw33lopKZgBtQmwgc/e6X+d
 yDFD94PzGj2MSryOfjPVsD7vdmiQ5Hcm5g1tEk2x57DfdJwX5Bsy897m2a1kUEn+K55P DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mjfg0bwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 14:14:07 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14II4PX5119805;
        Tue, 18 May 2021 14:14:06 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mjfg0bw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 14:14:06 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IIBV75021734;
        Tue, 18 May 2021 18:14:05 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 38j5x9fbvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 18:14:05 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IIE4E517367318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 18:14:04 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65E8AAC073;
        Tue, 18 May 2021 18:14:04 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E363FAC06C;
        Tue, 18 May 2021 18:14:03 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.177.219])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 18 May 2021 18:14:03 +0000 (GMT)
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
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <00c86767-ce8b-7050-f665-75f33fabe118@linux.ibm.com>
Date:   Tue, 18 May 2021 14:14:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <494af62b-dc9a-ef2c-1869-d8f5ed239504@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: w89M7WGTal8YvIqrvKylruOjxFeDkIpH
X-Proofpoint-ORIG-GUID: -WN6utSFq3HBY8dU3IVSml2EZwoBiaFz
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_09:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105180126
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/18/21 9:59 AM, Christian Borntraeger wrote:
>
>
> On 18.05.21 15:42, Tony Krowiak wrote:
>>
>>
>> On 5/18/21 5:30 AM, Christian Borntraeger wrote:
>>>
>>>
>>> On 17.05.21 21:10, Halil Pasic wrote:
>>>> On Mon, 17 May 2021 09:37:42 -0400
>>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>>
>>>>>>
>>>>>> Because of this, I don't think the rest of your argument is valid.
>>>>>
>>>>> Okay, so your concern is that between the point in time the
>>>>> vcpu->kvm->arch.crypto.pqap_hook pointer is checked in
>>>>> priv.c and the point in time the handle_pqap() function
>>>>> in vfio_ap_ops.c is called, the memory allocated for the
>>>>> matrix_mdev containing the struct kvm_s390_module_hook
>>>>> may get freed, thus rendering the function pointer invalid.
>>>>> While not impossible, that seems extremely unlikely to
>>>>> happen. Can you articulate a scenario where that could
>>>>> even occur?
>>>>
>>>> Malicious userspace. We tend to do the pqap aqic just once
>>>> in the guest right after the queue is detected. I do agree
>>>> it ain't very likely to happen during normal operation. But why are
>>>> you asking?
>>>
>>> Would it help, if the code in priv.c would read the hook once
>>> and then only work on the copy? We could protect that with rcu
>>> and do a synchronize rcu in vfio_ap_mdev_unset_kvm after
>>> unsetting the pointer?
>>
>> I'll look into this.
>
> I think it could work. in priv.c use rcu_readlock, save the
> pointer, do the check and call, call rcu_read_unlock.
> In vfio_ap use rcu_assign_pointer to set the pointer and
> after setting it to zero call sychronize_rcu.
>
> Halil, I think we can do this as an addon patch as it makes
> sense to have this callback pointer protected independent of
> this patch. Agree?

I agree that this is a viable option; however, this does not
guarantee that the matrix_mdev is not freed thus rendering
the function pointer to the interception handler invalid unless
that is also included within the rcu_readlock/rcu_read_unlock.
That is not possible given the matrix_mdev is freed within
the remove callback and the pointer to the structure that
contains the interception handler function pointer is cleared
in the vfio_ap_mdev_unset_kvm() function. I am working on
a patch and should be able to post it before EOD or first thing
tomorrow.


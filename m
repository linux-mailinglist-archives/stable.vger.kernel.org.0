Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CB8382D94
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 15:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237412AbhEQNjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 09:39:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23590 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234748AbhEQNjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 09:39:04 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14HDXSVL120091;
        Mon, 17 May 2021 09:37:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3iiwJu4opP4d4Yr3oPeI7Ztn+ZQ3lTqbeTmXb5u7e5w=;
 b=ayKja8cjOSNm66z8zg5v2dU4AJwcbjOgTgGhrtDHdCml1vcnrYPlHgUSrlovm0qwmFxI
 iNn9n7Z1JWOO9wdFaA7TzO+R8e6RrHSKKVbOyjmQN/iLqh0Ky7qW0SxP439Sv2Cmp8yQ
 nSvzcNuqgpBTcpIhv6/PX+TJs7kZ4azHFy2KIe3B04IVWQJlWGNvFSXnhGHcEMBWXJY6
 +0gaQiQV0+RdosLmpTXJOMA3idM30TDZhv0dDuc82Fu1XmocG8tcruZa+BYuzZzpqiT1
 a6taIzqZ2CpiquUv7Xh3So4F3IyYkt4ItLlGPgkoyMmZ3va+LIpbvcUTtylPQC0JrZjB 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38krv11ejx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 09:37:46 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14HDY3LF124797;
        Mon, 17 May 2021 09:37:45 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38krv11eje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 09:37:45 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14HDbHia025955;
        Mon, 17 May 2021 13:37:44 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 38j5x93ad6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 13:37:44 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14HDbhsK17236308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 13:37:43 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81EACAC06F;
        Mon, 17 May 2021 13:37:43 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF0ABAC067;
        Mon, 17 May 2021 13:37:42 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.177.219])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 17 May 2021 13:37:42 +0000 (GMT)
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com, jgg@nvidia.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
 <20210512203536.4209c29c.pasic@linux.ibm.com>
 <4c156ab8-da49-4867-f29c-9712c2628d44@linux.ibm.com>
 <20210513194541.58d1628a.pasic@linux.ibm.com>
 <243086e2-08a0-71ed-eb7e-618a62b007e4@linux.ibm.com>
 <20210514021500.60ad2a22.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <594374f6-8cf6-4c22-0bac-3b224c55bbb6@linux.ibm.com>
Date:   Mon, 17 May 2021 09:37:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210514021500.60ad2a22.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: x7D6xdCihIdvQFZr42GERFoG_wjuvG-2
X-Proofpoint-ORIG-GUID: gIYjGkYD2MmkJ6lWTGr01i6xTCTwZol0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_05:2021-05-17,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=0 mlxscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105170096
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/13/21 8:15 PM, Halil Pasic wrote:
> On Thu, 13 May 2021 15:23:27 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 5/13/21 1:45 PM, Halil Pasic wrote:
>>> On Thu, 13 May 2021 10:35:05 -0400
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>   
>>>> On 5/12/21 2:35 PM, Halil Pasic wrote:
>>>>> On Mon, 10 May 2021 17:48:37 -0400
>>>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>>>      
>>>>>> The mdev remove callback for the vfio_ap device driver bails out with
>>>>>> -EBUSY if the mdev is in use by a KVM guest. The intended purpose was
>>>>>> to prevent the mdev from being removed while in use; however, returning a
>>>>>> non-zero rc does not prevent removal. This could result in a memory leak
>>>>>> of the resources allocated when the mdev was created. In addition, the
>>>>>> KVM guest will still have access to the AP devices assigned to the mdev
>>>>>> even though the mdev no longer exists.
>>>>>>
>>>>>> To prevent this scenario, cleanup will be done - including unplugging the
>>>>>> AP adapters, domains and control domains - regardless of whether the mdev
>>>>>> is in use by a KVM guest or not.
>>>>>>
>>>>>> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>
>>>>>> ---
>>>>>>     drivers/s390/crypto/vfio_ap_ops.c | 13 ++-----------
>>>>>>     1 file changed, 2 insertions(+), 11 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>>>>>> index b2c7e10dfdcd..f90c9103dac2 100644
>>>>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>>>>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>>>>>> @@ -26,6 +26,7 @@
>>>>>>
>>>>>>     static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>>>>>>     static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>>>>>> +static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev);
>>>>>>
>>>>>>     static int match_apqn(struct device *dev, const void *data)
>>>>>>     {
>>>>>> @@ -366,17 +367,7 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
>>>>>>     	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>>>>>
>>>>>>     	mutex_lock(&matrix_dev->lock);
>>>>>> -
>>>>>> -	/*
>>>>>> -	 * If the KVM pointer is in flux or the guest is running, disallow
>>>>>> -	 * un-assignment of control domain.
>>>>>> -	 */
>>>>>> -	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
>>>>>> -		mutex_unlock(&matrix_dev->lock);
>>>>>> -		return -EBUSY;
>>>>>> -	}
>>>>>> -
>>>>>> -	vfio_ap_mdev_reset_queues(mdev);
>>>>>> +	vfio_ap_mdev_unset_kvm(matrix_mdev);
>>>>>>     	list_del(&matrix_mdev->node);
>>>>>>     	kfree(matrix_mdev);
>>>>> Are we at risk of handle_pqap() in arch/s390/kvm/priv.c using an
>>>>> already freed pqap_hook (which is a member of the matrix_mdev pointee
>>>>> that is freed just above my comment).
>>>>>
>>>>> I'm aware of the fact that vfio_ap_mdev_unset_kvm() does a
>>>>> matrix_mdev->kvm->arch.crypto.pqap_hook = NULL but that is
>>>>> AFRICT not done under any lock relevant for handle_pqap(). I guess
>>>>> the idea is, I guess, the check cited below
>>>>>
>>>>> static int handle_pqap(struct kvm_vcpu *vcpu)
>>>>> [..]
>>>>>            /*
>>>>>             * Verify that the hook callback is registered, lock the owner
>>>>>             * and call the hook.
>>>>>             */
>>>>>            if (vcpu->kvm->arch.crypto.pqap_hook) {
>>>>>                    if (!try_module_get(vcpu->kvm->arch.crypto.pqap_hook->owner))
>>>>>                            return -EOPNOTSUPP;
>>>>>                    ret = vcpu->kvm->arch.crypto.pqap_hook->hook(vcpu);
>>>>>                    module_put(vcpu->kvm->arch.crypto.pqap_hook->owner);
>>>>>                    if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)
>>>>>                            kvm_s390_set_psw_cc(vcpu, 3);
>>>>>                    return ret;
>>>>>            }
>>>>>
>>>>> is going to catch it, but I'm not sure it is guaranteed to catch it.
>>>>> Opinions?
>>>> The hook itself - handle_pqap() function in vfio_ap_ops.c - also checks
>>>> to see if the reference to the hook is set and terminates with an error
>>>> if it
>>>> is not. If the hook is invoked subsequent to the remove callback above,
>>>> all should be fine since the check is also done under the matrix_dev->lock.
>>>>   
>>> I don't quite understand your logic. Let us assume matrix_mdev was freed,
>>> but vcpu->kvm->arch.crypto.pqap_hook still points to what used to be
>>> (*matrix_mdev).pqap_hook. In that case the function pointer
>>> vcpu->kvm->arch.crypto.pqap_hook->hook is used after it was freed, and
>>> may not point to the handle_pqap() function in vfio_ap_ops.c, thus the
>>> check you are referring to ain't necessarily relevant. Than is
>>> if you mean the check in the  handle_pqap() function in vfio_ap_ops.c; if
>>> you mean the check in handle_pqap() in arch/s390/kvm/priv.c, that one is
>>> not done under the matrix_dev->lock. Or do I have a hole somewhere in my
>>> reasoning?
>> What I am saying is the vcpu->kvm->arch.crypto.pqap_hook
>> will either be NULL or point to the handle_pqap() function in the
>> vfio_ap driver.
> Please read the code again. In my reading of the code
> vcpu->kvm->arch.crypto.pqap_hook is never supposed to point to >(or does
> point to) the handle_pqap() function defined in vfio_ap_ops.c. It points
> to the pqap_hook member of struct ap_matrix_mdev (the type of the member
> is struct kvm_s390_module_hook, which in turn has a function pointer
> member called hook, which is supposed to hold the address of
> handle_pqap() function defined in vfio_ap_ops.c, and thus point to
> it).

You are correct, we are looking at the same code.

>
> Because of this, I don't think the rest of your argument is valid.

Okay, so your concern is that between the point in time the
vcpu->kvm->arch.crypto.pqap_hook pointer is checked in
priv.c and the point in time the handle_pqap() function
in vfio_ap_ops.c is called, the memory allocated for the
matrix_mdev containing the struct kvm_s390_module_hook
may get freed, thus rendering the function pointer invalid.
While not impossible, that seems extremely unlikely to
happen. Can you articulate a scenario where that could
even occur?

> Furthermore I believe we first need to get to common ground on this
> one before proceeding any further. If you happen to preserve your
> opinion after checking again, I think we should try to discuss this
> offline, as one of us is likely looking at the wrong code.
>
> Regards,
> Halil
>
>> In the latter case, the handler in the driver will get
>> called and try to acquire the matrix_dev->lock. The function that
>> sets the vcpu->kvm->arch.crypto.pqap_hook to NULL also takes that
>> lock. If the pointer is still active, then the handler will do its thing.
>> If not, then the handler will return without enabling or disabling
>> IRQs. That should not be a problem since the unset_kvm function
>> resets the queues which will disable the IRQs.
>>
>> I don't see how
>> the vcpu->kvm->arch.crypto.pqap_hook can point to anything
>> other than the handler or be NULL unless KVM is gone. Based on
>> my observations of the behavior, unless there is some
>> other way for the remove callback to be invoked other than in
>> response to a request from userspace via the sysfs remove
>> attribute, it will not get called until the file descriptor is
>> closed in which case the release callback will also unset_kvm.
>> I think you are worrying about something that will likely never
>> happen.
>>
>>> Regards,
>>> Halil
>>>   


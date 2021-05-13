Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4C037FE00
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 21:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhEMTYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 15:24:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33934 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhEMTYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 15:24:43 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14DJ560m101841;
        Thu, 13 May 2021 15:23:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=b8mKTnFqpv7SilKKm2gG5pFFlAz9lOrBb+xsgVQXuhc=;
 b=lMj/nVyJyOjB9KhkXfXvVSkFE2NVDHY1w4Ygbl66OlX7zmaWQu9nRd0Y8//5G2vo+zIn
 uGrN3kg1HKq5qlPr/Syedg9kJgaQ3wjBk+epZ7WrTrPRpPTeleYvOTH+99heiZhuH57V
 BiC4Z/ubd69oqjGxPBeNBn0FZRGNMW0xUdbvycHNOj40xNLaLoy53kaa71Cx5WMZsOvW
 6KAs3BuPrDnjkNtLVYZX7tCGKp4QTMKPMv87f6R+h/2nd+CiyGHGZRJ4qekX4jE2FLNS
 zJQueE4l71t0KL/yFpiK1zm4TE4YfYJWN3jVjYTjEdNMIJ61rlURvJFSVTEdaSLPqJ0M vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38h9vp0gjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 15:23:31 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14DJ590Y102341;
        Thu, 13 May 2021 15:23:31 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38h9vp0gj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 15:23:31 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14DJI7fG010535;
        Thu, 13 May 2021 19:23:30 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 38dj99f738-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 19:23:30 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14DJNTrY41288092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 19:23:29 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35BE5AC05B;
        Thu, 13 May 2021 19:23:29 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 388CBAC05E;
        Thu, 13 May 2021 19:23:28 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.177.219])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 13 May 2021 19:23:27 +0000 (GMT)
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
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <243086e2-08a0-71ed-eb7e-618a62b007e4@linux.ibm.com>
Date:   Thu, 13 May 2021 15:23:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210513194541.58d1628a.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: O9wNLxUst5TIJGsb7h6L37k4cpWe43nh
X-Proofpoint-ORIG-GUID: HRlaSfjJmSrnuG9ElxDs8xF0IYqU6skB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-13_12:2021-05-12,2021-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130132
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/13/21 1:45 PM, Halil Pasic wrote:
> On Thu, 13 May 2021 10:35:05 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 5/12/21 2:35 PM, Halil Pasic wrote:
>>> On Mon, 10 May 2021 17:48:37 -0400
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>   
>>>> The mdev remove callback for the vfio_ap device driver bails out with
>>>> -EBUSY if the mdev is in use by a KVM guest. The intended purpose was
>>>> to prevent the mdev from being removed while in use; however, returning a
>>>> non-zero rc does not prevent removal. This could result in a memory leak
>>>> of the resources allocated when the mdev was created. In addition, the
>>>> KVM guest will still have access to the AP devices assigned to the mdev
>>>> even though the mdev no longer exists.
>>>>
>>>> To prevent this scenario, cleanup will be done - including unplugging the
>>>> AP adapters, domains and control domains - regardless of whether the mdev
>>>> is in use by a KVM guest or not.
>>>>
>>>> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>
>>>> ---
>>>>    drivers/s390/crypto/vfio_ap_ops.c | 13 ++-----------
>>>>    1 file changed, 2 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>>>> index b2c7e10dfdcd..f90c9103dac2 100644
>>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>>>> @@ -26,6 +26,7 @@
>>>>
>>>>    static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>>>>    static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>>>> +static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev);
>>>>
>>>>    static int match_apqn(struct device *dev, const void *data)
>>>>    {
>>>> @@ -366,17 +367,7 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
>>>>    	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>>>
>>>>    	mutex_lock(&matrix_dev->lock);
>>>> -
>>>> -	/*
>>>> -	 * If the KVM pointer is in flux or the guest is running, disallow
>>>> -	 * un-assignment of control domain.
>>>> -	 */
>>>> -	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
>>>> -		mutex_unlock(&matrix_dev->lock);
>>>> -		return -EBUSY;
>>>> -	}
>>>> -
>>>> -	vfio_ap_mdev_reset_queues(mdev);
>>>> +	vfio_ap_mdev_unset_kvm(matrix_mdev);
>>>>    	list_del(&matrix_mdev->node);
>>>>    	kfree(matrix_mdev);
>>> Are we at risk of handle_pqap() in arch/s390/kvm/priv.c using an
>>> already freed pqap_hook (which is a member of the matrix_mdev pointee
>>> that is freed just above my comment).
>>>
>>> I'm aware of the fact that vfio_ap_mdev_unset_kvm() does a
>>> matrix_mdev->kvm->arch.crypto.pqap_hook = NULL but that is
>>> AFRICT not done under any lock relevant for handle_pqap(). I guess
>>> the idea is, I guess, the check cited below
>>>
>>> static int handle_pqap(struct kvm_vcpu *vcpu)
>>> [..]
>>>           /*
>>>            * Verify that the hook callback is registered, lock the owner
>>>            * and call the hook.
>>>            */
>>>           if (vcpu->kvm->arch.crypto.pqap_hook) {
>>>                   if (!try_module_get(vcpu->kvm->arch.crypto.pqap_hook->owner))
>>>                           return -EOPNOTSUPP;
>>>                   ret = vcpu->kvm->arch.crypto.pqap_hook->hook(vcpu);
>>>                   module_put(vcpu->kvm->arch.crypto.pqap_hook->owner);
>>>                   if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)
>>>                           kvm_s390_set_psw_cc(vcpu, 3);
>>>                   return ret;
>>>           }
>>>
>>> is going to catch it, but I'm not sure it is guaranteed to catch it.
>>> Opinions?
>> The hook itself - handle_pqap() function in vfio_ap_ops.c - also checks
>> to see if the reference to the hook is set and terminates with an error
>> if it
>> is not. If the hook is invoked subsequent to the remove callback above,
>> all should be fine since the check is also done under the matrix_dev->lock.
>>
> I don't quite understand your logic. Let us assume matrix_mdev was freed,
> but vcpu->kvm->arch.crypto.pqap_hook still points to what used to be
> (*matrix_mdev).pqap_hook. In that case the function pointer
> vcpu->kvm->arch.crypto.pqap_hook->hook is used after it was freed, and
> may not point to the handle_pqap() function in vfio_ap_ops.c, thus the
> check you are referring to ain't necessarily relevant. Than is
> if you mean the check in the  handle_pqap() function in vfio_ap_ops.c; if
> you mean the check in handle_pqap() in arch/s390/kvm/priv.c, that one is
> not done under the matrix_dev->lock. Or do I have a hole somewhere in my
> reasoning?

What I am saying is the vcpu->kvm->arch.crypto.pqap_hook
will either be NULL or point to the handle_pqap() function in the
vfio_ap driver. In the latter case, the handler in the driver will get
called and try to acquire the matrix_dev->lock. The function that
sets the vcpu->kvm->arch.crypto.pqap_hook to NULL also takes that
lock. If the pointer is still active, then the handler will do its thing.
If not, then the handler will return without enabling or disabling
IRQs. That should not be a problem since the unset_kvm function
resets the queues which will disable the IRQs.

I don't see how
the vcpu->kvm->arch.crypto.pqap_hook can point to anything
other than the handler or be NULL unless KVM is gone. Based on
my observations of the behavior, unless there is some
other way for the remove callback to be invoked other than in
response to a request from userspace via the sysfs remove
attribute, it will not get called until the file descriptor is
closed in which case the release callback will also unset_kvm.
I think you are worrying about something that will likely never
happen.

>
> Regards,
> Halil
>


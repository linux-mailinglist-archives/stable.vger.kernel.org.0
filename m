Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAADB32D90D
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 18:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhCDRyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 12:54:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6624 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239274AbhCDRpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 12:45:55 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 124HWkJk026321;
        Thu, 4 Mar 2021 12:43:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=O2bpJMovIuAP9ZczXDaRB1F9vrADuLVM4xgG+5AK7CY=;
 b=Zcxc1UYp+R7Iv9MuHrZ/gTrqZliRTRzNJ4Y70G2bO5kEiQaic4UquwJpWwLUKs+dp+LQ
 hImDdWKuMJWgOJY8DC7A6XjkDMU0U2rr/Qw2uoFRkH0jZezJeFtdeTPG32G9D8yKPQCd
 /yxcTfSK3E3z86NFon6j0iJM3tNR9O23KyEryikLn9TBHYzKvLi9KMYh1FJNIylMuYPS
 ZbyshjrofgRmgLADQr12V/ytCe+lTEY3VjH0RNblNzzhQHQO4GEU9NmeBsHi4SQkG70u
 GcIAyZ8h5myZ6yGalussM5mPoL1KwQWdxw5UNG5EIYq6kcZ6IAf3pKJn5B2Wh9RU4EWO vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3733vn8ux6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 12:43:50 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 124HWm7s026717;
        Thu, 4 Mar 2021 12:43:50 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3733vn8uww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 12:43:50 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 124HclqU001274;
        Thu, 4 Mar 2021 17:43:49 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 36ydq9tssu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 17:43:49 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 124HhlF523986604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Mar 2021 17:43:47 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBDE66E062;
        Thu,  4 Mar 2021 17:43:46 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D6B66E052;
        Thu,  4 Mar 2021 17:43:45 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.150.254])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  4 Mar 2021 17:43:45 +0000 (GMT)
Subject: Re: [PATCH v3 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
References: <20210302204322.24441-1-akrowiak@linux.ibm.com>
 <20210302204322.24441-2-akrowiak@linux.ibm.com>
 <20210303162332.4d227dbe.pasic@linux.ibm.com>
 <14665bcf-2224-e313-43ff-357cadd177cf@linux.ibm.com>
 <20210303204706.0538e84f.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <8f5ab6fa-8fd3-27d8-8561-d03ff457df16@linux.ibm.com>
Date:   Thu, 4 Mar 2021 12:43:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210303204706.0538e84f.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-04_05:2021-03-03,2021-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 impostorscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040082
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/3/21 2:47 PM, Halil Pasic wrote:
> On Wed, 3 Mar 2021 12:10:11 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 3/3/21 10:23 AM, Halil Pasic wrote:
>>> On Tue,  2 Mar 2021 15:43:22 -0500
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>   
>>>> This patch fixes a lockdep splat introduced by commit f21916ec4826
>>>> ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated").
>>>> The lockdep splat only occurs when starting a Secure Execution guest.
>>>> Crypto virtualization (vfio_ap) is not yet supported for SE guests;
>>>> however, in order to avoid this problem when support becomes available,
>>>> this fix is being provided.
>>> [..]
>>>   
>>>> @@ -1038,14 +1116,28 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>>>>    {
>>>>    	struct ap_matrix_mdev *m;
>>>>
>>>> -	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
>>>> -		if ((m != matrix_mdev) && (m->kvm == kvm))
>>>> -			return -EPERM;
>>>> -	}
>>>> +	if (kvm->arch.crypto.crycbd) {
>>>> +		matrix_mdev->kvm_busy = true;
>>>>
>>>> -	matrix_mdev->kvm = kvm;
>>>> -	kvm_get_kvm(kvm);
>>>> -	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
>>>> +		list_for_each_entry(m, &matrix_dev->mdev_list, node) {
>>>> +			if ((m != matrix_mdev) && (m->kvm == kvm)) {
>>>> +				wake_up_all(&matrix_mdev->wait_for_kvm);
>>> This ain't no good. kvm_busy will remain true if we take this exit. The
>>> wake_up_all() is not needed, because we hold the lock, so nobody can
>>> observe it if we don't forget kvm_busy set.
>>>
>>> I suggest moving matrix_mdev->kvm_busy = true; after this loop, maybe right
>>> before the unlock, and removing the wake_up_all().
>>>   
>>>> +				return -EPERM;
>>>> +			}
>>>> +		}
>>>> +
>>>> +		kvm_get_kvm(kvm);
>>>> +		mutex_unlock(&matrix_dev->lock);
>>>> +		kvm_arch_crypto_set_masks(kvm,
>>>> +					  matrix_mdev->matrix.apm,
>>>> +					  matrix_mdev->matrix.aqm,
>>>> +					  matrix_mdev->matrix.adm);
>>>> +		mutex_lock(&matrix_dev->lock);
>>>> +		kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
>>>> +		matrix_mdev->kvm = kvm;
>>>> +		matrix_mdev->kvm_busy = false;
>>>> +		wake_up_all(&matrix_mdev->wait_for_kvm);
>>>> +	}
>>>>
>>>>    	return 0;
>>>>    }
>>> [..]
>>>   
>>>> @@ -1300,7 +1406,21 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
>>>>    		ret = vfio_ap_mdev_get_device_info(arg);
>>>>    		break;
>>>>    	case VFIO_DEVICE_RESET:
>>>> -		ret = vfio_ap_mdev_reset_queues(mdev);
>>>> +		matrix_mdev = mdev_get_drvdata(mdev);
>>>> +
>>>> +		/*
>>>> +		 * If the KVM pointer is in the process of being set, wait until
>>>> +		 * the process has completed.
>>>> +		 */
>>>> +		wait_event_cmd(matrix_mdev->wait_for_kvm,
>>>> +			       matrix_mdev->kvm_busy == false,
>>>> +			       mutex_unlock(&matrix_dev->lock),
>>>> +			       mutex_lock(&matrix_dev->lock));
>>>> +
>>>> +		if (matrix_mdev->kvm)
>>>> +			ret = vfio_ap_mdev_reset_queues(mdev);
>>>> +		else
>>>> +			ret = -ENODEV;
>>> I don't think rejecting the reset is a good idea. I have you a more detailed
>>> explanation of the list, where we initially discussed this question.
>>>
>>> How do you exect userspace to react to this -ENODEV?
>> After reading your more detailed explanation, I have come to the
>> conclusion that the test for matrix_mdev->kvm should not be
>> performed here and the the vfio_ap_mdev_reset_queues() function
>> should be called regardless. Each queue assigned to the mdev
>> that is also bound to the vfio_ap driver will get reset and its
>> IRQ resources cleaned up if they haven't already been and the
>> other required conditions are met (i.e., see
>> vfio_ap_mdev_free_irq_resources()).
> My point is if !->kvm the other required conditions are not met. But
> yes we can go back to unconditional vfio_ap_mdev_reset_queues(mdev),
> and think about the necessity of performing a
> vfio_ap_mdev_reset_queues() if !->kvm later as I proposed in the other
> mail.

The other conditions may or may not have been met depending
upon whether ->kvm is NULL because the VFIO_DEVICE_RESET
ioctl was invoked while the matrix_dev->lock was released
in the vfio_ap_mdev_unset_kvm() function. If that was the case,
then there is no need to clean up the IRQ resources because it
will already have been done.

On the other hand, if we don't have ->kvm because something broke,
then we may be out of luck anyway. There will certainly be no
way to unregister the GISC; however, it may still be possible
to unpin the pages if we still have q->saved_pfn.

The point is, if the queue is bound to vfio_ap, it can be reset. If we can't
clean up the IRQ resources because something is broken, then there
is nothing we can do about that.


>
> Regards,
> Halil


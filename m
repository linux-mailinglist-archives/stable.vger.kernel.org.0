Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D3D32573C
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 21:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbhBYUDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 15:03:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28822 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233043AbhBYUDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 15:03:43 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PK2tWa125298;
        Thu, 25 Feb 2021 15:02:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3exAcU5W64AGjWhduBTxXEz55GVrwXwkpJlhpXule84=;
 b=galtFfBZIqMXAVCbOlbV4RitcALJDLd2vnTejETPtCv6CKLBYo8SYxlpamMipOp2PBk6
 yvRwaRNOIwAYkAzmgdraYO3rychYskeYh1kGrH/beTOUPMuwv4H3GlIm3qJdOEOjD2+3
 uu14RrjUKBvYpxWxUHoyIR7DImW0f/lRq77QG2y2XJWpxxWqi+sQ4F+PpWFbA8PrOqMJ
 +Cqjldw0Q2lOhN8G9tGmniXjvTDf4N6H3esW9pcAN3JHYs7MHbat8nMBbwznFIw/CC1V
 X+sOjfwZZ67H1/eCY0DET9i/1W6AqoZ2YjelxlHbYaMkisFi8PP50O4kK9brPnqDbTkc 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xfcjx5fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 15:02:54 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11PJX2vx190461;
        Thu, 25 Feb 2021 15:02:46 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xfcjx5f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 15:02:46 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11PJoMYO001197;
        Thu, 25 Feb 2021 20:02:45 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 36tt29h7ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 20:02:45 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11PK2ikR21496110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 20:02:44 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F472BE058;
        Thu, 25 Feb 2021 20:02:44 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02EF1BE051;
        Thu, 25 Feb 2021 20:02:42 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.150.254])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 25 Feb 2021 20:02:42 +0000 (GMT)
Subject: Re: [PATCH v2 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
References: <20210216011547.22277-1-akrowiak@linux.ibm.com>
 <20210216011547.22277-2-akrowiak@linux.ibm.com>
 <20210223104805.6a8d1872.pasic@linux.ibm.com>
 <63bb0d61-efcd-315b-5a1a-0ef4d99600f4@linux.ibm.com>
 <20210225122824.467b8ed9.pasic@linux.ibm.com>
 <f5d5cbab-2181-2a95-8a87-b21d05405936@linux.ibm.com>
 <0cebaf32-776c-62c5-b7a7-d0e8afb02ceb@linux.ibm.com>
 <20210225163507.45c3391f.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <12db0317-810c-419f-275f-0cd4e5516cf7@linux.ibm.com>
Date:   Thu, 25 Feb 2021 15:02:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210225163507.45c3391f.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_11:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxlogscore=999 mlxscore=0 adultscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250152
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/25/21 10:35 AM, Halil Pasic wrote:
> On Thu, 25 Feb 2021 10:25:24 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 2/25/21 8:53 AM, Tony Krowiak wrote:
>>>
>>> On 2/25/21 6:28 AM, Halil Pasic wrote:
>>>> On Wed, 24 Feb 2021 22:28:50 -0500
>>>> Tony Krowiak<akrowiak@linux.ibm.com>  wrote:
>>>>   
>>>>>>>     static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>>>>>>>     {
>>>>>>> -	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>>>>>>> -	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>>>>>>> -	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
>>>>>>> -	kvm_put_kvm(matrix_mdev->kvm);
>>>>>>> -	matrix_mdev->kvm = NULL;
>>>>>>> +	struct kvm *kvm;
>>>>>>> +
>>>>>>> +	if (matrix_mdev->kvm) {
>>>>>>> +		kvm = matrix_mdev->kvm;
>>>>>>> +		kvm_get_kvm(kvm);
>>>>>>> +		matrix_mdev->kvm = NULL;
>>>>>> I think if there were two threads dong the unset in parallel, one
>>>>>> of them could bail out and carry on before the cleanup is done. But
>>>>>> since nothing much happens in release after that, I don't see an
>>>>>> immediate problem.
>>>>>>
>>>>>> Another thing to consider is, that setting ->kvm to NULL arms
>>>>>> vfio_ap_mdev_remove()...
>>>>> I'm not entirely sure what you mean by this, but my
>>>>> assumption is that you are talking about the check
>>>>> for matrix_mdev->kvm != NULL at the start of
>>>>> that function.
>>>> Yes I was talking about the check
>>>>
>>>> static int vfio_ap_mdev_remove(struct mdev_device *mdev)
>>>> {
>>>>           struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>>>                                                                                   
>>>>           if (matrix_mdev->kvm)
>>>>                   return -EBUSY;
>>>> ...
>>>>           kfree(matrix_mdev);
>>>> ...
>>>> }
>>>>
>>>> As you see, we bail out if kvm is still set, otherwise we clean up the
>>>> matrix_mdev which includes kfree-ing it. And vfio_ap_mdev_remove() is
>>>> initiated via the sysfs, i.e. can be initiated at any time. If we were
>>>> to free matrix_mdev in mdev_remove() and then carry on with kvm_unset()
>>>> with mutex_lock(&matrix_dev->lock); that would be bad.
>>> I agree.
>>>   
>>>>   
>>>>> The reason
>>>>> matrix_mdev->kvm is set to NULL before giving up
>>>>> the matrix_dev->lock is so that functions that check
>>>>> for the presence of the matrix_mdev->kvm pointer,
>>>>> such as assign_adapter_store() - will exit if they get
>>>>> control while the masks are being cleared.
>>>> I disagree!
>>>>
>>>> static ssize_t assign_adapter_store(struct device *dev,
>>>>                                       struct device_attribute *attr,
>>>>                                       const char *buf, size_t count)
>>>> {
>>>>           int ret;
>>>>           unsigned long apid;
>>>>           struct mdev_device *mdev = mdev_from_dev(dev);
>>>>           struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>>>                                                                                   
>>>>           /* If the guest is running, disallow assignment of adapter */
>>>>           if (matrix_mdev->kvm)
>>>>                   return -EBUSY;
>>>>
>>>> We bail out when kvm != NULL, so having it set to NULL while the
>>>> mask are being cleared will make these not bail out.
>>> You are correct, I am an idiot.
>>>   
>>>>> So what we have
>>>>> here is a catch-22; in other words, we have the case
>>>>> you pointed out above and the cases related to
>>>>> assigning/unassigning adapters, domains and
>>>>> control domains which should exit when a guest
>>>>> is running.
>>>> See above.
>>> Ditto.
>>>   
>>>>> I may have an idea to resolve this. Suppose we add:
>>>>>
>>>>> struct ap_matrix_mdev {
>>>>>        ...
>>>>>        bool kvm_busy;
>>>>>        ...
>>>>> }
>>>>>
>>>>> This flag will be set to true at the start of both the
>>>>> vfio_ap_mdev_set_kvm() and vfio_ap_mdev_unset_kvm()
>>>>> and set to false at the end. The assignment/unassignment
>>>>> and remove callback functions can test this flag and
>>>>> return -EBUSY if the flag is true. That will preclude assigning
>>>>> or unassigning adapters, domains and control domains when
>>>>> the KVM pointer is being set/unset. Likewise, removal of the
>>>>> mediated device will also be prevented while the KVM pointer
>>>>> is being set/unset.
>>>>>
>>>>> In the case of the PQAP handler function, it can wait for the
>>>>> set/unset of the KVM pointer as follows:
>>>>>
>>>>> /while (matrix_mdev->kvm_busy) {//
>>>>> //        mutex_unlock(&matrix_dev->lock);//
>>>>> //        msleep(100);//
>>>>> //        mutex_lock(&matrix_dev->lock);//
>>>>> //}//
>>>>> //
>>>>> //if (!matrix_mdev->kvm)//
>>>>> //        goto out_unlock;
>>>>>
>>>>> /What say you?
>>>>> //
>>>> I'm not sure. Since I disagree with your analysis above it is difficult
>>>> to deal with the conclusion. I'm not against decoupling the tracking of
>>>> the state of the mdev_matrix device from the value of the kvm pointer. I
>>>> think we should first get a common understanding of the problem, before
>>>> we proceed to the solution.
>>> Regardless of my brain fog regarding the testing of the
>>> matrix_mdev->kvm pointer, I stand by what I stated
>>> in the paragraphs just before the code snippet.
>>>
>>> The problem is there are 10 functions that depend upon
>>> the value of the matrix_mdev->kvm pointer that can get
>>> control while the pointer is being set/unset and the
>>> matrix_dev->lock is given up to set/clear the masks:
>> * vfio_ap_irq_enable: called by handle_pqap() when AQIC is intercepted
>> * vfio_ap_irq_disable: called by handle_pqap() when AQIC is intercepted
>> * assign_adapter_store: sysfs
>> * unassign_adapter_store: sysfs
>> * assign_domain_store: sysfs
>> * unassign_domain_store: sysfs
>> * assign__control_domain_store: sysfs
>> * unassign_control_domain_store: sysfs
>> * vfio_ap_mdev_remove: sysfs
>> * vfio_ap_mdev_release: mdev fd closed by userspace (i.e., qemu)If we
>> add the proposed flag to indicate when the matrix_mdev->kvm
> Something is strange with this email. It is basically the same email
> as the previous one, just broken, or?

the previous email was rejected for the kernel addresses because
I used bulleted lists which aren't acceptable. The kernel email addresses
accept text-only, so I replaced the bulleted list with the above.

>
>>> pointer is in flux, then we can check that before allowing the functions
>>> in the list above to proceed.
>>>   
>>>> Regards,
>>>> Halil
>>>   


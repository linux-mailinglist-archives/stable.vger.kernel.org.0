Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9EC32C826
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbhCDAec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4588 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233473AbhCCRLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 12:11:35 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 123H3YMN036521;
        Wed, 3 Mar 2021 12:10:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xB4pj5ZQmdaIfWonq+qYZ9igM/UR1LN9BL/+/khQTwY=;
 b=HwfrlT+MWatOCZWhscq4UHiyg4cbIjTMAEIagbWjaEoz7svKwLB5tK/Xwo02drucOYec
 ZcBJgFtW+y0qd7sJZiQlVWkpNrX+gFnXh3LxqFay/li/CXdVq3BvZTyk1JbgcYJcArzv
 Tal++cENl7yLtZBLqCICg8XYJAcw8rQzSlqrHKzSw3HWc1LfRc92UDjurVjkbEjDVyMm
 1kJkLU7JPKRLnTcduFgurqih1tFO+1RDYP8za4aU+C3N8jMrGFesJYsJFzi9yjBHRa69
 +b3fvZnZwyYCKwQnTf+YXX8sXph6AEMjh4Cg+n2Y6aL+oL4txMnKjSrZS6INmz2maM2V VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 372dwshnb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 12:10:17 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 123H3uvX042538;
        Wed, 3 Mar 2021 12:10:17 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 372dwshnaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 12:10:16 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 123Gw93R032762;
        Wed, 3 Mar 2021 17:10:16 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma03dal.us.ibm.com with ESMTP id 3720r0eckk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 17:10:16 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 123HAEtU24379838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Mar 2021 17:10:14 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E63F13604F;
        Wed,  3 Mar 2021 17:10:14 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BFF2136053;
        Wed,  3 Mar 2021 17:10:12 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.150.254])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  3 Mar 2021 17:10:12 +0000 (GMT)
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
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <14665bcf-2224-e313-43ff-357cadd177cf@linux.ibm.com>
Date:   Wed, 3 Mar 2021 12:10:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210303162332.4d227dbe.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-03_05:2021-03-03,2021-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 adultscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103030123
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/3/21 10:23 AM, Halil Pasic wrote:
> On Tue,  2 Mar 2021 15:43:22 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> This patch fixes a lockdep splat introduced by commit f21916ec4826
>> ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated").
>> The lockdep splat only occurs when starting a Secure Execution guest.
>> Crypto virtualization (vfio_ap) is not yet supported for SE guests;
>> however, in order to avoid this problem when support becomes available,
>> this fix is being provided.
> [..]
>
>> @@ -1038,14 +1116,28 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>>   {
>>   	struct ap_matrix_mdev *m;
>>
>> -	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
>> -		if ((m != matrix_mdev) && (m->kvm == kvm))
>> -			return -EPERM;
>> -	}
>> +	if (kvm->arch.crypto.crycbd) {
>> +		matrix_mdev->kvm_busy = true;
>>
>> -	matrix_mdev->kvm = kvm;
>> -	kvm_get_kvm(kvm);
>> -	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
>> +		list_for_each_entry(m, &matrix_dev->mdev_list, node) {
>> +			if ((m != matrix_mdev) && (m->kvm == kvm)) {
>> +				wake_up_all(&matrix_mdev->wait_for_kvm);
> This ain't no good. kvm_busy will remain true if we take this exit. The
> wake_up_all() is not needed, because we hold the lock, so nobody can
> observe it if we don't forget kvm_busy set.
>
> I suggest moving matrix_mdev->kvm_busy = true; after this loop, maybe right
> before the unlock, and removing the wake_up_all().
>
>> +				return -EPERM;
>> +			}
>> +		}
>> +
>> +		kvm_get_kvm(kvm);
>> +		mutex_unlock(&matrix_dev->lock);
>> +		kvm_arch_crypto_set_masks(kvm,
>> +					  matrix_mdev->matrix.apm,
>> +					  matrix_mdev->matrix.aqm,
>> +					  matrix_mdev->matrix.adm);
>> +		mutex_lock(&matrix_dev->lock);
>> +		kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
>> +		matrix_mdev->kvm = kvm;
>> +		matrix_mdev->kvm_busy = false;
>> +		wake_up_all(&matrix_mdev->wait_for_kvm);
>> +	}
>>
>>   	return 0;
>>   }
> [..]
>
>> @@ -1300,7 +1406,21 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
>>   		ret = vfio_ap_mdev_get_device_info(arg);
>>   		break;
>>   	case VFIO_DEVICE_RESET:
>> -		ret = vfio_ap_mdev_reset_queues(mdev);
>> +		matrix_mdev = mdev_get_drvdata(mdev);
>> +
>> +		/*
>> +		 * If the KVM pointer is in the process of being set, wait until
>> +		 * the process has completed.
>> +		 */
>> +		wait_event_cmd(matrix_mdev->wait_for_kvm,
>> +			       matrix_mdev->kvm_busy == false,
>> +			       mutex_unlock(&matrix_dev->lock),
>> +			       mutex_lock(&matrix_dev->lock));
>> +
>> +		if (matrix_mdev->kvm)
>> +			ret = vfio_ap_mdev_reset_queues(mdev);
>> +		else
>> +			ret = -ENODEV;
> I don't think rejecting the reset is a good idea. I have you a more detailed
> explanation of the list, where we initially discussed this question.
>
> How do you exect userspace to react to this -ENODEV?

After reading your more detailed explanation, I have come to the
conclusion that the test for matrix_mdev->kvm should not be
performed here and the the vfio_ap_mdev_reset_queues() function
should be called regardless. Each queue assigned to the mdev
that is also bound to the vfio_ap driver will get reset and its
IRQ resources cleaned up if they haven't already been and the
other required conditions are met (i.e., see 
vfio_ap_mdev_free_irq_resources()).

>
> Otherwise looks good to me!
>
> I've tested your branch from yesterday (which looks to me like this patch
> without the above check on ->kvm and reset) for the lockdep splat, but I
> didn't do any comprehensive testing -- which would ensure that we didn't
> break something else in the process. With the two issues fixed, and your
> word that the patch was properly tested (except for the lockdep splat
> which I tested myself), I feel comfortable with moving forward with this.
>
> Regards,
>


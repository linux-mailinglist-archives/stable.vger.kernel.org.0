Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DD83172EC
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 23:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbhBJWIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 17:08:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232103AbhBJWIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 17:08:09 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11AM760T025147;
        Wed, 10 Feb 2021 17:07:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dhNfFfaI6Zouk2ES5TERUMQ3DUWiy95RvkmjHFsyWg0=;
 b=HlbXmcWjHgGB7NOsdRjdU/vlcGHJ2JT4WPdfjByt2uu9GjHkqgsB16DXYM1DxaOIXN+X
 rK8E4wo3MSvfD6kLkvSsHpaw+VJV/6SPScyLg+wPMxlMPDg6/77oxT9i/zDOGbqJHbsM
 hr5swdTKrXS8KbvgbHJ8ZX3zPtQVawqwsqM7oERpupAo5DbD6Wd4S4QUKPiCi2xtlyoJ
 7U0Zaf6Qs9LjJxm3PFPBvAllwfckxwVc1nwNjCA9NwJlwMSze7W/OP54qonYd+2d2LLw
 svZnHOBTuT79grscwQW8xhZsX4Au8aqDsFUIpOWkOpzA9Pblh1rq/rfqmxUD5Gv0T/U3 eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mqngge5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 17:07:25 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11AM7O86026303;
        Wed, 10 Feb 2021 17:07:24 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mqnggdmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 17:07:24 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11AM2gCc006636;
        Wed, 10 Feb 2021 22:03:42 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01dal.us.ibm.com with ESMTP id 36hjr9sdww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 22:03:42 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11AM3eRX18219422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 22:03:40 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69D026E090;
        Wed, 10 Feb 2021 22:03:40 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 073A36E094;
        Wed, 10 Feb 2021 22:03:38 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.203.235])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 10 Feb 2021 22:03:38 +0000 (GMT)
Subject: Re: [PATCH 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
To:     Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
References: <20210209194830.20271-1-akrowiak@linux.ibm.com>
 <20210209194830.20271-2-akrowiak@linux.ibm.com>
 <20210210115334.46635966.cohuck@redhat.com>
 <20210210162429.261fc17c.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <f709d4ec-c07a-3814-6f4d-27e1aaefada2@linux.ibm.com>
Date:   Wed, 10 Feb 2021 17:03:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210210162429.261fc17c.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_11:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100191
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/10/21 10:24 AM, Halil Pasic wrote:
> On Wed, 10 Feb 2021 11:53:34 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
>
>> On Tue,  9 Feb 2021 14:48:30 -0500
>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>
>>> This patch fixes a circular locking dependency in the CI introduced by
>>> commit f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM
>>> pointer invalidated"). The lockdep only occurs when starting a Secure
>>> Execution guest. Crypto virtualization (vfio_ap) is not yet supported for
>>> SE guests; however, in order to avoid CI errors, this fix is being
>>> provided.
>>>
>>> The circular lockdep was introduced when the masks in the guest's APCB
>>> were taken under the matrix_dev->lock. While the lock is definitely
>>> needed to protect the setting/unsetting of the KVM pointer, it is not
>>> necessarily critical for setting the masks, so this will not be done under
>>> protection of the matrix_dev->lock.
>>>
>>> Fixes: f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>> ---
>>>   drivers/s390/crypto/vfio_ap_ops.c | 75 ++++++++++++++++++-------------
>>>   1 file changed, 45 insertions(+), 30 deletions(-)
>>>    
>>>   static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>>>   {
>>> -	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>>> -	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>>> -	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
>>> -	kvm_put_kvm(matrix_mdev->kvm);
>>> -	matrix_mdev->kvm = NULL;
>>> +	if (matrix_mdev->kvm) {
>> If you're doing setting/unsetting under matrix_dev->lock, is it
>> possible that matrix_mdev->kvm gets unset between here and the next
>> line, as you don't hold the lock?
>>
>> Maybe you could
>> - grab a reference to kvm while holding the lock
>> - call the mask handling functions with that kvm reference
>> - lock again, drop the reference, and do the rest of the processing?
> I agree, matrix_mdev->kvm can go NULL any time and we are risking
> a null pointer dereference here.
>
> Another idea would be to do
>
>
> static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
> {
>          struct kvm *kvm;
>                                                          
>          mutex_lock(&matrix_dev->lock);
>          if (matrix_mdev->kvm) {
>                  kvm = matrix_mdev->kvm;
>                  matrix_mdev->kvm = NULL;
>                  mutex_unlock(&matrix_dev->lock);
>                  kvm_arch_crypto_clear_masks(kvm);
>                  mutex_lock(&matrix_dev->lock);
>                  matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>                  vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
>                  kvm_put_kvm(kvm);
>          }
>          mutex_unlock(&matrix_dev->lock);
> }
>
> That way only one unset would actually do the unset and cleanup
> and every other invocation would bail out with only checking
> matrix_mdev->kvm.

How ironic, that is exactly what I did after agreeing with Connie.

>
>   
>>> +		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>>> +		mutex_lock(&matrix_dev->lock);
>>> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>>> +		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
>>> +		kvm_put_kvm(matrix_mdev->kvm);
>>> +		matrix_mdev->kvm = NULL;
>>> +		mutex_unlock(&matrix_dev->lock);
>>> +	}
>>>   }


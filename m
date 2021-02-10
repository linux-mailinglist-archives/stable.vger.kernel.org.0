Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4B5317174
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 21:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbhBJUfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 15:35:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27806 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231948AbhBJUfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 15:35:11 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11AKX99M089354;
        Wed, 10 Feb 2021 15:34:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Z2CQz5gwvzQp8ZDyEEgU1QhdBwFeglrzERKm2ExhzfA=;
 b=XMV9XBgTcrQIra9JBuhpTH1WYiiDWNfsb2G3Myd6eh2d9r2shfASMFyLwX6i+CJuLlRh
 ic0ac4KZ/k1W3KjTsyBHlXmqica2S1J3QcCSNzGsNySSN3gyufrI3vXGIHBbs9n4Xm/2
 wYiPWVYP9X6sC0ktx+iI0M+yO6UnlcMpeGiYL+AmPK4AJX4xZ9VSiaCWl/pRb6vdb5Zq
 VQjiqEEFrWzJb9EHioCwU4GNXhioT3hUCOuj6T098lHdxgHWXeHMubrdDlMKXa/Qn49Z
 EsG5gzj+3VQelMi8FY5aRhMBBGkKKb0fcifQJGq1lvb0OKRWbQOVH3b1FgMw1WmSQTua hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mpka82ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 15:34:29 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11AKXJJx090185;
        Wed, 10 Feb 2021 15:34:29 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mpka82wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 15:34:29 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11AKSH7L025585;
        Wed, 10 Feb 2021 20:34:27 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 36hjra8w3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 20:34:27 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11AKYQVh29032952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 20:34:26 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 351076E04C;
        Wed, 10 Feb 2021 20:34:26 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15CA76E04E;
        Wed, 10 Feb 2021 20:34:24 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.203.235])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 10 Feb 2021 20:34:24 +0000 (GMT)
Subject: Re: [PATCH 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
References: <20210209194830.20271-1-akrowiak@linux.ibm.com>
 <20210209194830.20271-2-akrowiak@linux.ibm.com>
 <20210210115334.46635966.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <6e2842e4-334d-6592-a781-5b85ec0ed13c@linux.ibm.com>
Date:   Wed, 10 Feb 2021 15:34:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210210115334.46635966.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_10:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100183
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/10/21 5:53 AM, Cornelia Huck wrote:
> On Tue,  9 Feb 2021 14:48:30 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> This patch fixes a circular locking dependency in the CI introduced by
>> commit f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM
>> pointer invalidated"). The lockdep only occurs when starting a Secure
>> Execution guest. Crypto virtualization (vfio_ap) is not yet supported for
>> SE guests; however, in order to avoid CI errors, this fix is being
>> provided.
>>
>> The circular lockdep was introduced when the masks in the guest's APCB
>> were taken under the matrix_dev->lock. While the lock is definitely
>> needed to protect the setting/unsetting of the KVM pointer, it is not
>> necessarily critical for setting the masks, so this will not be done under
>> protection of the matrix_dev->lock.
>>
>> Fixes: f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 75 ++++++++++++++++++-------------
>>   1 file changed, 45 insertions(+), 30 deletions(-)
>>
>>   static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>>   {
>> -	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>> -	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>> -	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
>> -	kvm_put_kvm(matrix_mdev->kvm);
>> -	matrix_mdev->kvm = NULL;
>> +	if (matrix_mdev->kvm) {
> If you're doing setting/unsetting under matrix_dev->lock, is it
> possible that matrix_mdev->kvm gets unset between here and the next
> line, as you don't hold the lock?

That is highly unlikely because the only place the matrix_mdev->kvm
pointer is cleared is in this function which is called from only two
places: the notifier that handles the VFIO_GROUP_NOTIFY_SET_KVM
notification when the KVM pointer is cleared; the vfio_ap_mdev_release()
function which is called when the mdev fd is closed (i.e., when the guest
is shut down). The fact is, with the only end-to-end implementation
currently available, the notifier callback is never invoked to clear
the KVM pointer because the vfio_ap_mdev_release callback is
invoked first and it unregisters the notifier callback.

Having said that, I suppose there is no guarantee that there will not
be different userspace clients in the future that do things in a
different order. At the very least, it wouldn't hurt to protect against
that as you suggest below.

>
> Maybe you could
> - grab a reference to kvm while holding the lock
> - call the mask handling functions with that kvm reference
> - lock again, drop the reference, and do the rest of the processing?
>
>> +		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>> +		mutex_lock(&matrix_dev->lock);
>> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>> +		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
>> +		kvm_put_kvm(matrix_mdev->kvm);
>> +		matrix_mdev->kvm = NULL;
>> +		mutex_unlock(&matrix_dev->lock);
>> +	}
>>   }


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C639C379672
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 19:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbhEJRwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 13:52:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31066 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233060AbhEJRwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 13:52:06 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AHWjI6068969;
        Mon, 10 May 2021 13:51:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=O6I1sDLaSBhNsj27OxVc3axeaa1r5Dh/QHJIET1FP1Y=;
 b=VgJXxattGFxjZKCX+hCOjhPhvrtWblNoJyHWUldAqreXusEm9swOoJK5CjVckSawrVTg
 DHBNfUibmSj6SWQLBDy4uXOQiTKsfEfiB8aquiWRCAYn0gPutxtmQtIuqAN4ZZ5jZ9LF
 F+8DowoMgyF+PrJh15DGm86BITPopL8gBvznHd8WNQ2GTo7FPJ5DJB2D+3GYRTr9SAUf
 FHtUt37OpTM8NkbffYIbzjJ64pN4jJOskCLSo6NcPbVpuc5WtljDuzh9gr3EuAJN5ZNF
 c4HdU9xUVG5f8LWIpPQFRbux2XGbhKRf+LfWy1V8H5crS7Swie+FDKkvBwmTzwctU2k0 KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f9228xav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 13:51:00 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AHWjmx069034;
        Mon, 10 May 2021 13:50:59 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f9228xaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 13:50:59 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AHmCtq017628;
        Mon, 10 May 2021 17:50:58 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 38dj9901xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 17:50:58 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AHovYg30408998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 17:50:57 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9849112063;
        Mon, 10 May 2021 17:50:57 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4078C112062;
        Mon, 10 May 2021 17:50:57 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.140.234])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 17:50:57 +0000 (GMT)
Subject: Re: [PATCH] s390/vfio-ap: fix memory leak in mdev remove callback
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, pasic@linux.vnet.ibm.com,
        jjherne@linux.ibm.com, jgg@nvidia.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, stable@vger.kernel.org,
        Tony Krowiak <akrowiak@stny.rr.com>
References: <20210505172826.105304-1-akrowiak@linux.ibm.com>
 <20210506122245.20f4ba21.cohuck@redhat.com>
 <20210506124541.63e98b64.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <8fd7f138-8544-c38b-fb0f-fa12e3c8ef06@linux.ibm.com>
Date:   Mon, 10 May 2021 13:50:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506124541.63e98b64.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fn1s1Fw8-6KwfJBCFQJumBHeVpCIw-u8
X-Proofpoint-GUID: bieBX1xk9QSJv723mce2mabqDZJHBUEn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_11:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 phishscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 priorityscore=1501
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100118
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/6/21 6:45 AM, Cornelia Huck wrote:
> On Thu, 6 May 2021 12:22:45 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
>
>> On Wed,  5 May 2021 13:28:26 -0400
>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>
>>> The mdev remove callback for the vfio_ap device driver bails out with
>>> -EBUSY if the mdev is in use by a KVM guest. The intended purpose was
>>> to prevent the mdev from being removed while in use; however, returning a
>>> non-zero rc does not prevent removal. This could result in a memory leak
>>> of the resources allocated when the mdev was created. In addition, the
>>> KVM guest will still have access to the AP devices assigned to the mdev
>>> even though the mdev no longer exists.
>>>
>>> To prevent this scenario, cleanup will be done - including unplugging the
>>> AP adapters, domains and control domains - regardless of whether the mdev
>>> is in use by a KVM guest or not.
>>>
>>> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>
>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>> ---
>>>   drivers/s390/crypto/vfio_ap_ops.c | 39 +++++++++++++++++++++++--------
>>>   1 file changed, 29 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>>> index b2c7e10dfdcd..757166da947e 100644
>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>>> @@ -335,6 +335,32 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>>>   	matrix->adm_max = info->apxa ? info->Nd : 15;
>>>   }
>>>   
>>> +static bool vfio_ap_mdev_has_crycb(struct ap_matrix_mdev *matrix_mdev)
>>> +{
>>> +	return (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd);
>>> +}
>>> +
>>> +static void vfio_ap_mdev_clear_apcb(struct ap_matrix_mdev *matrix_mdev)
>>> +{
>>> +	/*
>>> +	 * If the KVM pointer is in the process of being set, wait until the
>>> +	 * process has completed.
>>> +	 */
>>> +	wait_event_cmd(matrix_mdev->wait_for_kvm,
>>> +		       !matrix_mdev->kvm_busy,
>>> +		       mutex_unlock(&matrix_dev->lock),
>>> +		       mutex_lock(&matrix_dev->lock));
>>> +
>>> +	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
>>> +		matrix_mdev->kvm_busy = true;
>>> +		mutex_unlock(&matrix_dev->lock);
>>> +		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>>> +		mutex_lock(&matrix_dev->lock);
>>> +		matrix_mdev->kvm_busy = false;
>>> +		wake_up_all(&matrix_mdev->wait_for_kvm);
>>> +	}
>>> +}
>> Looking at vfio_ap_mdev_unset_kvm(), do you need to unhook the kvm here
>> as well?
>>
>> (Or can you maybe even combine the two functions into one?)
> Staring at the code some more, the rules where you unset the kvm stuff
> seem pretty confusing (at least to me). Does this partial unhooking in
> the remove callback make sense?

If you stare at it too long, you'll go blind:) As I stated in my response
to your previous review comment, I'm going to remove the function
above and call the vfio_ap_mdev_unset_kvm() function from the
remove callback.

>
>>> +
>>>   static int vfio_ap_mdev_create(struct mdev_device *mdev)
>>>   {
>>>   	struct ap_matrix_mdev *matrix_mdev;
>>> @@ -366,16 +392,9 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
>>>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>>   
>>>   	mutex_lock(&matrix_dev->lock);
>>> -
>>> -	/*
>>> -	 * If the KVM pointer is in flux or the guest is running, disallow
>>> -	 * un-assignment of control domain.
>>> -	 */
>>> -	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
>>> -		mutex_unlock(&matrix_dev->lock);
>>> -		return -EBUSY;
>>> -	}
>>> -
>>> +	WARN(vfio_ap_mdev_has_crycb(matrix_mdev),
>>> +	     "Removing mdev leaves KVM guest without any crypto devices");
>>> +	vfio_ap_mdev_clear_apcb(matrix_mdev);
>>>   	vfio_ap_mdev_reset_queues(mdev);
>>>   	list_del(&matrix_mdev->node);
>>>   	kfree(matrix_mdev);


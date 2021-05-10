Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A8237964A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 19:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbhEJRp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 13:45:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47208 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232873AbhEJRp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 13:45:26 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AHXevq095641;
        Mon, 10 May 2021 13:44:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GQ5qMA1xQTi4vy3PaOh1vqePGiZHuAabLMLcrvBCn4k=;
 b=oKMF8fbRMTc0VzTpOHT+i6J3ppm2sRv2c1IYiPCFCsPGYFTB/1JhKK+Bq8LaRNQXecCc
 u8tdkj2r1Q/kzkt8AotoLIQaT5RdRs3Zitk3//4v5sEUgZKFknpSVEvIcLWy54bI1n8I
 GhElFA/QUQ5KtELhde/0WIlliqHePwdFTKAIKw0QfFpLQHPcbZRiGHPdbr4x63tZgjjW
 8aXiy7M3e72yuPs3UYeFTHDfWcARpV16o9yIOIyuD5OR+i+0nS7GgN8mDruTUcPZ8yAw
 vPoxxcMmhE7KUI2Wk0IE8LSD4dHf6RCAalfcJnFGg3mWtfw15CpVIqfAP5Ky69/CxIhD ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f8qus66v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 13:44:19 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AHZ513104462;
        Mon, 10 May 2021 13:44:19 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f8qus66g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 13:44:19 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AHgtNP010006;
        Mon, 10 May 2021 17:44:18 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 38dj993yab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 17:44:18 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AHiHHu9044594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 17:44:17 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C42B112067;
        Mon, 10 May 2021 17:44:17 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 974CD112063;
        Mon, 10 May 2021 17:44:16 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.140.234])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 17:44:16 +0000 (GMT)
Subject: Re: [PATCH] s390/vfio-ap: fix memory leak in mdev remove callback
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, pasic@linux.vnet.ibm.com,
        jjherne@linux.ibm.com, jgg@nvidia.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, stable@vger.kernel.org,
        Tony Krowiak <akrowiak@stny.rr.com>
References: <20210505172826.105304-1-akrowiak@linux.ibm.com>
 <20210506122245.20f4ba21.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <51acc512-58a9-2e69-d759-4efbbea941a8@linux.ibm.com>
Date:   Mon, 10 May 2021 13:44:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506122245.20f4ba21.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _c3aXrRmM3pMHY8KU92bUmoJ4P6vCK2X
X-Proofpoint-GUID: 1id1d3qBMgKJJh4vpZR1_tRGALK-FkT9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_11:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100118
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/6/21 6:22 AM, Cornelia Huck wrote:
> On Wed,  5 May 2021 13:28:26 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The mdev remove callback for the vfio_ap device driver bails out with
>> -EBUSY if the mdev is in use by a KVM guest. The intended purpose was
>> to prevent the mdev from being removed while in use; however, returning a
>> non-zero rc does not prevent removal. This could result in a memory leak
>> of the resources allocated when the mdev was created. In addition, the
>> KVM guest will still have access to the AP devices assigned to the mdev
>> even though the mdev no longer exists.
>>
>> To prevent this scenario, cleanup will be done - including unplugging the
>> AP adapters, domains and control domains - regardless of whether the mdev
>> is in use by a KVM guest or not.
>>
>> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 39 +++++++++++++++++++++++--------
>>   1 file changed, 29 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index b2c7e10dfdcd..757166da947e 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -335,6 +335,32 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>>   	matrix->adm_max = info->apxa ? info->Nd : 15;
>>   }
>>   
>> +static bool vfio_ap_mdev_has_crycb(struct ap_matrix_mdev *matrix_mdev)
>> +{
>> +	return (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd);
>> +}
>> +
>> +static void vfio_ap_mdev_clear_apcb(struct ap_matrix_mdev *matrix_mdev)
>> +{
>> +	/*
>> +	 * If the KVM pointer is in the process of being set, wait until the
>> +	 * process has completed.
>> +	 */
>> +	wait_event_cmd(matrix_mdev->wait_for_kvm,
>> +		       !matrix_mdev->kvm_busy,
>> +		       mutex_unlock(&matrix_dev->lock),
>> +		       mutex_lock(&matrix_dev->lock));
>> +
>> +	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
>> +		matrix_mdev->kvm_busy = true;
>> +		mutex_unlock(&matrix_dev->lock);
>> +		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>> +		mutex_lock(&matrix_dev->lock);
>> +		matrix_mdev->kvm_busy = false;
>> +		wake_up_all(&matrix_mdev->wait_for_kvm);
>> +	}
>> +}
> Looking at vfio_ap_mdev_unset_kvm(), do you need to unhook the kvm here
> as well?
>
> (Or can you maybe even combine the two functions into one?)

I contemplated just calling the vfio_ap_unset_kvm() function from
the vfio_ap_mdev_remove() function, but my thinking at the time
was that some of the other things done in the unset function, such
as kvm_put_kvm() etc., might cause problems.
After thinking about it some more, the vfio_ap_mdev_remove()
function will not get called until the vfio_ap_mdev_release()
callback is invoked unless something weird happens. Since the
remove callback gets rid of the mdev and the release callback
calls the vfio_ap_unset_kvm() function anyway, I now see no harm
in just calling the unset function from the remove callback and
eliminating the function above.

>
>> +
>>   static int vfio_ap_mdev_create(struct mdev_device *mdev)
>>   {
>>   	struct ap_matrix_mdev *matrix_mdev;
>> @@ -366,16 +392,9 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
>>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>   
>>   	mutex_lock(&matrix_dev->lock);
>> -
>> -	/*
>> -	 * If the KVM pointer is in flux or the guest is running, disallow
>> -	 * un-assignment of control domain.
>> -	 */
>> -	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
>> -		mutex_unlock(&matrix_dev->lock);
>> -		return -EBUSY;
>> -	}
>> -
>> +	WARN(vfio_ap_mdev_has_crycb(matrix_mdev),
>> +	     "Removing mdev leaves KVM guest without any crypto devices");
>> +	vfio_ap_mdev_clear_apcb(matrix_mdev);
>>   	vfio_ap_mdev_reset_queues(mdev);
>>   	list_del(&matrix_mdev->node);
>>   	kfree(matrix_mdev);


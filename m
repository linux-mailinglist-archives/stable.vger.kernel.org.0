Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F4A37F9BB
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 16:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbhEMOgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 10:36:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234523AbhEMOgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 10:36:21 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14DEX7Gc087417;
        Thu, 13 May 2021 10:35:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iSwoY2YWZNHhRVQgEZKA16BxLx3zkF5Ug4Bu/fju4tI=;
 b=S92tX9M4VFpAUSQZ3czHoECoTGAfLXDFlKphattRoc3V2Y2iuxyjCb6gsRi+OCFjBzJx
 KDoBL9DFDfCUu6XbY1sTi91YQwyfRb3DBUimB+Kvb5pf7qdGDBm7RyjnM7nNzjv0CAYN
 yjLAKNHVO4a/yNGO9KdMVtExei8YcA06NK+6eSJY//tgKf626HylnuwVkIpDiPtihCLh
 H/cRqlyB5MFIsDsXbC4MA6TV4HOvZqe9LsR6Nf363tJeh4V8A3k0XzqrVf5mToOTWMLI
 3b0KUMYURyvgHWr8ixjwHkEc+aOqGTUyG9nhFOZCUEnB7pgZLILqqr2/W7XR5s6mDzyF DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38h5a99bb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 10:35:09 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14DEXG1l088341;
        Thu, 13 May 2021 10:35:08 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38h5a99b9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 10:35:08 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14DEWIO4016419;
        Thu, 13 May 2021 14:35:07 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 38dj9a6uhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 14:35:07 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14DEZ6NC21758216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 14:35:06 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6697EAC067;
        Thu, 13 May 2021 14:35:06 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01D4EAC064;
        Thu, 13 May 2021 14:35:05 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.177.219])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 13 May 2021 14:35:05 +0000 (GMT)
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com, jgg@nvidia.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
 <20210512203536.4209c29c.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <4c156ab8-da49-4867-f29c-9712c2628d44@linux.ibm.com>
Date:   Thu, 13 May 2021 10:35:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210512203536.4209c29c.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -159Wt7lHllEYWqs8GaGA4Vt71HMrREC
X-Proofpoint-ORIG-GUID: Z_kVIkLBkVmX9T0QYqRB53St-e7ogXUA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-13_06:2021-05-12,2021-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130108
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/12/21 2:35 PM, Halil Pasic wrote:
> On Mon, 10 May 2021 17:48:37 -0400
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
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 13 ++-----------
>>   1 file changed, 2 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index b2c7e10dfdcd..f90c9103dac2 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -26,6 +26,7 @@
>>
>>   static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>>   static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>> +static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev);
>>
>>   static int match_apqn(struct device *dev, const void *data)
>>   {
>> @@ -366,17 +367,7 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
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
>> -	vfio_ap_mdev_reset_queues(mdev);
>> +	vfio_ap_mdev_unset_kvm(matrix_mdev);
>>   	list_del(&matrix_mdev->node);
>>   	kfree(matrix_mdev);
> Are we at risk of handle_pqap() in arch/s390/kvm/priv.c using an
> already freed pqap_hook (which is a member of the matrix_mdev pointee
> that is freed just above my comment).
>
> I'm aware of the fact that vfio_ap_mdev_unset_kvm() does a
> matrix_mdev->kvm->arch.crypto.pqap_hook = NULL but that is
> AFRICT not done under any lock relevant for handle_pqap(). I guess
> the idea is, I guess, the check cited below
>
> static int handle_pqap(struct kvm_vcpu *vcpu)
> [..]
>          /*
>           * Verify that the hook callback is registered, lock the owner
>           * and call the hook.
>           */
>          if (vcpu->kvm->arch.crypto.pqap_hook) {
>                  if (!try_module_get(vcpu->kvm->arch.crypto.pqap_hook->owner))
>                          return -EOPNOTSUPP;
>                  ret = vcpu->kvm->arch.crypto.pqap_hook->hook(vcpu);
>                  module_put(vcpu->kvm->arch.crypto.pqap_hook->owner);
>                  if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)
>                          kvm_s390_set_psw_cc(vcpu, 3);
>                  return ret;
>          }
>
> is going to catch it, but I'm not sure it is guaranteed to catch it.
> Opinions?

The hook itself - handle_pqap() function in vfio_ap_ops.c - also checks
to see if the reference to the hook is set and terminates with an error 
if it
is not. If the hook is invoked subsequent to the remove callback above,
all should be fine since the check is also done under the matrix_dev->lock.

>
> Regards,
> Halil
>
>
>>   	mdev_set_drvdata(mdev, NULL);


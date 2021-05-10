Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C991379549
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 19:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhEJRXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 13:23:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6184 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232296AbhEJRXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 13:23:16 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AHDgqd144288;
        Mon, 10 May 2021 13:22:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XkhLN/aUiRbMi4S98i2Vo6Fs5eJk3vJleHFVFpeRNPs=;
 b=Xx81k4K8RvaR/QbS1+j9M6bkEyV96wXKmDsun59ZBTdElP6T6bH9mJXyuWsFokrydpaW
 7cGQ/NjS6fS6b861mWXNeV9yj4ZoOCHeg7kGtvcZm/NEduaY50LBj/T3DArSYy/vM+3d
 aJCZpH9l9JJa+JMkHGNfn//6CDztHakcEW82UIlCam7T/gfiDOvgPt3V3uu75vZg8TiD
 /KNInrLzrw/XnwZnULyKId8aYbKnO0q11STbGUmrIkRTdoFYBqYgJfv4WyFQ+wbla+rc
 JaZxZqqIn65y2FQlOW8L743A+Uny8kH4dzJO+9ud/gahfTMrOgUD9V2SdKrLKt5aNDKv VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38f91s86yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 13:22:09 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AHFYNK149181;
        Mon, 10 May 2021 13:22:08 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38f91s86y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 13:22:08 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AHLoaK019739;
        Mon, 10 May 2021 17:22:08 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 38dj997wr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 17:22:08 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AHM7jZ13631938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 17:22:07 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95BE711207A;
        Mon, 10 May 2021 17:22:07 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECC2411207B;
        Mon, 10 May 2021 17:22:06 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.140.234])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 17:22:06 +0000 (GMT)
Subject: Re: [PATCH] s390/vfio-ap: fix memory leak in mdev remove callback
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     cohuck@redhat.com, pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        jgg@nvidia.com, alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
References: <20210505172826.105304-1-akrowiak@linux.ibm.com>
 <7b20afce-5782-53c6-beab-ae852ae69b40@de.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <509218be-9564-7b25-9d56-cab752abdaa4@linux.ibm.com>
Date:   Mon, 10 May 2021 13:22:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <7b20afce-5782-53c6-beab-ae852ae69b40@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uGsoq002xb1glzrQiijkEZqqPFEZxlma
X-Proofpoint-GUID: JffRP5eTMs3o21UYgQQ0zNevo5b5odWT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_11:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 clxscore=1015 spamscore=0 mlxlogscore=854
 bulkscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100114
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/5/21 1:44 PM, Christian Borntraeger wrote:
>
>
> On 05.05.21 19:28, Tony Krowiak wrote:
>> The mdev remove callback for the vfio_ap device driver bails out with
>> -EBUSY if the mdev is in use by a KVM guest. The intended purpose was
>> to prevent the mdev from being removed while in use; however, 
>> returning a
>> non-zero rc does not prevent removal. This could result in a memory leak
>> of the resources allocated when the mdev was created. In addition, the
>> KVM guest will still have access to the AP devices assigned to the mdev
>> even though the mdev no longer exists.
>>
>> To prevent this scenario, cleanup will be done - including unplugging 
>> the
>> AP adapters, domains and control domains - regardless of whether the 
>> mdev
>> is in use by a KVM guest or not.
> [...]
>>   static int vfio_ap_mdev_create(struct mdev_device *mdev)
>>   {
>>       struct ap_matrix_mdev *matrix_mdev;
>> @@ -366,16 +392,9 @@ static int vfio_ap_mdev_remove(struct 
>> mdev_device *mdev)
>>       struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>         mutex_lock(&matrix_dev->lock);
>> -
>> -    /*
>> -     * If the KVM pointer is in flux or the guest is running, disallow
>> -     * un-assignment of control domain.
>> -     */
>> -    if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
>> -        mutex_unlock(&matrix_dev->lock);
>> -        return -EBUSY;
>> -    }
>> -
>> +    WARN(vfio_ap_mdev_has_crycb(matrix_mdev),
>> +         "Removing mdev leaves KVM guest without any crypto devices");
>> +    vfio_ap_mdev_clear_apcb(matrix_mdev);
>
> Triggering a kernel warning due to an administrative task is not good.
> Can't you simply clear the crycb? Maybe do a printk, but not a WARN.

I'll take the warning out.

>
>>       vfio_ap_mdev_reset_queues(mdev);
>>       list_del(&matrix_mdev->node);
>>       kfree(matrix_mdev);
>>


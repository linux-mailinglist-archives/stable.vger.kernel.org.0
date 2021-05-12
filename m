Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958D037CEC6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239352AbhELRGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:06:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44644 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244523AbhELQup (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 12:50:45 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14CGYg9a113720;
        Wed, 12 May 2021 12:49:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KSAPkTFz0r19hIytJwB2GjWjANMg1ISP7wajH462VWA=;
 b=SCnvg4TzkmQ+6uonPhlUCMX2jlUBfaJtwZmlYzwC2wX0p+U0Z2OLbEu2MUHoyOYFLUr+
 M4csxtkb+tVO/Bg0+w949USefX/9XoEivq0kRt5zruhT2n2ASi9AUumg9kAHHJrrX6PA
 wT/MnSGbh8HLl3Y5hASke3Z30ezwGmt4KyLeVZZiL+jG9AjgiTqEthXrfovbjB6L0w+E
 m7WW/HvK5TzWrM5RO/PLGCI4PwK+DRPZMV3gCPyaN2qBZwF4ljpKV00M6T+6M7gLZzMS
 +xXCm4y7S55ewRUKBUwAjhiIrEVX/F8wgXfkiX8D2FQmaHF8tKKu9Jvn8tD+J1VkwjWp fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38ghy2hrfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 12:49:29 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14CGZ9MI115877;
        Wed, 12 May 2021 12:49:29 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38ghy2hret-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 12:49:29 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14CGnJ4F021355;
        Wed, 12 May 2021 16:49:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 38dj98aade-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 16:49:27 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14CGnO4D45023548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 16:49:24 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86AFC42372;
        Wed, 12 May 2021 16:49:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB68842373;
        Wed, 12 May 2021 16:49:23 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.73.206])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 May 2021 16:49:23 +0000 (GMT)
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     cohuck@redhat.com, pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        jgg@nvidia.com, alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <834f95f8-c1ca-17da-b709-69d5c55e8fcd@de.ibm.com>
Date:   Wed, 12 May 2021 18:49:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210510214837.359717-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XmYRU7UqZaQFb980xrp-qzfwD8aYDKXH
X-Proofpoint-ORIG-GUID: bort9dkKKEBHY1AtuudoK0dv5_liwnku
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-12_09:2021-05-12,2021-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105120105
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.05.21 23:48, Tony Krowiak wrote:
> The mdev remove callback for the vfio_ap device driver bails out with
> -EBUSY if the mdev is in use by a KVM guest. The intended purpose was
> to prevent the mdev from being removed while in use; however, returning a
> non-zero rc does not prevent removal. This could result in a memory leak
> of the resources allocated when the mdev was created. In addition, the
> KVM guest will still have access to the AP devices assigned to the mdev
> even though the mdev no longer exists.
> 
> To prevent this scenario, cleanup will be done - including unplugging the
> AP adapters, domains and control domains - regardless of whether the mdev
> is in use by a KVM guest or not.
> 
> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>

applied to the internal s390 tree. Lets give it some days of testing coverage of
CI and others.

Vasily, can you add this for the s390/fixes branch early next week if nothing
goes wrong?

> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 13 ++-----------
>   1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index b2c7e10dfdcd..f90c9103dac2 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -26,6 +26,7 @@
>   
>   static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>   static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
> +static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev);
>   
>   static int match_apqn(struct device *dev, const void *data)
>   {
> @@ -366,17 +367,7 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>   
>   	mutex_lock(&matrix_dev->lock);
> -
> -	/*
> -	 * If the KVM pointer is in flux or the guest is running, disallow
> -	 * un-assignment of control domain.
> -	 */
> -	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
> -		mutex_unlock(&matrix_dev->lock);
> -		return -EBUSY;
> -	}
> -
> -	vfio_ap_mdev_reset_queues(mdev);
> +	vfio_ap_mdev_unset_kvm(matrix_mdev);
>   	list_del(&matrix_mdev->node);
>   	kfree(matrix_mdev);
>   	mdev_set_drvdata(mdev, NULL);
> 

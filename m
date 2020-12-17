Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2562DCA12
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 01:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgLQAj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 19:39:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30370 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727123AbgLQAj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 19:39:58 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BH0Wdsg023948;
        Wed, 16 Dec 2020 19:39:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nDQtUXaiie9KSzxBEHKUAZ1YWKsyM8GQpyLFa12KJ5s=;
 b=p8ioIYisxb9LEW00kqqJJ+992VxlJyV/m9PEdHcw5vLrZLyjlPsnvHH1rfhk4tK4Tarl
 E+hNiHQkO3JqtV0o/odQRF2kBXYt6WvY2Ccj8U+T4J5b5hWyFsA3cLSFWfshES8au1hl
 O+lIbNyNUJjzZwm6uYj8TmeTWAdOcJIvF2iQOgMIgWGuPevxDlG2rSk2jpwhw0QzlMIN
 0y74GWxaBk0G94Qpmt3eO2S+smpHJ3tzxDWhJGE76WqufF8TnOH415v8p+xqCaslT2gj
 6xGfQ6gGhOp28C1iVpL9Yv7E7MavTCAEXuE3dhrXxCq2DL/LcWnQG7cQuJFjsNyp/rDr Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ftvvb3r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 19:39:14 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BH0Wr6E025243;
        Wed, 16 Dec 2020 19:39:13 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ftvvb3qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 19:39:13 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BH0bLrQ022424;
        Thu, 17 Dec 2020 00:39:12 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 35cng9mnwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 00:39:12 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BH0dBm421430632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 00:39:11 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8483ABE053;
        Thu, 17 Dec 2020 00:39:11 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 511A4BE04F;
        Thu, 17 Dec 2020 00:39:10 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 17 Dec 2020 00:39:10 +0000 (GMT)
Subject: Re: [PATCH v3] s390/vfio-ap: clean up vfio_ap resources when KVM
 pointer invalidated
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
References: <20201214165617.28685-1-akrowiak@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <7732abbb-ded8-e17e-858b-e79737bba8a6@linux.ibm.com>
Date:   Wed, 16 Dec 2020 19:39:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201214165617.28685-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_12:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 spamscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160149
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/14/20 11:56 AM, Tony Krowiak wrote:
> The vfio_ap device driver registers a group notifier with VFIO when the
> file descriptor for a VFIO mediated device for a KVM guest is opened to
> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
> event). When the KVM pointer is set, the vfio_ap driver takes the
> following actions:
> 1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
>     of the mediated device.
> 2. Calls the kvm_get_kvm() function to increment its reference counter.
> 3. Sets the function pointer to the function that handles interception of
>     the instruction that enables/disables interrupt processing.
> 4. Sets the masks in the KVM guest's CRYCB to pass AP resources through to
>     the guest.
>
> In order to avoid memory leaks, when the notifier is called to receive
> notification that the KVM pointer has been set to NULL, the vfio_ap device
> driver should reverse the actions taken when the KVM pointer was set.
>
> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 29 ++++++++++++++++++++---------
>   1 file changed, 20 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e0bde8518745..cd22e85588e1 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1037,8 +1037,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>   {
>   	struct ap_matrix_mdev *m;
>   
> -	mutex_lock(&matrix_dev->lock);
> -
>   	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
>   		if ((m != matrix_mdev) && (m->kvm == kvm)) {
>   			mutex_unlock(&matrix_dev->lock);

This unlock needs to be removed.

> @@ -1049,7 +1047,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>   	matrix_mdev->kvm = kvm;
>   	kvm_get_kvm(kvm);
>   	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
> -	mutex_unlock(&matrix_dev->lock);
>   
>   	return 0;
>   }
> @@ -1083,35 +1080,49 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
>   	return NOTIFY_DONE;
>   }
>   
> +static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> +	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> +	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> +	kvm_put_kvm(matrix_mdev->kvm);
> +	matrix_mdev->kvm = NULL;
> +}
> +
>   static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>   				       unsigned long action, void *data)
>   {
> -	int ret;
> +	int ret, notify_rc = NOTIFY_DONE;
>   	struct ap_matrix_mdev *matrix_mdev;
>   
>   	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
>   		return NOTIFY_OK;
>   
>   	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
> +	mutex_lock(&matrix_dev->lock);
>   
>   	if (!data) {
> -		matrix_mdev->kvm = NULL;
> -		return NOTIFY_OK;
> +		if (matrix_mdev->kvm)
> +			vfio_ap_mdev_unset_kvm(matrix_mdev);
> +		notify_rc = NOTIFY_OK;
> +		goto notify_done;
>   	}
>   
>   	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
>   	if (ret)
> -		return NOTIFY_DONE;
> +		goto notify_done;
>   
>   	/* If there is no CRYCB pointer, then we can't copy the masks */
>   	if (!matrix_mdev->kvm->arch.crypto.crycbd)
> -		return NOTIFY_DONE;
> +		goto notify_done;
>   
>   	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
>   				  matrix_mdev->matrix.aqm,
>   				  matrix_mdev->matrix.adm);
>   
> -	return NOTIFY_OK;
> +notify_done:
> +	mutex_unlock(&matrix_dev->lock);
> +	return notify_rc;
>   }
>   
>   static void vfio_ap_irq_disable_apqn(int apqn)


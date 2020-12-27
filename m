Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A452E30E0
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 12:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgL0LNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 06:13:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12116 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726031AbgL0LNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Dec 2020 06:13:40 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BRB3E7G106285;
        Sun, 27 Dec 2020 06:12:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=q4ZewLYFBsYdDeRAXAb5Z8x1vNVz73uAhuR4FFYjGxc=;
 b=adtwf1+0/6cRaEVcrQAuezquAM+4Z9whNC1sdtFiR7lcJIS2qxdRjiOUPWRLvrcB1yxo
 KDwcOWxfFErzLg1Xg22ZPRxPqZA9+T2C4lMq9f4GvZZQKUmMz68/J+abUnk9Rxnbl/Yx
 fvaXiN4nNGLvHzm0RQ/EIAaR/naY3TKXkDVz5htuUm79ett/1E5fD264sSPV9u8gFVxL
 Tz9UylBgGeqcQIcKP6RCcVtjm4rh4WnbWxTd7bN/3MXH/1DjYj7T77K7Wmt3WqUaAQif
 4+OtcW8XqC5xZgu5VqeRlup+dFnyA/iElQYlvEmdzQWMPJC/dTJ0yiXPW4E5hD77cMpH Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35pqg2snmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Dec 2020 06:12:58 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BRB3Olx107172;
        Sun, 27 Dec 2020 06:12:58 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35pqg2snm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Dec 2020 06:12:58 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BRBCKHe028337;
        Sun, 27 Dec 2020 11:12:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 35nvt892j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Dec 2020 11:12:55 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BRBCqVC42139956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Dec 2020 11:12:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C40E24203F;
        Sun, 27 Dec 2020 11:12:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CBD542042;
        Sun, 27 Dec 2020 11:12:52 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.34.111])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 27 Dec 2020 11:12:52 +0000 (GMT)
Subject: Re: [PATCH v5] s390/vfio-ap: clean up vfio_ap resources when KVM
 pointer invalidated
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        Halil Pasic <pasic@linux.ibm.com>
References: <20201223012013.5418-1-akrowiak@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <e8339b80-2466-5dd1-195c-f59b4794528c@de.ibm.com>
Date:   Sun, 27 Dec 2020 12:12:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201223012013.5418-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-27_08:2020-12-24,2020-12-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 phishscore=0 suspectscore=0 mlxscore=0 impostorscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012270069
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 23.12.20 02:20, Tony Krowiak wrote:
> The vfio_ap device driver registers a group notifier with VFIO when the
> file descriptor for a VFIO mediated device for a KVM guest is opened to
> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
> event). When the KVM pointer is set, the vfio_ap driver takes the
> following actions:
> 1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
>    of the mediated device.
> 2. Calls the kvm_get_kvm() function to increment its reference counter.
> 3. Sets the function pointer to the function that handles interception of
>    the instruction that enables/disables interrupt processing.
> 4. Sets the masks in the KVM guest's CRYCB to pass AP resources through to
>    the guest.
> 
> In order to avoid memory leaks, when the notifier is called to receive
> notification that the KVM pointer has been set to NULL, the vfio_ap device
> driver should reverse the actions taken when the KVM pointer was set.
> 
> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

thanks, applied to the s390 tree.


> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 49 ++++++++++++++++++-------------
>  1 file changed, 28 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e0bde8518745..7339043906cf 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1037,19 +1037,14 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>  {
>  	struct ap_matrix_mdev *m;
>  
> -	mutex_lock(&matrix_dev->lock);
> -
>  	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
> -		if ((m != matrix_mdev) && (m->kvm == kvm)) {
> -			mutex_unlock(&matrix_dev->lock);
> +		if ((m != matrix_mdev) && (m->kvm == kvm))
>  			return -EPERM;
> -		}
>  	}
>  
>  	matrix_mdev->kvm = kvm;
>  	kvm_get_kvm(kvm);
>  	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
> -	mutex_unlock(&matrix_dev->lock);
>  
>  	return 0;
>  }
> @@ -1083,35 +1078,52 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
>  	return NOTIFY_DONE;
>  }
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
>  static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  				       unsigned long action, void *data)
>  {
> -	int ret;
> +	int ret, notify_rc = NOTIFY_OK;
>  	struct ap_matrix_mdev *matrix_mdev;
>  
>  	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
>  		return NOTIFY_OK;
>  
>  	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
> +	mutex_lock(&matrix_dev->lock);
>  
>  	if (!data) {
> -		matrix_mdev->kvm = NULL;
> -		return NOTIFY_OK;
> +		if (matrix_mdev->kvm)
> +			vfio_ap_mdev_unset_kvm(matrix_mdev);
> +		goto notify_done;
>  	}
>  
>  	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
> -	if (ret)
> -		return NOTIFY_DONE;
> +	if (ret) {
> +		notify_rc = NOTIFY_DONE;
> +		goto notify_done;
> +	}
>  
>  	/* If there is no CRYCB pointer, then we can't copy the masks */
> -	if (!matrix_mdev->kvm->arch.crypto.crycbd)
> -		return NOTIFY_DONE;
> +	if (!matrix_mdev->kvm->arch.crypto.crycbd) {
> +		notify_rc = NOTIFY_DONE;
> +		goto notify_done;
> +	}
>  
>  	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
>  				  matrix_mdev->matrix.aqm,
>  				  matrix_mdev->matrix.adm);
>  
> -	return NOTIFY_OK;
> +notify_done:
> +	mutex_unlock(&matrix_dev->lock);
> +	return notify_rc;
>  }
>  
>  static void vfio_ap_irq_disable_apqn(int apqn)
> @@ -1222,13 +1234,8 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
>  	mutex_lock(&matrix_dev->lock);
> -	if (matrix_mdev->kvm) {
> -		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> -		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> -		vfio_ap_mdev_reset_queues(mdev);
> -		kvm_put_kvm(matrix_mdev->kvm);
> -		matrix_mdev->kvm = NULL;
> -	}
> +	if (matrix_mdev->kvm)
> +		vfio_ap_mdev_unset_kvm(matrix_mdev);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> 

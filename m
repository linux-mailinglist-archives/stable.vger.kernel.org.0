Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B423B31A756
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 23:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhBLWNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 17:13:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24504 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229718AbhBLWNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 17:13:10 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11CM2soI077519
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 17:12:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0FR3EVCTCz0mVwykqKlS+R8NvzsY8a3kKWfok4+cCbo=;
 b=lFxuOwBb4vCbysbqTkwvy9+5rStbAh3aORYoYdc10P5K1j7lX+BddveNEgAC9HqYOCnz
 j3Y5gPG/EpeFo0kKB0/oqX8mYEXMdYihrm+ACS4HCulJyv6d2LVZaEwHGqvOl8NFo5/i
 w+ITnUngQMm9wG6cQ7cSHBf5J5hlMt3WphudrHNPWOEASos6lZDujtLYPE21SVm6r9VH
 V+DVNX4/FZYq/ZkM4ZMwBBGIC29ySdDPRq2omwODj1jp160bxWFXGcnKdOYKkXE57s4F
 //JqUozFyTrz88S3wJluCSzO1zu9CT2jCHWK7mtxkIwUq8xmG2H5oUAxjaGoWyA7QbF6 Tg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36p1tv8tkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 17:12:29 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11CM71f2011486
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 22:12:27 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 36m1m2u8fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 22:12:26 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11CMCOpJ36307226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 22:12:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEF7CA4055;
        Fri, 12 Feb 2021 22:12:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9153A4051;
        Fri, 12 Feb 2021 22:12:23 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.49.159])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 12 Feb 2021 22:12:23 +0000 (GMT)
Date:   Fri, 12 Feb 2021 23:12:20 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     pasic@linux.vnet.ibm.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210212231220.6191a56f.pasic@linux.ibm.com>
In-Reply-To: <20210212165746.29839-2-akrowiak@linux.ibm.com>
References: <20210212165746.29839-1-akrowiak@linux.ibm.com>
        <20210212165746.29839-2-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_09:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1011 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120159
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 12 Feb 2021 11:57:46 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> This patch fixes a circular locking dependency in the CI introduced by
> commit f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM
> pointer invalidated"). The lockdep only occurs when starting a Secure
> Execution guest. Crypto virtualization (vfio_ap) is not yet supported for
> SE guests; however, in order to avoid CI errors, this fix is being
> provided.
> 
> The circular lockdep was introduced when the masks in the guest's APCB
> were taken under the matrix_dev->lock. While the lock is definitely
> needed to protect the setting/unsetting of the KVM pointer, it is not
> necessarily critical for setting the masks, so this will not be done under
> protection of the matrix_dev->lock.
> 
> Fixes: f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 78 +++++++++++++++++++------------
>  1 file changed, 48 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 41fc2e4135fe..bba0f64aa1f7 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1028,7 +1028,10 @@ static const struct attribute_group *vfio_ap_mdev_attr_groups[] = {
>   * @kvm: reference to KVM instance
>   *
>   * Verifies no other mediated matrix device has @kvm and sets a reference to
> - * it in @matrix_mdev->kvm.
> + * it in @matrix_mdev->kvm. The matrix_dev->lock must be taken prior to calling
> + * this function; however, the lock will be temporarily released while updating
> + * the guest's APCB to avoid a potential circular lock dependency with other
> + * asynchronous processes.
>   *
>   * Return 0 if no other mediated matrix device has a reference to @kvm;
>   * otherwise, returns an -EPERM.
> @@ -1043,10 +1046,19 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>  			return -EPERM;
>  	}
> 
> -	matrix_mdev->kvm = kvm;
>  	kvm_get_kvm(kvm);
> +	matrix_mdev->kvm = kvm;
>  	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
> 
> +	if (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd) {
> +		mutex_unlock(&matrix_dev->lock);
> +		kvm_arch_crypto_set_masks(kvm,
> +					  matrix_mdev->matrix.apm,
> +					  matrix_mdev->matrix.aqm,
> +					  matrix_mdev->matrix.adm);

I think in theory kvm_arch_crypto_set_masks() and
kvm_arch_crypto_clear_masks() can happen in reverse order.

E.g. vfio_ap_mdev_set_kvm() runs till just before crypto_set_mask() but
there the thread gets preempted, then vfio_ap_mdev_unset_kvm() executes up to
and including crypto_clear_mask(), then the set_kvm() thread does
crypto_set_mask() and then the unset_kvm() thread runs the second
critical section.

Please notice that matrix_mdev->kvm is set before crypto_set_mask() is
called, so the unset_kvm() thread won't bail out, but it bailing out
wouldn't help, because we would still end up not doing the cleanup.

I have to tell you, I never understood our cleanup logic. And with
having to drop the lock, things are getting awfully convoluted.

Probably the easiest way to resolving this problem would have been
to route PQAP via QEMU. I think that is what Pierre did at some point,
but I was against it, because the extra mile seemed unnecessary, and
Christian agreed. Back then, I didn't know that the vcpu lock is taken
under the kvm lock.

What I'm trying to say. I'm willing to let an imperfect solution slip
here, because I don't have a perfect one. I didn't try hard to come up
with a perfect solution, but usually I don't have to try hard to see
what needs to be done.


I'm curious do you have a plan for dynamic. Because with dynamics
amplifies the problem, as crycb is changed in various situations.

> +		mutex_lock(&matrix_dev->lock);
> +	}
> +
>  	return 0;
>  }
> 
> @@ -1079,13 +1091,34 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
>  	return NOTIFY_DONE;
>  }
> 
> +/**
> + * vfio_ap_mdev_unset_kvm
> + *
> + * @matrix_mdev: a matrix mediated device
> + *
> + * Clears the masks in the guest's APCB as well as the reference to KVM from
> + * @matrix_mdev. The matrix_dev->lock must be taken prior to calling this
> + * function; however, the lock will be temporarily released while updating
> + * the guest's APCB to avoid a potential circular lock dependency with other
> + * asynchronous processes.
> + */
>  static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>  {
> -	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> -	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> -	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> -	kvm_put_kvm(matrix_mdev->kvm);
> -	matrix_mdev->kvm = NULL;
> +	struct kvm *kvm;
> +
> +	if (matrix_mdev->kvm) {
> +		kvm = matrix_mdev->kvm;
> +		kvm_get_kvm(kvm);
> +		kvm->arch.crypto.pqap_hook = NULL;

You moved setting the hook to NULL before clearing the mask. I can't tell
right now if it matters or not. What is the idea? I'm tired.

> +		mutex_unlock(&matrix_dev->lock);
> +		kvm_arch_crypto_clear_masks(kvm);
> +		mutex_lock(&matrix_dev->lock);
> +		kvm_put_kvm(kvm);
> +		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> +		if (matrix_mdev->kvm)
> +			kvm_put_kvm(matrix_mdev->kvm);
> +		matrix_mdev->kvm = NULL;
> +	}
>  }
> 
>  static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
> @@ -1097,33 +1130,19 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
>  		return NOTIFY_OK;
> 
> -	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
>  	mutex_lock(&matrix_dev->lock);
> +	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);

I'm not sure moving this inside the critical section buys us anything,
but I'm pretty sure it won't hurt either. What is the idea?

I guess, the only thing that matters is that matrix_mdev is still alive,
and since it is freed in vfio_ap_mdev_remove() with the lock not held I
can't see how this being protected by the lock will prevent problems.

> 
> -	if (!data) {
> -		if (matrix_mdev->kvm)
> -			vfio_ap_mdev_unset_kvm(matrix_mdev);
> -		goto notify_done;
> -	}
> -
> -	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
> -	if (ret) {
> -		notify_rc = NOTIFY_DONE;
> -		goto notify_done;
> -	}
> +	if (!data)
> +		vfio_ap_mdev_unset_kvm(matrix_mdev);
> +	else
> +		ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
> 
> -	/* If there is no CRYCB pointer, then we can't copy the masks */
> -	if (!matrix_mdev->kvm->arch.crypto.crycbd) {
> +	if (ret)

I think this is undefined behavior if !data, because ret is
uninitialized.

>  		notify_rc = NOTIFY_DONE;
> -		goto notify_done;
> -	}
> -
> -	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
> -				  matrix_mdev->matrix.aqm,
> -				  matrix_mdev->matrix.adm);
> 
> -notify_done:
>  	mutex_unlock(&matrix_dev->lock);
> +
>  	return notify_rc;
>  }
> 
> @@ -1258,8 +1277,7 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> 
>  	mutex_lock(&matrix_dev->lock);
> -	if (matrix_mdev->kvm)
> -		vfio_ap_mdev_unset_kvm(matrix_mdev);
> +	vfio_ap_mdev_unset_kvm(matrix_mdev);
>  	mutex_unlock(&matrix_dev->lock);
> 
>  	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591F0375238
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 12:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhEFKX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 06:23:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20498 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232936AbhEFKX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 06:23:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620296578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5iD+tjKV6hDgGKw77PGTUybnlAkb873omzNjbbs3y68=;
        b=IyMD7QnjMaX9KQP7Vzg0PJ86DeHSIhXp0WCIGD1emmvZ78Fhyh1zHf/xYflTAUFbOcVtXG
        pUdf6qJq/m4ls8IjGkvV1RztWisbGz9JJ8Lnck9/bRwkXpMZn2YvYtuui2iOnYQqmTgUJO
        OIEAQPXqk+S+lkhIMEiVKUljVUSBTws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-TUsZUqhPOAiG_fqF_bC7qg-1; Thu, 06 May 2021 06:22:56 -0400
X-MC-Unique: TUsZUqhPOAiG_fqF_bC7qg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9948A64167;
        Thu,  6 May 2021 10:22:54 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-111.ams2.redhat.com [10.36.113.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 624331064146;
        Thu,  6 May 2021 10:22:48 +0000 (UTC)
Date:   Thu, 6 May 2021 12:22:45 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, pasic@linux.vnet.ibm.com,
        jjherne@linux.ibm.com, jgg@nvidia.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, stable@vger.kernel.org,
        Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH] s390/vfio-ap: fix memory leak in mdev remove callback
Message-ID: <20210506122245.20f4ba21.cohuck@redhat.com>
In-Reply-To: <20210505172826.105304-1-akrowiak@linux.ibm.com>
References: <20210505172826.105304-1-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed,  5 May 2021 13:28:26 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

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
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 39 +++++++++++++++++++++++--------
>  1 file changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index b2c7e10dfdcd..757166da947e 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -335,6 +335,32 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>  	matrix->adm_max = info->apxa ? info->Nd : 15;
>  }
>  
> +static bool vfio_ap_mdev_has_crycb(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	return (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd);
> +}
> +
> +static void vfio_ap_mdev_clear_apcb(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	/*
> +	 * If the KVM pointer is in the process of being set, wait until the
> +	 * process has completed.
> +	 */
> +	wait_event_cmd(matrix_mdev->wait_for_kvm,
> +		       !matrix_mdev->kvm_busy,
> +		       mutex_unlock(&matrix_dev->lock),
> +		       mutex_lock(&matrix_dev->lock));
> +
> +	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
> +		matrix_mdev->kvm_busy = true;
> +		mutex_unlock(&matrix_dev->lock);
> +		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> +		mutex_lock(&matrix_dev->lock);
> +		matrix_mdev->kvm_busy = false;
> +		wake_up_all(&matrix_mdev->wait_for_kvm);
> +	}
> +}

Looking at vfio_ap_mdev_unset_kvm(), do you need to unhook the kvm here
as well?

(Or can you maybe even combine the two functions into one?)

> +
>  static int vfio_ap_mdev_create(struct mdev_device *mdev)
>  {
>  	struct ap_matrix_mdev *matrix_mdev;
> @@ -366,16 +392,9 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
>  	mutex_lock(&matrix_dev->lock);
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
> +	WARN(vfio_ap_mdev_has_crycb(matrix_mdev),
> +	     "Removing mdev leaves KVM guest without any crypto devices");
> +	vfio_ap_mdev_clear_apcb(matrix_mdev);
>  	vfio_ap_mdev_reset_queues(mdev);
>  	list_del(&matrix_mdev->node);
>  	kfree(matrix_mdev);


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C35316473
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 11:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhBJK60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 05:58:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229636AbhBJKzN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 05:55:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612954427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UEBDm7SunPwkF3BoWeRyw0Tj/EvMcHXNW6J7Hdf+1LU=;
        b=NQLRQZxwuJ00LcNeWfZcF3xwPNUPktoEwLY0JINvdw0N/KsYePSqR8Cca27+RUvM9PENtp
        3YA6wJ/xLGRybjqkVw1y3cumztRhCyYKKMsQLut6ShFVNe1D3JR5vOMZ8X15CIelrgS9iO
        ueKE2aR1DAVyS2uO2JNOtis0E3/d/tA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-FZDUxRX4OaKcuyzYEPpJlQ-1; Wed, 10 Feb 2021 05:53:43 -0500
X-MC-Unique: FZDUxRX4OaKcuyzYEPpJlQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B3D6107ACC7;
        Wed, 10 Feb 2021 10:53:42 +0000 (UTC)
Received: from gondolin (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0345C627DA;
        Wed, 10 Feb 2021 10:53:36 +0000 (UTC)
Date:   Wed, 10 Feb 2021 11:53:34 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
Subject: Re: [PATCH 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210210115334.46635966.cohuck@redhat.com>
In-Reply-To: <20210209194830.20271-2-akrowiak@linux.ibm.com>
References: <20210209194830.20271-1-akrowiak@linux.ibm.com>
        <20210209194830.20271-2-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue,  9 Feb 2021 14:48:30 -0500
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
>  drivers/s390/crypto/vfio_ap_ops.c | 75 ++++++++++++++++++-------------
>  1 file changed, 45 insertions(+), 30 deletions(-)
> 

>  static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>  {
> -	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> -	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> -	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> -	kvm_put_kvm(matrix_mdev->kvm);
> -	matrix_mdev->kvm = NULL;
> +	if (matrix_mdev->kvm) {

If you're doing setting/unsetting under matrix_dev->lock, is it
possible that matrix_mdev->kvm gets unset between here and the next
line, as you don't hold the lock?

Maybe you could
- grab a reference to kvm while holding the lock
- call the mask handling functions with that kvm reference
- lock again, drop the reference, and do the rest of the processing?

> +		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> +		mutex_lock(&matrix_dev->lock);
> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> +		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> +		kvm_put_kvm(matrix_mdev->kvm);
> +		matrix_mdev->kvm = NULL;
> +		mutex_unlock(&matrix_dev->lock);
> +	}
>  }


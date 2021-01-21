Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633CA2FE4D7
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 09:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbhAUIWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 03:22:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727047AbhAUIWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 03:22:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611217264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0gba4+t4e2AipgLr57aF/TlL6LFHCc9J8pUh2gVcris=;
        b=BcpzMVeXNkj07EDc1NvNPrD3UGpnPj81WtvN2iBHpA19n4MdLpJI/OVw7ui7dDu6z1DtiO
        PoL5f7PudjaFgrOe7B8Bz7gaFfASpfxO73CPY0n255ghgFZiPKKoU2XofmyxedY2Rrm3Wo
        ZnIio3scO5iB+X/vY2O0ZnXWo7vaMew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-RYrER6NZN9yxIYxlQV358g-1; Thu, 21 Jan 2021 03:20:59 -0500
X-MC-Unique: RYrER6NZN9yxIYxlQV358g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DEF310054FF;
        Thu, 21 Jan 2021 08:20:57 +0000 (UTC)
Received: from gondolin (ovpn-113-94.ams2.redhat.com [10.36.113.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 546B871C9A;
        Thu, 21 Jan 2021 08:20:47 +0000 (UTC)
Date:   Thu, 21 Jan 2021 09:20:44 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Pierre Morel <pmorel@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com
Subject: Re: [PATCH 1/1] s390/vfio-ap: No need to disable IRQ after queue
 reset
Message-ID: <20210121092044.628b77c7.cohuck@redhat.com>
In-Reply-To: <20210121072008.76523-1-pasic@linux.ibm.com>
References: <20210121072008.76523-1-pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 21 Jan 2021 08:20:08 +0100
Halil Pasic <pasic@linux.ibm.com> wrote:

> From: Tony Krowiak <akrowiak@linux.ibm.com>
> 
> The queues assigned to a matrix mediated device are currently reset when:
> 
> * The VFIO_DEVICE_RESET ioctl is invoked
> * The mdev fd is closed by userspace (QEMU)
> * The mdev is removed from sysfs.
> 
> Immediately after the reset of a queue, a call is made to disable
> interrupts for the queue. This is entirely unnecessary because the reset of
> a queue disables interrupts, so this will be removed.
> 
> Furthermore, vfio_ap_irq_disable() does an unconditional PQAP/AQIC which
> can result in a specification exception (when the corresponding facility
> is not available), so this is actually a bugfix.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> [pasic@linux.ibm.com: minor rework before merging]
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: ec89b55e3bce ("s390: ap: implement PAPQ AQIC interception in kernel")
> Cc: <stable@vger.kernel.org>
> 
> ---
> 
> Since it turned out disabling the interrupts via PQAP/AQIC is not only
> unnecesary but also buggy, we decided to put this patch, which
> used to be apart of the series https://lkml.org/lkml/2020/12/22/757 on the fast
> lane.
> 
> If the backports turn out to be a bother, which I hope won't be the case
> not, I am happy to help with those.
> 
> ---
>  drivers/s390/crypto/vfio_ap_drv.c     |   6 +-
>  drivers/s390/crypto/vfio_ap_ops.c     | 100 ++++++++++++++++----------
>  drivers/s390/crypto/vfio_ap_private.h |  12 ++--
>  3 files changed, 69 insertions(+), 49 deletions(-)
> 

(...)

> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index f46dde56b464..28e9d9989768 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -88,11 +88,6 @@ struct ap_matrix_mdev {
>  	struct mdev_device *mdev;
>  };
>  
> -extern int vfio_ap_mdev_register(void);
> -extern void vfio_ap_mdev_unregister(void);
> -int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> -			     unsigned int retry);
> -
>  struct vfio_ap_queue {
>  	struct ap_matrix_mdev *matrix_mdev;
>  	unsigned long saved_pfn;
> @@ -100,5 +95,10 @@ struct vfio_ap_queue {
>  #define VFIO_AP_ISC_INVALID 0xff
>  	unsigned char saved_isc;
>  };
> -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
> +
> +int vfio_ap_mdev_register(void);
> +void vfio_ap_mdev_unregister(void);

Nit: was moving these two necessary?

> +int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
> +			     unsigned int retry);
> +
>  #endif /* _VFIO_AP_PRIVATE_H_ */
> 
> base-commit: 9791581c049c10929e97098374dd1716a81fefcc

Anyway, if I didn't entangle myself in the various branches, this seems
sane.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


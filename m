Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9B531FA1A
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 14:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhBSNrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 08:47:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30784 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230194AbhBSNrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Feb 2021 08:47:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613742367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oDE8EGVP9c1Qbtjtup3fFBceglrA202LnWw25MLTf5g=;
        b=IgJuwAgXzmAuEaStDsS1TjmDpWdZZpL5WOCuDw+KgX4L9ywlVErKAfRn3c1ImAoViUX0ar
        t5zOwV4dQ8VMdhDVkNRZgxi0vDZCTWi7mxgLbfG7Fx8IALwIwedlxF3EclAFwX9GBjLE5q
        DgL7xsdr2i9sZ1+oR9tZ3SPLuG6/ytY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-JZrauFMCM1e2KTyxmYmZEg-1; Fri, 19 Feb 2021 08:46:03 -0500
X-MC-Unique: JZrauFMCM1e2KTyxmYmZEg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E5CF100A67A;
        Fri, 19 Feb 2021 13:46:02 +0000 (UTC)
Received: from gondolin (ovpn-113-92.ams2.redhat.com [10.36.113.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1C0B5D9C2;
        Fri, 19 Feb 2021 13:45:56 +0000 (UTC)
Date:   Fri, 19 Feb 2021 14:45:54 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v2 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210219144554.3857a034.cohuck@redhat.com>
In-Reply-To: <20210216011547.22277-2-akrowiak@linux.ibm.com>
References: <20210216011547.22277-1-akrowiak@linux.ibm.com>
        <20210216011547.22277-2-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Feb 2021 20:15:47 -0500
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
>  drivers/s390/crypto/vfio_ap_ops.c | 119 +++++++++++++++++++++---------
>  1 file changed, 84 insertions(+), 35 deletions(-)

I've been looking at the patch for a bit now and tried to follow down
the various paths; and while I think it's ok, I do not really have
enough confidence about that for a R-b. But have an

Acked-by: Cornelia Huck <cohuck@redhat.com>


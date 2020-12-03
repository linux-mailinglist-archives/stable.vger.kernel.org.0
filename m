Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2012CE31E
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 00:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgLCXvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 18:51:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726924AbgLCXvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 18:51:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607039389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YYMeh+MuWwsdI9rSYUGVMvNUpGwpQQJeqKMCOCtMEZk=;
        b=iQpym2zfuiknc2/QaiMhtMI+8qZernLppOIDjZ3+rK1gTfsXcuvpN934JNR8avWK7nsbXC
        NKEAT8igWmuP3qABhX1N+lYyTqQryXuuMrInj/zga8MNUMJYKynUX4ktdr6aJI/OkEcjut
        nKYN6c5cmI9J8Kzzz1p75Dvpw2EyxEA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-2FvD_kYzPku0JPEUnj37ow-1; Thu, 03 Dec 2020 18:49:48 -0500
X-MC-Unique: 2FvD_kYzPku0JPEUnj37ow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D7EA10054FF;
        Thu,  3 Dec 2020 23:49:47 +0000 (UTC)
Received: from w520.home (ovpn-112-10.phx2.redhat.com [10.3.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1A565C1CF;
        Thu,  3 Dec 2020 23:49:43 +0000 (UTC)
Date:   Thu, 3 Dec 2020 16:49:43 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, cohuck@redhat.com,
        xyjxie@linux.vnet.ibm.com
Subject: Re: [PATCH] vfio/pci: Move dummy_resources_list init in
 vfio_pci_probe()
Message-ID: <20201203164943.3b78c35d@w520.home>
In-Reply-To: <20201113175202.4500-1-eric.auger@redhat.com>
References: <20201113175202.4500-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 Nov 2020 18:52:02 +0100
Eric Auger <eric.auger@redhat.com> wrote:

> In case an error occurs in vfio_pci_enable() before the call to
> vfio_pci_probe_mmaps(), vfio_pci_disable() will  try to iterate
> on an uninitialized list and cause a kernel panic.
> 
> Lets move to the initialization to vfio_pci_probe() to fix the
> issue.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Fixes: 05f0c03fbac1 ("vfio-pci: Allow to mmap sub-page MMIO BARs if the mmio page is exclusive")
> CC: Stable <stable@vger.kernel.org> # v4.7+
> ---
>  drivers/vfio/pci/vfio_pci.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Thanks, Eric.  Applied to vfio next branch for v5.11.

Alex

> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index e6190173482c..47ebc5c49ca4 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -161,8 +161,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
>  	int i;
>  	struct vfio_pci_dummy_resource *dummy_res;
>  
> -	INIT_LIST_HEAD(&vdev->dummy_resources_list);
> -
>  	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
>  		int bar = i + PCI_STD_RESOURCES;
>  
> @@ -1966,6 +1964,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	mutex_init(&vdev->igate);
>  	spin_lock_init(&vdev->irqlock);
>  	mutex_init(&vdev->ioeventfds_lock);
> +	INIT_LIST_HEAD(&vdev->dummy_resources_list);
>  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
>  	mutex_init(&vdev->vma_lock);
>  	INIT_LIST_HEAD(&vdev->vma_list);


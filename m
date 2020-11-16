Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AF22B3F9D
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 10:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgKPJUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 04:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgKPJUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 04:20:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBA4C0613CF;
        Mon, 16 Nov 2020 01:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l8lfZbtE/pQjKf8onWmpmDV2l9aNdEWCmZpm7QvhYhY=; b=WkZ4jWMSdM5oVJJ1+WT3a3ZKKw
        ZZd1qF3sOIRHnvODVySNJ0v9EmHjoNO5yHaKM+wxcmtRkp5tJ6xiiB8Ctp1jjq8rslJxEymNdglBP
        WaFi7AkglyXM9KtL/4HrR9B5G+5BQ75Ca2H2+eAB0Ix10CEsGgslpuPr0Rg7qjGinrOj5y54IbHAN
        9FmoqLypVkD5Dhx8lUSPxSBmHILF+SaNpwq/Q65nYk/fgyW3FvfidjnMzoaUIizFMe91Bmcx7vR4Z
        ike0qgFGPKS9fCN4ccNutbHYobwd2qe4CNXw7EBccw7LtABW6AD+J/p72yv57FL350vVm0OyurNam
        snYUw6lg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1keafu-00087a-31; Mon, 16 Nov 2020 09:19:50 +0000
Date:   Mon, 16 Nov 2020 09:19:50 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Suman Anna <s-anna@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH virtio] virtio: virtio_console: fix DMA memory allocation
 for rproc serial
Message-ID: <20201116091950.GA30524@infradead.org>
References: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I just noticed this showing up in Linus' tree and I'm not happy.

This whole model of the DMA subdevices in remoteproc is simply broken.

We really need to change the virtio code pass an expicit DMA device (
similar to what e.g. the USB and RDMA code does), instead of faking up
devices with broken adhoc inheritance of DMA properties and magic poking
into device parent relationships.

Bjorn, I thought you were going to look into this a while ago?


On Wed, Nov 04, 2020 at 03:31:36PM +0000, Alexander Lobakin wrote:
> Since commit 086d08725d34 ("remoteproc: create vdev subdevice with
> specific dma memory pool"), every remoteproc has a DMA subdevice
> ("remoteprocX#vdevYbuffer") for each virtio device, which inherits
> DMA capabilities from the corresponding platform device. This allowed
> to associate different DMA pools with each vdev, and required from
> virtio drivers to perform DMA operations with the parent device
> (vdev->dev.parent) instead of grandparent (vdev->dev.parent->parent).
> 
> virtio_rpmsg_bus was already changed in the same merge cycle with
> commit d999b622fcfb ("rpmsg: virtio: allocate buffer from parent"),
> but virtio_console did not. In fact, operations using the grandparent
> worked fine while the grandparent was the platform device, but since
> commit c774ad010873 ("remoteproc: Fix and restore the parenting
> hierarchy for vdev") this was changed, and now the grandparent device
> is the remoteproc device without any DMA capabilities.
> So, starting v5.8-rc1 the following warning is observed:
> 
> [    2.483925] ------------[ cut here ]------------
> [    2.489148] WARNING: CPU: 3 PID: 101 at kernel/dma/mapping.c:427 0x80e7eee8
> [    2.489152] Modules linked in: virtio_console(+)
> [    2.503737]  virtio_rpmsg_bus rpmsg_core
> [    2.508903]
> [    2.528898] <Other modules, stack and call trace here>
> [    2.913043]
> [    2.914907] ---[ end trace 93ac8746beab612c ]---
> [    2.920102] virtio-ports vport1p0: Error allocating inbufs
> 
> kernel/dma/mapping.c:427 is:
> 
> WARN_ON_ONCE(!dev->coherent_dma_mask);
> 
> obviously because the grandparent now is remoteproc dev without any
> DMA caps:
> 
> [    3.104943] Parent: remoteproc0#vdev1buffer, grandparent: remoteproc0
> 
> Fix this the same way as it was for virtio_rpmsg_bus, using just the
> parent device (vdev->dev.parent, "remoteprocX#vdevYbuffer") for DMA
> operations.
> This also allows now to reserve DMA pools/buffers for rproc serial
> via Device Tree.
> 
> Fixes: c774ad010873 ("remoteproc: Fix and restore the parenting hierarchy for vdev")
> Cc: stable@vger.kernel.org # 5.1+
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  drivers/char/virtio_console.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index a2da8f768b94..1836cc56e357 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -435,12 +435,12 @@ static struct port_buffer *alloc_buf(struct virtio_device *vdev, size_t buf_size
>  		/*
>  		 * Allocate DMA memory from ancestor. When a virtio
>  		 * device is created by remoteproc, the DMA memory is
> -		 * associated with the grandparent device:
> -		 * vdev => rproc => platform-dev.
> +		 * associated with the parent device:
> +		 * virtioY => remoteprocX#vdevYbuffer.
>  		 */
> -		if (!vdev->dev.parent || !vdev->dev.parent->parent)
> +		buf->dev = vdev->dev.parent;
> +		if (!buf->dev)
>  			goto free_buf;
> -		buf->dev = vdev->dev.parent->parent;
>  
>  		/* Increase device refcnt to avoid freeing it */
>  		get_device(buf->dev);
> -- 
> 2.29.2
> 
> 
---end quoted text---

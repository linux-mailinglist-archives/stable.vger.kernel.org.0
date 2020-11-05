Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14062A75F3
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 04:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387749AbgKEDKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 22:10:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388496AbgKEDKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 22:10:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604545842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+u0ac9KHv5wcKAFb5ZDCdLBF5wpiQCLC3Skb+q8JnJI=;
        b=VA4pe7o+5Venfs9l53pM22AMBLOnaZUo3A30nQhTE7a0aAf7iSo6xpU8O/KaoMIuFUgarr
        eYL3Tu45gwKqZBo1/yIicwYC+0oHUygwPVIj2ieAdmEc1cK7zSNSu0nv/xlcz2PYLQiWbG
        69TWU/DyK5PcDO68UCwXsWdWiT7kmiw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-yd3NH94MMTu1ekabTjB6KQ-1; Wed, 04 Nov 2020 22:10:40 -0500
X-MC-Unique: yd3NH94MMTu1ekabTjB6KQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 940321007469;
        Thu,  5 Nov 2020 03:10:38 +0000 (UTC)
Received: from [10.72.13.154] (ovpn-13-154.pek2.redhat.com [10.72.13.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D783C5B4DC;
        Thu,  5 Nov 2020 03:10:25 +0000 (UTC)
Subject: Re: [PATCH virtio] virtio: virtio_console: fix DMA memory allocation
 for rproc serial
To:     Alexander Lobakin <alobakin@pm.me>, Amit Shah <amit@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Suman Anna <s-anna@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <004da56d-aad2-3b69-3428-02a14263289b@redhat.com>
Date:   Thu, 5 Nov 2020 11:10:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2020/11/4 下午11:31, Alexander Lobakin wrote:
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
>   drivers/char/virtio_console.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index a2da8f768b94..1836cc56e357 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -435,12 +435,12 @@ static struct port_buffer *alloc_buf(struct virtio_device *vdev, size_t buf_size
>   		/*
>   		 * Allocate DMA memory from ancestor. When a virtio
>   		 * device is created by remoteproc, the DMA memory is
> -		 * associated with the grandparent device:
> -		 * vdev => rproc => platform-dev.
> +		 * associated with the parent device:
> +		 * virtioY => remoteprocX#vdevYbuffer.
>   		 */
> -		if (!vdev->dev.parent || !vdev->dev.parent->parent)
> +		buf->dev = vdev->dev.parent;
> +		if (!buf->dev)
>   			goto free_buf;
> -		buf->dev = vdev->dev.parent->parent;


I wonder it could be the right time to introduce dma_dev for virtio 
instead of depending on something magic via parent.

(Btw I don't even notice that there's transport specific code in virtio 
console, it's better to avoid it)

Thanks


>   
>   		/* Increase device refcnt to avoid freeing it */
>   		get_device(buf->dev);


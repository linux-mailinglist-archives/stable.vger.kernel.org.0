Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8AB4110090
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 15:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfLCOq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 09:46:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52120 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfLCOq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 09:46:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Mime-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Df/63bTiz0MbvffoTq5LGNY0f3lhFWeKO2rB4GEICME=; b=PWrO0iJZ5Jov8iCg1pPsVunCpH
        VKIXG5NVaIwAyuk9qs+FtWWaqb8GHI5HIot4d4zS3l6ToeM4RJ9C9bKwkp4Bq7bScIXW/DnbH4CAM
        yX7WpR5Rv2X15OcVcVeilludvtzlx7C2WNs1b9A/WXTpW2K1+4qASeNrpmeCIvfBnuzi3prBumKoL
        1d43Blr5eVn4L+04HYdlwEE6sDS2n1DiK04Ik3SKuX7a2ZpX7F3YDx9RfxvPzwchv65B5056Jwzg9
        0mGFcU35sYGU5ydUEAQ4yMoYJV8mpZDrykj1RVEwaTNPitrVywJ5mMupy42gvs6mZnOLLA784MBjp
        lfjSKxTw==;
Received: from [54.239.6.185] (helo=u0c626add9cce5a.ant.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ic9S1-0000q1-9o; Tue, 03 Dec 2019 14:46:53 +0000
Message-ID: <ae3451423c18f2e408245d745d1f28e311a2845c.camel@infradead.org>
Subject: Re: [PATCH v3] virtio_console: allocate inbufs in add_port() only
 if it is needed
From:   Amit Shah <amit@infradead.org>
To:     Laurent Vivier <lvivier@redhat.com>, linux-kernel@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Amit Shah <amit@kernel.org>
Date:   Tue, 03 Dec 2019 15:46:50 +0100
In-Reply-To: <20191114122548.24364-1-lvivier@redhat.com>
References: <20191114122548.24364-1-lvivier@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-11-14 at 13:25 +0100, Laurent Vivier wrote:
> When we hot unplug a virtserialport and then try to hot plug again,
> it fails:
> 
> (qemu) chardev-add socket,id=serial0,path=/tmp/serial0,server,nowait
> (qemu) device_add virtserialport,bus=virtio-serial0.0,nr=2,\
>                   chardev=serial0,id=serial0,name=serial0
> (qemu) device_del serial0
> (qemu) device_add virtserialport,bus=virtio-serial0.0,nr=2,\
>                   chardev=serial0,id=serial0,name=serial0
> kernel error:
>   virtio-ports vport2p2: Error allocating inbufs
> qemu error:
>   virtio-serial-bus: Guest failure in adding port 2 for device \
>                      virtio-serial0.0
> 
> This happens because buffers for the in_vq are allocated when the
> port is
> added but are not released when the port is unplugged.
> 
> They are only released when virtconsole is removed (see a7a69ec0d8e4)
> 
> To avoid the problem and to be symmetric, we could allocate all the
> buffers
> in init_vqs() as they are released in remove_vqs(), but it sounds
> like
> a waste of memory.
> 
> Rather than that, this patch changes add_port() logic to ignore
> ENOSPC
> error in fill_queue(), which means queue has already been filled.
> 
> Fixes: a7a69ec0d8e4 ("virtio_console: free buffers after reset")
> Cc: mst@redhat.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>

Reviewed-by: Amit Shah <amit@kernel.org>

Thanks!

> ---
> 
> Notes:
>     v3: add a comment about ENOSPC error
>     v2: making fill_queue return int and testing return code for
> -ENOSPC
> 
>  drivers/char/virtio_console.c | 28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/char/virtio_console.c
> b/drivers/char/virtio_console.c
> index 7270e7b69262..3259426f01dc 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -1325,24 +1325,24 @@ static void set_console_size(struct port
> *port, u16 rows, u16 cols)
>  	port->cons.ws.ws_col = cols;
>  }
>  
> -static unsigned int fill_queue(struct virtqueue *vq, spinlock_t
> *lock)
> +static int fill_queue(struct virtqueue *vq, spinlock_t *lock)
>  {
>  	struct port_buffer *buf;
> -	unsigned int nr_added_bufs;
> +	int nr_added_bufs;
>  	int ret;
>  
>  	nr_added_bufs = 0;
>  	do {
>  		buf = alloc_buf(vq->vdev, PAGE_SIZE, 0);
>  		if (!buf)
> -			break;
> +			return -ENOMEM;
>  
>  		spin_lock_irq(lock);
>  		ret = add_inbuf(vq, buf);
>  		if (ret < 0) {
>  			spin_unlock_irq(lock);
>  			free_buf(buf, true);
> -			break;
> +			return ret;
>  		}
>  		nr_added_bufs++;
>  		spin_unlock_irq(lock);
> @@ -1362,7 +1362,6 @@ static int add_port(struct ports_device
> *portdev, u32 id)
>  	char debugfs_name[16];
>  	struct port *port;
>  	dev_t devt;
> -	unsigned int nr_added_bufs;
>  	int err;
>  
>  	port = kmalloc(sizeof(*port), GFP_KERNEL);
> @@ -1421,11 +1420,13 @@ static int add_port(struct ports_device
> *portdev, u32 id)
>  	spin_lock_init(&port->outvq_lock);
>  	init_waitqueue_head(&port->waitqueue);
>  
> -	/* Fill the in_vq with buffers so the host can send us data. */
> -	nr_added_bufs = fill_queue(port->in_vq, &port->inbuf_lock);
> -	if (!nr_added_bufs) {
> +	/* We can safely ignore ENOSPC because it means
> +	 * the queue already has buffers. Buffers are removed
> +	 * only by virtcons_remove(), not by unplug_port()
> +	 */
> +	err = fill_queue(port->in_vq, &port->inbuf_lock);
> +	if (err < 0 && err != -ENOSPC) {
>  		dev_err(port->dev, "Error allocating inbufs\n");
> -		err = -ENOMEM;
>  		goto free_device;
>  	}
>  
> @@ -2059,14 +2060,11 @@ static int virtcons_probe(struct
> virtio_device *vdev)
>  	INIT_WORK(&portdev->control_work, &control_work_handler);
>  
>  	if (multiport) {
> -		unsigned int nr_added_bufs;
> -
>  		spin_lock_init(&portdev->c_ivq_lock);
>  		spin_lock_init(&portdev->c_ovq_lock);
>  
> -		nr_added_bufs = fill_queue(portdev->c_ivq,
> -					   &portdev->c_ivq_lock);
> -		if (!nr_added_bufs) {
> +		err = fill_queue(portdev->c_ivq, &portdev->c_ivq_lock);
> +		if (err < 0) {
>  			dev_err(&vdev->dev,
>  				"Error allocating buffers for control
> queue\n");
>  			/*
> @@ -2077,7 +2075,7 @@ static int virtcons_probe(struct virtio_device
> *vdev)
>  					   VIRTIO_CONSOLE_DEVICE_READY,
> 0);
>  			/* Device was functional: we need full cleanup.
> */
>  			virtcons_remove(vdev);
> -			return -ENOMEM;
> +			return err;
>  		}
>  	} else {
>  		/*


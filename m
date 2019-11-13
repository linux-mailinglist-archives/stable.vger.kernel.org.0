Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C02AAFB393
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 16:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfKMPVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 10:21:14 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56514 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726335AbfKMPVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 10:21:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573658473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ni75lCcQrpsQ864Hh4egoWZfMx6GoJOEu0Txc6DxR4I=;
        b=CxKlmTJ9zYkmt2GzNNT3luDAqq941+CYoSePybgNcMPAlDTjIZ1JARN93o0hkG6YePNGmX
        J3I20ODQbmgyeLIB1TnFqIDyAC4txglnAv0t+gOucCWwD05+EtPj28YHF8lWtXREEDucOv
        pQUNkp3iIsRFWTLJ0Sd232XJNBrYAL0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-QT3whoIEPCCSyMjZUm5XPQ-1; Wed, 13 Nov 2019 10:21:12 -0500
Received: by mail-qk1-f198.google.com with SMTP id h80so1713914qke.15
        for <stable@vger.kernel.org>; Wed, 13 Nov 2019 07:21:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XcCOD3MZGV+TFihxnkOXCXAXzldN+sMQ52FQOz5W/8o=;
        b=gnknilzTcTEQgZF0pRGYaY1ofrsmeylCj5/c2MxbEFIbUJoDAJuZin+pBoGVkEKZnN
         XDwCNsG9Tvzli3+FB+mW4Z9HYNv3Peu1tdzoyLFJfLF4mSfJl56+Sh+ogqXRdwjvNOE0
         btJ3h0BwA49+8R5v9kmuIaKaeeuomNyRVrH39IyIC/lmNlmYsVRsnAXazOXkekNL7Yjv
         n2AXTXTiPgu26P2kYWwmX0k8D+L7Hdnmwb2rtg1j5jUtlEbfMrlFlGn0z9SHMgTy/8zj
         rWNxwxMQZNPTwSgwMJAKWXHvkNanmXGgXjqqFBQHZdOKN2kACHWv+rMF3nibTlUXv2/h
         p/Ug==
X-Gm-Message-State: APjAAAXOn2kZfO+S/8ZL6gdTkKjlc1m3wo4g+DdrSkUARXohG3UerA0b
        cj0zBM7ZFZHtQIW8fOD17Lfnoq4spR2draT8RHoOkCNTX3S/84+6T2ks6468KzdoQNnRsAs+gJF
        N4zS1/l+4Td93eGsy
X-Received: by 2002:a37:7b83:: with SMTP id w125mr2785620qkc.343.1573658471664;
        Wed, 13 Nov 2019 07:21:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqz7xnbYa9tTLt6MQY+f/nsPs3ipIWvgyM8Tf9P55Utd9mLx47RmBjetUvy+qCiobpbI+BzFHQ==
X-Received: by 2002:a37:7b83:: with SMTP id w125mr2785592qkc.343.1573658471330;
        Wed, 13 Nov 2019 07:21:11 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id i128sm1078375qkf.134.2019.11.13.07.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 07:21:10 -0800 (PST)
Date:   Wed, 13 Nov 2019 10:21:05 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit@kernel.org>,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] virtio_console: allocate inbufs in add_port() only if
 it is needed
Message-ID: <20191113101929-mutt-send-email-mst@kernel.org>
References: <20191113150056.9990-1-lvivier@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191113150056.9990-1-lvivier@redhat.com>
X-MC-Unique: QT3whoIEPCCSyMjZUm5XPQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 13, 2019 at 04:00:56PM +0100, Laurent Vivier wrote:
> When we hot unplug a virtserialport and then try to hot plug again,
> it fails:
>=20
> (qemu) chardev-add socket,id=3Dserial0,path=3D/tmp/serial0,server,nowait
> (qemu) device_add virtserialport,bus=3Dvirtio-serial0.0,nr=3D2,\
>                   chardev=3Dserial0,id=3Dserial0,name=3Dserial0
> (qemu) device_del serial0
> (qemu) device_add virtserialport,bus=3Dvirtio-serial0.0,nr=3D2,\
>                   chardev=3Dserial0,id=3Dserial0,name=3Dserial0
> kernel error:
>   virtio-ports vport2p2: Error allocating inbufs
> qemu error:
>   virtio-serial-bus: Guest failure in adding port 2 for device \
>                      virtio-serial0.0
>=20
> This happens because buffers for the in_vq are allocated when the port is
> added but are not released when the port is unplugged.
>=20
> They are only released when virtconsole is removed (see a7a69ec0d8e4)
>=20
> To avoid the problem and to be symmetric, we could allocate all the buffe=
rs
> in init_vqs() as they are released in remove_vqs(), but it sounds like
> a waste of memory.
>=20
> Rather than that, this patch changes add_port() logic to ignore ENOSPC
> error in fill_queue(), which means queue has already been filled.
>=20
> Fixes: a7a69ec0d8e4 ("virtio_console: free buffers after reset")
> Cc: mst@redhat.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> ---
>=20
> Notes:
>     v2: making fill_queue return int and testing return code for -ENOSPC
>=20
>  drivers/char/virtio_console.c | 24 +++++++++---------------
>  1 file changed, 9 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.=
c
> index 7270e7b69262..9e6534fd1aa4 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -1325,24 +1325,24 @@ static void set_console_size(struct port *port, u=
16 rows, u16 cols)
>  =09port->cons.ws.ws_col =3D cols;
>  }
> =20
> -static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
> +static int fill_queue(struct virtqueue *vq, spinlock_t *lock)
>  {
>  =09struct port_buffer *buf;
> -=09unsigned int nr_added_bufs;
> +=09int nr_added_bufs;
>  =09int ret;
> =20
>  =09nr_added_bufs =3D 0;
>  =09do {
>  =09=09buf =3D alloc_buf(vq->vdev, PAGE_SIZE, 0);
>  =09=09if (!buf)
> -=09=09=09break;
> +=09=09=09return -ENOMEM;
> =20
>  =09=09spin_lock_irq(lock);
>  =09=09ret =3D add_inbuf(vq, buf);
>  =09=09if (ret < 0) {
>  =09=09=09spin_unlock_irq(lock);
>  =09=09=09free_buf(buf, true);
> -=09=09=09break;
> +=09=09=09return ret;
>  =09=09}
>  =09=09nr_added_bufs++;
>  =09=09spin_unlock_irq(lock);
> @@ -1362,7 +1362,6 @@ static int add_port(struct ports_device *portdev, u=
32 id)
>  =09char debugfs_name[16];
>  =09struct port *port;
>  =09dev_t devt;
> -=09unsigned int nr_added_bufs;
>  =09int err;
> =20
>  =09port =3D kmalloc(sizeof(*port), GFP_KERNEL);
> @@ -1421,11 +1420,9 @@ static int add_port(struct ports_device *portdev, =
u32 id)
>  =09spin_lock_init(&port->outvq_lock);
>  =09init_waitqueue_head(&port->waitqueue);
> =20
> -=09/* Fill the in_vq with buffers so the host can send us data. */
> -=09nr_added_bufs =3D fill_queue(port->in_vq, &port->inbuf_lock);
> -=09if (!nr_added_bufs) {
> +=09err =3D fill_queue(port->in_vq, &port->inbuf_lock);
> +=09if (err < 0 && err !=3D -ENOSPC) {
>  =09=09dev_err(port->dev, "Error allocating inbufs\n");
> -=09=09err =3D -ENOMEM;
>  =09=09goto free_device;
>  =09}
> =20

Pls add a comment explaining that -ENOSPC happens when
queue already has buffers (e.g. from previous detach).


> @@ -2059,14 +2056,11 @@ static int virtcons_probe(struct virtio_device *v=
dev)
>  =09INIT_WORK(&portdev->control_work, &control_work_handler);
> =20
>  =09if (multiport) {
> -=09=09unsigned int nr_added_bufs;
> -
>  =09=09spin_lock_init(&portdev->c_ivq_lock);
>  =09=09spin_lock_init(&portdev->c_ovq_lock);
> =20
> -=09=09nr_added_bufs =3D fill_queue(portdev->c_ivq,
> -=09=09=09=09=09   &portdev->c_ivq_lock);
> -=09=09if (!nr_added_bufs) {
> +=09=09err =3D fill_queue(portdev->c_ivq, &portdev->c_ivq_lock);
> +=09=09if (err < 0) {
>  =09=09=09dev_err(&vdev->dev,
>  =09=09=09=09"Error allocating buffers for control queue\n");
>  =09=09=09/*
> @@ -2077,7 +2071,7 @@ static int virtcons_probe(struct virtio_device *vde=
v)
>  =09=09=09=09=09   VIRTIO_CONSOLE_DEVICE_READY, 0);
>  =09=09=09/* Device was functional: we need full cleanup. */
>  =09=09=09virtcons_remove(vdev);
> -=09=09=09return -ENOMEM;
> +=09=09=09return err;
>  =09=09}
>  =09} else {
>  =09=09/*
> --=20
> 2.23.0


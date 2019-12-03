Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D32A110173
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 16:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfLCPnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 10:43:04 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44675 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726189AbfLCPnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 10:43:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575387782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mwIie4f/cRbrQG5a7iYXir2IBzgVvgbaZEb5jJx1d6Y=;
        b=CAhokgvPHvb2YxNkU7r5eDZxXgAcmDvYr4TjzOOg1cuGXBRTEWk+8VOSKTrr/mS+77Uh/n
        +6V1cTMUf4cstGx5nZRpbc2qC/rU7uV6TVq5qDUBDzgrdI73YmxsoHrJjkZwUnzGSWlVJJ
        tWXv09K1zvplLcRPbJquzyvibvlXNbk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-NMmrTK2XO3SJ4mhXSh8omA-1; Tue, 03 Dec 2019 10:42:59 -0500
Received: by mail-qk1-f199.google.com with SMTP id x127so2483245qkb.0
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 07:42:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U0dQFMzS2rXCEeOJP1XOszx/oJ4UEFVvA3Pxp6Rvtd0=;
        b=tGNQ7MVbGfEN/+fY8QDgl1rqwpaCJBzOnOIqwFDx4suDFnc6HlMmf3I6KlLXiy4Ejf
         v5RC++bwuytSBOTprbKpG/1lFloz4O9jelA2GIQ25nY6VPwXiq+/u4wTYKTp4ecE43m5
         EyVwrZScH7mf/9rm0aS1FPqFCTpQIuTf+lRfJXGIKfOxdLQdiQCzUkrOYcNG3gpTyPnF
         MVLSF4y6wJ9R930GpQltyN4kEbjDK1uOhyqfuXSZrxr06XTT0m2MIi+tWeb2fnz4oImu
         bpku/JajdRCQWCEqncQPs6RwOp1iCFyjN1IBVYvFzN4VQK7R8ehdn79WI8OTkAPW2D6V
         D9RA==
X-Gm-Message-State: APjAAAUrTatQB7iw6rCGk2wZVxp604Y+qlE34I0fd8hQKeADBvhaJh1I
        /vKf0d1SOBkexAo6QnlSf0En4iG+9Vzgd87hDL8n6eQlSgA5tzls41SGy9+JKTeOThHWJK2CJ1N
        R6aH5spceDZa/gYJY
X-Received: by 2002:ac8:4645:: with SMTP id f5mr5640957qto.38.1575387779010;
        Tue, 03 Dec 2019 07:42:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqxp9lC/Jp/2dE/7mPrFm8Zdh/X3yaI1ji1wcvv4uxOgmr6DGkywI8tk4Ps6zBeos0vlMFEIrQ==
X-Received: by 2002:ac8:4645:: with SMTP id f5mr5640925qto.38.1575387778733;
        Tue, 03 Dec 2019 07:42:58 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id m29sm2013564qtf.1.2019.12.03.07.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 07:42:57 -0800 (PST)
Date:   Tue, 3 Dec 2019 10:42:52 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Amit Shah <amit@infradead.org>
Cc:     Laurent Vivier <lvivier@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Amit Shah <amit@kernel.org>
Subject: Re: [PATCH v3] virtio_console: allocate inbufs in add_port() only if
 it is needed
Message-ID: <20191203103840-mutt-send-email-mst@kernel.org>
References: <20191114122548.24364-1-lvivier@redhat.com>
 <ae3451423c18f2e408245d745d1f28e311a2845c.camel@infradead.org>
MIME-Version: 1.0
In-Reply-To: <ae3451423c18f2e408245d745d1f28e311a2845c.camel@infradead.org>
X-MC-Unique: NMmrTK2XO3SJ4mhXSh8omA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 03:46:50PM +0100, Amit Shah wrote:
> On Thu, 2019-11-14 at 13:25 +0100, Laurent Vivier wrote:
> > When we hot unplug a virtserialport and then try to hot plug again,
> > it fails:
> >=20
> > (qemu) chardev-add socket,id=3Dserial0,path=3D/tmp/serial0,server,nowai=
t
> > (qemu) device_add virtserialport,bus=3Dvirtio-serial0.0,nr=3D2,\
> >                   chardev=3Dserial0,id=3Dserial0,name=3Dserial0
> > (qemu) device_del serial0
> > (qemu) device_add virtserialport,bus=3Dvirtio-serial0.0,nr=3D2,\
> >                   chardev=3Dserial0,id=3Dserial0,name=3Dserial0
> > kernel error:
> >   virtio-ports vport2p2: Error allocating inbufs
> > qemu error:
> >   virtio-serial-bus: Guest failure in adding port 2 for device \
> >                      virtio-serial0.0
> >=20
> > This happens because buffers for the in_vq are allocated when the
> > port is
> > added but are not released when the port is unplugged.
> >=20
> > They are only released when virtconsole is removed (see a7a69ec0d8e4)
> >=20
> > To avoid the problem and to be symmetric, we could allocate all the
> > buffers
> > in init_vqs() as they are released in remove_vqs(), but it sounds
> > like
> > a waste of memory.
> >=20
> > Rather than that, this patch changes add_port() logic to ignore
> > ENOSPC
> > error in fill_queue(), which means queue has already been filled.
> >=20
> > Fixes: a7a69ec0d8e4 ("virtio_console: free buffers after reset")
> > Cc: mst@redhat.com
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>=20
> Reviewed-by: Amit Shah <amit@kernel.org>
>=20
> Thanks!


Thanks, however this has already been merged by Linus.
I can't add the tag retroactively, sorry about that.

For bugfix patches like that, I think we can reasonably
target a turn around of a couple of days, these
shouldn't really need to wait weeks for review.

> > ---
> >=20
> > Notes:
> >     v3: add a comment about ENOSPC error
> >     v2: making fill_queue return int and testing return code for
> > -ENOSPC
> >=20
> >  drivers/char/virtio_console.c | 28 +++++++++++++---------------
> >  1 file changed, 13 insertions(+), 15 deletions(-)
> >=20
> > diff --git a/drivers/char/virtio_console.c
> > b/drivers/char/virtio_console.c
> > index 7270e7b69262..3259426f01dc 100644
> > --- a/drivers/char/virtio_console.c
> > +++ b/drivers/char/virtio_console.c
> > @@ -1325,24 +1325,24 @@ static void set_console_size(struct port
> > *port, u16 rows, u16 cols)
> >  =09port->cons.ws.ws_col =3D cols;
> >  }
> > =20
> > -static unsigned int fill_queue(struct virtqueue *vq, spinlock_t
> > *lock)
> > +static int fill_queue(struct virtqueue *vq, spinlock_t *lock)
> >  {
> >  =09struct port_buffer *buf;
> > -=09unsigned int nr_added_bufs;
> > +=09int nr_added_bufs;
> >  =09int ret;
> > =20
> >  =09nr_added_bufs =3D 0;
> >  =09do {
> >  =09=09buf =3D alloc_buf(vq->vdev, PAGE_SIZE, 0);
> >  =09=09if (!buf)
> > -=09=09=09break;
> > +=09=09=09return -ENOMEM;
> > =20
> >  =09=09spin_lock_irq(lock);
> >  =09=09ret =3D add_inbuf(vq, buf);
> >  =09=09if (ret < 0) {
> >  =09=09=09spin_unlock_irq(lock);
> >  =09=09=09free_buf(buf, true);
> > -=09=09=09break;
> > +=09=09=09return ret;
> >  =09=09}
> >  =09=09nr_added_bufs++;
> >  =09=09spin_unlock_irq(lock);
> > @@ -1362,7 +1362,6 @@ static int add_port(struct ports_device
> > *portdev, u32 id)
> >  =09char debugfs_name[16];
> >  =09struct port *port;
> >  =09dev_t devt;
> > -=09unsigned int nr_added_bufs;
> >  =09int err;
> > =20
> >  =09port =3D kmalloc(sizeof(*port), GFP_KERNEL);
> > @@ -1421,11 +1420,13 @@ static int add_port(struct ports_device
> > *portdev, u32 id)
> >  =09spin_lock_init(&port->outvq_lock);
> >  =09init_waitqueue_head(&port->waitqueue);
> > =20
> > -=09/* Fill the in_vq with buffers so the host can send us data. */
> > -=09nr_added_bufs =3D fill_queue(port->in_vq, &port->inbuf_lock);
> > -=09if (!nr_added_bufs) {
> > +=09/* We can safely ignore ENOSPC because it means
> > +=09 * the queue already has buffers. Buffers are removed
> > +=09 * only by virtcons_remove(), not by unplug_port()
> > +=09 */
> > +=09err =3D fill_queue(port->in_vq, &port->inbuf_lock);
> > +=09if (err < 0 && err !=3D -ENOSPC) {
> >  =09=09dev_err(port->dev, "Error allocating inbufs\n");
> > -=09=09err =3D -ENOMEM;
> >  =09=09goto free_device;
> >  =09}
> > =20
> > @@ -2059,14 +2060,11 @@ static int virtcons_probe(struct
> > virtio_device *vdev)
> >  =09INIT_WORK(&portdev->control_work, &control_work_handler);
> > =20
> >  =09if (multiport) {
> > -=09=09unsigned int nr_added_bufs;
> > -
> >  =09=09spin_lock_init(&portdev->c_ivq_lock);
> >  =09=09spin_lock_init(&portdev->c_ovq_lock);
> > =20
> > -=09=09nr_added_bufs =3D fill_queue(portdev->c_ivq,
> > -=09=09=09=09=09   &portdev->c_ivq_lock);
> > -=09=09if (!nr_added_bufs) {
> > +=09=09err =3D fill_queue(portdev->c_ivq, &portdev->c_ivq_lock);
> > +=09=09if (err < 0) {
> >  =09=09=09dev_err(&vdev->dev,
> >  =09=09=09=09"Error allocating buffers for control
> > queue\n");
> >  =09=09=09/*
> > @@ -2077,7 +2075,7 @@ static int virtcons_probe(struct virtio_device
> > *vdev)
> >  =09=09=09=09=09   VIRTIO_CONSOLE_DEVICE_READY,
> > 0);
> >  =09=09=09/* Device was functional: we need full cleanup.
> > */
> >  =09=09=09virtcons_remove(vdev);
> > -=09=09=09return -ENOMEM;
> > +=09=09=09return err;
> >  =09=09}
> >  =09} else {
> >  =09=09/*


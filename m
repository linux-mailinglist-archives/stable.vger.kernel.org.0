Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F60AFB8CE
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 20:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfKMT2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 14:28:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52240 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726189AbfKMT2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 14:28:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573673330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8DO2hwiHu3pgkopyWQopR93a48RM5O8XuzUQ/v4W2kE=;
        b=MLxerkn8GU8AlysHMqxyN6aw/q0n3neEV61SDpyPcKedpZzXgg0bB+OlZIHqMNPHhsgRQu
        tzfce6LRi1QehMiUlSEG/ajplLhuaqLClo11PWoLEesVO3DryE0EYhxVnuFIRexUosc645
        FWTv5ugnbzj0/1VkipkfiWrrdNNIZvA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-TDcBO5UfOxuYvvRfVfoM4A-1; Wed, 13 Nov 2019 14:28:49 -0500
Received: by mail-qv1-f69.google.com with SMTP id w7so2289975qvs.15
        for <stable@vger.kernel.org>; Wed, 13 Nov 2019 11:28:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CoUlcMFhYrKHjvPh5qnAfb7ZB6jVrV1NCGIqlkgFJ7Q=;
        b=bI1dQ7z2CMzwfUu0lTxyiyNLS6gh2D+APKHMM1c83L+5xZN62LweY/xQeulAy7ShJT
         AacIVN9uyulNMOJWPMxv8jUw5D3+gnRVzEvErp2edmvZbSLwXe8c6E8z0hqefJBhZKSx
         C/zxqBEyZMpCXRf2q79HV7DON4Ts/SSnPD3Yrrig8/u2+5/Qr0B5NF5H+aXcExKdnCA1
         WduQrZEfIA7RNFH/EaLRjdVHP0m8j7ZmqKfVNPtgpMyR6MwWdFoz6jAqKKvitNHSfqg5
         Pj0YwxtQ6++Yk+3CvbpsXvBdAjIs+6INJyBVgacXWfXviyvN64f1eg1O4yRXEGmeOd91
         GfUA==
X-Gm-Message-State: APjAAAVMcThVuxNlCk3XBW1Gnk/Xci/sSrlXDKfOoVzOT2nxE/JPZ01Y
        lR8HYD5Ip9divtuNlLcO2ZS77IZ3CJBj6NuiEI5TekHvE1F7+vWoMfZqnrijCj+JxA2T1POpI4J
        YCDECWZ3bRsABgyLB
X-Received: by 2002:ac8:7085:: with SMTP id y5mr4307323qto.76.1573673329297;
        Wed, 13 Nov 2019 11:28:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqx0ClAjjDvl9GSwMYMpNSj/1YP4wP59jyAYjjbPHC57IJ0tL8dPnQYy8A4DXBH9pQa2yR53Lw==
X-Received: by 2002:ac8:7085:: with SMTP id y5mr4307296qto.76.1573673329049;
        Wed, 13 Nov 2019 11:28:49 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id i4sm1621727qtp.57.2019.11.13.11.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 11:28:47 -0800 (PST)
Date:   Wed, 13 Nov 2019 14:28:42 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit@kernel.org>,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] virtio_console: allocate inbufs in add_port() only if
 it is needed
Message-ID: <20191113142757-mutt-send-email-mst@kernel.org>
References: <20191113150056.9990-1-lvivier@redhat.com>
 <20191113101929-mutt-send-email-mst@kernel.org>
 <20191113102126-mutt-send-email-mst@kernel.org>
 <7bd34d61-146f-8edb-d82d-7285a83437b4@redhat.com>
MIME-Version: 1.0
In-Reply-To: <7bd34d61-146f-8edb-d82d-7285a83437b4@redhat.com>
X-MC-Unique: TDcBO5UfOxuYvvRfVfoM4A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 13, 2019 at 05:37:34PM +0100, Laurent Vivier wrote:
> On 13/11/2019 16:22, Michael S. Tsirkin wrote:
> > On Wed, Nov 13, 2019 at 10:21:11AM -0500, Michael S. Tsirkin wrote:
> >> On Wed, Nov 13, 2019 at 04:00:56PM +0100, Laurent Vivier wrote:
> >>> When we hot unplug a virtserialport and then try to hot plug again,
> >>> it fails:
> >>>
> >>> (qemu) chardev-add socket,id=3Dserial0,path=3D/tmp/serial0,server,now=
ait
> >>> (qemu) device_add virtserialport,bus=3Dvirtio-serial0.0,nr=3D2,\
> >>>                   chardev=3Dserial0,id=3Dserial0,name=3Dserial0
> >>> (qemu) device_del serial0
> >>> (qemu) device_add virtserialport,bus=3Dvirtio-serial0.0,nr=3D2,\
> >>>                   chardev=3Dserial0,id=3Dserial0,name=3Dserial0
> >>> kernel error:
> >>>   virtio-ports vport2p2: Error allocating inbufs
> >>> qemu error:
> >>>   virtio-serial-bus: Guest failure in adding port 2 for device \
> >>>                      virtio-serial0.0
> >>>
> >>> This happens because buffers for the in_vq are allocated when the por=
t is
> >>> added but are not released when the port is unplugged.
> >>>
> >>> They are only released when virtconsole is removed (see a7a69ec0d8e4)
> >>>
> >>> To avoid the problem and to be symmetric, we could allocate all the b=
uffers
> >>> in init_vqs() as they are released in remove_vqs(), but it sounds lik=
e
> >>> a waste of memory.
> >>>
> >>> Rather than that, this patch changes add_port() logic to ignore ENOSP=
C
> >>> error in fill_queue(), which means queue has already been filled.
> >>>
> >>> Fixes: a7a69ec0d8e4 ("virtio_console: free buffers after reset")
> >>> Cc: mst@redhat.com
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> >>> ---
> >>>
> >>> Notes:
> >>>     v2: making fill_queue return int and testing return code for -ENO=
SPC
> >>>
> >>>  drivers/char/virtio_console.c | 24 +++++++++---------------
> >>>  1 file changed, 9 insertions(+), 15 deletions(-)
> >>>
> >>> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_cons=
ole.c
> >>> index 7270e7b69262..9e6534fd1aa4 100644
> >>> --- a/drivers/char/virtio_console.c
> >>> +++ b/drivers/char/virtio_console.c
> >>> @@ -1325,24 +1325,24 @@ static void set_console_size(struct port *por=
t, u16 rows, u16 cols)
> >>>  =09port->cons.ws.ws_col =3D cols;
> >>>  }
> >>> =20
> >>> -static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *loc=
k)
> >>> +static int fill_queue(struct virtqueue *vq, spinlock_t *lock)
> >>>  {
> >>>  =09struct port_buffer *buf;
> >>> -=09unsigned int nr_added_bufs;
> >>> +=09int nr_added_bufs;
> >>>  =09int ret;
> >>> =20
> >>>  =09nr_added_bufs =3D 0;
> >>>  =09do {
> >>>  =09=09buf =3D alloc_buf(vq->vdev, PAGE_SIZE, 0);
> >>>  =09=09if (!buf)
> >>> -=09=09=09break;
> >>> +=09=09=09return -ENOMEM;
> >>> =20
> >>>  =09=09spin_lock_irq(lock);
> >>>  =09=09ret =3D add_inbuf(vq, buf);
> >>>  =09=09if (ret < 0) {
> >>>  =09=09=09spin_unlock_irq(lock);
> >>>  =09=09=09free_buf(buf, true);
> >>> -=09=09=09break;
> >>> +=09=09=09return ret;
> >>>  =09=09}
> >>>  =09=09nr_added_bufs++;
> >>>  =09=09spin_unlock_irq(lock);
> >=20
> > So actually, how about handling ENOSPC specially here, and
> > returning success? After all queue is full as requested ...
>=20
> I think it's interesting to return -ENOSPC to manage it as a real error
> in virtcons_probe() as in this function the queue should not be already
> full (is this right?) and to return the real error code.
>=20
> Thanks,
> Laurent

OK then. Pls add comments.


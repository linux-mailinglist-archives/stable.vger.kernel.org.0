Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87EFFFB316
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 16:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfKMPBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 10:01:10 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38922 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727730AbfKMPBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 10:01:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573657267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pZrVnWf11qMep6zPjTPieof4+h3HJFQO0raZCoFr0t8=;
        b=Yr8uSatWsck0J4UxCx5bC/Jy7kOHp8jFvikfLjrbwSwQ/7qdzb8GoTnc1gN09RLIwPql2p
        +2ukxrPl+bRCOHwLqId2IZurcRLVpCfJRFmagORtr8TgxGKvC2A2toUJdvqqSfMe4Z6SK5
        nIEPJ0Rw9Cz2H/gaRK10CwldU1T5NLI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-oR_IZnsWO86m8XAGuP0U2w-1; Wed, 13 Nov 2019 10:01:04 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 093F118B5F76;
        Wed, 13 Nov 2019 15:01:02 +0000 (UTC)
Received: from thinkpad.redhat.com (ovpn-117-236.ams2.redhat.com [10.36.117.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDF3360308;
        Wed, 13 Nov 2019 15:00:56 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v2] virtio_console: allocate inbufs in add_port() only if it is needed
Date:   Wed, 13 Nov 2019 16:00:56 +0100
Message-Id: <20191113150056.9990-1-lvivier@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: oR_IZnsWO86m8XAGuP0U2w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we hot unplug a virtserialport and then try to hot plug again,
it fails:

(qemu) chardev-add socket,id=3Dserial0,path=3D/tmp/serial0,server,nowait
(qemu) device_add virtserialport,bus=3Dvirtio-serial0.0,nr=3D2,\
                  chardev=3Dserial0,id=3Dserial0,name=3Dserial0
(qemu) device_del serial0
(qemu) device_add virtserialport,bus=3Dvirtio-serial0.0,nr=3D2,\
                  chardev=3Dserial0,id=3Dserial0,name=3Dserial0
kernel error:
  virtio-ports vport2p2: Error allocating inbufs
qemu error:
  virtio-serial-bus: Guest failure in adding port 2 for device \
                     virtio-serial0.0

This happens because buffers for the in_vq are allocated when the port is
added but are not released when the port is unplugged.

They are only released when virtconsole is removed (see a7a69ec0d8e4)

To avoid the problem and to be symmetric, we could allocate all the buffers
in init_vqs() as they are released in remove_vqs(), but it sounds like
a waste of memory.

Rather than that, this patch changes add_port() logic to ignore ENOSPC
error in fill_queue(), which means queue has already been filled.

Fixes: a7a69ec0d8e4 ("virtio_console: free buffers after reset")
Cc: mst@redhat.com
Cc: stable@vger.kernel.org
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---

Notes:
    v2: making fill_queue return int and testing return code for -ENOSPC

 drivers/char/virtio_console.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 7270e7b69262..9e6534fd1aa4 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1325,24 +1325,24 @@ static void set_console_size(struct port *port, u16=
 rows, u16 cols)
 =09port->cons.ws.ws_col =3D cols;
 }
=20
-static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
+static int fill_queue(struct virtqueue *vq, spinlock_t *lock)
 {
 =09struct port_buffer *buf;
-=09unsigned int nr_added_bufs;
+=09int nr_added_bufs;
 =09int ret;
=20
 =09nr_added_bufs =3D 0;
 =09do {
 =09=09buf =3D alloc_buf(vq->vdev, PAGE_SIZE, 0);
 =09=09if (!buf)
-=09=09=09break;
+=09=09=09return -ENOMEM;
=20
 =09=09spin_lock_irq(lock);
 =09=09ret =3D add_inbuf(vq, buf);
 =09=09if (ret < 0) {
 =09=09=09spin_unlock_irq(lock);
 =09=09=09free_buf(buf, true);
-=09=09=09break;
+=09=09=09return ret;
 =09=09}
 =09=09nr_added_bufs++;
 =09=09spin_unlock_irq(lock);
@@ -1362,7 +1362,6 @@ static int add_port(struct ports_device *portdev, u32=
 id)
 =09char debugfs_name[16];
 =09struct port *port;
 =09dev_t devt;
-=09unsigned int nr_added_bufs;
 =09int err;
=20
 =09port =3D kmalloc(sizeof(*port), GFP_KERNEL);
@@ -1421,11 +1420,9 @@ static int add_port(struct ports_device *portdev, u3=
2 id)
 =09spin_lock_init(&port->outvq_lock);
 =09init_waitqueue_head(&port->waitqueue);
=20
-=09/* Fill the in_vq with buffers so the host can send us data. */
-=09nr_added_bufs =3D fill_queue(port->in_vq, &port->inbuf_lock);
-=09if (!nr_added_bufs) {
+=09err =3D fill_queue(port->in_vq, &port->inbuf_lock);
+=09if (err < 0 && err !=3D -ENOSPC) {
 =09=09dev_err(port->dev, "Error allocating inbufs\n");
-=09=09err =3D -ENOMEM;
 =09=09goto free_device;
 =09}
=20
@@ -2059,14 +2056,11 @@ static int virtcons_probe(struct virtio_device *vde=
v)
 =09INIT_WORK(&portdev->control_work, &control_work_handler);
=20
 =09if (multiport) {
-=09=09unsigned int nr_added_bufs;
-
 =09=09spin_lock_init(&portdev->c_ivq_lock);
 =09=09spin_lock_init(&portdev->c_ovq_lock);
=20
-=09=09nr_added_bufs =3D fill_queue(portdev->c_ivq,
-=09=09=09=09=09   &portdev->c_ivq_lock);
-=09=09if (!nr_added_bufs) {
+=09=09err =3D fill_queue(portdev->c_ivq, &portdev->c_ivq_lock);
+=09=09if (err < 0) {
 =09=09=09dev_err(&vdev->dev,
 =09=09=09=09"Error allocating buffers for control queue\n");
 =09=09=09/*
@@ -2077,7 +2071,7 @@ static int virtcons_probe(struct virtio_device *vdev)
 =09=09=09=09=09   VIRTIO_CONSOLE_DEVICE_READY, 0);
 =09=09=09/* Device was functional: we need full cleanup. */
 =09=09=09virtcons_remove(vdev);
-=09=09=09return -ENOMEM;
+=09=09=09return err;
 =09=09}
 =09} else {
 =09=09/*
--=20
2.23.0


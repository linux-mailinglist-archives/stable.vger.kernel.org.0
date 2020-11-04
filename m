Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26B42A67B8
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 16:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbgKDPby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 10:31:54 -0500
Received: from mail-03.mail-europe.com ([91.134.188.129]:39852 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730579AbgKDPbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 10:31:53 -0500
Date:   Wed, 04 Nov 2020 15:31:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604503904; bh=BQ2VaKtBiuQCT6Mo5ex46388MTeEB/SnXnxf3lZZ6PE=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=a5WlYYvHMV++OZhuUV+kCl1zVOYrV9Vm7lfn6z9tXWm1JBLZOKa968UzJS/TkbqgN
         wNwWCW6KdS1ak8qZ/6QtDAY4jIg1mLUy9I3d0BUiMp+cIVYtEQhpqZQERwWejf/+3M
         acOJPAaBecyzPiUTt2UmUFJ9qDo6qjj9/A7D/mbxah5+R+Bwht3xnGLzlRGohULnKZ
         Flc9/XySag7zQXjBQgDD6wtPZBqzhVDeqF7KYpFIwmJMcPyO3EujhdbAJVrHwJrABk
         1NuprOaH0ubjmO/qfNAUKwQ0059p8+wgMwci3pD4PaKgzyJR9dRW+b8uw6EInxBJOV
         2GH78BvoHl3Ug==
To:     Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Suman Anna <s-anna@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH virtio] virtio: virtio_console: fix DMA memory allocation for rproc serial
Message-ID: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 086d08725d34 ("remoteproc: create vdev subdevice with
specific dma memory pool"), every remoteproc has a DMA subdevice
("remoteprocX#vdevYbuffer") for each virtio device, which inherits
DMA capabilities from the corresponding platform device. This allowed
to associate different DMA pools with each vdev, and required from
virtio drivers to perform DMA operations with the parent device
(vdev->dev.parent) instead of grandparent (vdev->dev.parent->parent).

virtio_rpmsg_bus was already changed in the same merge cycle with
commit d999b622fcfb ("rpmsg: virtio: allocate buffer from parent"),
but virtio_console did not. In fact, operations using the grandparent
worked fine while the grandparent was the platform device, but since
commit c774ad010873 ("remoteproc: Fix and restore the parenting
hierarchy for vdev") this was changed, and now the grandparent device
is the remoteproc device without any DMA capabilities.
So, starting v5.8-rc1 the following warning is observed:

[    2.483925] ------------[ cut here ]------------
[    2.489148] WARNING: CPU: 3 PID: 101 at kernel/dma/mapping.c:427 0x80e7e=
ee8
[    2.489152] Modules linked in: virtio_console(+)
[    2.503737]  virtio_rpmsg_bus rpmsg_core
[    2.508903]
[    2.528898] <Other modules, stack and call trace here>
[    2.913043]
[    2.914907] ---[ end trace 93ac8746beab612c ]---
[    2.920102] virtio-ports vport1p0: Error allocating inbufs

kernel/dma/mapping.c:427 is:

WARN_ON_ONCE(!dev->coherent_dma_mask);

obviously because the grandparent now is remoteproc dev without any
DMA caps:

[    3.104943] Parent: remoteproc0#vdev1buffer, grandparent: remoteproc0

Fix this the same way as it was for virtio_rpmsg_bus, using just the
parent device (vdev->dev.parent, "remoteprocX#vdevYbuffer") for DMA
operations.
This also allows now to reserve DMA pools/buffers for rproc serial
via Device Tree.

Fixes: c774ad010873 ("remoteproc: Fix and restore the parenting hierarchy f=
or vdev")
Cc: stable@vger.kernel.org # 5.1+
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/char/virtio_console.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index a2da8f768b94..1836cc56e357 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -435,12 +435,12 @@ static struct port_buffer *alloc_buf(struct virtio_de=
vice *vdev, size_t buf_size
 =09=09/*
 =09=09 * Allocate DMA memory from ancestor. When a virtio
 =09=09 * device is created by remoteproc, the DMA memory is
-=09=09 * associated with the grandparent device:
-=09=09 * vdev =3D> rproc =3D> platform-dev.
+=09=09 * associated with the parent device:
+=09=09 * virtioY =3D> remoteprocX#vdevYbuffer.
 =09=09 */
-=09=09if (!vdev->dev.parent || !vdev->dev.parent->parent)
+=09=09buf->dev =3D vdev->dev.parent;
+=09=09if (!buf->dev)
 =09=09=09goto free_buf;
-=09=09buf->dev =3D vdev->dev.parent->parent;
=20
 =09=09/* Increase device refcnt to avoid freeing it */
 =09=09get_device(buf->dev);
--=20
2.29.2



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C1D2B6545
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbgKQNxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:53:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730420AbgKQN1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:27:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7931220867;
        Tue, 17 Nov 2020 13:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619673;
        bh=d8nCTxOSf7imVAKInrzj6zYbrEaG60l1D7WJ1t2ivz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mXwzui+zhiJ1oW3/X93PFR2CaUJ/mt+ao8Un5H0GYI/RHJoQ/jdjGffAhcNLK8eRu
         yH9rbbElWuzzX08G7pEeOZXvlqJPRSxhutt+mpREJHI9cRNVz0Ko1sIGVV+jSLKAsl
         2MMfqHSGzr31U2Db14dT+DgzETsJxaaM5nDInSiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH 5.4 118/151] virtio: virtio_console: fix DMA memory allocation for rproc serial
Date:   Tue, 17 Nov 2020 14:05:48 +0100
Message-Id: <20201117122127.163434799@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

commit 9d516aa82b7d4fbe7f6303348697960ba03a530b upstream.

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
[    2.489148] WARNING: CPU: 3 PID: 101 at kernel/dma/mapping.c:427 0x80e7eee8
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

Fixes: c774ad010873 ("remoteproc: Fix and restore the parenting hierarchy for vdev")
Cc: stable@vger.kernel.org # 5.1+
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Date: Thu, 5 Nov 2020 11:10:24 +0800
Link: https://lore.kernel.org/r/AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/virtio_console.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -435,12 +435,12 @@ static struct port_buffer *alloc_buf(str
 		/*
 		 * Allocate DMA memory from ancestor. When a virtio
 		 * device is created by remoteproc, the DMA memory is
-		 * associated with the grandparent device:
-		 * vdev => rproc => platform-dev.
+		 * associated with the parent device:
+		 * virtioY => remoteprocX#vdevYbuffer.
 		 */
-		if (!vdev->dev.parent || !vdev->dev.parent->parent)
+		buf->dev = vdev->dev.parent;
+		if (!buf->dev)
 			goto free_buf;
-		buf->dev = vdev->dev.parent->parent;
 
 		/* Increase device refcnt to avoid freeing it */
 		get_device(buf->dev);



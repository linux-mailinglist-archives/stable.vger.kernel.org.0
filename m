Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBB010BF69
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbfK0VnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:43:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:43324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728028AbfK0UjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:39:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29E4921771;
        Wed, 27 Nov 2019 20:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887154;
        bh=7THZt9ZkgK+9f/AJ+1jxMmWKlvyOwQTfGltNfMG3Ofo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LP1se55hQ803BB9Tp3i4kLe4ltlxcy961vM6oXy5Nc+IX93eeEkDeXsrQ0yCNoIe7
         uRkC/25XpMd+AH9x0tmJnkSmRIsNHki26el9VzxKL0luCmMqwYqfFafdkVRBIHJw4f
         QEFAk7LVFJjRABb95WTVchtEhl0jq374RPDCstMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, mst@redhat.com,
        Laurent Vivier <lvivier@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 118/132] virtio_console: allocate inbufs in add_port() only if it is needed
Date:   Wed, 27 Nov 2019 21:31:49 +0100
Message-Id: <20191127203032.308948451@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Vivier <lvivier@redhat.com>

[ Upstream commit d791cfcbf98191122af70b053a21075cb450d119 ]

When we hot unplug a virtserialport and then try to hot plug again,
it fails:

(qemu) chardev-add socket,id=serial0,path=/tmp/serial0,server,nowait
(qemu) device_add virtserialport,bus=virtio-serial0.0,nr=2,\
                  chardev=serial0,id=serial0,name=serial0
(qemu) device_del serial0
(qemu) device_add virtserialport,bus=virtio-serial0.0,nr=2,\
                  chardev=serial0,id=serial0,name=serial0
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
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/virtio_console.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 1a566e3b16e07..c5b89f6b0145e 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1363,24 +1363,24 @@ static void set_console_size(struct port *port, u16 rows, u16 cols)
 	port->cons.ws.ws_col = cols;
 }
 
-static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
+static int fill_queue(struct virtqueue *vq, spinlock_t *lock)
 {
 	struct port_buffer *buf;
-	unsigned int nr_added_bufs;
+	int nr_added_bufs;
 	int ret;
 
 	nr_added_bufs = 0;
 	do {
 		buf = alloc_buf(vq->vdev, PAGE_SIZE, 0);
 		if (!buf)
-			break;
+			return -ENOMEM;
 
 		spin_lock_irq(lock);
 		ret = add_inbuf(vq, buf);
 		if (ret < 0) {
 			spin_unlock_irq(lock);
 			free_buf(buf, true);
-			break;
+			return ret;
 		}
 		nr_added_bufs++;
 		spin_unlock_irq(lock);
@@ -1400,7 +1400,6 @@ static int add_port(struct ports_device *portdev, u32 id)
 	char debugfs_name[16];
 	struct port *port;
 	dev_t devt;
-	unsigned int nr_added_bufs;
 	int err;
 
 	port = kmalloc(sizeof(*port), GFP_KERNEL);
@@ -1459,11 +1458,13 @@ static int add_port(struct ports_device *portdev, u32 id)
 	spin_lock_init(&port->outvq_lock);
 	init_waitqueue_head(&port->waitqueue);
 
-	/* Fill the in_vq with buffers so the host can send us data. */
-	nr_added_bufs = fill_queue(port->in_vq, &port->inbuf_lock);
-	if (!nr_added_bufs) {
+	/* We can safely ignore ENOSPC because it means
+	 * the queue already has buffers. Buffers are removed
+	 * only by virtcons_remove(), not by unplug_port()
+	 */
+	err = fill_queue(port->in_vq, &port->inbuf_lock);
+	if (err < 0 && err != -ENOSPC) {
 		dev_err(port->dev, "Error allocating inbufs\n");
-		err = -ENOMEM;
 		goto free_device;
 	}
 
@@ -2075,14 +2076,11 @@ static int virtcons_probe(struct virtio_device *vdev)
 	INIT_WORK(&portdev->control_work, &control_work_handler);
 
 	if (multiport) {
-		unsigned int nr_added_bufs;
-
 		spin_lock_init(&portdev->c_ivq_lock);
 		spin_lock_init(&portdev->c_ovq_lock);
 
-		nr_added_bufs = fill_queue(portdev->c_ivq,
-					   &portdev->c_ivq_lock);
-		if (!nr_added_bufs) {
+		err = fill_queue(portdev->c_ivq, &portdev->c_ivq_lock);
+		if (err < 0) {
 			dev_err(&vdev->dev,
 				"Error allocating buffers for control queue\n");
 			/*
@@ -2093,7 +2091,7 @@ static int virtcons_probe(struct virtio_device *vdev)
 					   VIRTIO_CONSOLE_DEVICE_READY, 0);
 			/* Device was functional: we need full cleanup. */
 			virtcons_remove(vdev);
-			return -ENOMEM;
+			return err;
 		}
 	} else {
 		/*
-- 
2.20.1




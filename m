Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EED20109306
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 18:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfKYRoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 12:44:09 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37771 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725851AbfKYRoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 12:44:09 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 117102275D;
        Mon, 25 Nov 2019 12:44:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 25 Nov 2019 12:44:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=35NRYw
        tilGojHnSasR/TKGn1LIE1Uv1FDSYavWqNzIU=; b=R8/ynM+ArmDBRb4KSTnYVQ
        0NsA/qzh6uvKjG2z1zE1Ng2rkewvw91sSn65xU3Zg5bDtlahAhr5merBzHZZMbKo
        7okcHqMeICmnOxpI1kLb5Bp2y321vyw8FJ+/67QC1wtdTyX6CLZcz7uxPIxRFGyI
        9pyWyD7sBASth47MGYhyc73db0bRAINBUJ4CxjcjTrcEbeP4t4QxeQc63F6C2XnI
        V1pT0cBIbq4fyRhHA98v9JS4zbSmCEUqKg5w3NgOTV2cIe8UtTDXMj+dGk5baERk
        Eq4pFrfSMGXthP3liQsPDrWWosTYScvPHKbYnO1B2J8Q8VHAZ0Mfrp7uP0x5fDdQ
        ==
X-ME-Sender: <xms:5xLcXYVNQJQ1ZdJ5KTU1hgRtbpBx0-E4pgZgMBn6XUDOcro5f0G6sw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeiuddguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:5xLcXffhLaCr9cvs0t0nMmxe4GFxiSUlaPdZKQhOcx4Wpl8H3Zri-Q>
    <xmx:5xLcXdO_tM-_mOqhqg5ILKAqFywoXNX19idollT_ZFP0gidYtANxYQ>
    <xmx:5xLcXZIUjtY3PanZWmjcD8tDpK5znXUZR77MhY74hIDV3W1Lcs9IVw>
    <xmx:6BLcXbUZO-HzIXdBDBchSg-EbXLrcv4U48C6GrYY-qiRePQ0OIO42g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8458B306005F;
        Mon, 25 Nov 2019 12:44:07 -0500 (EST)
Subject: FAILED: patch "[PATCH] virtio_console: allocate inbufs in add_port() only if it is" failed to apply to 4.9-stable tree
To:     lvivier@redhat.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Nov 2019 18:44:05 +0100
Message-ID: <15747038452146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d791cfcbf98191122af70b053a21075cb450d119 Mon Sep 17 00:00:00 2001
From: Laurent Vivier <lvivier@redhat.com>
Date: Thu, 14 Nov 2019 13:25:48 +0100
Subject: [PATCH] virtio_console: allocate inbufs in add_port() only if it is
 needed

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

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 7270e7b69262..3259426f01dc 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1325,24 +1325,24 @@ static void set_console_size(struct port *port, u16 rows, u16 cols)
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
@@ -1362,7 +1362,6 @@ static int add_port(struct ports_device *portdev, u32 id)
 	char debugfs_name[16];
 	struct port *port;
 	dev_t devt;
-	unsigned int nr_added_bufs;
 	int err;
 
 	port = kmalloc(sizeof(*port), GFP_KERNEL);
@@ -1421,11 +1420,13 @@ static int add_port(struct ports_device *portdev, u32 id)
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
 
@@ -2059,14 +2060,11 @@ static int virtcons_probe(struct virtio_device *vdev)
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
@@ -2077,7 +2075,7 @@ static int virtcons_probe(struct virtio_device *vdev)
 					   VIRTIO_CONSOLE_DEVICE_READY, 0);
 			/* Device was functional: we need full cleanup. */
 			virtcons_remove(vdev);
-			return -ENOMEM;
+			return err;
 		}
 	} else {
 		/*


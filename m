Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017C136AD74
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbhDZHgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:36:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232885AbhDZHgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C74DA61364;
        Mon, 26 Apr 2021 07:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422426;
        bh=bvdls4t8th6leIRkZnrx6Zf4Ki8gX2dLgJkvDOiN3uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSqym+WAqLgU8S5eiUtpiHlmdJyLnljvTiBYPBamjOxO1DAZh3i/mm9IDjblFSOfc
         PqF+qVtAl28cVXAfHwTBb+VQSK+jEm/qi/IDk3SlfkDzXKIeulrb+dXlVfAXvky+kM
         +EcmJkiaV5Ivo1v8shTMXwxGyQKUo+iNk3NgK87g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Tom Seewald <tseewald@gmail.com>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Subject: [PATCH 4.9 24/37] usbip: add sysfs_lock to synchronize sysfs code paths
Date:   Mon, 26 Apr 2021 09:29:25 +0200
Message-Id: <20210426072818.070293810@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072817.245304364@linuxfoundation.org>
References: <20210426072817.245304364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 4e9c93af7279b059faf5bb1897ee90512b258a12 upstream.

Fuzzing uncovered race condition between sysfs code paths in usbip
drivers. Device connect/disconnect code paths initiated through
sysfs interface are prone to races if disconnect happens during
connect and vice versa.

This problem is common to all drivers while it can be reproduced easily
in vhci_hcd. Add a sysfs_lock to usbip_device struct to protect the paths.

Use this in vhci_hcd to protect sysfs paths. For a complete fix, usip_host
and usip-vudc drivers and the event handler will have to use this lock to
protect the paths. These changes will be done in subsequent patches.

Cc: stable@vger.kernel.org # 4.9.x
Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/b6568f7beae702bbc236a545d3c020106ca75eac.1616807117.git.skhan@linuxfoundation.org
Signed-off-by: Tom Seewald <tseewald@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/usbip_common.h |    3 +++
 drivers/usb/usbip/vhci_hcd.c     |    1 +
 drivers/usb/usbip/vhci_sysfs.c   |   30 +++++++++++++++++++++++++-----
 3 files changed, 29 insertions(+), 5 deletions(-)

--- a/drivers/usb/usbip/usbip_common.h
+++ b/drivers/usb/usbip/usbip_common.h
@@ -278,6 +278,9 @@ struct usbip_device {
 	/* lock for status */
 	spinlock_t lock;
 
+	/* mutex for synchronizing sysfs store paths */
+	struct mutex sysfs_lock;
+
 	int sockfd;
 	struct socket *tcp_socket;
 
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -907,6 +907,7 @@ static void vhci_device_init(struct vhci
 	vdev->ud.side   = USBIP_VHCI;
 	vdev->ud.status = VDEV_ST_NULL;
 	spin_lock_init(&vdev->ud.lock);
+	mutex_init(&vdev->ud.sysfs_lock);
 
 	INIT_LIST_HEAD(&vdev->priv_rx);
 	INIT_LIST_HEAD(&vdev->priv_tx);
--- a/drivers/usb/usbip/vhci_sysfs.c
+++ b/drivers/usb/usbip/vhci_sysfs.c
@@ -161,6 +161,8 @@ static int vhci_port_disconnect(struct v
 
 	usbip_dbg_vhci_sysfs("enter\n");
 
+	mutex_lock(&vdev->ud.sysfs_lock);
+
 	/* lock */
 	spin_lock_irqsave(&vhci->lock, flags);
 	spin_lock(&vdev->ud.lock);
@@ -171,6 +173,7 @@ static int vhci_port_disconnect(struct v
 		/* unlock */
 		spin_unlock(&vdev->ud.lock);
 		spin_unlock_irqrestore(&vhci->lock, flags);
+		mutex_unlock(&vdev->ud.sysfs_lock);
 
 		return -EINVAL;
 	}
@@ -181,6 +184,8 @@ static int vhci_port_disconnect(struct v
 
 	usbip_event_add(&vdev->ud, VDEV_EVENT_DOWN);
 
+	mutex_unlock(&vdev->ud.sysfs_lock);
+
 	return 0;
 }
 
@@ -309,30 +314,36 @@ static ssize_t store_attach(struct devic
 	vhci = hcd_to_vhci(hcd);
 	vdev = &vhci->vdev[rhport];
 
+	mutex_lock(&vdev->ud.sysfs_lock);
+
 	/* Extract socket from fd. */
 	socket = sockfd_lookup(sockfd, &err);
 	if (!socket) {
 		dev_err(dev, "failed to lookup sock");
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock_mutex;
 	}
 	if (socket->type != SOCK_STREAM) {
 		dev_err(dev, "Expecting SOCK_STREAM - found %d",
 			socket->type);
 		sockfd_put(socket);
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock_mutex;
 	}
 
 	/* create threads before locking */
 	tcp_rx = kthread_create(vhci_rx_loop, &vdev->ud, "vhci_rx");
 	if (IS_ERR(tcp_rx)) {
 		sockfd_put(socket);
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock_mutex;
 	}
 	tcp_tx = kthread_create(vhci_tx_loop, &vdev->ud, "vhci_tx");
 	if (IS_ERR(tcp_tx)) {
 		kthread_stop(tcp_rx);
 		sockfd_put(socket);
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock_mutex;
 	}
 
 	/* get task structs now */
@@ -353,7 +364,8 @@ static ssize_t store_attach(struct devic
 		kthread_stop_put(tcp_tx);
 
 		dev_err(dev, "port %d already used\n", rhport);
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock_mutex;
 	}
 
 	dev_info(dev, "pdev(%u) rhport(%u) sockfd(%d)\n",
@@ -378,7 +390,15 @@ static ssize_t store_attach(struct devic
 
 	rh_port_connect(vdev, speed);
 
+	dev_info(dev, "Device attached\n");
+
+	mutex_unlock(&vdev->ud.sysfs_lock);
+
 	return count;
+
+unlock_mutex:
+	mutex_unlock(&vdev->ud.sysfs_lock);
+	return err;
 }
 static DEVICE_ATTR(attach, S_IWUSR, NULL, store_attach);
 



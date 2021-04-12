Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EC835BFCE
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239168AbhDLJG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239999AbhDLJE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:04:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7556D61289;
        Mon, 12 Apr 2021 09:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218128;
        bh=nD1XbmUtLI57bRf4xzb+SI/BIIQnh6f3jKjJJIW1DMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOPTy31tfqeHFkdrUrBhlDdvZ6F+SK1Cz58Kp13VtyVJ5OyqQpgbH4/2lN5MEdCWW
         w373Ppb6mAQhbMdMOljw/ppf+pBxMnUr1YrnoyxxQ+DiIQS2UUlC3tXCgAThyLdSiu
         0hEw0oPYj/mUzdZnmjHqVpfYIH6OKy+w2Gf72AiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Subject: [PATCH 5.11 080/210] usbip: add sysfs_lock to synchronize sysfs code paths
Date:   Mon, 12 Apr 2021 10:39:45 +0200
Message-Id: <20210412084018.683740022@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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

Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/b6568f7beae702bbc236a545d3c020106ca75eac.1616807117.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/usbip_common.h |    3 +++
 drivers/usb/usbip/vhci_hcd.c     |    1 +
 drivers/usb/usbip/vhci_sysfs.c   |   30 +++++++++++++++++++++++++-----
 3 files changed, 29 insertions(+), 5 deletions(-)

--- a/drivers/usb/usbip/usbip_common.h
+++ b/drivers/usb/usbip/usbip_common.h
@@ -263,6 +263,9 @@ struct usbip_device {
 	/* lock for status */
 	spinlock_t lock;
 
+	/* mutex for synchronizing sysfs store paths */
+	struct mutex sysfs_lock;
+
 	int sockfd;
 	struct socket *tcp_socket;
 
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -1101,6 +1101,7 @@ static void vhci_device_init(struct vhci
 	vdev->ud.side   = USBIP_VHCI;
 	vdev->ud.status = VDEV_ST_NULL;
 	spin_lock_init(&vdev->ud.lock);
+	mutex_init(&vdev->ud.sysfs_lock);
 
 	INIT_LIST_HEAD(&vdev->priv_rx);
 	INIT_LIST_HEAD(&vdev->priv_tx);
--- a/drivers/usb/usbip/vhci_sysfs.c
+++ b/drivers/usb/usbip/vhci_sysfs.c
@@ -185,6 +185,8 @@ static int vhci_port_disconnect(struct v
 
 	usbip_dbg_vhci_sysfs("enter\n");
 
+	mutex_lock(&vdev->ud.sysfs_lock);
+
 	/* lock */
 	spin_lock_irqsave(&vhci->lock, flags);
 	spin_lock(&vdev->ud.lock);
@@ -195,6 +197,7 @@ static int vhci_port_disconnect(struct v
 		/* unlock */
 		spin_unlock(&vdev->ud.lock);
 		spin_unlock_irqrestore(&vhci->lock, flags);
+		mutex_unlock(&vdev->ud.sysfs_lock);
 
 		return -EINVAL;
 	}
@@ -205,6 +208,8 @@ static int vhci_port_disconnect(struct v
 
 	usbip_event_add(&vdev->ud, VDEV_EVENT_DOWN);
 
+	mutex_unlock(&vdev->ud.sysfs_lock);
+
 	return 0;
 }
 
@@ -349,30 +354,36 @@ static ssize_t attach_store(struct devic
 	else
 		vdev = &vhci->vhci_hcd_hs->vdev[rhport];
 
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
@@ -397,7 +408,8 @@ static ssize_t attach_store(struct devic
 		 * Will be retried from userspace
 		 * if there's another free port.
 		 */
-		return -EBUSY;
+		err = -EBUSY;
+		goto unlock_mutex;
 	}
 
 	dev_info(dev, "pdev(%u) rhport(%u) sockfd(%d)\n",
@@ -422,7 +434,15 @@ static ssize_t attach_store(struct devic
 
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
 static DEVICE_ATTR_WO(attach);
 



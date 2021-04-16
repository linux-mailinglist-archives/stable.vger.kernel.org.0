Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689473629A7
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 22:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbhDPUyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 16:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbhDPUx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 16:53:58 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D11C061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 13:53:32 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 92-20020a9d02e50000b029028fcc3d2c9eso4449198otl.0
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 13:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FI4INRVT2Pj8fXtTpAiz4l6HCcKpyf7chOv8uNKovyU=;
        b=m0PN7EA+Psvol027YrlObVbCokG9mw2JZYL7QWbwXKK55rIODbdm9aw1U9MfZ+dPYW
         nz5iRzNfOM529tkmK0XryVEby24Xm5hWww9U8Er6jExLQuDSSNBHbBbhxjV2/7hg6s9K
         FKbAlhWWtyd800YJ/kHWxcnI1qtK49Obq3m0lDO+0b1b0oJMNh3CM/fkJ7LoSpelE9+M
         wlUltoaSb2a+iHp6CEd3I2ttIsO3YL705gw1JxmbxsA86ZDAfBOXY591hWjztQ/HYu3j
         EcVte9xdE+cKzeduFovJG7BgUBDJl9T5/kDi5cu30WKyMp7CHQTzSxEh0PH2NRAyMieA
         f2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FI4INRVT2Pj8fXtTpAiz4l6HCcKpyf7chOv8uNKovyU=;
        b=o29bdKAnrN0VRNbG9ypVrguJ/NvM5F41gHV40dJ1S7ci5fYsmiC58hC+x7qaWSpkbx
         PmpeUwtYLSl0NQSztC1UlBQmamQyoeonZ26Y9xTWVl3xemgHpRsCC3Lwoit3x7e/d3LW
         25rVhjfm+8bCltDFDKuAjNF+9XUq4rZotLnntGFNC6TKUne3+0USNISejj0TnCJ9wfhe
         5nzy7GPvT6FgE2tjLC5+71gAfHkyNOSUUzft/yNO70WK3AcP47n2z7x19lFKA0UckKAl
         yldEgpZ8uXbzXc9WYYdtUelBjxKR12QKsTgdKCa59VvAWlElAxV/4AfLiI0m1kNTsiXJ
         3Q2g==
X-Gm-Message-State: AOAM530Fsf+BhrjLJ0Y9eP/LLhpc2lZ2P2OkDYM4EhxHn3RrcMEEtNBf
        kSYi/Wl4n2SLFoaDjlwpIs2St91CcNUrik1V
X-Google-Smtp-Source: ABdhPJzdzI4zuBbl1cyHE6jwswu+ZL4buASKlammCfaY52ym4cZt1xiDD9l6QLryisoi6GUnYYBSmA==
X-Received: by 2002:a9d:1c9d:: with SMTP id l29mr5116609ota.372.1618606411167;
        Fri, 16 Apr 2021 13:53:31 -0700 (PDT)
Received: from proxmox.local.lan (2603-80a0-0e01-cc2f-0226-b9ff-fe41-ba6b.res6.spectrum.com. [2603:80a0:e01:cc2f:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id c21sm1440847ooa.48.2021.04.16.13.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 13:53:30 -0700 (PDT)
From:   Tom Seewald <tseewald@gmail.com>
To:     stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tom Seewald <tseewald@gmail.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Subject: [PATCH 1/4] usbip: add sysfs_lock to synchronize sysfs code paths
Date:   Fri, 16 Apr 2021 15:53:16 -0500
Message-Id: <20210416205319.14075-1-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Tom Seewald <tseewald@gmail.com>
---
 drivers/usb/usbip/usbip_common.h |  3 +++
 drivers/usb/usbip/vhci_hcd.c     |  1 +
 drivers/usb/usbip/vhci_sysfs.c   | 30 +++++++++++++++++++++++++-----
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/usbip/usbip_common.h b/drivers/usb/usbip/usbip_common.h
index 0b199a2664c0..3d47c681aea2 100644
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
 
diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
index 8bda6455dfcb..fb7b03029b8e 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -907,6 +907,7 @@ static void vhci_device_init(struct vhci_device *vdev)
 	vdev->ud.side   = USBIP_VHCI;
 	vdev->ud.status = VDEV_ST_NULL;
 	spin_lock_init(&vdev->ud.lock);
+	mutex_init(&vdev->ud.sysfs_lock);
 
 	INIT_LIST_HEAD(&vdev->priv_rx);
 	INIT_LIST_HEAD(&vdev->priv_tx);
diff --git a/drivers/usb/usbip/vhci_sysfs.c b/drivers/usb/usbip/vhci_sysfs.c
index ca00d38d22af..3496b402aa1b 100644
--- a/drivers/usb/usbip/vhci_sysfs.c
+++ b/drivers/usb/usbip/vhci_sysfs.c
@@ -161,6 +161,8 @@ static int vhci_port_disconnect(struct vhci_hcd *vhci, __u32 rhport)
 
 	usbip_dbg_vhci_sysfs("enter\n");
 
+	mutex_lock(&vdev->ud.sysfs_lock);
+
 	/* lock */
 	spin_lock_irqsave(&vhci->lock, flags);
 	spin_lock(&vdev->ud.lock);
@@ -171,6 +173,7 @@ static int vhci_port_disconnect(struct vhci_hcd *vhci, __u32 rhport)
 		/* unlock */
 		spin_unlock(&vdev->ud.lock);
 		spin_unlock_irqrestore(&vhci->lock, flags);
+		mutex_unlock(&vdev->ud.sysfs_lock);
 
 		return -EINVAL;
 	}
@@ -181,6 +184,8 @@ static int vhci_port_disconnect(struct vhci_hcd *vhci, __u32 rhport)
 
 	usbip_event_add(&vdev->ud, VDEV_EVENT_DOWN);
 
+	mutex_unlock(&vdev->ud.sysfs_lock);
+
 	return 0;
 }
 
@@ -309,30 +314,36 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
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
@@ -353,7 +364,8 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
 		kthread_stop_put(tcp_tx);
 
 		dev_err(dev, "port %d already used\n", rhport);
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock_mutex;
 	}
 
 	dev_info(dev, "pdev(%u) rhport(%u) sockfd(%d)\n",
@@ -378,7 +390,15 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
 
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
 
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCCD2B64ED
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732217AbgKQNby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:31:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731609AbgKQNbu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:31:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36A0D207BC;
        Tue, 17 Nov 2020 13:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619908;
        bh=Mt69135e1oi6Zy6gjvQ/+941SEt9u4XvZhiHgz0TAtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBgzPuNfNKWTt6kS88V+y/SYKtUynxyK3QB7eXxzVzjGy2779ywu7LEEg0miYGoW/
         zkldwqpNFPjlkTZ40sWa9mHhbygGf4nKmm6WpBTDyAvGEeSuGTjizTwihu9pusYqrI
         AbmPiYbdm1aqvCOUD+t7s8wAN+ezwhEjMPIQEtek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Pilcher <arequipeno@gmail.com>,
        Justin Gatzen <justin.gatzen@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 044/255] vfio/pci: Implement ioeventfd thread handler for contended memory lock
Date:   Tue, 17 Nov 2020 14:03:04 +0100
Message-Id: <20201117122141.095356131@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 38565c93c8a1306dc5f245572a545fbea908ac41 ]

The ioeventfd is called under spinlock with interrupts disabled,
therefore if the memory lock is contended defer code that might
sleep to a thread context.

Fixes: bc93b9ae0151 ("vfio-pci: Avoid recursive read-lock usage")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=209253#c1
Reported-by: Ian Pilcher <arequipeno@gmail.com>
Tested-by: Ian Pilcher <arequipeno@gmail.com>
Tested-by: Justin Gatzen <justin.gatzen@gmail.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 43 ++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 9e353c484ace2..a0b5fc8e46f4d 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -356,34 +356,60 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 	return done;
 }
 
-static int vfio_pci_ioeventfd_handler(void *opaque, void *unused)
+static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
+					bool test_mem)
 {
-	struct vfio_pci_ioeventfd *ioeventfd = opaque;
-
 	switch (ioeventfd->count) {
 	case 1:
-		vfio_pci_iowrite8(ioeventfd->vdev, ioeventfd->test_mem,
+		vfio_pci_iowrite8(ioeventfd->vdev, test_mem,
 				  ioeventfd->data, ioeventfd->addr);
 		break;
 	case 2:
-		vfio_pci_iowrite16(ioeventfd->vdev, ioeventfd->test_mem,
+		vfio_pci_iowrite16(ioeventfd->vdev, test_mem,
 				   ioeventfd->data, ioeventfd->addr);
 		break;
 	case 4:
-		vfio_pci_iowrite32(ioeventfd->vdev, ioeventfd->test_mem,
+		vfio_pci_iowrite32(ioeventfd->vdev, test_mem,
 				   ioeventfd->data, ioeventfd->addr);
 		break;
 #ifdef iowrite64
 	case 8:
-		vfio_pci_iowrite64(ioeventfd->vdev, ioeventfd->test_mem,
+		vfio_pci_iowrite64(ioeventfd->vdev, test_mem,
 				   ioeventfd->data, ioeventfd->addr);
 		break;
 #endif
 	}
+}
+
+static int vfio_pci_ioeventfd_handler(void *opaque, void *unused)
+{
+	struct vfio_pci_ioeventfd *ioeventfd = opaque;
+	struct vfio_pci_device *vdev = ioeventfd->vdev;
+
+	if (ioeventfd->test_mem) {
+		if (!down_read_trylock(&vdev->memory_lock))
+			return 1; /* Lock contended, use thread */
+		if (!__vfio_pci_memory_enabled(vdev)) {
+			up_read(&vdev->memory_lock);
+			return 0;
+		}
+	}
+
+	vfio_pci_ioeventfd_do_write(ioeventfd, false);
+
+	if (ioeventfd->test_mem)
+		up_read(&vdev->memory_lock);
 
 	return 0;
 }
 
+static void vfio_pci_ioeventfd_thread(void *opaque, void *unused)
+{
+	struct vfio_pci_ioeventfd *ioeventfd = opaque;
+
+	vfio_pci_ioeventfd_do_write(ioeventfd, ioeventfd->test_mem);
+}
+
 long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 			uint64_t data, int count, int fd)
 {
@@ -457,7 +483,8 @@ long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 	ioeventfd->test_mem = vdev->pdev->resource[bar].flags & IORESOURCE_MEM;
 
 	ret = vfio_virqfd_enable(ioeventfd, vfio_pci_ioeventfd_handler,
-				 NULL, NULL, &ioeventfd->virqfd, fd);
+				 vfio_pci_ioeventfd_thread, NULL,
+				 &ioeventfd->virqfd, fd);
 	if (ret) {
 		kfree(ioeventfd);
 		goto out_unlock;
-- 
2.27.0




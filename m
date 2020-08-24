Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059FC24FA62
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgHXIgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:36:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728226AbgHXIgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:36:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6443204FD;
        Mon, 24 Aug 2020 08:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258180;
        bh=est7SGQG0fblsWK2YX33ulc92bM7hIZ3xQWuUtc6svA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6MlHWy6IOIjNz3qHkh5L3jaSauiFVXIzvUc+7l3rZd2F3+welEk2jTPRVvDVR/H5
         Cq0boS+YrhUayrSflj1VCche13LUKM1CZkg0tLd6b5/60jkdy6ZMzSyzoA8/S2J352
         YUNq+vJ4KzwpLpEntRuysjkPlsDmf5ZYlHHCZ+hA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhiyi Guo <zhguo@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 103/148] vfio-pci: Avoid recursive read-lock usage
Date:   Mon, 24 Aug 2020 10:30:01 +0200
Message-Id: <20200824082418.965556568@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit bc93b9ae0151ae5ad5b8504cdc598428ea99570b ]

A down_read on memory_lock is held when performing read/write accesses
to MMIO BAR space, including across the copy_to/from_user() callouts
which may fault.  If the user buffer for these copies resides in an
mmap of device MMIO space, the mmap fault handler will acquire a
recursive read-lock on memory_lock.  Avoid this by reducing the lock
granularity.  Sequential accesses requiring multiple ioread/iowrite
cycles are expected to be rare, therefore typical accesses should not
see additional overhead.

VGA MMIO accesses are expected to be non-fatal regardless of the PCI
memory enable bit to allow legacy probing, this behavior remains with
a comment added.  ioeventfds are now included in memory access testing,
with writes dropped while memory space is disabled.

Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
Reported-by: Zhiyi Guo <zhguo@redhat.com>
Tested-by: Zhiyi Guo <zhguo@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_private.h |   2 +
 drivers/vfio/pci/vfio_pci_rdwr.c    | 120 ++++++++++++++++++++++------
 2 files changed, 98 insertions(+), 24 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 86a02aff8735f..61ca8ab165dc1 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -33,12 +33,14 @@
 
 struct vfio_pci_ioeventfd {
 	struct list_head	next;
+	struct vfio_pci_device	*vdev;
 	struct virqfd		*virqfd;
 	void __iomem		*addr;
 	uint64_t		data;
 	loff_t			pos;
 	int			bar;
 	int			count;
+	bool			test_mem;
 };
 
 struct vfio_pci_irq_ctx {
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 916b184df3a5b..9e353c484ace2 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -37,17 +37,70 @@
 #define vfio_ioread8	ioread8
 #define vfio_iowrite8	iowrite8
 
+#define VFIO_IOWRITE(size) \
+static int vfio_pci_iowrite##size(struct vfio_pci_device *vdev,		\
+			bool test_mem, u##size val, void __iomem *io)	\
+{									\
+	if (test_mem) {							\
+		down_read(&vdev->memory_lock);				\
+		if (!__vfio_pci_memory_enabled(vdev)) {			\
+			up_read(&vdev->memory_lock);			\
+			return -EIO;					\
+		}							\
+	}								\
+									\
+	vfio_iowrite##size(val, io);					\
+									\
+	if (test_mem)							\
+		up_read(&vdev->memory_lock);				\
+									\
+	return 0;							\
+}
+
+VFIO_IOWRITE(8)
+VFIO_IOWRITE(16)
+VFIO_IOWRITE(32)
+#ifdef iowrite64
+VFIO_IOWRITE(64)
+#endif
+
+#define VFIO_IOREAD(size) \
+static int vfio_pci_ioread##size(struct vfio_pci_device *vdev,		\
+			bool test_mem, u##size *val, void __iomem *io)	\
+{									\
+	if (test_mem) {							\
+		down_read(&vdev->memory_lock);				\
+		if (!__vfio_pci_memory_enabled(vdev)) {			\
+			up_read(&vdev->memory_lock);			\
+			return -EIO;					\
+		}							\
+	}								\
+									\
+	*val = vfio_ioread##size(io);					\
+									\
+	if (test_mem)							\
+		up_read(&vdev->memory_lock);				\
+									\
+	return 0;							\
+}
+
+VFIO_IOREAD(8)
+VFIO_IOREAD(16)
+VFIO_IOREAD(32)
+
 /*
  * Read or write from an __iomem region (MMIO or I/O port) with an excluded
  * range which is inaccessible.  The excluded range drops writes and fills
  * reads with -1.  This is intended for handling MSI-X vector tables and
  * leftover space for ROM BARs.
  */
-static ssize_t do_io_rw(void __iomem *io, char __user *buf,
+static ssize_t do_io_rw(struct vfio_pci_device *vdev, bool test_mem,
+			void __iomem *io, char __user *buf,
 			loff_t off, size_t count, size_t x_start,
 			size_t x_end, bool iswrite)
 {
 	ssize_t done = 0;
+	int ret;
 
 	while (count) {
 		size_t fillable, filled;
@@ -66,9 +119,15 @@ static ssize_t do_io_rw(void __iomem *io, char __user *buf,
 				if (copy_from_user(&val, buf, 4))
 					return -EFAULT;
 
-				vfio_iowrite32(val, io + off);
+				ret = vfio_pci_iowrite32(vdev, test_mem,
+							 val, io + off);
+				if (ret)
+					return ret;
 			} else {
-				val = vfio_ioread32(io + off);
+				ret = vfio_pci_ioread32(vdev, test_mem,
+							&val, io + off);
+				if (ret)
+					return ret;
 
 				if (copy_to_user(buf, &val, 4))
 					return -EFAULT;
@@ -82,9 +141,15 @@ static ssize_t do_io_rw(void __iomem *io, char __user *buf,
 				if (copy_from_user(&val, buf, 2))
 					return -EFAULT;
 
-				vfio_iowrite16(val, io + off);
+				ret = vfio_pci_iowrite16(vdev, test_mem,
+							 val, io + off);
+				if (ret)
+					return ret;
 			} else {
-				val = vfio_ioread16(io + off);
+				ret = vfio_pci_ioread16(vdev, test_mem,
+							&val, io + off);
+				if (ret)
+					return ret;
 
 				if (copy_to_user(buf, &val, 2))
 					return -EFAULT;
@@ -98,9 +163,15 @@ static ssize_t do_io_rw(void __iomem *io, char __user *buf,
 				if (copy_from_user(&val, buf, 1))
 					return -EFAULT;
 
-				vfio_iowrite8(val, io + off);
+				ret = vfio_pci_iowrite8(vdev, test_mem,
+							val, io + off);
+				if (ret)
+					return ret;
 			} else {
-				val = vfio_ioread8(io + off);
+				ret = vfio_pci_ioread8(vdev, test_mem,
+						       &val, io + off);
+				if (ret)
+					return ret;
 
 				if (copy_to_user(buf, &val, 1))
 					return -EFAULT;
@@ -178,14 +249,6 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 
 	count = min(count, (size_t)(end - pos));
 
-	if (res->flags & IORESOURCE_MEM) {
-		down_read(&vdev->memory_lock);
-		if (!__vfio_pci_memory_enabled(vdev)) {
-			up_read(&vdev->memory_lock);
-			return -EIO;
-		}
-	}
-
 	if (bar == PCI_ROM_RESOURCE) {
 		/*
 		 * The ROM can fill less space than the BAR, so we start the
@@ -213,7 +276,8 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 		x_end = vdev->msix_offset + vdev->msix_size;
 	}
 
-	done = do_io_rw(io, buf, pos, count, x_start, x_end, iswrite);
+	done = do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
+			count, x_start, x_end, iswrite);
 
 	if (done >= 0)
 		*ppos += done;
@@ -221,9 +285,6 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 	if (bar == PCI_ROM_RESOURCE)
 		pci_unmap_rom(pdev, io);
 out:
-	if (res->flags & IORESOURCE_MEM)
-		up_read(&vdev->memory_lock);
-
 	return done;
 }
 
@@ -278,7 +339,12 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 		return ret;
 	}
 
-	done = do_io_rw(iomem, buf, off, count, 0, 0, iswrite);
+	/*
+	 * VGA MMIO is a legacy, non-BAR resource that hopefully allows
+	 * probing, so we don't currently worry about access in relation
+	 * to the memory enable bit in the command register.
+	 */
+	done = do_io_rw(vdev, false, iomem, buf, off, count, 0, 0, iswrite);
 
 	vga_put(vdev->pdev, rsrc);
 
@@ -296,17 +362,21 @@ static int vfio_pci_ioeventfd_handler(void *opaque, void *unused)
 
 	switch (ioeventfd->count) {
 	case 1:
-		vfio_iowrite8(ioeventfd->data, ioeventfd->addr);
+		vfio_pci_iowrite8(ioeventfd->vdev, ioeventfd->test_mem,
+				  ioeventfd->data, ioeventfd->addr);
 		break;
 	case 2:
-		vfio_iowrite16(ioeventfd->data, ioeventfd->addr);
+		vfio_pci_iowrite16(ioeventfd->vdev, ioeventfd->test_mem,
+				   ioeventfd->data, ioeventfd->addr);
 		break;
 	case 4:
-		vfio_iowrite32(ioeventfd->data, ioeventfd->addr);
+		vfio_pci_iowrite32(ioeventfd->vdev, ioeventfd->test_mem,
+				   ioeventfd->data, ioeventfd->addr);
 		break;
 #ifdef iowrite64
 	case 8:
-		vfio_iowrite64(ioeventfd->data, ioeventfd->addr);
+		vfio_pci_iowrite64(ioeventfd->vdev, ioeventfd->test_mem,
+				   ioeventfd->data, ioeventfd->addr);
 		break;
 #endif
 	}
@@ -378,11 +448,13 @@ long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 		goto out_unlock;
 	}
 
+	ioeventfd->vdev = vdev;
 	ioeventfd->addr = vdev->barmap[bar] + pos;
 	ioeventfd->data = data;
 	ioeventfd->pos = pos;
 	ioeventfd->bar = bar;
 	ioeventfd->count = count;
+	ioeventfd->test_mem = vdev->pdev->resource[bar].flags & IORESOURCE_MEM;
 
 	ret = vfio_virqfd_enable(ioeventfd, vfio_pci_ioeventfd_handler,
 				 NULL, NULL, &ioeventfd->virqfd, fd);
-- 
2.25.1




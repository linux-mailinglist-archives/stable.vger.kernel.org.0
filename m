Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2672E9968
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbhADP7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:59:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727911AbhADP7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:59:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC4DA22509;
        Mon,  4 Jan 2021 15:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775906;
        bh=9uabOt3IJz6vfocy9/UKNGALFASkXfczEZd3cN3lQ6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NM9KUqCNsMtswPHKDieDBBzg6Ky59g6Zxxbe3ia7w/px6jWSUvze0DgiTZngjCMna
         vNp9RUTzlu0pyQ7vdqDUz6E3oyz2AFfzN/E+w9pS44noQoXGOs39RKI+pazMmnT400
         poCgBcNggFMNazUbO/nyu3WY9qZErjdpEpvknQDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/35] vfio/pci: Move dummy_resources_list init in vfio_pci_probe()
Date:   Mon,  4 Jan 2021 16:57:09 +0100
Message-Id: <20210104155703.698976948@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155703.375788488@linuxfoundation.org>
References: <20210104155703.375788488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

[ Upstream commit 16b8fe4caf499ae8e12d2ab1b1324497e36a7b83 ]

In case an error occurs in vfio_pci_enable() before the call to
vfio_pci_probe_mmaps(), vfio_pci_disable() will  try to iterate
on an uninitialized list and cause a kernel panic.

Lets move to the initialization to vfio_pci_probe() to fix the
issue.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Fixes: 05f0c03fbac1 ("vfio-pci: Allow to mmap sub-page MMIO BARs if the mmio page is exclusive")
CC: Stable <stable@vger.kernel.org> # v4.7+
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 5e23e4aa5b0a3..c48e1d84efb6b 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -118,8 +118,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 	int bar;
 	struct vfio_pci_dummy_resource *dummy_res;
 
-	INIT_LIST_HEAD(&vdev->dummy_resources_list);
-
 	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
 		res = vdev->pdev->resource + bar;
 
@@ -1522,6 +1520,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&vdev->igate);
 	spin_lock_init(&vdev->irqlock);
 	mutex_init(&vdev->ioeventfds_lock);
+	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	mutex_init(&vdev->vma_lock);
 	INIT_LIST_HEAD(&vdev->vma_list);
-- 
2.27.0




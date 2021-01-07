Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2382ED2BE
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbhAGOhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729173AbhAGOcF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:32:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ED69233EA;
        Thu,  7 Jan 2021 14:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029893;
        bh=X6Rf5+F9NCddo6q7+z2kw4bOkqXsMsmKVrRg2mOe4bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1FrvgfQXIx9A5uk3bPdRObyrBu+j/JTKnP86rSKFbI45zpe/WSutkaklAglj06PL
         2Tfowo9i/F4cfdF4p+XnR2pdZ1ng72wK5u9yNFDSLZb3ZIqETlcMOj8QED/aJ7mZlm
         9YIhl51Q4iSRhJF2RpFe1f/Y+2G9AvRUY8VjTfkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/29] vfio/pci: Move dummy_resources_list init in vfio_pci_probe()
Date:   Thu,  7 Jan 2021 15:31:24 +0100
Message-Id: <20210107143054.267705062@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.973437064@linuxfoundation.org>
References: <20210107143052.973437064@linuxfoundation.org>
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
index 6fceefcab81db..dedc7edea5178 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -118,8 +118,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 	int bar;
 	struct vfio_pci_dummy_resource *dummy_res;
 
-	INIT_LIST_HEAD(&vdev->dummy_resources_list);
-
 	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
 		res = vdev->pdev->resource + bar;
 
@@ -1524,6 +1522,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	mutex_init(&vdev->igate);
 	spin_lock_init(&vdev->irqlock);
+	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	mutex_init(&vdev->vma_lock);
 	INIT_LIST_HEAD(&vdev->vma_list);
 	init_rwsem(&vdev->memory_lock);
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0049F10BA9F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbfK0VFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:05:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732228AbfK0VE7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:04:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 661412166E;
        Wed, 27 Nov 2019 21:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888698;
        bh=fD3i4LF56F5nF67qI1WpmKo+F44vFHcpbntZ+Ul8q2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLoSy5Cmo4tckbcgd9PLFtH0lf20zk16shtFQE6bFiwUuRBef0ritpk8FxpJq31H1
         rmHJmV0bCW99DfptZazYfIyteqNUbOJVbG4NTvorPkgJ3/eRQTZLgnoJ6+aR0j3YRH
         JPywK1NezUsWbfdyLqn0efjt9/GV5MZg9xt3HZaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <keith.busch@intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 192/306] nvme-pci: fix conflicting p2p resource adds
Date:   Wed, 27 Nov 2019 21:30:42 +0100
Message-Id: <20191127203129.250504127@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <keith.busch@intel.com>

[ Upstream commit 9fe5c59ff6a1e5e26a39b75489a1420e7eaaf0b1 ]

The nvme pci driver had been adding its CMB resource to the P2P DMA
subsystem everytime on on a controller reset. This results in the
following warning:

    ------------[ cut here ]------------
    nvme 0000:00:03.0: Conflicting mapping in same section
    WARNING: CPU: 7 PID: 81 at kernel/memremap.c:155 devm_memremap_pages+0xa6/0x380
    ...
    Call Trace:
     pci_p2pdma_add_resource+0x153/0x370
     nvme_reset_work+0x28c/0x17b1 [nvme]
     ? add_timer+0x107/0x1e0
     ? dequeue_entity+0x81/0x660
     ? dequeue_entity+0x3b0/0x660
     ? pick_next_task_fair+0xaf/0x610
     ? __switch_to+0xbc/0x410
     process_one_work+0x1cf/0x350
     worker_thread+0x215/0x3d0
     ? process_one_work+0x350/0x350
     kthread+0x107/0x120
     ? kthread_park+0x80/0x80
     ret_from_fork+0x1f/0x30
    ---[ end trace f7ea76ac6ee72727 ]---
    nvme nvme0: failed to register the CMB

This patch fixes this by registering the CMB with P2P only once.

Signed-off-by: Keith Busch <keith.busch@intel.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 9479c0db08f62..124f41157173e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1652,6 +1652,9 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
 	int bar;
 
+	if (dev->cmb_size)
+		return;
+
 	dev->cmbsz = readl(dev->bar + NVME_REG_CMBSZ);
 	if (!dev->cmbsz)
 		return;
@@ -2136,7 +2139,6 @@ static void nvme_pci_disable(struct nvme_dev *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
 
-	nvme_release_cmb(dev);
 	pci_free_irq_vectors(pdev);
 
 	if (pci_is_enabled(pdev)) {
@@ -2595,6 +2597,7 @@ static void nvme_remove(struct pci_dev *pdev)
 	nvme_stop_ctrl(&dev->ctrl);
 	nvme_remove_namespaces(&dev->ctrl);
 	nvme_dev_disable(dev, true);
+	nvme_release_cmb(dev);
 	nvme_free_host_mem(dev);
 	nvme_dev_remove_admin(dev);
 	nvme_free_queues(dev, 0);
-- 
2.20.1




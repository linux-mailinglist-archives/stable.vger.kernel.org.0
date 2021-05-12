Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69DB37C92E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238767AbhELQPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233346AbhELQIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:08:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70D0C61997;
        Wed, 12 May 2021 15:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833955;
        bh=IctrLuusrI9vVJ9a28zso74mmzrptNV6lJ3aTrhRA5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c09xVk3Yw9Vtf9xGzyXbSt5uS+7tzbjCMf5lLhT/HdWlHTBZhaiBkJJ/3VAXUvS4a
         JDuAh1kM7sQ65r0ZtAmZH+LtnFL6ExAi8Ry/5cGzIZw5I8zbFW+Hkb2MGfRyUJGAmg
         d3ivFJsYpjngcPzfD7vvWOGkdDetfHdp0xq00E+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 353/601] vfio/pci: Re-order vfio_pci_probe()
Date:   Wed, 12 May 2021 16:47:10 +0200
Message-Id: <20210512144839.416834070@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 4aeec3984ddc853f7c65903bde472ffdef738bae ]

vfio_add_group_dev() must be called only after all of the private data in
vdev is fully setup and ready, otherwise there could be races with user
space instantiating a device file descriptor and starting to call ops.

For instance vfio_pci_reflck_attach() sets vdev->reflck and
vfio_pci_open(), called by fops open, unconditionally derefs it, which
will crash if things get out of order.

Fixes: cc20d7999000 ("vfio/pci: Introduce VF token")
Fixes: e309df5b0c9e ("vfio/pci: Parallelize device open and release")
Fixes: 6eb7018705de ("vfio-pci: Move idle devices to D3hot power state")
Fixes: ecaa1f6a0154 ("vfio-pci: Add VGA arbiter client")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Message-Id: <8-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index f31aa25f361c..48b048edf1ee 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -2034,13 +2034,9 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&vdev->vma_list);
 	init_rwsem(&vdev->memory_lock);
 
-	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
-	if (ret)
-		goto out_free;
-
 	ret = vfio_pci_reflck_attach(vdev);
 	if (ret)
-		goto out_del_group_dev;
+		goto out_free;
 	ret = vfio_pci_vf_init(vdev);
 	if (ret)
 		goto out_reflck;
@@ -2064,15 +2060,20 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 	}
 
-	return ret;
+	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
+	if (ret)
+		goto out_power;
+	return 0;
 
+out_power:
+	if (!disable_idle_d3)
+		vfio_pci_set_power_state(vdev, PCI_D0);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
 out_reflck:
 	vfio_pci_reflck_put(vdev->reflck);
-out_del_group_dev:
-	vfio_del_group_dev(&pdev->dev);
 out_free:
+	kfree(vdev->pm_save);
 	kfree(vdev);
 out_group_put:
 	vfio_iommu_group_put(group, &pdev->dev);
-- 
2.30.2




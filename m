Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEA5FED30
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbfKPPmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:42:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbfKPPmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:38 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 455FF207DD;
        Sat, 16 Nov 2019 15:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918957;
        bh=omppKKnMzlwMUO/lGjPYMr5FWF7KOGGvHMhEJD4Ko/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Aw2TMS6s/4lnKh+mMRRIBqj2uBDvEkNbne/B+xhXm974eBM3O22Y8C2IHtM0DDXo
         bdxBOd1WmXVgA31fwJS16M6gzyai6PGGjho4mrcFmFyr2tn5bpGLOIW33v6HHWEEuM
         skYN26IUtYRmkVB4vzNLMpMc+5kSZYzJZHIYB8Yo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Derrick <jonathan.derrick@intel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Keith Busch <keith.busch@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 076/237] PCI: vmd: Detach resources after stopping root bus
Date:   Sat, 16 Nov 2019 10:38:31 -0500
Message-Id: <20191116154113.7417-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

[ Upstream commit dc8af3a827df6d4bb925d3b81b7ec94a7cce9482 ]

The VMD removal path calls pci_stop_root_busi(), which tears down the pcie
tree, including detaching all of the attached drivers. During driver
detachment, devices may use pci_release_region() to release resources.
This path relies on the resource being accessible in resource tree.

By detaching the child domain from the parent resource domain prior to
stopping the bus, we are preventing the list traversal from finding the
resource to be freed. If we instead detach the resource after stopping
the bus, we will have properly freed the resource and detaching is
simply accounting at that point.

Without this order, the resource is never freed and is orphaned on VMD
removal, leading to a warning:

[  181.940162] Trying to free nonexistent resource <e5a10000-e5a13fff>

Fixes: 2c2c5c5cd213 ("x86/PCI: VMD: Attach VMD resources to parent domain's resource tree")
Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
[lorenzo.pieralisi@arm.com: updated commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index 65eaa6b618685..ab36e5ca1aca3 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -818,12 +818,12 @@ static void vmd_remove(struct pci_dev *dev)
 {
 	struct vmd_dev *vmd = pci_get_drvdata(dev);
 
-	vmd_detach_resources(vmd);
 	sysfs_remove_link(&vmd->dev->dev.kobj, "domain");
 	pci_stop_root_bus(vmd->bus);
 	pci_remove_root_bus(vmd->bus);
 	vmd_cleanup_srcu(vmd);
 	vmd_teardown_dma_ops(vmd);
+	vmd_detach_resources(vmd);
 	irq_domain_remove(vmd->irq_domain);
 }
 
-- 
2.20.1


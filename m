Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4648382FCD
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbhEQOUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:20:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239133AbhEQOSt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:18:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1082613AF;
        Mon, 17 May 2021 14:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260640;
        bh=LHbAARHTedA2/v4hrm2YrX6wgYt8bojWAYV82dByK94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVdLOe8ITYiXsEkvOO3s7TbIVfD6MzojYymkFdDBHOWLxctGQT2figGKnG55ZltGp
         DNfzOYisevo22hNwLOc8sfve2yPNcVY2HcSWzp/VOKaxsL3ehmgfhnW72E9k0gzHdQ
         3uQ3uvD4yOD7/IWshsIjf91uJNRXUTLlRiY5u8mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 172/363] dmaengine: idxd: use ida for device instance enumeration
Date:   Mon, 17 May 2021 16:00:38 +0200
Message-Id: <20210517140308.419999099@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit f7f7739847bd68b3c3103fd1b50d943038bd14c7 ]

The idr is only used for an device id, never to lookup context from that
id. Switch to plain ida.

Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/161852984730.2203940.15032482460902003819.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/init.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 11a2e14b5b80..a4f0489515b4 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -34,8 +34,7 @@ MODULE_PARM_DESC(sva, "Toggle SVA support on/off");
 
 bool support_enqcmd;
 
-static struct idr idxd_idrs[IDXD_TYPE_MAX];
-static DEFINE_MUTEX(idxd_idr_lock);
+static struct ida idxd_idas[IDXD_TYPE_MAX];
 
 static struct pci_device_id idxd_pci_tbl[] = {
 	/* DSA ver 1.0 platforms */
@@ -348,12 +347,10 @@ static int idxd_probe(struct idxd_device *idxd)
 
 	dev_dbg(dev, "IDXD interrupt setup complete.\n");
 
-	mutex_lock(&idxd_idr_lock);
-	idxd->id = idr_alloc(&idxd_idrs[idxd->type], idxd, 0, 0, GFP_KERNEL);
-	mutex_unlock(&idxd_idr_lock);
+	idxd->id = ida_alloc(&idxd_idas[idxd->type], GFP_KERNEL);
 	if (idxd->id < 0) {
 		rc = -ENOMEM;
-		goto err_idr_fail;
+		goto err_ida_fail;
 	}
 
 	idxd->major = idxd_cdev_get_major(idxd);
@@ -361,7 +358,7 @@ static int idxd_probe(struct idxd_device *idxd)
 	dev_dbg(dev, "IDXD device %d probed successfully\n", idxd->id);
 	return 0;
 
- err_idr_fail:
+ err_ida_fail:
 	idxd_mask_error_interrupts(idxd);
 	idxd_mask_msix_vectors(idxd);
  err_setup:
@@ -518,9 +515,7 @@ static void idxd_remove(struct pci_dev *pdev)
 	idxd_shutdown(pdev);
 	if (device_pasid_enabled(idxd))
 		idxd_disable_system_pasid(idxd);
-	mutex_lock(&idxd_idr_lock);
-	idr_remove(&idxd_idrs[idxd->type], idxd->id);
-	mutex_unlock(&idxd_idr_lock);
+	ida_free(&idxd_idas[idxd->type], idxd->id);
 }
 
 static struct pci_driver idxd_pci_driver = {
@@ -550,7 +545,7 @@ static int __init idxd_init_module(void)
 		support_enqcmd = true;
 
 	for (i = 0; i < IDXD_TYPE_MAX; i++)
-		idr_init(&idxd_idrs[i]);
+		ida_init(&idxd_idas[i]);
 
 	err = idxd_register_bus_type();
 	if (err < 0)
-- 
2.30.2




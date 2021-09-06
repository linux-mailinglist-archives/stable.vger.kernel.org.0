Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA375401348
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239812AbhIFBY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239819AbhIFBX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:23:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83686610E7;
        Mon,  6 Sep 2021 01:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891308;
        bh=V4zQKo3zm95xUkUBmIe5IpXxDHQrL+nsc7ZQnDPEk0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJ6uQvxPmZt9uSrwRA0vRcWFkVqj0CH8LBKGm3GUlc91guuhCVxcA84jfI1y11d86
         d0PBXm/TNPey4Vkv5HJvhFQluty+H7PTxye+Z3PWEK8vjpdIT6y3NjDKBXGd0oUzgW
         YaO1jrSZ2APLpzGvEEBymmjK08GAUgjrcZ/tny8KFF0L8VKfp+SRcbyGjcC2+z1IJ7
         fyvnm7+nOXUFQ7CabE0Vs/1x4QOrMVS+oq7qISh13mYqahO/Q/p8QrYUz9WJMkBhKO
         JFQ8Mg1MxWqrqz9+GJnLvdZrKO+hUpJBKwfUoybrxQmz0PhIHstzieki6AkTCBt93y
         zbgpMOTfKtA/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 43/46] s390/pci: fix misleading rc in clp_set_pci_fn()
Date:   Sun,  5 Sep 2021 21:20:48 -0400
Message-Id: <20210906012052.929174-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012052.929174-1-sashal@kernel.org>
References: <20210906012052.929174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit f7addcdd527a6dddfebe20c358b87bdb95624612 ]

Currently clp_set_pci_fn() always returns 0 as long as the CLP request
itself succeeds even if the operation itself returns a response code
other than CLP_RC_OK or CLP_RC_SETPCIFN_ALRDY. This is highly misleading
because calling code assumes that a zero rc means that the operation was
successful.

Fix this by returning the response code or cc on failure with the
exception of the special handling for CLP_RC_SETPCIFN_ALRDY. Also let's
not assume that the returned function handle for CLP_RC_SETPCIFN_ALRDY
is 0, we don't need it anyway.

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci.c     |  7 ++++---
 arch/s390/pci/pci_clp.c | 33 ++++++++++++++++-----------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 8fcb7ecb7225..77cd965cffef 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -661,9 +661,10 @@ int zpci_enable_device(struct zpci_dev *zdev)
 {
 	int rc;
 
-	rc = clp_enable_fh(zdev, ZPCI_NR_DMA_SPACES);
-	if (rc)
+	if (clp_enable_fh(zdev, ZPCI_NR_DMA_SPACES)) {
+		rc = -EIO;
 		goto out;
+	}
 
 	rc = zpci_dma_init_device(zdev);
 	if (rc)
@@ -684,7 +685,7 @@ int zpci_disable_device(struct zpci_dev *zdev)
 	 * The zPCI function may already be disabled by the platform, this is
 	 * detected in clp_disable_fh() which becomes a no-op.
 	 */
-	return clp_disable_fh(zdev);
+	return clp_disable_fh(zdev) ? -EIO : 0;
 }
 
 /**
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index d3331596ddbe..0a0e8b8293be 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -213,15 +213,19 @@ int clp_query_pci_fn(struct zpci_dev *zdev)
 }
 
 static int clp_refresh_fh(u32 fid);
-/*
- * Enable/Disable a given PCI function and update its function handle if
- * necessary
+/**
+ * clp_set_pci_fn() - Execute a command on a PCI function
+ * @zdev: Function that will be affected
+ * @nr_dma_as: DMA address space number
+ * @command: The command code to execute
+ *
+ * Returns: 0 on success, < 0 for Linux errors (e.g. -ENOMEM), and
+ * > 0 for non-success platform responses
  */
 static int clp_set_pci_fn(struct zpci_dev *zdev, u8 nr_dma_as, u8 command)
 {
 	struct clp_req_rsp_set_pci *rrb;
 	int rc, retries = 100;
-	u32 fid = zdev->fid;
 
 	rrb = clp_alloc_block(GFP_KERNEL);
 	if (!rrb)
@@ -245,17 +249,16 @@ static int clp_set_pci_fn(struct zpci_dev *zdev, u8 nr_dma_as, u8 command)
 		}
 	} while (rrb->response.hdr.rsp == CLP_RC_SETPCIFN_BUSY);
 
-	if (rc || rrb->response.hdr.rsp != CLP_RC_OK) {
-		zpci_err("Set PCI FN:\n");
-		zpci_err_clp(rrb->response.hdr.rsp, rc);
-	}
-
 	if (!rc && rrb->response.hdr.rsp == CLP_RC_OK) {
 		zdev->fh = rrb->response.fh;
-	} else if (!rc && rrb->response.hdr.rsp == CLP_RC_SETPCIFN_ALRDY &&
-			rrb->response.fh == 0) {
+	} else if (!rc && rrb->response.hdr.rsp == CLP_RC_SETPCIFN_ALRDY) {
 		/* Function is already in desired state - update handle */
-		rc = clp_refresh_fh(fid);
+		rc = clp_refresh_fh(zdev->fid);
+	} else {
+		zpci_err("Set PCI FN:\n");
+		zpci_err_clp(rrb->response.hdr.rsp, rc);
+		if (!rc)
+			rc = rrb->response.hdr.rsp;
 	}
 	clp_free_block(rrb);
 	return rc;
@@ -301,17 +304,13 @@ int clp_enable_fh(struct zpci_dev *zdev, u8 nr_dma_as)
 
 	rc = clp_set_pci_fn(zdev, nr_dma_as, CLP_SET_ENABLE_PCI_FN);
 	zpci_dbg(3, "ena fid:%x, fh:%x, rc:%d\n", zdev->fid, zdev->fh, rc);
-	if (rc)
-		goto out;
-
-	if (zpci_use_mio(zdev)) {
+	if (!rc && zpci_use_mio(zdev)) {
 		rc = clp_set_pci_fn(zdev, nr_dma_as, CLP_SET_ENABLE_MIO);
 		zpci_dbg(3, "ena mio fid:%x, fh:%x, rc:%d\n",
 				zdev->fid, zdev->fh, rc);
 		if (rc)
 			clp_disable_fh(zdev);
 	}
-out:
 	return rc;
 }
 
-- 
2.30.2


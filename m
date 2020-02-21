Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 134FB167700
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbgBUIBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:01:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731161AbgBUIBK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:01:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD49F206ED;
        Fri, 21 Feb 2020 08:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272069;
        bh=Df6Drub/gyVbgXioqxJtd2ALD8EBW3djCNk3Y/1Enoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a2hY4ofrO5/95suckeUHDJobIeQ+ImW3/oE/+uQstdZFW9vSp948fh5emCL0+QUbs
         sfomchFvjwHzo8nDgVlzhX02eg2TgQ5MAu1yvc8Bmp/RELzoLRhDyV6/oud6t0HHgY
         8AYnqC6nSETHuCClaNNhA/WRi9ddk0xrFaYYQojs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 397/399] s390/pci: Recover handle in clp_set_pci_fn()
Date:   Fri, 21 Feb 2020 08:42:02 +0100
Message-Id: <20200221072438.426522639@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 17cdec960cf776b20b1fb08c622221babe591d51 ]

When we try to recover a PCI function using

    echo 1 > /sys/bus/pci/devices/<id>/recover

or manually with

    echo 1 > /sys/bus/pci/devices/<id>/remove
    echo 0 > /sys/bus/pci/slots/<slot>/power
    echo 1 > /sys/bus/pci/slots/<slot>/power

clp_disable_fn() / clp_enable_fn() call clp_set_pci_fn() to first
disable and then reenable the function.

When the function is already in the requested state we may be left with
an invalid function handle.

To get a new valid handle we do a clp_list_pci() call. For this we need
both the function ID and function handle in clp_set_pci_fn() so pass the
zdev and get both.

To simplify things also pull setting the refreshed function handle into
clp_set_pci_fn()

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/pci.h |  2 +-
 arch/s390/pci/pci.c         |  2 +-
 arch/s390/pci/pci_clp.c     | 48 ++++++++++++++++++++++---------------
 3 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 3a06c264ea533..b05187ce5dbdc 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -180,7 +180,7 @@ void zpci_remove_reserved_devices(void);
 /* CLP */
 int clp_scan_pci_devices(void);
 int clp_rescan_pci_devices(void);
-int clp_rescan_pci_devices_simple(void);
+int clp_rescan_pci_devices_simple(u32 *fid);
 int clp_add_pci_device(u32, u32, int);
 int clp_enable_fh(struct zpci_dev *, u8);
 int clp_disable_fh(struct zpci_dev *);
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 8e872951c07ba..bc61ea18e88d9 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -939,5 +939,5 @@ subsys_initcall_sync(pci_base_init);
 void zpci_rescan(void)
 {
 	if (zpci_is_enabled())
-		clp_rescan_pci_devices_simple();
+		clp_rescan_pci_devices_simple(NULL);
 }
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index 4c613e569fe08..0d3d8f170ea42 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -240,12 +240,14 @@ error:
 }
 
 /*
- * Enable/Disable a given PCI function defined by its function handle.
+ * Enable/Disable a given PCI function and update its function handle if
+ * necessary
  */
-static int clp_set_pci_fn(u32 *fh, u8 nr_dma_as, u8 command)
+static int clp_set_pci_fn(struct zpci_dev *zdev, u8 nr_dma_as, u8 command)
 {
 	struct clp_req_rsp_set_pci *rrb;
 	int rc, retries = 100;
+	u32 fid = zdev->fid;
 
 	rrb = clp_alloc_block(GFP_KERNEL);
 	if (!rrb)
@@ -256,7 +258,7 @@ static int clp_set_pci_fn(u32 *fh, u8 nr_dma_as, u8 command)
 		rrb->request.hdr.len = sizeof(rrb->request);
 		rrb->request.hdr.cmd = CLP_SET_PCI_FN;
 		rrb->response.hdr.len = sizeof(rrb->response);
-		rrb->request.fh = *fh;
+		rrb->request.fh = zdev->fh;
 		rrb->request.oc = command;
 		rrb->request.ndas = nr_dma_as;
 
@@ -269,12 +271,17 @@ static int clp_set_pci_fn(u32 *fh, u8 nr_dma_as, u8 command)
 		}
 	} while (rrb->response.hdr.rsp == CLP_RC_SETPCIFN_BUSY);
 
-	if (!rc && rrb->response.hdr.rsp == CLP_RC_OK)
-		*fh = rrb->response.fh;
-	else {
+	if (rc || rrb->response.hdr.rsp != CLP_RC_OK) {
 		zpci_err("Set PCI FN:\n");
 		zpci_err_clp(rrb->response.hdr.rsp, rc);
-		rc = -EIO;
+	}
+
+	if (!rc && rrb->response.hdr.rsp == CLP_RC_OK) {
+		zdev->fh = rrb->response.fh;
+	} else if (!rc && rrb->response.hdr.rsp == CLP_RC_SETPCIFN_ALRDY &&
+			rrb->response.fh == 0) {
+		/* Function is already in desired state - update handle */
+		rc = clp_rescan_pci_devices_simple(&fid);
 	}
 	clp_free_block(rrb);
 	return rc;
@@ -282,18 +289,17 @@ static int clp_set_pci_fn(u32 *fh, u8 nr_dma_as, u8 command)
 
 int clp_enable_fh(struct zpci_dev *zdev, u8 nr_dma_as)
 {
-	u32 fh = zdev->fh;
 	int rc;
 
-	rc = clp_set_pci_fn(&fh, nr_dma_as, CLP_SET_ENABLE_PCI_FN);
-	zpci_dbg(3, "ena fid:%x, fh:%x, rc:%d\n", zdev->fid, fh, rc);
+	rc = clp_set_pci_fn(zdev, nr_dma_as, CLP_SET_ENABLE_PCI_FN);
+	zpci_dbg(3, "ena fid:%x, fh:%x, rc:%d\n", zdev->fid, zdev->fh, rc);
 	if (rc)
 		goto out;
 
-	zdev->fh = fh;
 	if (zpci_use_mio(zdev)) {
-		rc = clp_set_pci_fn(&fh, nr_dma_as, CLP_SET_ENABLE_MIO);
-		zpci_dbg(3, "ena mio fid:%x, fh:%x, rc:%d\n", zdev->fid, fh, rc);
+		rc = clp_set_pci_fn(zdev, nr_dma_as, CLP_SET_ENABLE_MIO);
+		zpci_dbg(3, "ena mio fid:%x, fh:%x, rc:%d\n",
+				zdev->fid, zdev->fh, rc);
 		if (rc)
 			clp_disable_fh(zdev);
 	}
@@ -309,11 +315,8 @@ int clp_disable_fh(struct zpci_dev *zdev)
 	if (!zdev_enabled(zdev))
 		return 0;
 
-	rc = clp_set_pci_fn(&fh, 0, CLP_SET_DISABLE_PCI_FN);
+	rc = clp_set_pci_fn(zdev, 0, CLP_SET_DISABLE_PCI_FN);
 	zpci_dbg(3, "dis fid:%x, fh:%x, rc:%d\n", zdev->fid, fh, rc);
-	if (!rc)
-		zdev->fh = fh;
-
 	return rc;
 }
 
@@ -370,10 +373,14 @@ static void __clp_add(struct clp_fh_list_entry *entry, void *data)
 static void __clp_update(struct clp_fh_list_entry *entry, void *data)
 {
 	struct zpci_dev *zdev;
+	u32 *fid = data;
 
 	if (!entry->vendor_id)
 		return;
 
+	if (fid && *fid != entry->fid)
+		return;
+
 	zdev = get_zdev_by_fid(entry->fid);
 	if (!zdev)
 		return;
@@ -413,7 +420,10 @@ int clp_rescan_pci_devices(void)
 	return rc;
 }
 
-int clp_rescan_pci_devices_simple(void)
+/* Rescan PCI functions and refresh function handles. If fid is non-NULL only
+ * refresh the handle of the function matching @fid
+ */
+int clp_rescan_pci_devices_simple(u32 *fid)
 {
 	struct clp_req_rsp_list_pci *rrb;
 	int rc;
@@ -422,7 +432,7 @@ int clp_rescan_pci_devices_simple(void)
 	if (!rrb)
 		return -ENOMEM;
 
-	rc = clp_list_pci(rrb, NULL, __clp_update);
+	rc = clp_list_pci(rrb, fid, __clp_update);
 
 	clp_free_block(rrb);
 	return rc;
-- 
2.20.1




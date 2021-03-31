Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1447E3440FD
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhCVM35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230140AbhCVM3s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:29:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B005C61990;
        Mon, 22 Mar 2021 12:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416188;
        bh=cp9wZfEPae1Nc9xGaB+adsvqPVgiFQ6AUb3bC7ydGQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJwGXnk0JPQGxrWMuxxxMe6jydh7XOiG5RbjiBERzUKiJ9Zu0f+cldiBG3Q1wAr4A
         /iYzEgsRLbp1+/kGOqAkxEc7gUbh9YlWtIcHQmWVUjsXAHO5B8unSCjbo7DZwP/GYU
         7M+973vhs/DsoWSqRrggOsKRETz4sHPRtJEfOHY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pierre Morel <pmorel@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.11 013/120] s390/pci: refactor zpci_create_device()
Date:   Mon, 22 Mar 2021 13:26:36 +0100
Message-Id: <20210322121930.108628676@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit ba764dd703feacb5a9c410d191af1b6cfbe96845 upstream.

Currently zpci_create_device() is only called in clp_add_pci_device()
which allocates the memory for the struct zpci_dev being created. There
is little separation of concerns as only both functions together can
create a zpci_dev and the only CLP specific code in
clp_add_pci_device() is a call to clp_query_pci_fn().

Improve this by removing clp_add_pci_device() and refactor
zpci_create_device() such that it alone creates and initializes the
zpci_dev given the FID and Function Handle. For this we need to make
clp_query_pci_fn() non-static. While at it remove the function handle
parameter since we can just take that from the zpci_dev. Also move
adding to the zpci_list to after the zdev has been fully created which
eliminates a window where a partially initialized zdev can be found by
get_zdev_by_fid().

Acked-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/pci.h |    4 +--
 arch/s390/pci/pci.c         |   57 +++++++++++++++++++++++++++++++-------------
 arch/s390/pci/pci_clp.c     |   40 ++----------------------------
 arch/s390/pci/pci_event.c   |    4 +--
 4 files changed, 48 insertions(+), 57 deletions(-)

--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -201,7 +201,7 @@ extern unsigned int s390_pci_no_rid;
   Prototypes
 ----------------------------------------------------------------------------- */
 /* Base stuff */
-int zpci_create_device(struct zpci_dev *);
+int zpci_create_device(u32 fid, u32 fh, enum zpci_state state);
 void zpci_remove_device(struct zpci_dev *zdev);
 int zpci_enable_device(struct zpci_dev *);
 int zpci_disable_device(struct zpci_dev *);
@@ -212,7 +212,7 @@ void zpci_remove_reserved_devices(void);
 /* CLP */
 int clp_setup_writeback_mio(void);
 int clp_scan_pci_devices(void);
-int clp_add_pci_device(u32, u32, int);
+int clp_query_pci_fn(struct zpci_dev *zdev);
 int clp_enable_fh(struct zpci_dev *, u8);
 int clp_disable_fh(struct zpci_dev *);
 int clp_get_state(u32 fid, enum zpci_state *state);
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -695,43 +695,68 @@ void zpci_remove_device(struct zpci_dev
 	}
 }
 
-int zpci_create_device(struct zpci_dev *zdev)
+/**
+ * zpci_create_device() - Create a new zpci_dev and add it to the zbus
+ * @fid: Function ID of the device to be created
+ * @fh: Current Function Handle of the device to be created
+ * @state: Initial state after creation either Standby or Configured
+ *
+ * Creates a new zpci device and adds it to its, possibly newly created, zbus
+ * as well as zpci_list.
+ *
+ * Returns: 0 on success, an error value otherwise
+ */
+int zpci_create_device(u32 fid, u32 fh, enum zpci_state state)
 {
+	struct zpci_dev *zdev;
 	int rc;
 
-	kref_init(&zdev->kref);
+	zpci_dbg(3, "add fid:%x, fh:%x, c:%d\n", fid, fh, state);
+	zdev = kzalloc(sizeof(*zdev), GFP_KERNEL);
+	if (!zdev)
+		return -ENOMEM;
+
+	/* FID and Function Handle are the static/dynamic identifiers */
+	zdev->fid = fid;
+	zdev->fh = fh;
 
-	spin_lock(&zpci_list_lock);
-	list_add_tail(&zdev->entry, &zpci_list);
-	spin_unlock(&zpci_list_lock);
+	/* Query function properties and update zdev */
+	rc = clp_query_pci_fn(zdev);
+	if (rc)
+		goto error;
+	zdev->state =  state;
+
+	kref_init(&zdev->kref);
+	mutex_init(&zdev->lock);
 
 	rc = zpci_init_iommu(zdev);
 	if (rc)
-		goto out;
+		goto error;
 
-	mutex_init(&zdev->lock);
 	if (zdev->state == ZPCI_FN_STATE_CONFIGURED) {
 		rc = zpci_enable_device(zdev);
 		if (rc)
-			goto out_destroy_iommu;
+			goto error_destroy_iommu;
 	}
 
 	rc = zpci_bus_device_register(zdev, &pci_root_ops);
 	if (rc)
-		goto out_disable;
+		goto error_disable;
+
+	spin_lock(&zpci_list_lock);
+	list_add_tail(&zdev->entry, &zpci_list);
+	spin_unlock(&zpci_list_lock);
 
 	return 0;
 
-out_disable:
+error_disable:
 	if (zdev->state == ZPCI_FN_STATE_ONLINE)
 		zpci_disable_device(zdev);
-
-out_destroy_iommu:
+error_destroy_iommu:
 	zpci_destroy_iommu(zdev);
-out:
-	spin_lock(&zpci_list_lock);
-	list_del(&zdev->entry);
-	spin_unlock(&zpci_list_lock);
+error:
+	zpci_dbg(0, "add fid:%x, rc:%d\n", fid, rc);
+	kfree(zdev);
 	return rc;
 }
 
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -181,7 +181,7 @@ static int clp_store_query_pci_fn(struct
 	return 0;
 }
 
-static int clp_query_pci_fn(struct zpci_dev *zdev, u32 fh)
+int clp_query_pci_fn(struct zpci_dev *zdev)
 {
 	struct clp_req_rsp_query_pci *rrb;
 	int rc;
@@ -194,7 +194,7 @@ static int clp_query_pci_fn(struct zpci_
 	rrb->request.hdr.len = sizeof(rrb->request);
 	rrb->request.hdr.cmd = CLP_QUERY_PCI_FN;
 	rrb->response.hdr.len = sizeof(rrb->response);
-	rrb->request.fh = fh;
+	rrb->request.fh = zdev->fh;
 
 	rc = clp_req(rrb, CLP_LPS_PCI);
 	if (!rc && rrb->response.hdr.rsp == CLP_RC_OK) {
@@ -212,40 +212,6 @@ out:
 	return rc;
 }
 
-int clp_add_pci_device(u32 fid, u32 fh, int configured)
-{
-	struct zpci_dev *zdev;
-	int rc = -ENOMEM;
-
-	zpci_dbg(3, "add fid:%x, fh:%x, c:%d\n", fid, fh, configured);
-	zdev = kzalloc(sizeof(*zdev), GFP_KERNEL);
-	if (!zdev)
-		goto error;
-
-	zdev->fh = fh;
-	zdev->fid = fid;
-
-	/* Query function properties and update zdev */
-	rc = clp_query_pci_fn(zdev, fh);
-	if (rc)
-		goto error;
-
-	if (configured)
-		zdev->state = ZPCI_FN_STATE_CONFIGURED;
-	else
-		zdev->state = ZPCI_FN_STATE_STANDBY;
-
-	rc = zpci_create_device(zdev);
-	if (rc)
-		goto error;
-	return 0;
-
-error:
-	zpci_dbg(0, "add fid:%x, rc:%d\n", fid, rc);
-	kfree(zdev);
-	return rc;
-}
-
 static int clp_refresh_fh(u32 fid);
 /*
  * Enable/Disable a given PCI function and update its function handle if
@@ -408,7 +374,7 @@ static void __clp_add(struct clp_fh_list
 
 	zdev = get_zdev_by_fid(entry->fid);
 	if (!zdev)
-		clp_add_pci_device(entry->fid, entry->fh, entry->config_state);
+		zpci_create_device(entry->fid, entry->fh, entry->config_state);
 }
 
 int clp_scan_pci_devices(void)
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -89,7 +89,7 @@ static void __zpci_event_availability(st
 	switch (ccdf->pec) {
 	case 0x0301: /* Reserved|Standby -> Configured */
 		if (!zdev) {
-			ret = clp_add_pci_device(ccdf->fid, ccdf->fh, 1);
+			zpci_create_device(ccdf->fid, ccdf->fh, ZPCI_FN_STATE_CONFIGURED);
 			break;
 		}
 		/* the configuration request may be stale */
@@ -116,7 +116,7 @@ static void __zpci_event_availability(st
 		break;
 	case 0x0302: /* Reserved -> Standby */
 		if (!zdev) {
-			clp_add_pci_device(ccdf->fid, ccdf->fh, 0);
+			zpci_create_device(ccdf->fid, ccdf->fh, ZPCI_FN_STATE_STANDBY);
 			break;
 		}
 		zdev->fh = ccdf->fh;



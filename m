Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853BE50524E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbiDRMlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240969AbiDRMjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5FE1C118;
        Mon, 18 Apr 2022 05:31:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5CC6B80EDB;
        Mon, 18 Apr 2022 12:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C64C385A7;
        Mon, 18 Apr 2022 12:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285094;
        bh=Ds7pQ5K9Ekh4Kn16DxJKRAnPQmA4+mzFyVFzsmvggo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tcIpCy3jO8T3Yy79UKslarV2StKYbqsy1IDSD29V+w2tuk2ns2EisC0ICb+CIgeyA
         QZZ4PymC3WXF+uYqj4vKPOeAeKVs6rP+bOvFtCNerQSSoXIyeCI89XO6fixChtuTEN
         l38IfU0G72TFATsdvQWCWdlGWigNnjZ3XtIKrEpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/189] vfio/pci: Fix vf_token mechanism when device-specific VF drivers are used
Date:   Mon, 18 Apr 2022 14:12:02 +0200
Message-Id: <20220418121203.398055646@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 1ef3342a934e235aca72b4bcc0d6854d80a65077 ]

get_pf_vdev() tries to check if a PF is a VFIO PF by looking at the driver:

       if (pci_dev_driver(physfn) != pci_dev_driver(vdev->pdev)) {

However now that we have multiple VF and PF drivers this is no longer
reliable.

This means that security tests realted to vf_token can be skipped by
mixing and matching different VFIO PCI drivers.

Instead of trying to use the driver core to find the PF devices maintain a
linked list of all PF vfio_pci_core_device's that we have called
pci_enable_sriov() on.

When registering a VF just search the list to see if the PF is present and
record the match permanently in the struct. PCI core locking prevents a PF
from passing pci_disable_sriov() while VF drivers are attached so the VFIO
owned PF becomes a static property of the VF.

In common cases where vfio does not own the PF the global list remains
empty and the VF's pointer is statically NULL.

This also fixes a lockdep splat from recursive locking of the
vfio_group::device_lock between vfio_device_get_from_name() and
vfio_device_get_from_dev(). If the VF and PF share the same group this
would deadlock.

Fixes: ff53edf6d6ab ("vfio/pci: Split the pci_driver code out of vfio_pci_core.c")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/0-v3-876570980634+f2e8-vfio_vf_token_jgg@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 124 ++++++++++++++++++-------------
 include/linux/vfio_pci_core.h    |   2 +
 2 files changed, 76 insertions(+), 50 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 15d158bdcde0..f3916e6b16b9 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -36,6 +36,10 @@ static bool nointxmask;
 static bool disable_vga;
 static bool disable_idle_d3;
 
+/* List of PF's that vfio_pci_core_sriov_configure() has been called on */
+static DEFINE_MUTEX(vfio_pci_sriov_pfs_mutex);
+static LIST_HEAD(vfio_pci_sriov_pfs);
+
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -434,47 +438,17 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
 
-static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vdev)
-{
-	struct pci_dev *physfn = pci_physfn(vdev->pdev);
-	struct vfio_device *pf_dev;
-
-	if (!vdev->pdev->is_virtfn)
-		return NULL;
-
-	pf_dev = vfio_device_get_from_dev(&physfn->dev);
-	if (!pf_dev)
-		return NULL;
-
-	if (pci_dev_driver(physfn) != pci_dev_driver(vdev->pdev)) {
-		vfio_device_put(pf_dev);
-		return NULL;
-	}
-
-	return container_of(pf_dev, struct vfio_pci_core_device, vdev);
-}
-
-static void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int val)
-{
-	struct vfio_pci_core_device *pf_vdev = get_pf_vdev(vdev);
-
-	if (!pf_vdev)
-		return;
-
-	mutex_lock(&pf_vdev->vf_token->lock);
-	pf_vdev->vf_token->users += val;
-	WARN_ON(pf_vdev->vf_token->users < 0);
-	mutex_unlock(&pf_vdev->vf_token->lock);
-
-	vfio_device_put(&pf_vdev->vdev);
-}
-
 void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 
-	vfio_pci_vf_token_user_add(vdev, -1);
+	if (vdev->sriov_pf_core_dev) {
+		mutex_lock(&vdev->sriov_pf_core_dev->vf_token->lock);
+		WARN_ON(!vdev->sriov_pf_core_dev->vf_token->users);
+		vdev->sriov_pf_core_dev->vf_token->users--;
+		mutex_unlock(&vdev->sriov_pf_core_dev->vf_token->lock);
+	}
 	vfio_spapr_pci_eeh_release(vdev->pdev);
 	vfio_pci_core_disable(vdev);
 
@@ -495,7 +469,12 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
 	vfio_pci_probe_mmaps(vdev);
 	vfio_spapr_pci_eeh_open(vdev->pdev);
-	vfio_pci_vf_token_user_add(vdev, 1);
+
+	if (vdev->sriov_pf_core_dev) {
+		mutex_lock(&vdev->sriov_pf_core_dev->vf_token->lock);
+		vdev->sriov_pf_core_dev->vf_token->users++;
+		mutex_unlock(&vdev->sriov_pf_core_dev->vf_token->lock);
+	}
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
 
@@ -1603,11 +1582,8 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 	 *
 	 * If the VF token is provided but unused, an error is generated.
 	 */
-	if (!vdev->pdev->is_virtfn && !vdev->vf_token && !vf_token)
-		return 0; /* No VF token provided or required */
-
 	if (vdev->pdev->is_virtfn) {
-		struct vfio_pci_core_device *pf_vdev = get_pf_vdev(vdev);
+		struct vfio_pci_core_device *pf_vdev = vdev->sriov_pf_core_dev;
 		bool match;
 
 		if (!pf_vdev) {
@@ -1620,7 +1596,6 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 		}
 
 		if (!vf_token) {
-			vfio_device_put(&pf_vdev->vdev);
 			pci_info_ratelimited(vdev->pdev,
 				"VF token required to access device\n");
 			return -EACCES;
@@ -1630,8 +1605,6 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 		match = uuid_equal(uuid, &pf_vdev->vf_token->uuid);
 		mutex_unlock(&pf_vdev->vf_token->lock);
 
-		vfio_device_put(&pf_vdev->vdev);
-
 		if (!match) {
 			pci_info_ratelimited(vdev->pdev,
 				"Incorrect VF token provided for device\n");
@@ -1752,8 +1725,30 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_core_device *cur;
+	struct pci_dev *physfn;
 	int ret;
 
+	if (pdev->is_virtfn) {
+		/*
+		 * If this VF was created by our vfio_pci_core_sriov_configure()
+		 * then we can find the PF vfio_pci_core_device now, and due to
+		 * the locking in pci_disable_sriov() it cannot change until
+		 * this VF device driver is removed.
+		 */
+		physfn = pci_physfn(vdev->pdev);
+		mutex_lock(&vfio_pci_sriov_pfs_mutex);
+		list_for_each_entry(cur, &vfio_pci_sriov_pfs, sriov_pfs_item) {
+			if (cur->pdev == physfn) {
+				vdev->sriov_pf_core_dev = cur;
+				break;
+			}
+		}
+		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
+		return 0;
+	}
+
+	/* Not a SRIOV PF */
 	if (!pdev->is_physfn)
 		return 0;
 
@@ -1825,6 +1820,7 @@ void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	mutex_init(&vdev->vma_lock);
 	INIT_LIST_HEAD(&vdev->vma_list);
+	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
 	init_rwsem(&vdev->memory_lock);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_init_device);
@@ -1923,7 +1919,7 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 
-	pci_disable_sriov(pdev);
+	vfio_pci_core_sriov_configure(pdev, 0);
 
 	vfio_unregister_group_dev(&vdev->vdev);
 
@@ -1963,21 +1959,49 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 
 int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
+	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
 	int ret = 0;
 
+	device_lock_assert(&pdev->dev);
+
 	device = vfio_device_get_from_dev(&pdev->dev);
 	if (!device)
 		return -ENODEV;
 
-	if (nr_virtfn == 0)
-		pci_disable_sriov(pdev);
-	else
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+
+	if (nr_virtfn) {
+		mutex_lock(&vfio_pci_sriov_pfs_mutex);
+		/*
+		 * The thread that adds the vdev to the list is the only thread
+		 * that gets to call pci_enable_sriov() and we will only allow
+		 * it to be called once without going through
+		 * pci_disable_sriov()
+		 */
+		if (!list_empty(&vdev->sriov_pfs_item)) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+		list_add_tail(&vdev->sriov_pfs_item, &vfio_pci_sriov_pfs);
+		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
 		ret = pci_enable_sriov(pdev, nr_virtfn);
+		if (ret)
+			goto out_del;
+		ret = nr_virtfn;
+		goto out_put;
+	}
 
-	vfio_device_put(device);
+	pci_disable_sriov(pdev);
 
-	return ret < 0 ? ret : nr_virtfn;
+out_del:
+	mutex_lock(&vfio_pci_sriov_pfs_mutex);
+	list_del_init(&vdev->sriov_pfs_item);
+out_unlock:
+	mutex_unlock(&vfio_pci_sriov_pfs_mutex);
+out_put:
+	vfio_device_put(device);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index ae6f4838ab75..6e5db4edc335 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -133,6 +133,8 @@ struct vfio_pci_core_device {
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
 	struct vfio_pci_vf_token	*vf_token;
+	struct list_head		sriov_pfs_item;
+	struct vfio_pci_core_device	*sriov_pf_core_dev;
 	struct notifier_block	nb;
 	struct mutex		vma_lock;
 	struct list_head	vma_list;
-- 
2.35.1




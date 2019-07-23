Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB027179D
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 13:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732020AbfGWL72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 07:59:28 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45467 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728418AbfGWL72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 07:59:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A933621EB2;
        Tue, 23 Jul 2019 07:59:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 07:59:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=f6MIAe
        mCF9uhyjlQPeHAmdeN9WYQK3JXzuSawEGttYk=; b=UVWc6L2DvPabaEHtxcwumh
        BphpDuMqfUoHdbr4o4PVFE2swafEq19FXQn+ymngmJyv7j3dpl/vZBJ2iihBolr1
        lYVy5kQKt6M88pMgm0b3L1IrS3X8AKwHzMIKqlbXRw/rDpJ9+Mnah00m6jH+jwfn
        254DbOzm3A0ZUfJQHEU2AqTMsos/aodroUpHHzzL/oNSy4+87sxXhRvqADRoDdPt
        e3qU1vF6b7WC3kwVo3qdOucKNi7IP7HVZbFAAymADPiYBnb4FuO5FE3fP52ACjEh
        QOc+3u8vR4+04phN19elLGNufKR9SjI4YZoICxeNRSI1ukrq9jELLuRdjKwigiOA
        ==
X-ME-Sender: <xms:n_Y2XfGvEgDwwx9tO8V4Y2hzEmJUP29rydAuChF00vhjwSmYyQbO3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:n_Y2XSqz8dbp2_a_5LSsku2GjFtArPO46j2dqEde1Dx9z6InR-kPcg>
    <xmx:n_Y2Xd1b0VjyZBnZOOuWnkCJZkjhSKUNb28S5mMoITsU3BUhy4U9VA>
    <xmx:n_Y2XbsjIDfmC9EPIB2d8qbKCsIBfj2Y7f617edwjibc2hxQO-HLUg>
    <xmx:n_Y2XZNW0CoLbFUcUj25YjaIoM85S2bdb-7MRx0bVTu56fgy3un-jg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 09297380084;
        Tue, 23 Jul 2019 07:59:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: hv: Fix a use-after-free bug in hv_eject_device_work()" failed to apply to 4.9-stable tree
To:     decui@microsoft.com, lorenzo.pieralisi@arm.com,
        mikelley@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 13:59:25 +0200
Message-ID: <1563883165157254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4df591b20b80cb77920953812d894db259d85bd7 Mon Sep 17 00:00:00 2001
From: Dexuan Cui <decui@microsoft.com>
Date: Fri, 21 Jun 2019 23:45:23 +0000
Subject: [PATCH] PCI: hv: Fix a use-after-free bug in hv_eject_device_work()

Fix a use-after-free in hv_eject_device_work().

Fixes: 05f151a73ec2 ("PCI: hv: Fix a memory leak in hv_eject_device_work()")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 82acd6155adf..40b625458afa 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1875,6 +1875,7 @@ static void hv_pci_devices_present(struct hv_pcibus_device *hbus,
 static void hv_eject_device_work(struct work_struct *work)
 {
 	struct pci_eject_response *ejct_pkt;
+	struct hv_pcibus_device *hbus;
 	struct hv_pci_dev *hpdev;
 	struct pci_dev *pdev;
 	unsigned long flags;
@@ -1885,6 +1886,7 @@ static void hv_eject_device_work(struct work_struct *work)
 	} ctxt;
 
 	hpdev = container_of(work, struct hv_pci_dev, wrk);
+	hbus = hpdev->hbus;
 
 	WARN_ON(hpdev->state != hv_pcichild_ejecting);
 
@@ -1895,8 +1897,7 @@ static void hv_eject_device_work(struct work_struct *work)
 	 * because hbus->pci_bus may not exist yet.
 	 */
 	wslot = wslot_to_devfn(hpdev->desc.win_slot.slot);
-	pdev = pci_get_domain_bus_and_slot(hpdev->hbus->sysdata.domain, 0,
-					   wslot);
+	pdev = pci_get_domain_bus_and_slot(hbus->sysdata.domain, 0, wslot);
 	if (pdev) {
 		pci_lock_rescan_remove();
 		pci_stop_and_remove_bus_device(pdev);
@@ -1904,9 +1905,9 @@ static void hv_eject_device_work(struct work_struct *work)
 		pci_unlock_rescan_remove();
 	}
 
-	spin_lock_irqsave(&hpdev->hbus->device_list_lock, flags);
+	spin_lock_irqsave(&hbus->device_list_lock, flags);
 	list_del(&hpdev->list_entry);
-	spin_unlock_irqrestore(&hpdev->hbus->device_list_lock, flags);
+	spin_unlock_irqrestore(&hbus->device_list_lock, flags);
 
 	if (hpdev->pci_slot)
 		pci_destroy_slot(hpdev->pci_slot);
@@ -1915,7 +1916,7 @@ static void hv_eject_device_work(struct work_struct *work)
 	ejct_pkt = (struct pci_eject_response *)&ctxt.pkt.message;
 	ejct_pkt->message_type.type = PCI_EJECTION_COMPLETE;
 	ejct_pkt->wslot.slot = hpdev->desc.win_slot.slot;
-	vmbus_sendpacket(hpdev->hbus->hdev->channel, ejct_pkt,
+	vmbus_sendpacket(hbus->hdev->channel, ejct_pkt,
 			 sizeof(*ejct_pkt), (unsigned long)&ctxt.pkt,
 			 VM_PKT_DATA_INBAND, 0);
 
@@ -1924,7 +1925,9 @@ static void hv_eject_device_work(struct work_struct *work)
 	/* For the two refs got in new_pcichild_device() */
 	put_pcichild(hpdev);
 	put_pcichild(hpdev);
-	put_hvpcibus(hpdev->hbus);
+	/* hpdev has been freed. Do not use it any more. */
+
+	put_hvpcibus(hbus);
 }
 
 /**


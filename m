Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760457179E
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 13:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731031AbfGWL7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 07:59:38 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39347 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728418AbfGWL7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 07:59:37 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 54AA82208C;
        Tue, 23 Jul 2019 07:59:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 07:59:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9DGEUw
        2tLMZoUcLCdD6NBSYw/CNElTh7rBCBaYGXhg0=; b=KU7US4N6QZAvHZ+sT+s90S
        SF1wKYr+cH2Z5tIc0Jd8AoNSRO3dE7kfSUJXyX0QgRjL6KEbSAOfYshthr1BXsh7
        5Qekc8ox8pu9KaQod5EbwESsfooByJ7LEBPmfZ0q2BdH9g8wgykvyoryjSBAlr92
        T/XYHBy1KqQ8W/FGAu5LH++IDyTHxAOF7CSlowRU4uBl3MyYxMGf56ZpSCrJXyYv
        9GiIJCDx/bWTjf9FBBw5ygOgEZnjcDOJiaLmLZaPg/QAeI23ktRTWLBCSh6DCk7j
        7qAL2QRkWO+N2UOSAAQ/Y0S2teXjjb5k5j0Od1sArZY3M5o81CvbvjkEC+ZxY0vQ
        ==
X-ME-Sender: <xms:qPY2Xci3PK8Xx7hO-w9zjl5XVfbuErd20J_4bmuwklMghh_fG-NLnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeh
X-ME-Proxy: <xmx:qPY2XRXdAsg4_MBJKwZTrqF_YQGLbJrArpBID0y9NKNUfa4ehFPgxg>
    <xmx:qPY2XW0JNNBi4x2EVlFezEDghTMPN7-jH_y7r3dx3HaY2HTLmb_2wA>
    <xmx:qPY2XfGQr3WFSYRJIxQ7NS9vJ3rJ7RJJv8SJJ_0kkPiTZF_j31Fp9A>
    <xmx:qPY2XQzkzZXaHFRSPkn4eHlgVoRkFUQPX3xomQgATK2DD8xvzJGQGA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC584380079;
        Tue, 23 Jul 2019 07:59:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: hv: Fix a use-after-free bug in hv_eject_device_work()" failed to apply to 4.14-stable tree
To:     decui@microsoft.com, lorenzo.pieralisi@arm.com,
        mikelley@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 13:59:26 +0200
Message-ID: <156388316686177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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


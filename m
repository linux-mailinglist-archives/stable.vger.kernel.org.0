Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB3F1EA3A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 10:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfEOIfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 04:35:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42115 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725871AbfEOIfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 04:35:21 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8FF3725936;
        Wed, 15 May 2019 04:35:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 15 May 2019 04:35:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ipaHiB
        0jB+FTvHaE3aBlvo4CLzn3Y0RvZ6D3K023XLw=; b=Mrj97KdccoeMC5wNTYdIJi
        9+dMk12Hzmz4IbVhPp1i37MfU6QBSODNE31fgoEq+uoTf6/fpRDnqsfUJTLsgaqW
        cmAVGdYgMkN5k8B2GXy29LQ3aNnyGExurIfCVVsuYNw/INvXTQly3Jy91OaNEFuS
        vLOr0aE3GuoJfhOn9hwyRkECgs71y77bwZpsM2rbXYdvpak98kIgDfJwuJ/A1WpQ
        mp50EqVTVvuVlO8H8tG6oQzb40vsh7V2vE3w6rCSTFIB3ZNCK/Ny+n1p9upJ2Cst
        KtOiCk8WMBppJLYbCyTWC6+uKjAaXTEsp6fbRYZiTI5qbUra/hg8wLnuyeqFy5fg
        ==
X-ME-Sender: <xms:SM_bXILAJxvan_IJo89gX7pBdk4mADHwfOdTPSo-X3MLfH7y0LUcYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrleekgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:SM_bXOpiJ-DOHD-SjK79iNq5K4Ye3abRHfFsO9w1YfR5DgGmWY1P6g>
    <xmx:SM_bXGtkRYjkrHKWHFeNCP2t7RizLIMrg5pfqjaYAnC_U0hDs8-Qrw>
    <xmx:SM_bXIIvEsh2pSOHPiE_b8UlSxDN-gu3qyVb-IH0kSvtjBMZSXSFBQ>
    <xmx:SM_bXEjuMShMG9otRCRU84koiBH9Umg_kY4yLRcpxmn_cVy2ugYXPg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD5D310323;
        Wed, 15 May 2019 04:35:19 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: hv: Add hv_pci_remove_slots() when we unload the driver" failed to apply to 4.14-stable tree
To:     decui@microsoft.com, lorenzo.pieralisi@arm.com,
        mikelley@microsoft.com, sthemmin@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 May 2019 10:35:18 +0200
Message-ID: <155790931816178@kroah.com>
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

From 15becc2b56c6eda3d9bf5ae993bafd5661c1fad1 Mon Sep 17 00:00:00 2001
From: Dexuan Cui <decui@microsoft.com>
Date: Mon, 4 Mar 2019 21:34:48 +0000
Subject: [PATCH] PCI: hv: Add hv_pci_remove_slots() when we unload the driver

When we unload the pci-hyperv host controller driver, the host does not
send us a PCI_EJECT message.

In this case we also need to make sure the sysfs PCI slot directory is
removed, otherwise a command on a slot file eg:

"cat /sys/bus/pci/slots/2/address"

will trigger a

"BUG: unable to handle kernel paging request"

and, if we unload/reload the driver several times we would end up with
stale slot entries in PCI slot directories in /sys/bus/pci/slots/

root@localhost:~# ls -rtl  /sys/bus/pci/slots/
total 0
drwxr-xr-x 2 root root 0 Feb  7 10:49 2
drwxr-xr-x 2 root root 0 Feb  7 10:49 2-1
drwxr-xr-x 2 root root 0 Feb  7 10:51 2-2

Add the missing code to remove the PCI slot and fix the current
behaviour.

Fixes: a15f2c08c708 ("PCI: hv: support reporting serial number as slot information")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
[lorenzo.pieralisi@arm.com: reformatted the log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Stephen Hemminger <sthemmin@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 30f16b882746..b489412e3502 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1486,6 +1486,21 @@ static void hv_pci_assign_slots(struct hv_pcibus_device *hbus)
 	}
 }
 
+/*
+ * Remove entries in sysfs pci slot directory.
+ */
+static void hv_pci_remove_slots(struct hv_pcibus_device *hbus)
+{
+	struct hv_pci_dev *hpdev;
+
+	list_for_each_entry(hpdev, &hbus->children, list_entry) {
+		if (!hpdev->pci_slot)
+			continue;
+		pci_destroy_slot(hpdev->pci_slot);
+		hpdev->pci_slot = NULL;
+	}
+}
+
 /**
  * create_root_hv_pci_bus() - Expose a new root PCI bus
  * @hbus:	Root PCI bus, as understood by this driver
@@ -2680,6 +2695,7 @@ static int hv_pci_remove(struct hv_device *hdev)
 		pci_lock_rescan_remove();
 		pci_stop_root_bus(hbus->pci_bus);
 		pci_remove_root_bus(hbus->pci_bus);
+		hv_pci_remove_slots(hbus);
 		pci_unlock_rescan_remove();
 		hbus->state = hv_pcibus_removed;
 	}


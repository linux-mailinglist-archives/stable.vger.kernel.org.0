Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F93C1EF3C
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfEOLbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732904AbfEOLbf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:31:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 127F92084A;
        Wed, 15 May 2019 11:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919894;
        bh=FojP+nXiRvBcWpMCM3FS04aD2Od+btT7ex4k/BSAnjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2OIbU2gaJDoBt06Hcl7LaKQkWJH2EeA1nS2wvnHYTqtbUg7AS+2Ae0QMufp4cO5x
         R/26sownMIBjTMdsLm4r95zf471hEH2tla62CUT/U6FM6LN+QsCrq7szzdMEML9JlC
         nbmkNjc0u5Wa6roqYyQunjAQTj70LcS3+ZAlKBBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: [PATCH 5.0 135/137] PCI: hv: Add hv_pci_remove_slots() when we unload the driver
Date:   Wed, 15 May 2019 12:56:56 +0200
Message-Id: <20190515090703.665227215@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit 15becc2b56c6eda3d9bf5ae993bafd5661c1fad1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/pci-hyperv.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1491,6 +1491,21 @@ static void hv_pci_assign_slots(struct h
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
@@ -2685,6 +2700,7 @@ static int hv_pci_remove(struct hv_devic
 		pci_lock_rescan_remove();
 		pci_stop_root_bus(hbus->pci_bus);
 		pci_remove_root_bus(hbus->pci_bus);
+		hv_pci_remove_slots(hbus);
 		pci_unlock_rescan_remove();
 		hbus->state = hv_pcibus_removed;
 	}



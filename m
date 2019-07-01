Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA3B236EF
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731669AbfETMSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387720AbfETMSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:18:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5923521019;
        Mon, 20 May 2019 12:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354713;
        bh=03B4r+gdfV3zZKsrGh0pxXl2QtZADUcF3UWhdO37XDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1qw6m9zTb0hnI5WBav8eL4V55CaScqX7S9YHxcOu6x6pmDzuxY62LWQcSx8tWPtA
         lLx6KEXn5OurUJT95YAcNyMpQSu/2odGYWkoxDwv+tu36/qfAdH0792yDgBeRe52Al
         hhmFlsjURL7hWeyQxf9xQbIW+swt7zcbSJcI/MOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 04/63] PCI: hv: Add hv_pci_remove_slots() when we unload the driver
Date:   Mon, 20 May 2019 14:13:43 +0200
Message-Id: <20190520115231.769898685@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 15becc2b56c6eda3d9bf5ae993bafd5661c1fad1 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/host/pci-hyperv.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/pci/host/pci-hyperv.c b/drivers/pci/host/pci-hyperv.c
index 292450c7da625..a5825bbcded72 100644
--- a/drivers/pci/host/pci-hyperv.c
+++ b/drivers/pci/host/pci-hyperv.c
@@ -1513,6 +1513,21 @@ static void hv_pci_assign_slots(struct hv_pcibus_device *hbus)
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
@@ -2719,6 +2734,7 @@ static int hv_pci_remove(struct hv_device *hdev)
 		pci_lock_rescan_remove();
 		pci_stop_root_bus(hbus->pci_bus);
 		pci_remove_root_bus(hbus->pci_bus);
+		hv_pci_remove_slots(hbus);
 		pci_unlock_rescan_remove();
 		hbus->state = hv_pcibus_removed;
 	}
-- 
2.20.1




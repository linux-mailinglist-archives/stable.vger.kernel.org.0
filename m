Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42161199069
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731722AbgCaJLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731713AbgCaJLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:11:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5487F208E0;
        Tue, 31 Mar 2020 09:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645895;
        bh=ifBt3CI7SlrcM3xldCDjQT3UR3cLW7WWdDFl5ZDiFEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KO5NkY0idcztJ/HK7b0uW+9arQTiKLfn27EsoP0GPnwpTIQ+MpY/ikLZlr6/ufBtE
         5MuzFVHeluRw2aWIzzD9psvHkMBd+rJuMFrsw0mOHkVAfRUIXpB045jZaSVeTDMwaG
         ztKZoD3sLGUrbaeleLuEhYUSg+SAeoZqw0fWY/Bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 020/155] net: ena: Add PCI shutdown handler to allow safe kexec
Date:   Tue, 31 Mar 2020 10:57:40 +0200
Message-Id: <20200331085420.649523440@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>

[ Upstream commit 428c491332bca498c8eb2127669af51506c346c7 ]

Currently ENA only provides the PCI remove() handler, used during rmmod
for example. This is not called on shutdown/kexec path; we are potentially
creating a failure scenario on kexec:

(a) Kexec is triggered, no shutdown() / remove() handler is called for ENA;
instead pci_device_shutdown() clears the master bit of the PCI device,
stopping all DMA transactions;

(b) Kexec reboot happens and the device gets enabled again, likely having
its FW with that DMA transaction buffered; then it may trigger the (now
invalid) memory operation in the new kernel, corrupting kernel memory area.

This patch aims to prevent this, by implementing a shutdown() handler
quite similar to the remove() one - the difference being the handling
of the netdev, which is unregistered on remove(), but following the
convention observed in other drivers, it's only detached on shutdown().

This prevents an odd issue in AWS Nitro instances, in which after the 2nd
kexec the next one will fail with an initrd corruption, caused by a wild
DMA write to invalid kernel memory. The lspci output for the adapter
present in my instance is:

00:05.0 Ethernet controller [0200]: Amazon.com, Inc. Elastic Network
Adapter (ENA) [1d0f:ec20]

Suggested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Acked-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |   51 +++++++++++++++++++++------
 1 file changed, 41 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3652,13 +3652,15 @@ err_disable_device:
 
 /*****************************************************************************/
 
-/* ena_remove - Device Removal Routine
+/* __ena_shutoff - Helper used in both PCI remove/shutdown routines
  * @pdev: PCI device information struct
+ * @shutdown: Is it a shutdown operation? If false, means it is a removal
  *
- * ena_remove is called by the PCI subsystem to alert the driver
- * that it should release a PCI device.
+ * __ena_shutoff is a helper routine that does the real work on shutdown and
+ * removal paths; the difference between those paths is with regards to whether
+ * dettach or unregister the netdevice.
  */
-static void ena_remove(struct pci_dev *pdev)
+static void __ena_shutoff(struct pci_dev *pdev, bool shutdown)
 {
 	struct ena_adapter *adapter = pci_get_drvdata(pdev);
 	struct ena_com_dev *ena_dev;
@@ -3677,13 +3679,17 @@ static void ena_remove(struct pci_dev *p
 
 	cancel_work_sync(&adapter->reset_task);
 
-	rtnl_lock();
+	rtnl_lock(); /* lock released inside the below if-else block */
 	ena_destroy_device(adapter, true);
-	rtnl_unlock();
-
-	unregister_netdev(netdev);
-
-	free_netdev(netdev);
+	if (shutdown) {
+		netif_device_detach(netdev);
+		dev_close(netdev);
+		rtnl_unlock();
+	} else {
+		rtnl_unlock();
+		unregister_netdev(netdev);
+		free_netdev(netdev);
+	}
 
 	ena_com_rss_destroy(ena_dev);
 
@@ -3698,6 +3704,30 @@ static void ena_remove(struct pci_dev *p
 	vfree(ena_dev);
 }
 
+/* ena_remove - Device Removal Routine
+ * @pdev: PCI device information struct
+ *
+ * ena_remove is called by the PCI subsystem to alert the driver
+ * that it should release a PCI device.
+ */
+
+static void ena_remove(struct pci_dev *pdev)
+{
+	__ena_shutoff(pdev, false);
+}
+
+/* ena_shutdown - Device Shutdown Routine
+ * @pdev: PCI device information struct
+ *
+ * ena_shutdown is called by the PCI subsystem to alert the driver that
+ * a shutdown/reboot (or kexec) is happening and device must be disabled.
+ */
+
+static void ena_shutdown(struct pci_dev *pdev)
+{
+	__ena_shutoff(pdev, true);
+}
+
 #ifdef CONFIG_PM
 /* ena_suspend - PM suspend callback
  * @pdev: PCI device information struct
@@ -3747,6 +3777,7 @@ static struct pci_driver ena_pci_driver
 	.id_table	= ena_pci_tbl,
 	.probe		= ena_probe,
 	.remove		= ena_remove,
+	.shutdown	= ena_shutdown,
 #ifdef CONFIG_PM
 	.suspend    = ena_suspend,
 	.resume     = ena_resume,



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3CCD198F4F
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbgCaJCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730681AbgCaJCP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:02:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC4D620787;
        Tue, 31 Mar 2020 09:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645334;
        bh=3H6k1wjVqfa9JIOqEprW66a4+Ddv97Y372AhUSotXHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLLQc791lhmT+zxJfC4GSlerHu7uL166SOCOpY2uan3mOo7wXKuLFCpx5iNU5eem/
         W5yYumj43e68REh89FJPxKN0O/LRiheCAq2BdM7NRGIEZ5f2HJdXdUS1bNJ9NdaGZ8
         u7U6RCSvaGPUIHS2wZm/iGKJ/WjknevnS3SXPUh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 021/170] net: ena: Add PCI shutdown handler to allow safe kexec
Date:   Tue, 31 Mar 2020 10:57:15 +0200
Message-Id: <20200331085426.295622266@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
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
@@ -3662,13 +3662,15 @@ err_disable_device:
 
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
@@ -3687,13 +3689,17 @@ static void ena_remove(struct pci_dev *p
 
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
 
@@ -3708,6 +3714,30 @@ static void ena_remove(struct pci_dev *p
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
@@ -3757,6 +3787,7 @@ static struct pci_driver ena_pci_driver
 	.id_table	= ena_pci_tbl,
 	.probe		= ena_probe,
 	.remove		= ena_remove,
+	.shutdown	= ena_shutdown,
 #ifdef CONFIG_PM
 	.suspend    = ena_suspend,
 	.resume     = ena_resume,



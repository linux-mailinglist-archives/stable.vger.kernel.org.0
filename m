Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B79628B7CE
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbgJLNqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389800AbgJLNp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3C922076E;
        Mon, 12 Oct 2020 13:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510357;
        bh=7Jp3shl7xbWXcAIayJ7RPBKk9nhLcI4JZd5t3RWmzCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=up8/eqzwNM3Vgg09Tlq9ZC0TChe/jreXHuIvyxVRD1iK1AUK/lEeyTUzWLTUN8FSL
         7IkBrwceJMon2ylOaS9Z8GR8obwZs8idVfx3R0d+Z//d2op39DkgNlvF/LZLR6y//P
         gfwai1o8DIqpK/DrP+o8V0KtjhrCY7tePWAtcLIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 065/124] iavf: use generic power management
Date:   Mon, 12 Oct 2020 15:31:09 +0200
Message-Id: <20201012133150.000256292@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vaibhav Gupta <vaibhavgupta40@gmail.com>

[ Upstream commit bc5cbd73eb493944b8665dc517f684c40eb18a4a ]

With the support of generic PM callbacks, drivers no longer need to use
legacy .suspend() and .resume() in which they had to maintain PCI states
changes and device's power state themselves. The required operations are
done by PCI core.

PCI drivers are not expected to invoke PCI helper functions like
pci_save/restore_state(), pci_enable/disable_device(),
pci_set_power_state(), etc. Their tasks are completed by PCI core itself.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 45 ++++++---------------
 1 file changed, 12 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index d338efe5f3f55..b3b349ecb0a8d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3777,7 +3777,6 @@ err_dma:
 	return err;
 }
 
-#ifdef CONFIG_PM
 /**
  * iavf_suspend - Power management suspend routine
  * @pdev: PCI device information struct
@@ -3785,11 +3784,10 @@ err_dma:
  *
  * Called when the system (VM) is entering sleep/suspend.
  **/
-static int iavf_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused iavf_suspend(struct device *dev_d)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct iavf_adapter *adapter = netdev_priv(netdev);
-	int retval = 0;
 
 	netif_device_detach(netdev);
 
@@ -3807,12 +3805,6 @@ static int iavf_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
 
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
-	pci_disable_device(pdev);
-
 	return 0;
 }
 
@@ -3822,24 +3814,13 @@ static int iavf_suspend(struct pci_dev *pdev, pm_message_t state)
  *
  * Called when the system (VM) is resumed from sleep/suspend.
  **/
-static int iavf_resume(struct pci_dev *pdev)
+static int __maybe_unused iavf_resume(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct iavf_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
 	u32 err;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	/* pci_restore_state clears dev->state_saved so call
-	 * pci_save_state to restore it.
-	 */
-	pci_save_state(pdev);
-
-	err = pci_enable_device_mem(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "Cannot enable PCI device from suspend.\n");
-		return err;
-	}
 	pci_set_master(pdev);
 
 	rtnl_lock();
@@ -3863,7 +3844,6 @@ static int iavf_resume(struct pci_dev *pdev)
 	return err;
 }
 
-#endif /* CONFIG_PM */
 /**
  * iavf_remove - Device Removal Routine
  * @pdev: PCI device information struct
@@ -3965,16 +3945,15 @@ static void iavf_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+static SIMPLE_DEV_PM_OPS(iavf_pm_ops, iavf_suspend, iavf_resume);
+
 static struct pci_driver iavf_driver = {
-	.name     = iavf_driver_name,
-	.id_table = iavf_pci_tbl,
-	.probe    = iavf_probe,
-	.remove   = iavf_remove,
-#ifdef CONFIG_PM
-	.suspend  = iavf_suspend,
-	.resume   = iavf_resume,
-#endif
-	.shutdown = iavf_shutdown,
+	.name      = iavf_driver_name,
+	.id_table  = iavf_pci_tbl,
+	.probe     = iavf_probe,
+	.remove    = iavf_remove,
+	.driver.pm = &iavf_pm_ops,
+	.shutdown  = iavf_shutdown,
 };
 
 /**
-- 
2.25.1




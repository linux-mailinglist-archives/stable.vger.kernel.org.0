Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 758AE171E8D
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388038AbgB0OHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:07:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388037AbgB0OHL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:07:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E64920801;
        Thu, 27 Feb 2020 14:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812430;
        bh=Wz6bUIagI7E52vNvqGZt2+l4o9kfdPMamH19p7nZsq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ck7DJQ2msuOBMQbLnURn/vQZ7B/MbyKAXx4b+EwMMr7dpGLV4FtZuCJiD+kJ8kJJw
         zZX9LlhAeNeKIwEzkmTE0w9E+9Ih1kK7dQfHAB8YH3SuSh8INNhKJx5isenWMFV4t5
         x5p7eCHFUMoRiNi1uJ5vWfGwAkYZcNPoR9s9TIZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Morumuri Srivalli <smorumu1@in.ibm.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        David Dai <zdai@linux.vnet.ibm.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH 5.4 015/135] e1000e: Use rtnl_lock to prevent race conditions between net and pci/pm
Date:   Thu, 27 Feb 2020 14:35:55 +0100
Message-Id: <20200227132231.457798739@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

commit a7023819404ac9bd2bb311a4fafd38515cfa71ec upstream.

This patch is meant to address possible race conditions that can exist
between network configuration and power management. A similar issue was
fixed for igb in commit 9474933caf21 ("igb: close/suspend race in
netif_device_detach").

In addition it consolidates the code so that the PCI error handling code
will essentially perform the power management freeze on the device prior to
attempting a reset, and will thaw the device afterwards if that is what it
is planning to do. Otherwise when we call close on the interface it should
see it is detached and not attempt to call the logic to down the interface
and free the IRQs again.

>From what I can tell the check that was adding the check for __E1000_DOWN
in e1000e_close was added when runtime power management was added. However
it should not be relevant for us as we perform a call to
pm_runtime_get_sync before we call e1000_down/free_irq so it should always
be back up before we call into this anyway.

Reported-by: Morumuri Srivalli <smorumu1@in.ibm.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Tested-by: David Dai <zdai@linux.vnet.ibm.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/netdev.c |   68 ++++++++++++++---------------
 1 file changed, 35 insertions(+), 33 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -4713,12 +4713,12 @@ int e1000e_close(struct net_device *netd
 
 	pm_runtime_get_sync(&pdev->dev);
 
-	if (!test_bit(__E1000_DOWN, &adapter->state)) {
+	if (netif_device_present(netdev)) {
 		e1000e_down(adapter, true);
 		e1000_free_irq(adapter);
 
 		/* Link status message must follow this format */
-		pr_info("%s NIC Link is Down\n", adapter->netdev->name);
+		pr_info("%s NIC Link is Down\n", netdev->name);
 	}
 
 	napi_disable(&adapter->napi);
@@ -6309,10 +6309,14 @@ static int e1000e_pm_freeze(struct devic
 {
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
+	bool present;
 
+	rtnl_lock();
+
+	present = netif_device_present(netdev);
 	netif_device_detach(netdev);
 
-	if (netif_running(netdev)) {
+	if (present && netif_running(netdev)) {
 		int count = E1000_CHECK_RESET_COUNT;
 
 		while (test_bit(__E1000_RESETTING, &adapter->state) && count--)
@@ -6324,6 +6328,8 @@ static int e1000e_pm_freeze(struct devic
 		e1000e_down(adapter, false);
 		e1000_free_irq(adapter);
 	}
+	rtnl_unlock();
+
 	e1000e_reset_interrupt_capability(adapter);
 
 	/* Allow time for pending master requests to run */
@@ -6571,6 +6577,30 @@ static void e1000e_disable_aspm_locked(s
 	__e1000e_disable_aspm(pdev, state, 1);
 }
 
+static int e1000e_pm_thaw(struct device *dev)
+{
+	struct net_device *netdev = dev_get_drvdata(dev);
+	struct e1000_adapter *adapter = netdev_priv(netdev);
+	int rc = 0;
+
+	e1000e_set_interrupt_capability(adapter);
+
+	rtnl_lock();
+	if (netif_running(netdev)) {
+		rc = e1000_request_irq(adapter);
+		if (rc)
+			goto err_irq;
+
+		e1000e_up(adapter);
+	}
+
+	netif_device_attach(netdev);
+err_irq:
+	rtnl_unlock();
+
+	return rc;
+}
+
 #ifdef CONFIG_PM
 static int __e1000_resume(struct pci_dev *pdev)
 {
@@ -6638,26 +6668,6 @@ static int __e1000_resume(struct pci_dev
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int e1000e_pm_thaw(struct device *dev)
-{
-	struct net_device *netdev = dev_get_drvdata(dev);
-	struct e1000_adapter *adapter = netdev_priv(netdev);
-
-	e1000e_set_interrupt_capability(adapter);
-	if (netif_running(netdev)) {
-		u32 err = e1000_request_irq(adapter);
-
-		if (err)
-			return err;
-
-		e1000e_up(adapter);
-	}
-
-	netif_device_attach(netdev);
-
-	return 0;
-}
-
 static int e1000e_pm_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -6829,16 +6839,11 @@ static void e1000_netpoll(struct net_dev
 static pci_ers_result_t e1000_io_error_detected(struct pci_dev *pdev,
 						pci_channel_state_t state)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
-	struct e1000_adapter *adapter = netdev_priv(netdev);
-
-	netif_device_detach(netdev);
+	e1000e_pm_freeze(&pdev->dev);
 
 	if (state == pci_channel_io_perm_failure)
 		return PCI_ERS_RESULT_DISCONNECT;
 
-	if (netif_running(netdev))
-		e1000e_down(adapter, true);
 	pci_disable_device(pdev);
 
 	/* Request a slot slot reset. */
@@ -6904,10 +6909,7 @@ static void e1000_io_resume(struct pci_d
 
 	e1000_init_manageability_pt(adapter);
 
-	if (netif_running(netdev))
-		e1000e_up(adapter);
-
-	netif_device_attach(netdev);
+	e1000e_pm_thaw(&pdev->dev);
 
 	/* If the controller has AMT, do not set DRV_LOAD until the interface
 	 * is up.  For all other cases, let the f/w know that the h/w is now



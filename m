Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AED20617F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390295AbgFWUnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392537AbgFWUng (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:43:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BE9621883;
        Tue, 23 Jun 2020 20:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945016;
        bh=aVQvAqoDRPXw5wPyTnBE2z3xocTyKQd+x9V86cnGcwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oea1dc6GL7BfdxBe7DoMww25/9mDb6yY2tHIXcO5YyLjNJjeqeLjS4dzJq4Cos1Bg
         v9JXkz9YqA/Fm7j2b/whHbrocErOmwIL5M/APMB5Molg9in7C3xo6rk932qGRhfjov
         GtYnhnIPj7YHBICD/fhNcbVa4lUtT7p6CdxEaxBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stable@vger.kernel.org, Chen Yu <yu.c.chen@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 4.19 201/206] e1000e: Do not wake up the system via WOL if device wakeup is disabled
Date:   Tue, 23 Jun 2020 21:58:49 +0200
Message-Id: <20200623195326.928100772@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Yu <yu.c.chen@intel.com>

commit 6bf6be1127f7e6d4bf39f84d56854e944d045d74 upstream.

Currently the system will be woken up via WOL(Wake On LAN) even if the
device wakeup ability has been disabled via sysfs:
 cat /sys/devices/pci0000:00/0000:00:1f.6/power/wakeup
 disabled

The system should not be woken up if the user has explicitly
disabled the wake up ability for this device.

This patch clears the WOL ability of this network device if the
user has disabled the wake up ability in sysfs.

Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver")
Reported-by: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/netdev.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6308,11 +6308,17 @@ static int __e1000_shutdown(struct pci_d
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
-	u32 ctrl, ctrl_ext, rctl, status;
-	/* Runtime suspend should only enable wakeup for link changes */
-	u32 wufc = runtime ? E1000_WUFC_LNKC : adapter->wol;
+	u32 ctrl, ctrl_ext, rctl, status, wufc;
 	int retval = 0;
 
+	/* Runtime suspend should only enable wakeup for link changes */
+	if (runtime)
+		wufc = E1000_WUFC_LNKC;
+	else if (device_may_wakeup(&pdev->dev))
+		wufc = adapter->wol;
+	else
+		wufc = 0;
+
 	status = er32(STATUS);
 	if (status & E1000_STATUS_LU)
 		wufc &= ~E1000_WUFC_LNKC;
@@ -6369,7 +6375,7 @@ static int __e1000_shutdown(struct pci_d
 	if (adapter->hw.phy.type == e1000_phy_igp_3) {
 		e1000e_igp3_phy_powerdown_workaround_ich8lan(&adapter->hw);
 	} else if (hw->mac.type >= e1000_pch_lpt) {
-		if (!(wufc & (E1000_WUFC_EX | E1000_WUFC_MC | E1000_WUFC_BC)))
+		if (wufc && !(wufc & (E1000_WUFC_EX | E1000_WUFC_MC | E1000_WUFC_BC)))
 			/* ULP does not support wake from unicast, multicast
 			 * or broadcast.
 			 */



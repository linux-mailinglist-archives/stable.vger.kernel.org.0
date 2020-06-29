Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC1520D6ED
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732442AbgF2TZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732474AbgF2TZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1024E253F4;
        Mon, 29 Jun 2020 15:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445335;
        bh=ChTL6Zpp6VFyxhQl5HlLme+O9W/F52bSbqdY44CyKVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyFgbiRZM8Ywh9235B44ra+4MrEZSDTts51d3svzbjAHDfKHkrZz6jfWXJrj+RKu8
         /Zf/O4ux87bLz5Nf4wrrqvevE/swDjCEVzLgF1MXpkSWT2DHEzj5BYJh1aOm1qUlkm
         rJZrgYDwGXkDIYVFIjv/eTNw8QxAaJQyosA1rLzw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Yu <yu.c.chen@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stable@vger.kernel.org, Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 096/191] e1000e: Do not wake up the system via WOL if device wakeup is disabled
Date:   Mon, 29 Jun 2020 11:38:32 -0400
Message-Id: <20200629154007.2495120-97-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Yu <yu.c.chen@intel.com>

[ Upstream commit 6bf6be1127f7e6d4bf39f84d56854e944d045d74 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index be324b4761eb6..3c01bc43889a2 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6315,11 +6315,17 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool runtime)
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
@@ -6377,7 +6383,7 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool runtime)
 		e1000e_igp3_phy_powerdown_workaround_ich8lan(&adapter->hw);
 	} else if ((hw->mac.type == e1000_pch_lpt) ||
 		   (hw->mac.type == e1000_pch_spt)) {
-		if (!(wufc & (E1000_WUFC_EX | E1000_WUFC_MC | E1000_WUFC_BC)))
+		if (wufc && !(wufc & (E1000_WUFC_EX | E1000_WUFC_MC | E1000_WUFC_BC)))
 			/* ULP does not support wake from unicast, multicast
 			 * or broadcast.
 			 */
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B7248002B
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239372AbhL0Pn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:43:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40732 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239366AbhL0Pl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1703610D5;
        Mon, 27 Dec 2021 15:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CE1C36AED;
        Mon, 27 Dec 2021 15:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619685;
        bh=oIgmO0mRHxv3bqYiesItCGa+d75K5ER1dqeR8hIqSXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qT2cgQLmPtiLRLg1UPslz9HiOhY+VJPMoL+QZgC23/x9rR05dM8VYJbNwKj/pThy3
         l8rsHbegz0rZ8y4GwyF7t56a58HtsG2tZO0xp9OmyxNteQNRN35HxqMRenRQlcCh0O
         lLYy3xzXQuYytxYDmJtY4uk/sYYBCDUi283xgSp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Stolpe <martin.stolpe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/128] igb: fix deadlock caused by taking RTNL in RPM resume path
Date:   Mon, 27 Dec 2021 16:30:08 +0100
Message-Id: <20211227151332.638054128@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit ac8c58f5b535d6272324e2b8b4a0454781c9147e ]

Recent net core changes caused an issue with few Intel drivers
(reportedly igb), where taking RTNL in RPM resume path results in a
deadlock. See [0] for a bug report. I don't think the core changes
are wrong, but taking RTNL in RPM resume path isn't needed.
The Intel drivers are the only ones doing this. See [1] for a
discussion on the issue. Following patch changes the RPM resume path
to not take RTNL.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=215129
[1] https://lore.kernel.org/netdev/20211125074949.5f897431@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/t/

Fixes: bd869245a3dc ("net: core: try to runtime-resume detached device in __dev_open")
Fixes: f32a21376573 ("ethtool: runtime-resume netdev parent before ethtool ioctl ops")
Tested-by: Martin Stolpe <martin.stolpe@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20211220201844.2714498-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 533199d819501..82a712f77cb34 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -9247,7 +9247,7 @@ static int __maybe_unused igb_suspend(struct device *dev)
 	return __igb_shutdown(to_pci_dev(dev), NULL, 0);
 }
 
-static int __maybe_unused igb_resume(struct device *dev)
+static int __maybe_unused __igb_resume(struct device *dev, bool rpm)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
@@ -9290,17 +9290,24 @@ static int __maybe_unused igb_resume(struct device *dev)
 
 	wr32(E1000_WUS, ~0);
 
-	rtnl_lock();
+	if (!rpm)
+		rtnl_lock();
 	if (!err && netif_running(netdev))
 		err = __igb_open(netdev, true);
 
 	if (!err)
 		netif_device_attach(netdev);
-	rtnl_unlock();
+	if (!rpm)
+		rtnl_unlock();
 
 	return err;
 }
 
+static int __maybe_unused igb_resume(struct device *dev)
+{
+	return __igb_resume(dev, false);
+}
+
 static int __maybe_unused igb_runtime_idle(struct device *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(dev);
@@ -9319,7 +9326,7 @@ static int __maybe_unused igb_runtime_suspend(struct device *dev)
 
 static int __maybe_unused igb_runtime_resume(struct device *dev)
 {
-	return igb_resume(dev);
+	return __igb_resume(dev, true);
 }
 
 static void igb_shutdown(struct pci_dev *pdev)
@@ -9435,7 +9442,7 @@ static pci_ers_result_t igb_io_error_detected(struct pci_dev *pdev,
  *  @pdev: Pointer to PCI device
  *
  *  Restart the card from scratch, as if from a cold-boot. Implementation
- *  resembles the first-half of the igb_resume routine.
+ *  resembles the first-half of the __igb_resume routine.
  **/
 static pci_ers_result_t igb_io_slot_reset(struct pci_dev *pdev)
 {
@@ -9475,7 +9482,7 @@ static pci_ers_result_t igb_io_slot_reset(struct pci_dev *pdev)
  *
  *  This callback is called when the error recovery driver tells us that
  *  its OK to resume normal operation. Implementation resembles the
- *  second-half of the igb_resume routine.
+ *  second-half of the __igb_resume routine.
  */
 static void igb_io_resume(struct pci_dev *pdev)
 {
-- 
2.34.1




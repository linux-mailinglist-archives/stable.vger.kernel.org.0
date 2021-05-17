Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F034B382EB0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237978AbhEQOKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238118AbhEQOIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:08:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72A6A61363;
        Mon, 17 May 2021 14:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260391;
        bh=SZH2iEu/9UXu1MA/l2N2zkqcul96f+NDS4x1UCqNgog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Jbjb2QC2Z6xvEzvE8Tgxm1xAytxJmmxl/uwNPDZcMBhSf+f9cZILdvRg/ueD9hGs
         u9z3Rqx+N4MCQmW2UWKSLY7ImB3rEictAhPMZ9Sb5ndCtJFa3rPcCEPdsvHoV1Hnwr
         eNINRCF90vH/AAtmJ2Cj0OCw5zkEipsJG59i/x6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 059/363] net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM
Date:   Mon, 17 May 2021 15:58:45 +0200
Message-Id: <20210517140304.606386960@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit fba863b816049b03f3fbb07b10ebdcfe5c4141f7 ]

Resume callback of the PHY driver is called after the one for the MAC
driver. The PHY driver resume callback calls phy_init_hw(), and this is
potentially problematic if the MAC driver calls phy_start() in its resume
callback. One issue was reported with the fec driver and a KSZ8081 PHY
which seems to become unstable if a soft reset is triggered during aneg.

The new flag allows MAC drivers to indicate that they take care of
suspending/resuming the PHY. Then the MAC PM callbacks can handle
any dependency between MAC and PHY PM.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 6 ++++++
 include/linux/phy.h          | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index cc38e326405a..af2e1759b523 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -273,6 +273,9 @@ static __maybe_unused int mdio_bus_phy_suspend(struct device *dev)
 {
 	struct phy_device *phydev = to_phy_device(dev);
 
+	if (phydev->mac_managed_pm)
+		return 0;
+
 	/* We must stop the state machine manually, otherwise it stops out of
 	 * control, possibly with the phydev->lock held. Upon resume, netdev
 	 * may call phy routines that try to grab the same lock, and that may
@@ -294,6 +297,9 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 	struct phy_device *phydev = to_phy_device(dev);
 	int ret;
 
+	if (phydev->mac_managed_pm)
+		return 0;
+
 	if (!phydev->suspended_by_mdio_bus)
 		goto no_resume;
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 1a12e4436b5b..8644b097dea3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -493,6 +493,7 @@ struct macsec_ops;
  * @loopback_enabled: Set true if this PHY has been loopbacked successfully.
  * @downshifted_rate: Set true if link speed has been downshifted.
  * @is_on_sfp_module: Set true if PHY is located on an SFP module.
+ * @mac_managed_pm: Set true if MAC driver takes of suspending/resuming PHY
  * @state: State of the PHY for management purposes
  * @dev_flags: Device-specific flags used by the PHY driver.
  * @irq: IRQ number of the PHY's interrupt (-1 if none)
@@ -567,6 +568,7 @@ struct phy_device {
 	unsigned loopback_enabled:1;
 	unsigned downshifted_rate:1;
 	unsigned is_on_sfp_module:1;
+	unsigned mac_managed_pm:1;
 
 	unsigned autoneg:1;
 	/* The most recently read link state */
-- 
2.30.2




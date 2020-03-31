Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAAD31991CA
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbgCaJIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:08:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730956AbgCaJIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:08:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1619208E0;
        Tue, 31 Mar 2020 09:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645731;
        bh=e4gP1AzGAjExssar5Y8zyS0WgVBcnkIz92jxOIUyN20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vcjhbqs9CLci06eu3pdlDcwA552Qzh+SLUJqpd4NBd76xEVPV0ZrkzKeCcOFTkJcV
         8RRkxYstgLV5lk35HjWAfOvih+yAN3CssaF0kh5RHz68N/BimCnGmTEuykt1A/r//N
         iophog/Sy30VFzqg8Q+OAunv9Pi0y8vMDsRBejUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chih-Wei Huang <cwhuang@android-x86.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 146/170] r8169: fix PHY driver check on platforms w/o module softdeps
Date:   Tue, 31 Mar 2020 10:59:20 +0200
Message-Id: <20200331085438.836502509@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 2e8c339b4946490a922a21aa8cd869c6cfad2023 upstream.

On Android/x86 the module loading infrastructure can't deal with
softdeps. Therefore the check for presence of the Realtek PHY driver
module fails. mdiobus_register() will try to load the PHY driver
module, therefore move the check to after this call and explicitly
check that a dedicated PHY driver is bound to the PHY device.

Fixes: f32593773549 ("r8169: check that Realtek PHY driver module is loaded")
Reported-by: Chih-Wei Huang <cwhuang@android-x86.org>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/realtek/r8169_main.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6670,6 +6670,13 @@ static int r8169_mdio_register(struct rt
 	if (!tp->phydev) {
 		mdiobus_unregister(new_bus);
 		return -ENODEV;
+	} else if (!tp->phydev->drv) {
+		/* Most chip versions fail with the genphy driver.
+		 * Therefore ensure that the dedicated PHY driver is loaded.
+		 */
+		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
+		mdiobus_unregister(new_bus);
+		return -EUNATCH;
 	}
 
 	/* PHY will be woken up in rtl_open() */
@@ -6831,15 +6838,6 @@ static int rtl_init_one(struct pci_dev *
 	int chipset, region;
 	int jumbo_max, rc;
 
-	/* Some tools for creating an initramfs don't consider softdeps, then
-	 * r8169.ko may be in initramfs, but realtek.ko not. Then the generic
-	 * PHY driver is used that doesn't work with most chip versions.
-	 */
-	if (!driver_find("RTL8201CP Ethernet", &mdio_bus_type)) {
-		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
-		return -ENOENT;
-	}
-
 	dev = devm_alloc_etherdev(&pdev->dev, sizeof (*tp));
 	if (!dev)
 		return -ENOMEM;



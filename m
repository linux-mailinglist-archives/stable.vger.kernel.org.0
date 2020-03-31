Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E112E19912F
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730948AbgCaJRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731899AbgCaJRw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:17:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B453320772;
        Tue, 31 Mar 2020 09:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646272;
        bh=TeARL0MEysMl1kXo3PO6VsWf6KiLr0xQ30CuSJnkSGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2ytdZTf00jtoSGJFZa634uwCr/hpj3IdPLhr3rA0wxxthvoYSSxeyuhb/EJ02szk
         qLF6yeq9DqfX002mPJfCwLHulN3EyEe5k9xGBWJWKBuPqEmp03tEqYfjLqsM+1cUeG
         dGdXZ3Bsm3bUOXQx8bbBCRALTbluTdV12Aniq0jU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chih-Wei Huang <cwhuang@android-x86.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 134/155] r8169: fix PHY driver check on platforms w/o module softdeps
Date:   Tue, 31 Mar 2020 10:59:34 +0200
Message-Id: <20200331085433.273204395@linuxfoundation.org>
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
@@ -6903,6 +6903,13 @@ static int r8169_mdio_register(struct rt
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
@@ -7064,15 +7071,6 @@ static int rtl_init_one(struct pci_dev *
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



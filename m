Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0607A18B76B
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbgCSNOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:14:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728405AbgCSNOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:14:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AEA320409;
        Thu, 19 Mar 2020 13:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623654;
        bh=byaEF/vae3AUfyhaqaPGHPXOKVYFasBGOsVVtxKkHK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CL7/rc8qpZou5Ch5wmepsLD9RJj6vo6gqMDTKlwRz07q1QJohozh9Eyx4OuRh18UX
         cu1b5zJuLmoDf0sX5Cw5LZCr/ziICsq8JU+12rbzy/vGxFrYYkHIcs5S6YIUhZLlxU
         XHw6re64VdB1h17mJxjvH8TxSxDM+T/Crsg+FUMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 01/99] phy: Revert toggling reset changes.
Date:   Thu, 19 Mar 2020 14:02:39 +0100
Message-Id: <20200319123942.004707889@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

commit 7b566f70e1bf65b189b66eb3de6f431c30f7dff2 upstream.

This reverts:

ef1b5bf506b1 ("net: phy: Fix not to call phy_resume() if PHY is not attached")
8c85f4b81296 ("net: phy: micrel: add toggling phy reset if PHY is not  attached")

Andrew Lunn informs me that there are alternative efforts
underway to fix this more properly.

Signed-off-by: David S. Miller <davem@davemloft.net>
[just take the ef1b5bf506b1 revert - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/phy_device.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -76,7 +76,7 @@ static LIST_HEAD(phy_fixup_list);
 static DEFINE_MUTEX(phy_fixup_lock);
 
 #ifdef CONFIG_PM
-static bool mdio_bus_phy_may_suspend(struct phy_device *phydev, bool suspend)
+static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
 {
 	struct device_driver *drv = phydev->mdio.dev.driver;
 	struct phy_driver *phydrv = to_phy_driver(drv);
@@ -88,11 +88,10 @@ static bool mdio_bus_phy_may_suspend(str
 	/* PHY not attached? May suspend if the PHY has not already been
 	 * suspended as part of a prior call to phy_disconnect() ->
 	 * phy_detach() -> phy_suspend() because the parent netdev might be the
-	 * MDIO bus driver and clock gated at this point. Also may resume if
-	 * PHY is not attached.
+	 * MDIO bus driver and clock gated at this point.
 	 */
 	if (!netdev)
-		return suspend ? !phydev->suspended : phydev->suspended;
+		return !phydev->suspended;
 
 	/* Don't suspend PHY if the attached netdev parent may wakeup.
 	 * The parent may point to a PCI device, as in tg3 driver.
@@ -122,7 +121,7 @@ static int mdio_bus_phy_suspend(struct d
 	if (phydev->attached_dev && phydev->adjust_link)
 		phy_stop_machine(phydev);
 
-	if (!mdio_bus_phy_may_suspend(phydev, true))
+	if (!mdio_bus_phy_may_suspend(phydev))
 		return 0;
 
 	return phy_suspend(phydev);
@@ -133,7 +132,7 @@ static int mdio_bus_phy_resume(struct de
 	struct phy_device *phydev = to_phy_device(dev);
 	int ret;
 
-	if (!mdio_bus_phy_may_suspend(phydev, false))
+	if (!mdio_bus_phy_may_suspend(phydev))
 		goto no_resume;
 
 	ret = phy_resume(phydev);



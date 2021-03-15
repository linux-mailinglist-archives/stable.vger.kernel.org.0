Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3231833B8F2
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbhCOOE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232131AbhCON6n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FAA964F37;
        Mon, 15 Mar 2021 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816712;
        bh=+ptmoKpV4hlB21msSzO9E3KSI8JK5/TGAUnVA56A/VI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ue5NmdQEIzhK3+sB6qYEXQEBFHNL/ZUmo83qUVf3hUJr9v1Egi+PSjU9VUUAC3mvP
         tZkgjHMq44vwiNTW/0ywUrnshKeWxWza5BiRj8rq51mQWSgx7C9bPnchr21av9rnPW
         HEqm/hWGOX09dai6kUCA6gd+KRdjM6jxfV+koj5Y=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 070/290] net: phy: make mdio_bus_phy_suspend/resume as __maybe_unused
Date:   Mon, 15 Mar 2021 14:52:43 +0100
Message-Id: <20210315135544.273556234@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Arnd Bergmann <arnd@arndb.de>

commit 7f654157f0aefba04cd7f6297351c87b76b47b89 upstream.

When CONFIG_PM_SLEEP is disabled, the compiler warns about unused
functions:

drivers/net/phy/phy_device.c:273:12: error: unused function 'mdio_bus_phy_suspend' [-Werror,-Wunused-function]
static int mdio_bus_phy_suspend(struct device *dev)
drivers/net/phy/phy_device.c:293:12: error: unused function 'mdio_bus_phy_resume' [-Werror,-Wunused-function]
static int mdio_bus_phy_resume(struct device *dev)

The logic is intentional, so just mark these two as __maybe_unused
and remove the incorrect #ifdef.

Fixes: 4c0d2e96ba05 ("net: phy: consider that suspend2ram may cut off PHY power")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20210225145748.404410-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -230,7 +230,6 @@ static struct phy_driver genphy_driver;
 static LIST_HEAD(phy_fixup_list);
 static DEFINE_MUTEX(phy_fixup_lock);
 
-#ifdef CONFIG_PM
 static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
 {
 	struct device_driver *drv = phydev->mdio.dev.driver;
@@ -270,7 +269,7 @@ out:
 	return !phydev->suspended;
 }
 
-static int mdio_bus_phy_suspend(struct device *dev)
+static __maybe_unused int mdio_bus_phy_suspend(struct device *dev)
 {
 	struct phy_device *phydev = to_phy_device(dev);
 
@@ -290,7 +289,7 @@ static int mdio_bus_phy_suspend(struct d
 	return phy_suspend(phydev);
 }
 
-static int mdio_bus_phy_resume(struct device *dev)
+static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 {
 	struct phy_device *phydev = to_phy_device(dev);
 	int ret;
@@ -316,7 +315,6 @@ no_resume:
 
 static SIMPLE_DEV_PM_OPS(mdio_bus_phy_pm_ops, mdio_bus_phy_suspend,
 			 mdio_bus_phy_resume);
-#endif /* CONFIG_PM */
 
 /**
  * phy_register_fixup - creates a new phy_fixup and adds it to the list



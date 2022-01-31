Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754894A40F6
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240779AbiAaLBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:01:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48234 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358456AbiAaLAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:00:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79B07B82A5E;
        Mon, 31 Jan 2022 11:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F22C340E8;
        Mon, 31 Jan 2022 11:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626821;
        bh=6bTuMqjIAe8M5U9uAeUKlMxp1hGna8u+ajA/AFCtbEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ng0M60fYzLkcfwBoTwvKt7eAPkgmqx4UA8kzSoHEnsTUI7NK+GiC4d7TtPPUOHqbz
         ngJm+ujIfEJsO4XfmRhZNsjM+y5QQfg1Uhyj7E6scs2GIDsBDO4TTLiVrua3iMHwKw
         a9gSaZZpbyScDZ8bA2bNN44cIBtfn+tHQHlxz3ZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 51/64] phylib: fix potential use-after-free
Date:   Mon, 31 Jan 2022 11:56:36 +0100
Message-Id: <20220131105217.406475015@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit cbda1b16687580d5beee38273f6241ae3725960c ]

Commit bafbdd527d56 ("phylib: Add device reset GPIO support") added call
to phy_device_reset(phydev) after the put_device() call in phy_detach().

The comment before the put_device() call says that the phydev might go
away with put_device().

Fix potential use-after-free by calling phy_device_reset() before
put_device().

Fixes: bafbdd527d56 ("phylib: Add device reset GPIO support")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220119162748.32418-1-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 35ade5d21de51..78b918dcd5472 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1433,6 +1433,9 @@ void phy_detach(struct phy_device *phydev)
 	    phy_driver_is_genphy_10g(phydev))
 		device_release_driver(&phydev->mdio.dev);
 
+	/* Assert the reset signal */
+	phy_device_reset(phydev, 1);
+
 	/*
 	 * The phydev might go away on the put_device() below, so avoid
 	 * a use-after-free bug by reading the underlying bus first.
@@ -1444,9 +1447,6 @@ void phy_detach(struct phy_device *phydev)
 		ndev_owner = dev->dev.parent->driver->owner;
 	if (ndev_owner != bus->owner)
 		module_put(bus->owner);
-
-	/* Assert the reset signal */
-	phy_device_reset(phydev, 1);
 }
 EXPORT_SYMBOL(phy_detach);
 
-- 
2.34.1




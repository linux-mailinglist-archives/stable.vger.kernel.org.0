Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8274A436F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359573AbiAaLVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378144AbiAaLTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:19:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7628EC0619CA;
        Mon, 31 Jan 2022 03:12:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13DC9611C3;
        Mon, 31 Jan 2022 11:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE44BC340E8;
        Mon, 31 Jan 2022 11:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627525;
        bh=F+KcQCjkUXziZuww+nEM5pVstxxMaDKgDUy5oz4R+24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKKUiiG68YX8OG++S+9WAJ5NDcOqHd0wKLRC194nnJMHSb013l5t5mP6rIfBIpI4b
         2+fJs5JZo8jrpc0eXnfdzc20CiZOIsQyI7voDvz4aMneFwJHZFTavb/emTRSwMaxM9
         9PzK1T9hSAQnChIfuDCJXeDaDtgLsBMReGL9sRqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/171] phylib: fix potential use-after-free
Date:   Mon, 31 Jan 2022 11:56:18 +0100
Message-Id: <20220131105233.857125202@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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
index 4f9990b47a377..28f4a383aba72 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1746,6 +1746,9 @@ void phy_detach(struct phy_device *phydev)
 	    phy_driver_is_genphy_10g(phydev))
 		device_release_driver(&phydev->mdio.dev);
 
+	/* Assert the reset signal */
+	phy_device_reset(phydev, 1);
+
 	/*
 	 * The phydev might go away on the put_device() below, so avoid
 	 * a use-after-free bug by reading the underlying bus first.
@@ -1757,9 +1760,6 @@ void phy_detach(struct phy_device *phydev)
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




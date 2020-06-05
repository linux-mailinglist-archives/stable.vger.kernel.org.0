Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918751EFB4F
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgFEOZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:25:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728250AbgFEOQc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:16:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F6AB2075B;
        Fri,  5 Jun 2020 14:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366591;
        bh=EUyRpb3EQAr3VgeyKmxe4l/6m82tQ6ZFBOGR+llSCE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKMG6og3TG8ORfExXpwBHLrR16jaN1VjJ/vqG7Z0zOVAAgkh35+Pr2Yyr9Cy/m3HS
         uCnSbhvo77mzy2VbbM1UyObo+0k3k4LtMwiHz2sEJSwhXBHGCIcy0Am7g061C3D5D9
         alMZ90iCnNY/VJ7qXE0n42ILKy0iVJg2Yxfsfb8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 15/43] net: phy: propagate an error back to the callers of phy_sfp_probe
Date:   Fri,  5 Jun 2020 16:14:45 +0200
Message-Id: <20200605140153.322521877@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit e3f2d5579c0b8ad9d1fb6a5813cee38a86386e05 ]

The compilation warning below reveals that the errors returned from
the sfp_bus_add_upstream() call are not propagated to the callers.
Fix it by returning "ret".

14:37:51 drivers/net/phy/phy_device.c: In function 'phy_sfp_probe':
14:37:51 drivers/net/phy/phy_device.c:1236:6: warning: variable 'ret'
   set but not used [-Wunused-but-set-variable]
14:37:51  1236 |  int ret;
14:37:51       |      ^~~

Fixes: 298e54fa810e ("net: phy: add core phylib sfp support")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 28e3c5c0e3c3..faca0d84f5af 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1239,7 +1239,7 @@ int phy_sfp_probe(struct phy_device *phydev,
 		  const struct sfp_upstream_ops *ops)
 {
 	struct sfp_bus *bus;
-	int ret;
+	int ret = 0;
 
 	if (phydev->mdio.dev.fwnode) {
 		bus = sfp_bus_find_fwnode(phydev->mdio.dev.fwnode);
@@ -1251,7 +1251,7 @@ int phy_sfp_probe(struct phy_device *phydev,
 		ret = sfp_bus_add_upstream(bus, phydev, ops);
 		sfp_bus_put(bus);
 	}
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(phy_sfp_probe);
 
-- 
2.25.1




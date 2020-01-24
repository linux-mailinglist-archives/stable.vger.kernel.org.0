Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C92C41480FC
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388443AbgAXLQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:16:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388173AbgAXLQF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:16:05 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA3C72071A;
        Fri, 24 Jan 2020 11:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864565;
        bh=fT27P53UADxBLx/ulqZt3KGFVu3oyoXYVqDZc4Uu5hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqBLxOTc6ijfIgzj2v6VCRF2Hq7/AeDOLaXOTuW1j29L9tbb7tTeX/0U7VrPL56aG
         6jQyuCGY9oj0ySIu+/uaOcbFFOEmhNVnTefsG4bUCTEGD4dYDzHFg87eyAY9sBtUku
         A7RbqUMJxKlQfsBfog7qzjFFcQvBs35MEwePwLZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 278/639] net: dsa: Avoid null pointer when failing to connect to PHY
Date:   Fri, 24 Jan 2020 10:27:28 +0100
Message-Id: <20200124093121.657361201@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit 6146dd453e235c487d85ae4dc6cc08978a1c890f ]

When phylink_of_phy_connect fails, dsa_slave_phy_setup tries to save the
day by connecting to an alternative PHY, none other than a PHY on the
switch's internal MDIO bus, at an address equal to the port's index.

However this does not take into consideration the scenario when the
switch that failed to probe an external PHY does not have an internal
MDIO bus at all.

Fixes: aab9c4067d23 ("net: dsa: Plug in PHYLINK support")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/slave.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index b39720d0995d3..8ee28b6016d82 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1219,9 +1219,9 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		phy_flags = ds->ops->get_phy_flags(ds, dp->index);
 
 	ret = phylink_of_phy_connect(dp->pl, port_dn, phy_flags);
-	if (ret == -ENODEV) {
-		/* We could not connect to a designated PHY or SFP, so use the
-		 * switch internal MDIO bus instead
+	if (ret == -ENODEV && ds->slave_mii_bus) {
+		/* We could not connect to a designated PHY or SFP, so try to
+		 * use the switch internal MDIO bus instead
 		 */
 		ret = dsa_slave_phy_connect(slave_dev, dp->index);
 		if (ret) {
@@ -1233,7 +1233,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		}
 	}
 
-	return 0;
+	return ret;
 }
 
 static struct lock_class_key dsa_slave_netdev_xmit_lock_key;
-- 
2.20.1




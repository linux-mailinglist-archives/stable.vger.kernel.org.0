Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 150EF793CC
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388023AbfG2TYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387447AbfG2TYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:24:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C3BD217D6;
        Mon, 29 Jul 2019 19:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428282;
        bh=mqOO6ooWFtLdytVZIivB4Aq5Nxr2se0FN63LIoZTr6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k44nERdb8SPIbhkrUEkqpy31bevaxZUlKO/TxMAFbieIptRMp3pQYckRv1L8uJQl7
         fC/Z1VIWZgLyEWmabjkwDiI9GNormqNeDvwyvPb/UMnNamm6AmHJw0Cz85O9V6BUrc
         vmq0dobgNaXqHvx61qfl9KqCDaehMTHW4syEWQaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 027/293] net: phy: Check against net_device being NULL
Date:   Mon, 29 Jul 2019 21:18:38 +0200
Message-Id: <20190729190823.695917249@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 82c76aca81187b3d28a6fb3062f6916450ce955e ]

In general, we don't want MAC drivers calling phy_attach_direct with the
net_device being NULL. Add checks against this in all the functions
calling it: phy_attach() and phy_connect_direct().

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c433be573e0d..ed7e3c70b511 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -729,6 +729,9 @@ int phy_connect_direct(struct net_device *dev, struct phy_device *phydev,
 {
 	int rc;
 
+	if (!dev)
+		return -EINVAL;
+
 	rc = phy_attach_direct(dev, phydev, phydev->dev_flags, interface);
 	if (rc)
 		return rc;
@@ -1067,6 +1070,9 @@ struct phy_device *phy_attach(struct net_device *dev, const char *bus_id,
 	struct device *d;
 	int rc;
 
+	if (!dev)
+		return ERR_PTR(-EINVAL);
+
 	/* Search the list of PHY devices on the mdio bus for the
 	 * PHY with the requested name
 	 */
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257FF395BFB
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhEaN0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231950AbhEaNYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:24:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29283613F5;
        Mon, 31 May 2021 13:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467233;
        bh=4wBO4HH5W5Gu4Lso9HS7zxZEbBiamO6rRNPgJ3RIF9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofhvTVyDO5FGmhV4A3r3TuyBhUSwmLWcSYJgQbuV9REj/U2o4qcNkWWosy3NnHPG6
         /rUPuvXpozH6KJQ5ov1ehwk6Z9cLG9xmXvXBairccdB9F0UrW7EAH4rPI+9leDJHxI
         7bDK9R8e1Aejg9Z1oOW+pNFMrBYoDdvlRIUbVQ8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 56/66] net: mdio: octeon: Fix some double free issues
Date:   Mon, 31 May 2021 15:14:29 +0200
Message-Id: <20210531130638.023958244@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e1d027dd97e1e750669cdc0d3b016a4f54e473eb ]

'bus->mii_bus' has been allocated with 'devm_mdiobus_alloc_size()' in the
probe function. So it must not be freed explicitly or there will be a
double free.

Remove the incorrect 'mdiobus_free' in the error handling path of the
probe function and in remove function.

Suggested-By: Andrew Lunn <andrew@lunn.ch>
Fixes: 35d2aeac9810 ("phy: mdio-octeon: Use devm_mdiobus_alloc_size()")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio-octeon.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/phy/mdio-octeon.c b/drivers/net/phy/mdio-octeon.c
index ab6914f8bd50..1da104150f44 100644
--- a/drivers/net/phy/mdio-octeon.c
+++ b/drivers/net/phy/mdio-octeon.c
@@ -75,7 +75,6 @@ static int octeon_mdiobus_probe(struct platform_device *pdev)
 
 	return 0;
 fail_register:
-	mdiobus_free(bus->mii_bus);
 	smi_en.u64 = 0;
 	oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
 	return err;
@@ -89,7 +88,6 @@ static int octeon_mdiobus_remove(struct platform_device *pdev)
 	bus = platform_get_drvdata(pdev);
 
 	mdiobus_unregister(bus->mii_bus);
-	mdiobus_free(bus->mii_bus);
 	smi_en.u64 = 0;
 	oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
 	return 0;
-- 
2.30.2




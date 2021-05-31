Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DD4395F22
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbhEaOIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:08:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232867AbhEaOGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:06:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8193B61963;
        Mon, 31 May 2021 13:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468329;
        bh=XPZeU7ItnRBofVGC1Ghuw4wvvrqTmfH+opkYC75BA9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MwCJAZZog/ZOm/h76lwiECAtfIDyL/tUkL24sK7UYUbgpwqnwAxCWvttK+R2ut2j1
         mWq7eJAGKM3c/oi75dkKxzNi8mYohGQapfMd6ahhcAxJIgsu/LCgEXIp6+NBlwH9XJ
         q6ShLdgwVelgo/98NaXFgs/U718VKm6/KLq5dqtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 203/252] net: mdio: octeon: Fix some double free issues
Date:   Mon, 31 May 2021 15:14:28 +0200
Message-Id: <20210531130704.915054806@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
 drivers/net/mdio/mdio-octeon.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-octeon.c b/drivers/net/mdio/mdio-octeon.c
index d1e1009d51af..6faf39314ac9 100644
--- a/drivers/net/mdio/mdio-octeon.c
+++ b/drivers/net/mdio/mdio-octeon.c
@@ -71,7 +71,6 @@ static int octeon_mdiobus_probe(struct platform_device *pdev)
 
 	return 0;
 fail_register:
-	mdiobus_free(bus->mii_bus);
 	smi_en.u64 = 0;
 	oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
 	return err;
@@ -85,7 +84,6 @@ static int octeon_mdiobus_remove(struct platform_device *pdev)
 	bus = platform_get_drvdata(pdev);
 
 	mdiobus_unregister(bus->mii_bus);
-	mdiobus_free(bus->mii_bus);
 	smi_en.u64 = 0;
 	oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
 	return 0;
-- 
2.30.2




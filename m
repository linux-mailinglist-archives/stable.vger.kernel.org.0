Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0267395CCA
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhEaNiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232069AbhEaNfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:35:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF76461441;
        Mon, 31 May 2021 13:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467534;
        bh=4wBO4HH5W5Gu4Lso9HS7zxZEbBiamO6rRNPgJ3RIF9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JiEcqqlOHzaRP1N4e+Wtk1PZHNtFo53LVNb74nCFvuzCzMbt3IYVp/BF7Q5jX/PMS
         KksA+AR4hsawQezGV6XuKQXjaQkaieTGriiW7zixQBHfKGc9l4EHCnA1Gf/ZJTaxm7
         kRVhe+M35YqmWxv1Dhcf1q6imZBGI/RhpbgtMTY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/116] net: mdio: octeon: Fix some double free issues
Date:   Mon, 31 May 2021 15:14:36 +0200
Message-Id: <20210531130643.523849263@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
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




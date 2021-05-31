Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8903960A3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhEaOam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233625AbhEaO1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:27:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EC4F61C17;
        Mon, 31 May 2021 13:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468823;
        bh=cUkw0qjG7kiX+pmn/gAfEEiyJM1R+QsQ4474B0sxByE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLTiOkBcipXJxiR1fwDHLHBLe3ld8jjKgtGBSRE/0mdWPTJSCV2gsGRvoC3+hTCuH
         ccwZd50RW0wwX8Ajc5P43cVUjA9ZsXqWkaZQozlg+9x1hCZmVTTYq5tL0r/rayecDq
         f6c6SBGxHM2+WvcU0bHnKHvJvfYx8kwOtrdL9z8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 142/177] net: mdio: octeon: Fix some double free issues
Date:   Mon, 31 May 2021 15:14:59 +0200
Message-Id: <20210531130652.846779246@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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
index 8327382aa568..088c73731652 100644
--- a/drivers/net/phy/mdio-octeon.c
+++ b/drivers/net/phy/mdio-octeon.c
@@ -72,7 +72,6 @@ static int octeon_mdiobus_probe(struct platform_device *pdev)
 
 	return 0;
 fail_register:
-	mdiobus_free(bus->mii_bus);
 	smi_en.u64 = 0;
 	oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
 	return err;
@@ -86,7 +85,6 @@ static int octeon_mdiobus_remove(struct platform_device *pdev)
 	bus = platform_get_drvdata(pdev);
 
 	mdiobus_unregister(bus->mii_bus);
-	mdiobus_free(bus->mii_bus);
 	smi_en.u64 = 0;
 	oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
 	return 0;
-- 
2.30.2




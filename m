Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F329240E2E3
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243159AbhIPQmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245524AbhIPQkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:40:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EF4961501;
        Thu, 16 Sep 2021 16:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809438;
        bh=vL1tCi+P8oHoCWquG29pMGeUOGlw7/g0zHRAzDDPO2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPjcW6eEYQvToo/+wIllTOb4MIw4RYnu5P11EdXBTTtdV/atHV5MASXhus1B/bCe6
         IcdGUUKzjuI4+aSGEpZa3GvkuwmmfHO1n4GZbTmLDpzhtT1mI5oudA+wF5bp3DlV5B
         M5cz9vEg2OhsOVY1A5LNXOadVsbv1J0JW2M1qjYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 155/380] net: phy: Fix data type in DP83822 dp8382x_disable_wol()
Date:   Thu, 16 Sep 2021 17:58:32 +0200
Message-Id: <20210916155809.343387376@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 0d6835ffe50c9c1f098b5704394331710b67af48 ]

The last argument of phy_clear_bits_mmd(..., u16 val); is u16 and not
int, just inline the value into the function call arguments.

No functional change.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83822.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index f7a2ec150e54..211b5476a6f5 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -326,11 +326,9 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
 
 static int dp8382x_disable_wol(struct phy_device *phydev)
 {
-	int value = DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
-		    DP83822_WOL_SECURE_ON;
-
-	return phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
-				  MII_DP83822_WOL_CFG, value);
+	return phy_clear_bits_mmd(phydev, DP83822_DEVADDR, MII_DP83822_WOL_CFG,
+				  DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
+				  DP83822_WOL_SECURE_ON);
 }
 
 static int dp83822_read_status(struct phy_device *phydev)
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D220840DFA5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbhIPQM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235505AbhIPQKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:10:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3419A61356;
        Thu, 16 Sep 2021 16:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808511;
        bh=oEucGP7KA0TVuE98wc3+iLQVouHdB1vVi2pdgYZ5p3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zuOgjTbcXFDQV7OkAy7ZzrdxkLscK4HPqfji/lnp2wJuVsGEdX24e/5f84/X7KKs6
         H0fsu2gWKsyu8FjNeQ4W59zwX58u7naQDMXxH/c/aSZa748tSP2CSRmSI865LzOqUn
         vvst0t5IW4mNHueOFjDNzytwYlV3tDGncpDGDlVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/306] net: phy: Fix data type in DP83822 dp8382x_disable_wol()
Date:   Thu, 16 Sep 2021 17:57:44 +0200
Message-Id: <20210916155758.129325564@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index a9b058bb1be8..7bf43031cea8 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -305,11 +305,9 @@ static int dp83822_config_intr(struct phy_device *phydev)
 
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




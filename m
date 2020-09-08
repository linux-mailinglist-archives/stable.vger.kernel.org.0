Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC82261CD4
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731903AbgIHT1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731051AbgIHQAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:00:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B9ED2404D;
        Tue,  8 Sep 2020 15:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579492;
        bh=qGT3/ySqSqFR13Q+ieA5/jBlGs2udlquAiRUcFkiAeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=opQPvir0AxgMCWno4AZpd1owBhpmIl+CRxgrzMEuCliHzCG77WP9xIwo76DE74C2J
         /xreb6KxZdaL+kZizMHbxtLtrESUlnWycWfPKug7B+Nydq5HEebVIp2j2mS2k7Opf8
         FjJp7nWQdRzIAHgQCZroXH/JoVKm5995g+iiUhlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 100/186] net: dp83867: Fix WoL SecureOn password
Date:   Tue,  8 Sep 2020 17:24:02 +0200
Message-Id: <20200908152246.483465624@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

[ Upstream commit 8b4a11c67da538504d60ae917ffe5254f59b1248 ]

Fix the registers being written to as the values were being over written
when writing the same registers.

Fixes: caabee5b53f5 ("net: phy: dp83867: support Wake on LAN")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83867.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index f3c04981b8da6..cd7032628a28c 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -215,9 +215,9 @@ static int dp83867_set_wol(struct phy_device *phydev,
 		if (wol->wolopts & WAKE_MAGICSECURE) {
 			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
 				      (wol->sopass[1] << 8) | wol->sopass[0]);
-			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
+			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP2,
 				      (wol->sopass[3] << 8) | wol->sopass[2]);
-			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
+			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP3,
 				      (wol->sopass[5] << 8) | wol->sopass[4]);
 
 			val_rxcfg |= DP83867_WOL_SEC_EN;
-- 
2.25.1




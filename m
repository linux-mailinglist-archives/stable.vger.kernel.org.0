Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467AC39608C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhEaO2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:28:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232226AbhEaO0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:26:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D72E26162B;
        Mon, 31 May 2021 13:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468818;
        bh=/KPhMXtE6Gel3LC66DtyO7p+G798alWq8oCpoGdXxYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MWGO5GdLnbhfFus1U7J6Q7SbSCN687C2Agnzqz1jPJms+bUDV8Pr3i6MpRz8c3+1a
         HNjPPX6MqcY2VLzuGX3S5hfAdSHUsS0BqQ+ynFzUhfzBSLYSWKzWldaJFUGIxV4Uxo
         +SRVPiOf93bNgWcuZCwYoLGkJ2VMokqgKMVBEJLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 141/177] net: mdio: thunder: Fix a double free issue in the .remove function
Date:   Mon, 31 May 2021 15:14:58 +0200
Message-Id: <20210531130652.815942801@linuxfoundation.org>
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

[ Upstream commit a93a0a15876d2a077a3bc260b387d2457a051f24 ]

'bus->mii_bus' have been allocated with 'devm_mdiobus_alloc_size()' in the
probe function. So it must not be freed explicitly or there will be a
double free.

Remove the incorrect 'mdiobus_free' in the remove function.

Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio-thunder.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/mdio-thunder.c b/drivers/net/phy/mdio-thunder.c
index b6128ae7f14f..1e2f57ed1ef7 100644
--- a/drivers/net/phy/mdio-thunder.c
+++ b/drivers/net/phy/mdio-thunder.c
@@ -126,7 +126,6 @@ static void thunder_mdiobus_pci_remove(struct pci_dev *pdev)
 			continue;
 
 		mdiobus_unregister(bus->mii_bus);
-		mdiobus_free(bus->mii_bus);
 		oct_mdio_writeq(0, bus->register_base + SMI_EN);
 	}
 	pci_set_drvdata(pdev, NULL);
-- 
2.30.2




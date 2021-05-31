Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87F5395CCF
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhEaNiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:38:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232482AbhEaNfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:35:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FF2561448;
        Mon, 31 May 2021 13:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467531;
        bh=DbpjfWwOX5w4DXwVz2QROu43Vb5DxDjYUSn+itNusMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iGvvlqNcn6s/DZlxirqiOZL+6FRTBsKW8e3ChhkFdWRW4xFCv7/MZGuTthMK88tff
         xbA8QveuVsTnCsDm+NcE9tReiDyasORsiiCPH+uTnhJPgj10Ud3FDMNk0iBFLfms31
         0UkLia+GGYCK6//s1I2QDRywJL0NAQKqp3BfI1zQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/116] net: mdio: thunder: Fix a double free issue in the .remove function
Date:   Mon, 31 May 2021 15:14:35 +0200
Message-Id: <20210531130643.493455174@linuxfoundation.org>
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
index 564616968cad..c0c922eff760 100644
--- a/drivers/net/phy/mdio-thunder.c
+++ b/drivers/net/phy/mdio-thunder.c
@@ -129,7 +129,6 @@ static void thunder_mdiobus_pci_remove(struct pci_dev *pdev)
 			continue;
 
 		mdiobus_unregister(bus->mii_bus);
-		mdiobus_free(bus->mii_bus);
 		oct_mdio_writeq(0, bus->register_base + SMI_EN);
 	}
 	pci_set_drvdata(pdev, NULL);
-- 
2.30.2




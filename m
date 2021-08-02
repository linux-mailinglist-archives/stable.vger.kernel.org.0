Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962253DD9BB
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbhHBODZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235060AbhHBOBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:01:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1161B6120E;
        Mon,  2 Aug 2021 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912594;
        bh=DRGdif0+md7ffSLCRW0MUogZtHNJWeZBOKThkqeTa5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGwaEE6pC3QYfOAieqaw/V5h2DHt4lftV5wYpnL/8P8ezCn1geNObJfQUgIgrnLqA
         UiKHJIafs3F0JKo87TopOqFj8jvGkF0n6VPZHdkIT3c5VbL7k8lakto430oHWz7bDd
         xznmdsYRcpaDe7nUaS3T3MFKWmcg1IGgUQjtFoHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Lo <kevlo@kevlo.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 064/104] net: phy: broadcom: re-add check for PHY_BRCM_DIS_TXCRXC_NOENRGY on the BCM54811 PHY
Date:   Mon,  2 Aug 2021 15:45:01 +0200
Message-Id: <20210802134346.100599184@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Lo <kevlo@kevlo.org>

[ Upstream commit ad4e1e48a6291f7fb53fbef38ca264966ffd65c9 ]

Restore PHY_ID_BCM54811 accidently removed by commit 5d4358ede8eb.

Fixes: 5d4358ede8eb ("net: phy: broadcom: Allow BCM54210E to configure APD")
Signed-off-by: Kevin Lo <kevlo@kevlo.org>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/broadcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 7bf3011b8e77..83aea5c5cd03 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -288,7 +288,7 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
 	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) {
 		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E ||
 		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810 ||
-		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E)
+		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54811)
 			val |= BCM54XX_SHD_SCR3_RXCTXC_DIS;
 		else
 			val |= BCM54XX_SHD_SCR3_TRDDAPD;
-- 
2.30.2




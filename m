Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37FF6147F69
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732916AbgAXLCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:02:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731007AbgAXLCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:02:02 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8492821556;
        Fri, 24 Jan 2020 11:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863721;
        bh=her1KqZZZYJ1ULu+WSHGR4a7gMqynTguaE1Gg09azHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ksZX/Mf42clK7q+dmPqIEjzgQoc03xcxquISS70Ln1v1e9QiPRl0jcXZ1vi1bwK0
         Y9VDc/cFaQ5P9bA0RDW5YuDs8nC0yxUvaiYW54GLBoZpmhgrFn5kfp3F2KAfzeQ+Ax
         JeWudwWPTCm69D40xmoPBbqRLYr+lyIG+ng8Bybs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Yoshitoyo Osaki <osaki.yoshitoyo@socionext.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/639] net: socionext: Add dummy PHY register read in phy_write()
Date:   Fri, 24 Jan 2020 10:23:47 +0100
Message-Id: <20200124093054.547335723@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahisa Kojima <masahisa.kojima@linaro.org>

[ Upstream commit a3241a91de6429051a211b5ce04d6946157caec7 ]

There is a compatibility issue between RTL8211E implemented
in Developerbox and netsec ethernet controller IP.

Our MDIO controller stops MDC clock right after the write
access, but RTL8211E expects MDC clock must be kept toggling
for several clock cycle with MDIO high before entering
the IDLE state. Without keeping clock after write access,
write access is not correctly handled and register is not
updated.

To meet this requirement, netsec driver needs to issue dummy
read(e.g. read PHYID1(offset 0x2) register) right after write
access, to keep MDC clock.

We think this compatibility issue is a problem specific to
our MDIO controller and RTL8211E.

Fixes: 533dd11a12f6 ("net: socionext: Add Synquacer NetSec driver")
Signed-off-by: Masahisa Kojima <masahisa.kojima@linaro.org>
Signed-off-by: Yoshitoyo Osaki <osaki.yoshitoyo@socionext.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 28d582c18afb9..d9d0d03e4ce79 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -432,9 +432,12 @@ static int netsec_mac_update_to_phy_state(struct netsec_priv *priv)
 	return 0;
 }
 
+static int netsec_phy_read(struct mii_bus *bus, int phy_addr, int reg_addr);
+
 static int netsec_phy_write(struct mii_bus *bus,
 			    int phy_addr, int reg, u16 val)
 {
+	int status;
 	struct netsec_priv *priv = bus->priv;
 
 	if (netsec_mac_write(priv, GMAC_REG_GDR, val))
@@ -447,8 +450,19 @@ static int netsec_phy_write(struct mii_bus *bus,
 			      GMAC_REG_SHIFT_CR_GAR)))
 		return -ETIMEDOUT;
 
-	return netsec_mac_wait_while_busy(priv, GMAC_REG_GAR,
-					  NETSEC_GMAC_GAR_REG_GB);
+	status = netsec_mac_wait_while_busy(priv, GMAC_REG_GAR,
+					    NETSEC_GMAC_GAR_REG_GB);
+
+	/* Developerbox implements RTL8211E PHY and there is
+	 * a compatibility problem with F_GMAC4.
+	 * RTL8211E expects MDC clock must be kept toggling for several
+	 * clock cycle with MDIO high before entering the IDLE state.
+	 * To meet this requirement, netsec driver needs to issue dummy
+	 * read(e.g. read PHYID1(offset 0x2) register) right after write.
+	 */
+	netsec_phy_read(bus, phy_addr, MII_PHYSID1);
+
+	return status;
 }
 
 static int netsec_phy_read(struct mii_bus *bus, int phy_addr, int reg_addr)
-- 
2.20.1




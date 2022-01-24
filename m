Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E06A499140
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378926AbiAXUKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:10:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46142 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376272AbiAXUBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:01:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 063BBB8124F;
        Mon, 24 Jan 2022 20:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31808C340E5;
        Mon, 24 Jan 2022 20:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054468;
        bh=MOqpyLIQ3I/vv1y8J/7vIEClqtBU18OiiM0sN/pQ4eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOElBW9Pm3SkRaxePYkH5Sr7ZI7CANFZ5kDf5yHTxdAJ9VM/OFdbv5LeDZ4rjmaod
         W+wNRv9LwYycjZ7SuDiLUjl218zAzKz6z1geu8ilH8aJCILZ1UpcY8dt6ckUG1SKwC
         wttYlH9J+2JfJw7EVxSBiB0gcq2pDPrRCXKHlhQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 400/563] net: phy: marvell: configure RGMII delays for 88E1118
Date:   Mon, 24 Jan 2022 19:42:45 +0100
Message-Id: <20220124184038.266854410@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit f22725c95ececb703c3f741e8f946d23705630b7 ]

Corentin Labbe reports that the SSI 1328 does not work when allowing
the PHY to operate at gigabit speeds, but does work with the generic
PHY driver.

This appears to be because m88e1118_config_init() writes a fixed value
to the MSCR register, claiming that this is to enable 1G speeds.
However, this always sets bits 4 and 5, enabling RGMII transmit and
receive delays. The suspicion is that the original board this was
added for required the delays to make 1G speeds work.

Add the necessary configuration for RGMII delays for the 88E1118 to
bring this into line with the requirements for RGMII support, and thus
make the SSI 1328 work.

Corentin Labbe has tested this on gemini-ssi1328 and gemini-ns2502.

Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 91616182c311f..4dda2ab19c265 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1090,6 +1090,12 @@ static int m88e1118_config_init(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
+	if (phy_interface_is_rgmii(phydev)) {
+		err = m88e1121_config_aneg_rgmii_delays(phydev);
+		if (err < 0)
+			return err;
+	}
+
 	/* Adjust LED Control */
 	if (phydev->dev_flags & MARVELL_PHY_M1118_DNS323_LEDS)
 		err = phy_write(phydev, 0x10, 0x1100);
-- 
2.34.1




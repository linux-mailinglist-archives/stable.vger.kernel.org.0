Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61FF499C96
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579712AbiAXWGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457894AbiAXVzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:55:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0085C07E2A4;
        Mon, 24 Jan 2022 12:36:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9178961535;
        Mon, 24 Jan 2022 20:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDAAC340E5;
        Mon, 24 Jan 2022 20:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056598;
        bh=cIVsYXY5t94PiqfXWViR/Oi0njjK/oBXtpCVnbK2xrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDCuDoLYb1l6mtmbdUKZ45Jml+amoKLjOYlekNvNdBMRp04LIqFRneVNFau08DQPi
         ymUUJ4Uhu2/qgbr0g7d/kzOZTxdacLYIKC2H8hu6Zw0H2f6Ry/Yexv+haBVzDi1A2p
         B5ZVoRrkGQGKceZ5Ik6p7n9uE9na2MaYJAI+nRrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 536/846] net: phy: prefer 1000baseT over 1000baseKX
Date:   Mon, 24 Jan 2022 19:40:53 +0100
Message-Id: <20220124184119.489770077@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit f20f94f7f52c4685c81754f489ffcc72186e8bdb ]

The PHY settings table is supposed to be sorted by descending match
priority - in other words, earlier entries are preferred over later
entries.

The order of 1000baseKX/Full and 1000baseT/Full is such that we
prefer 1000baseKX/Full over 1000baseT/Full, but 1000baseKX/Full is
a lot rarer than 1000baseT/Full, and thus is much less likely to
be preferred.

This causes phylink problems - it means a fixed link specifying a
speed of 1G and full duplex gets an ethtool linkmode of 1000baseKX/Full
rather than 1000baseT/Full as would be expected - and since we offer
userspace a software emulation of a conventional copper PHY, we want
to offer copper modes in preference to anything else. However, we do
still want to allow the rarer modes as well.

Hence, let's reorder these two modes to prefer copper.

Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/E1muvFO-00F6jY-1K@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 2870c33b8975d..271fc01f7f7fd 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -162,11 +162,11 @@ static const struct phy_setting settings[] = {
 	PHY_SETTING(   2500, FULL,   2500baseT_Full		),
 	PHY_SETTING(   2500, FULL,   2500baseX_Full		),
 	/* 1G */
-	PHY_SETTING(   1000, FULL,   1000baseKX_Full		),
 	PHY_SETTING(   1000, FULL,   1000baseT_Full		),
 	PHY_SETTING(   1000, HALF,   1000baseT_Half		),
 	PHY_SETTING(   1000, FULL,   1000baseT1_Full		),
 	PHY_SETTING(   1000, FULL,   1000baseX_Full		),
+	PHY_SETTING(   1000, FULL,   1000baseKX_Full		),
 	/* 100M */
 	PHY_SETTING(    100, FULL,    100baseT_Full		),
 	PHY_SETTING(    100, FULL,    100baseT1_Full		),
-- 
2.34.1




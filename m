Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F625498E27
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354894AbiAXTjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:39:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56438 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353222AbiAXTdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:33:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FF84B811FB;
        Mon, 24 Jan 2022 19:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B2AC340E5;
        Mon, 24 Jan 2022 19:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052810;
        bh=z3KHjrtjkrAJ1l60+JVSkvpB2u2zxdDMwLh9FzYWkM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eaT2bYcJPpqC4kXQPUSVMzK5zNTwDVesxhNLr4dm1ZEV/ob+7bsIO1BBCypGGWCLO
         py8fYe2WwjLjAB5rMvK7QByA1B06mPenxald7olN2nwRf7LJIXRmjx4WMNKnf8aUjW
         rTkJlfggZ34iAsA0FCzAd2WFq2mtDBs4aQPvUaSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 182/320] net: phy: prefer 1000baseT over 1000baseKX
Date:   Mon, 24 Jan 2022 19:42:46 +0100
Message-Id: <20220124183959.854124738@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index 9412669b579c7..84064120918f0 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -128,11 +128,11 @@ static const struct phy_setting settings[] = {
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




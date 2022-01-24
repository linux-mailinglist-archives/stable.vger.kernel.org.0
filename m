Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0374B4995EC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443598AbiAXU5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359040AbiAXUxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:53:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2536C02B862;
        Mon, 24 Jan 2022 11:58:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFA9560FEA;
        Mon, 24 Jan 2022 19:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B00EC340E8;
        Mon, 24 Jan 2022 19:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054329;
        bh=FXSw/S6ooWsN7m2aISlJ2oWew5BJRMgPDCbiE4oQ4RI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nz6yw2XRc0mGJLLS1kPZegysgogatvIoxwvTy6YG8DlCQtTuafxPJIJmUi5avvEbZ
         iqdCFwJG01xQFlrxLDp8u1EQ2iX0opwhRSl4dYpmrtWgesC/ubNn/7DxjGguz0WU7a
         LqjPQ1/7uTckJaRF8fiwWT2fxIUtoevI87M/2448=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 352/563] net: phy: prefer 1000baseT over 1000baseKX
Date:   Mon, 24 Jan 2022 19:41:57 +0100
Message-Id: <20220124184036.580028364@linuxfoundation.org>
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
index 8d333d3084ed3..cccb83dae673b 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -161,11 +161,11 @@ static const struct phy_setting settings[] = {
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




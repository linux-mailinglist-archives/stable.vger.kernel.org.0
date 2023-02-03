Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48EF46894E1
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbjBCKOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbjBCKOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:14:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D398F536
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:14:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A37C6B82A61
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7B7C433EF;
        Fri,  3 Feb 2023 10:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419269;
        bh=fpVLSjS4tCFPz9zuDmLMHujYVQo2gB+XXTQ/ifW5WuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hihsvcygSmDVh9VOYhNqfAQIbnMunZRx38rM0ldm1OyRRQ/mPk0nLHp+lHeB4wTkF
         g7WpFhzPKfP2kWYGmM7/rrE6muhXvidFt1iL2oh/uBz2BH5/4wejEO1dQVdhfk8fBg
         wk/hDJAlIr5EbObXUGGPrd0apHrK3myWioMoWJA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/62] net: mdio: validate parameter addr in mdiobus_get_phy()
Date:   Fri,  3 Feb 2023 11:12:09 +0100
Message-Id: <20230203101013.572345570@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 867dbe784c5010a466f00a7d1467c1c5ea569c75 ]

The caller may pass any value as addr, what may result in an out-of-bounds
access to array mdio_map. One existing case is stmmac_init_phy() that
may pass -1 as addr. Therefore validate addr before using it.

Fixes: 7f854420fbfe ("phy: Add API for {un}registering an mdio device to a bus.")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/cdf664ea-3312-e915-73f8-021678d08887@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 7a813449d0d1..a9a0638a9b7a 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -70,7 +70,12 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
 
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
 {
-	struct mdio_device *mdiodev = bus->mdio_map[addr];
+	struct mdio_device *mdiodev;
+
+	if (addr < 0 || addr >= ARRAY_SIZE(bus->mdio_map))
+		return NULL;
+
+	mdiodev = bus->mdio_map[addr];
 
 	if (!mdiodev)
 		return NULL;
-- 
2.39.0




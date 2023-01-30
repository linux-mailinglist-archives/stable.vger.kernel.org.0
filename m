Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455D3681341
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237839AbjA3Oab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237844AbjA3O3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:29:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE283FF27
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:28:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27146B811DC
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7750FC4339B;
        Mon, 30 Jan 2023 14:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088498;
        bh=Zd0NEtMvirAzblY4F/dZMttRUfQ6d4OYmPwA6KaVl14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qY4hVwZCcgGZaIPkczb6nNxMctb9SCOVFfllh4DXFVQL85YLWstx6HMpHOCXowZ/v
         JjJn8BfRsOsRtnqxFnYfaeciZCYfYx/4BBv9KK/KTesTHHLXimzks54uFEA7gGVkUL
         CKFIM87YbAokKXOSFjHUhYWHb67pUPFn9yE95PxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/143] net: mdio: validate parameter addr in mdiobus_get_phy()
Date:   Mon, 30 Jan 2023 14:51:36 +0100
Message-Id: <20230130134308.471588612@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
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
index 77ba6c3c7a09..e9303be48655 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -108,7 +108,12 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
 
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




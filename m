Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309D16B42F6
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbjCJOJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbjCJOIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:08:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81567637FF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:08:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA62FB822BB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C9EC433D2;
        Fri, 10 Mar 2023 14:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457302;
        bh=XUKplGLeoirwiZGl7M6zpSZIxJfDY+V6fHuy5E/3b2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTnO9OS8cwgMp2xvKcVFz0miqsDBu+tVa/+IL50IANsH1j4wo3IIbLe7jqZzMHWuR
         d2QE6W9ZN4euSgBUR146sDFtW0BNrPf2NqV57kcB8ZtSa9St0HMY/Xe/b6s2ejOFN8
         eSHfDA8quHWXilB7xr2fFQBAih/g+5K+98JAiJPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/200] net: dsa: seville: ignore mscc-miim read errors from Lynx PCS
Date:   Fri, 10 Mar 2023 14:38:17 +0100
Message-Id: <20230310133719.878680841@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 0322ef49c1ac6f0e2ef37b146c0bf8440873072c ]

During the refactoring in the commit below, vsc9953_mdio_read() was
replaced with mscc_miim_read(), which has one extra step: it checks for
the MSCC_MIIM_DATA_ERROR bits before returning the result.

On T1040RDB, there are 8 QSGMII PCSes belonging to the switch, and they
are organized in 2 groups. First group responds to MDIO addresses 4-7
because QSGMIIACR1[MDEV_PORT] is 1, and the second group responds to
MDIO addresses 8-11 because QSGMIIBCR1[MDEV_PORT] is 2. I have double
checked that these values are correctly set in the SERDES, as well as
PCCR1[QSGMA_CFG] and PCCR1[QSGMB_CFG] are both 0b01.

mscc_miim_read: phyad 8 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 8 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 8 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 8 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 9 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 9 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 9 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 9 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 10 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 10 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 10 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 10 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 11 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 11 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 11 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 11 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 4 reg 0x1 MIIM_DATA 0x3002d, ERROR
mscc_miim_read: phyad 4 reg 0x5 MIIM_DATA 0x3da01, ERROR
mscc_miim_read: phyad 5 reg 0x1 MIIM_DATA 0x3002d, ERROR
mscc_miim_read: phyad 5 reg 0x5 MIIM_DATA 0x35801, ERROR
mscc_miim_read: phyad 5 reg 0x1 MIIM_DATA 0x3002d, ERROR
mscc_miim_read: phyad 5 reg 0x5 MIIM_DATA 0x35801, ERROR
mscc_miim_read: phyad 6 reg 0x1 MIIM_DATA 0x3002d, ERROR
mscc_miim_read: phyad 6 reg 0x5 MIIM_DATA 0x35801, ERROR
mscc_miim_read: phyad 6 reg 0x1 MIIM_DATA 0x3002d, ERROR
mscc_miim_read: phyad 6 reg 0x5 MIIM_DATA 0x35801, ERROR
mscc_miim_read: phyad 7 reg 0x1 MIIM_DATA 0x3002d, ERROR
mscc_miim_read: phyad 7 reg 0x5 MIIM_DATA 0x35801, ERROR
mscc_miim_read: phyad 7 reg 0x1 MIIM_DATA 0x3002d, ERROR
mscc_miim_read: phyad 7 reg 0x5 MIIM_DATA 0x35801, ERROR

As can be seen, the data in MIIM_DATA is still valid despite having the
MSCC_MIIM_DATA_ERROR bits set. The driver as introduced in commit
84705fc16552 ("net: dsa: felix: introduce support for Seville VSC9953
switch") was ignoring these bits, perhaps deliberately (although
unbeknownst to me).

This is an old IP and the hardware team cannot seem to be able to help
me track down a plausible reason for these failures. I'll keep
investigating, but in the meantime, this is a direct regression which
must be restored to a working state.

The only thing I can do is keep ignoring the errors as before.

Fixes: b99658452355 ("net: dsa: ocelot: felix: utilize shared mscc-miim driver for indirect MDIO access")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 4 ++--
 drivers/net/mdio/mdio-mscc-miim.c        | 9 ++++++---
 include/linux/mdio/mdio-mscc-miim.h      | 2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 7af33b2c685da..c2863d6d870fb 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -923,8 +923,8 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 
 	rc = mscc_miim_setup(dev, &bus, "VSC9953 internal MDIO bus",
 			     ocelot->targets[GCB],
-			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK]);
-
+			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK],
+			     true);
 	if (rc) {
 		dev_err(dev, "failed to setup MDIO bus\n");
 		return rc;
diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 51f68daac152f..34b87389788bb 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -52,6 +52,7 @@ struct mscc_miim_info {
 struct mscc_miim_dev {
 	struct regmap *regs;
 	int mii_status_offset;
+	bool ignore_read_errors;
 	struct regmap *phy_regs;
 	const struct mscc_miim_info *info;
 	struct clk *clk;
@@ -138,7 +139,7 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 		goto out;
 	}
 
-	if (val & MSCC_MIIM_DATA_ERROR) {
+	if (!miim->ignore_read_errors && !!(val & MSCC_MIIM_DATA_ERROR)) {
 		ret = -EIO;
 		goto out;
 	}
@@ -218,7 +219,8 @@ static const struct regmap_config mscc_miim_phy_regmap_config = {
 };
 
 int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
-		    struct regmap *mii_regmap, int status_offset)
+		    struct regmap *mii_regmap, int status_offset,
+		    bool ignore_read_errors)
 {
 	struct mscc_miim_dev *miim;
 	struct mii_bus *bus;
@@ -240,6 +242,7 @@ int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
 
 	miim->regs = mii_regmap;
 	miim->mii_status_offset = status_offset;
+	miim->ignore_read_errors = ignore_read_errors;
 
 	*pbus = bus;
 
@@ -291,7 +294,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(phy_regmap),
 				     "Unable to create phy register regmap\n");
 
-	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0);
+	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0, false);
 	if (ret < 0) {
 		dev_err(dev, "Unable to setup the MDIO bus\n");
 		return ret;
diff --git a/include/linux/mdio/mdio-mscc-miim.h b/include/linux/mdio/mdio-mscc-miim.h
index 5b4ed2c3cbb9a..1ce699740af63 100644
--- a/include/linux/mdio/mdio-mscc-miim.h
+++ b/include/linux/mdio/mdio-mscc-miim.h
@@ -14,6 +14,6 @@
 
 int mscc_miim_setup(struct device *device, struct mii_bus **bus,
 		    const char *name, struct regmap *mii_regmap,
-		    int status_offset);
+		    int status_offset, bool ignore_read_errors);
 
 #endif
-- 
2.39.2




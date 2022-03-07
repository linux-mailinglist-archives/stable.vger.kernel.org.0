Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69FD24CF790
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238192AbiCGJqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236349AbiCGJmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:42:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA9B2617;
        Mon,  7 Mar 2022 01:41:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 979BAB8102B;
        Mon,  7 Mar 2022 09:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DB6C340E9;
        Mon,  7 Mar 2022 09:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646068;
        bh=fbeLY+CHCzdXGQgG50LPchB8OedOkqqonlZol/wh2iU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2uWPHhqmrHI1tTmAa39yKSid4l8IROTdftQmjJipqYXMo0j/8v4/kqYvcjhgwRp4
         7SDn98aTQhO3QfydQIUCIaxflMUvvo+JUpCEXmm3fKkWw19R3mIB6kC8X+ZZoN455k
         Tl7r/xZepRBvSGw0hfETYD2w4cnejPlXx21jQmQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Colin Foster <colin.foster@in-advantage.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/262] net: dsa: ocelot: seville: utilize of_mdiobus_register
Date:   Mon,  7 Mar 2022 10:17:46 +0100
Message-Id: <20220307091705.905040960@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Foster <colin.foster@in-advantage.com>

[ Upstream commit 5186c4a05b9713138b762a49467a8ab9753cdb36 ]

Switch seville to use of_mdiobus_register(bus, NULL) instead of just
mdiobus_register. This code is about to be pulled into a separate module
that can optionally define ports by the device_node.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index de1d34a1f1e47..ca8c003b99bc5 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -10,6 +10,7 @@
 #include <linux/pcs-lynx.h>
 #include <linux/dsa/ocelot.h>
 #include <linux/iopoll.h>
+#include <linux/of_mdio.h>
 #include "felix.h"
 
 #define MSCC_MIIM_CMD_OPR_WRITE			BIT(1)
@@ -1110,7 +1111,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
 
 	/* Needed in order to initialize the bus mutex lock */
-	rc = mdiobus_register(bus);
+	rc = of_mdiobus_register(bus, NULL);
 	if (rc < 0) {
 		dev_err(dev, "failed to register MDIO bus\n");
 		return rc;
-- 
2.34.1




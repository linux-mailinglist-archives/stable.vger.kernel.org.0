Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1623501447
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241150AbiDNNhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245465AbiDNN27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:28:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B07313F74;
        Thu, 14 Apr 2022 06:22:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24FFAB82987;
        Thu, 14 Apr 2022 13:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6888AC385A1;
        Thu, 14 Apr 2022 13:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942572;
        bh=MhbVDkR2xA2otRvtCUnVfjn/M07uTiXjhK6YPmb0k9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vc3J98ex1CIDLg0E9oTv4EylhluJFrdNURBUZcgnLwea8eU0j3kTGZI5TctIe09Ls
         156n1FyWtDMSSfdXxOuMVSd8jrNTsaGJZhGwgHrbXCiHFcQJXk0VpnCyohcMWbLGg+
         hoPWwk2zp03czDSuR9yBXnZUw4lE3gLr+m/rZi9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 183/338] net: phy: broadcom: Fix brcm_fet_config_init()
Date:   Thu, 14 Apr 2022 15:11:26 +0200
Message-Id: <20220414110844.107724712@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit bf8bfc4336f7a34e48b3bbd19b1542bf085bdc3d ]

A Broadcom AC201 PHY (same entry as 5241) would be flagged by the
Broadcom UniMAC MDIO controller as not completing the turn around
properly since the PHY expects 65 MDC clock cycles to complete a write
cycle, and the MDIO controller was only sending 64 MDC clock cycles as
determined by looking at a scope shot.

This would make the subsequent read fail with the UniMAC MDIO controller
command field having MDIO_READ_FAIL set and we would abort the
brcm_fet_config_init() function and thus not probe the PHY at all.

After issuing a software reset, wait for at least 1ms which is well
above the 1us reset delay advertised by the datasheet and issue a dummy
read to let the PHY turn around the line properly. This read
specifically ignores -EIO which would be returned by MDIO controllers
checking for the line being turned around.

If we have a genuine reaad failure, the next read of the interrupt
status register would pick it up anyway.

Fixes: d7a2ed9248a3 ("broadcom: Add AC131 phy support")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220324232438.1156812-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/broadcom.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index e86ea105c802..94622d119abc 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -15,6 +15,7 @@
  */
 
 #include "bcm-phy-lib.h"
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/phy.h>
 #include <linux/brcmphy.h>
@@ -462,6 +463,26 @@ static int brcm_fet_config_init(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
+	/* The datasheet indicates the PHY needs up to 1us to complete a reset,
+	 * build some slack here.
+	 */
+	usleep_range(1000, 2000);
+
+	/* The PHY requires 65 MDC clock cycles to complete a write operation
+	 * and turnaround the line properly.
+	 *
+	 * We ignore -EIO here as the MDIO controller (e.g.: mdio-bcm-unimac)
+	 * may flag the lack of turn-around as a read failure. This is
+	 * particularly true with this combination since the MDIO controller
+	 * only used 64 MDC cycles. This is not a critical failure in this
+	 * specific case and it has no functional impact otherwise, so we let
+	 * that one go through. If there is a genuine bus error, the next read
+	 * of MII_BRCM_FET_INTREG will error out.
+	 */
+	err = phy_read(phydev, MII_BMCR);
+	if (err < 0 && err != -EIO)
+		return err;
+
 	reg = phy_read(phydev, MII_BRCM_FET_INTREG);
 	if (reg < 0)
 		return reg;
-- 
2.34.1




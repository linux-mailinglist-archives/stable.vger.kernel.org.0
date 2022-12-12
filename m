Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94D564A1F5
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbiLLNrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbiLLNrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:47:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA001CD9
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:47:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62C61CE0F19
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CB0C433EF;
        Mon, 12 Dec 2022 13:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852830;
        bh=IiPo4eLlYAOWPWZWmGvcDpt8Om6V50tIifiRFFUUmpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEuqXvBxkq4Y1+UDzfyQwRdX7RfpM6eC+hgdxbTUG2O376ByicoteYfPYeYOdLekE
         DpUhhjbkZZ5jk2Izi4/SJowRqVpSzOwhQCwF9hKNAKFPnbu7JT6D/5PLVsGelcys0s
         5D02vdIk0r/ZJnyCfSNYLSNPKcqRVrmp0pcqNCE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Walle <michael@walle.cc>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 150/157] net: phy: mxl-gpy: add MDINT workaround
Date:   Mon, 12 Dec 2022 14:18:18 +0100
Message-Id: <20221212130941.251192187@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Michael Walle <michael@walle.cc>

[ Upstream commit 5f4d487d01ff5349da38f7a09ca36bf6aa2e29fb ]

At least the GPY215B and GPY215C has a bug where it is still driving the
interrupt line (MDINT) even after the interrupt status register is read
and its bits are cleared. This will cause an interrupt storm.

Although the MDINT is multiplexed with a GPIO pin and theoretically we
could switch the pinmux to GPIO input mode, this isn't possible because
the access to this register will stall exactly as long as the interrupt
line is asserted. We exploit this very fact and just read a random
internal register in our interrupt handler. This way, it will be delayed
until the external interrupt line is released and an interrupt storm is
avoided.

The internal register access via the mailbox was deduced by looking at
the downstream PHY API because the datasheet doesn't mention any of
this.

Fixes: 7d901a1e878a ("net: phy: add Maxlinear GPY115/21x/24x driver")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20221205200453.3447866-1-michael@walle.cc
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mxl-gpy.c | 85 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 24bae27eedef..cae24091fb6f 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/bitfield.h>
 #include <linux/hwmon.h>
+#include <linux/mutex.h>
 #include <linux/phy.h>
 #include <linux/polynomial.h>
 #include <linux/netdevice.h>
@@ -70,6 +71,14 @@
 #define VPSPEC1_TEMP_STA	0x0E
 #define VPSPEC1_TEMP_STA_DATA	GENMASK(9, 0)
 
+/* Mailbox */
+#define VSPEC1_MBOX_DATA	0x5
+#define VSPEC1_MBOX_ADDRLO	0x6
+#define VSPEC1_MBOX_CMD		0x7
+#define VSPEC1_MBOX_CMD_ADDRHI	GENMASK(7, 0)
+#define VSPEC1_MBOX_CMD_RD	(0 << 8)
+#define VSPEC1_MBOX_CMD_READY	BIT(15)
+
 /* WoL */
 #define VPSPEC2_WOL_CTL		0x0E06
 #define VPSPEC2_WOL_AD01	0x0E08
@@ -77,7 +86,13 @@
 #define VPSPEC2_WOL_AD45	0x0E0A
 #define WOL_EN			BIT(0)
 
+/* Internal registers, access via mbox */
+#define REG_GPIO0_OUT		0xd3ce00
+
 struct gpy_priv {
+	/* serialize mailbox acesses */
+	struct mutex mbox_lock;
+
 	u8 fw_major;
 	u8 fw_minor;
 };
@@ -187,6 +202,45 @@ static int gpy_hwmon_register(struct phy_device *phydev)
 }
 #endif
 
+static int gpy_mbox_read(struct phy_device *phydev, u32 addr)
+{
+	struct gpy_priv *priv = phydev->priv;
+	int val, ret;
+	u16 cmd;
+
+	mutex_lock(&priv->mbox_lock);
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_MBOX_ADDRLO,
+			    addr);
+	if (ret)
+		goto out;
+
+	cmd = VSPEC1_MBOX_CMD_RD;
+	cmd |= FIELD_PREP(VSPEC1_MBOX_CMD_ADDRHI, addr >> 16);
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_MBOX_CMD, cmd);
+	if (ret)
+		goto out;
+
+	/* The mbox read is used in the interrupt workaround. It was observed
+	 * that a read might take up to 2.5ms. This is also the time for which
+	 * the interrupt line is stuck low. To be on the safe side, poll the
+	 * ready bit for 10ms.
+	 */
+	ret = phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1,
+					VSPEC1_MBOX_CMD, val,
+					(val & VSPEC1_MBOX_CMD_READY),
+					500, 10000, false);
+	if (ret)
+		goto out;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_MBOX_DATA);
+
+out:
+	mutex_unlock(&priv->mbox_lock);
+	return ret;
+}
+
 static int gpy_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -201,6 +255,13 @@ static int gpy_config_init(struct phy_device *phydev)
 	return ret < 0 ? ret : 0;
 }
 
+static bool gpy_has_broken_mdint(struct phy_device *phydev)
+{
+	/* At least these PHYs are known to have broken interrupt handling */
+	return phydev->drv->phy_id == PHY_ID_GPY215B ||
+	       phydev->drv->phy_id == PHY_ID_GPY215C;
+}
+
 static int gpy_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -218,6 +279,7 @@ static int gpy_probe(struct phy_device *phydev)
 	if (!priv)
 		return -ENOMEM;
 	phydev->priv = priv;
+	mutex_init(&priv->mbox_lock);
 
 	fw_version = phy_read(phydev, PHY_FWV);
 	if (fw_version < 0)
@@ -492,6 +554,29 @@ static irqreturn_t gpy_handle_interrupt(struct phy_device *phydev)
 	if (!(reg & PHY_IMASK_MASK))
 		return IRQ_NONE;
 
+	/* The PHY might leave the interrupt line asserted even after PHY_ISTAT
+	 * is read. To avoid interrupt storms, delay the interrupt handling as
+	 * long as the PHY drives the interrupt line. An internal bus read will
+	 * stall as long as the interrupt line is asserted, thus just read a
+	 * random register here.
+	 * Because we cannot access the internal bus at all while the interrupt
+	 * is driven by the PHY, there is no way to make the interrupt line
+	 * unstuck (e.g. by changing the pinmux to GPIO input) during that time
+	 * frame. Therefore, polling is the best we can do and won't do any more
+	 * harm.
+	 * It was observed that this bug happens on link state and link speed
+	 * changes on a GPY215B and GYP215C independent of the firmware version
+	 * (which doesn't mean that this list is exhaustive).
+	 */
+	if (gpy_has_broken_mdint(phydev) &&
+	    (reg & (PHY_IMASK_LSTC | PHY_IMASK_LSPC))) {
+		reg = gpy_mbox_read(phydev, REG_GPIO0_OUT);
+		if (reg < 0) {
+			phy_error(phydev);
+			return IRQ_NONE;
+		}
+	}
+
 	phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
-- 
2.35.1




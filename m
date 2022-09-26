Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF705EA22E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbiIZLEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237059AbiIZLDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:03:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1E35EDF4;
        Mon, 26 Sep 2022 03:32:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9224DB8094D;
        Mon, 26 Sep 2022 10:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1923C433D6;
        Mon, 26 Sep 2022 10:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188208;
        bh=Jf6oRZhil1xoJGyJp8jVwLBg4X5qkPjZTxNA897XdmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MkozwcIZ4SL/z69reul6oToo5FyOZKkzzHJysMnlCw7h+l2kGEkmoUFFi3/mFCr/C
         ivp06lRGYoMSClsYPj9U/LXc7r/X+4cf4tsgRkSXg5nG3GBAWzSP1VrkjYXVA+kt3a
         2nRRTvlIgwGedKIUaMoK3OteS85MgDSOGUcPRjYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/141] net: phy: aquantia: wait for the suspend/resume operations to finish
Date:   Mon, 26 Sep 2022 12:11:41 +0200
Message-Id: <20220926100757.166693051@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit ca2dccdeeb49a7e408112d681bf447984c845292 ]

The Aquantia datasheet notes that after issuing a Processor-Intensive
MDIO operation, like changing the low-power state of the device, the
driver should wait for the operation to finish before issuing a new MDIO
command.

The new aqr107_wait_processor_intensive_op() function is added which can
be used after these kind of MDIO operations. At the moment, we are only
adding it at the end of the suspend/resume calls.

The issue was identified on a board featuring the AQR113C PHY, on
which commands like 'ip link (..) up / down' issued without any delays
between them would render the link on the PHY to remain down.
The issue was easy to reproduce with a one-liner:
 $ ip link set dev ethX down; ip link set dev ethX up; \
 ip link set dev ethX down; ip link set dev ethX up;

Fixes: ac9e81c230eb ("net: phy: aquantia: add suspend / resume callbacks for AQR107 family")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220906130451.1483448-1-ioana.ciornei@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/aquantia_main.c | 53 ++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 75a62d1cc737..7045595f8d7d 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -89,6 +89,9 @@
 #define VEND1_GLOBAL_FW_ID_MAJOR		GENMASK(15, 8)
 #define VEND1_GLOBAL_FW_ID_MINOR		GENMASK(7, 0)
 
+#define VEND1_GLOBAL_GEN_STAT2			0xc831
+#define VEND1_GLOBAL_GEN_STAT2_OP_IN_PROG	BIT(15)
+
 #define VEND1_GLOBAL_RSVD_STAT1			0xc885
 #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
 #define VEND1_GLOBAL_RSVD_STAT1_PROV_ID		GENMASK(3, 0)
@@ -123,6 +126,12 @@
 #define VEND1_GLOBAL_INT_VEND_MASK_GLOBAL2	BIT(1)
 #define VEND1_GLOBAL_INT_VEND_MASK_GLOBAL3	BIT(0)
 
+/* Sleep and timeout for checking if the Processor-Intensive
+ * MDIO operation is finished
+ */
+#define AQR107_OP_IN_PROG_SLEEP		1000
+#define AQR107_OP_IN_PROG_TIMEOUT	100000
+
 struct aqr107_hw_stat {
 	const char *name;
 	int reg;
@@ -569,16 +578,52 @@ static void aqr107_link_change_notify(struct phy_device *phydev)
 		phydev_info(phydev, "Aquantia 1000Base-T2 mode active\n");
 }
 
+static int aqr107_wait_processor_intensive_op(struct phy_device *phydev)
+{
+	int val, err;
+
+	/* The datasheet notes to wait at least 1ms after issuing a
+	 * processor intensive operation before checking.
+	 * We cannot use the 'sleep_before_read' parameter of read_poll_timeout
+	 * because that just determines the maximum time slept, not the minimum.
+	 */
+	usleep_range(1000, 5000);
+
+	err = phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1,
+					VEND1_GLOBAL_GEN_STAT2, val,
+					!(val & VEND1_GLOBAL_GEN_STAT2_OP_IN_PROG),
+					AQR107_OP_IN_PROG_SLEEP,
+					AQR107_OP_IN_PROG_TIMEOUT, false);
+	if (err) {
+		phydev_err(phydev, "timeout: processor-intensive MDIO operation\n");
+		return err;
+	}
+
+	return 0;
+}
+
 static int aqr107_suspend(struct phy_device *phydev)
 {
-	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
-				MDIO_CTRL1_LPOWER);
+	int err;
+
+	err = phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
+			       MDIO_CTRL1_LPOWER);
+	if (err)
+		return err;
+
+	return aqr107_wait_processor_intensive_op(phydev);
 }
 
 static int aqr107_resume(struct phy_device *phydev)
 {
-	return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
-				  MDIO_CTRL1_LPOWER);
+	int err;
+
+	err = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
+				 MDIO_CTRL1_LPOWER);
+	if (err)
+		return err;
+
+	return aqr107_wait_processor_intensive_op(phydev);
 }
 
 static int aqr107_probe(struct phy_device *phydev)
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46CA5EA5AE
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239356AbiIZMMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239301AbiIZMMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:12:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5348383BD0;
        Mon, 26 Sep 2022 03:58:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AFC360A36;
        Mon, 26 Sep 2022 10:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658ECC433B5;
        Mon, 26 Sep 2022 10:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189265;
        bh=MaRHsgu6x1R5SWPGz555MhiLnxi/cADJmYE8LEBbTcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWS6jO3XDuYvAnxU7bsNFdGM1P6gRSPMX6fvq0kbL/qXErEmnsAWB8rjDCxogXCpB
         nDHhAUdJQpoJP7xV7Et4YniVdAnwscH8RWjkrXJNSv3TKSMCvFhccZBy3sMob8/0gE
         NfX7896VWOeLYcgtA7TLI+thx7PlorDSmnCh3nYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 101/207] net: phy: aquantia: wait for the suspend/resume operations to finish
Date:   Mon, 26 Sep 2022 12:11:30 +0200
Message-Id: <20220926100811.109439140@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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
index c7047f5d7a9b..8bc0957a0f6d 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -90,6 +90,9 @@
 #define VEND1_GLOBAL_FW_ID_MAJOR		GENMASK(15, 8)
 #define VEND1_GLOBAL_FW_ID_MINOR		GENMASK(7, 0)
 
+#define VEND1_GLOBAL_GEN_STAT2			0xc831
+#define VEND1_GLOBAL_GEN_STAT2_OP_IN_PROG	BIT(15)
+
 #define VEND1_GLOBAL_RSVD_STAT1			0xc885
 #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
 #define VEND1_GLOBAL_RSVD_STAT1_PROV_ID		GENMASK(3, 0)
@@ -124,6 +127,12 @@
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
@@ -596,16 +605,52 @@ static void aqr107_link_change_notify(struct phy_device *phydev)
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCC046840B
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 11:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344568AbhLDKcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 05:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbhLDKcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 05:32:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD523C061751
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 02:28:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62E1D60BFE
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 10:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43011C341C0;
        Sat,  4 Dec 2021 10:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638613717;
        bh=ihsRoY+/Cp344F8jE2bFzwVSShYflSezg6c1qfgol5Q=;
        h=Subject:To:Cc:From:Date:From;
        b=mkYGelvD6JhmP3Ndk1hwIuK+f1oLgfN4nbE0AotyHCnMY542W8d797oQGW5CX4S2D
         fKlr/lUrL+FTsHaaNognnTnC9DFbTWLotpV4IAN0Vy3E5wcTkWwf9nzwuGuaN51A9n
         wayO37l+r4tXs9NdNIAN4sbn49jn6W/dYHAyQrp8=
Subject: FAILED: patch "[PATCH] net: dsa: mv88e6xxx: Save power by disabling SerDes" failed to apply to 5.15-stable tree
To:     kabel@kernel.org, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 04 Dec 2021 11:28:35 +0100
Message-ID: <16386137159777@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7527d66260ac0c603c6baca5146748061fcddbd6 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Date: Tue, 30 Nov 2021 18:01:48 +0100
Subject: [PATCH] net: dsa: mv88e6xxx: Save power by disabling SerDes
 trasmitter and receiver
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Save power on 88E6393X by disabling SerDes receiver and transmitter
after SerDes is SerDes is disabled.

Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org # de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 3a6244596a67..ceb63d7f1f97 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1271,6 +1271,28 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
 	}
 }
 
+static int mv88e6393x_serdes_power_lane(struct mv88e6xxx_chip *chip, int lane,
+					bool on)
+{
+	u16 reg;
+	int err;
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6393X_SERDES_CTRL1, &reg);
+	if (err)
+		return err;
+
+	if (on)
+		reg &= ~(MV88E6393X_SERDES_CTRL1_TX_PDOWN |
+			 MV88E6393X_SERDES_CTRL1_RX_PDOWN);
+	else
+		reg |= MV88E6393X_SERDES_CTRL1_TX_PDOWN |
+		       MV88E6393X_SERDES_CTRL1_RX_PDOWN;
+
+	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				      MV88E6393X_SERDES_CTRL1, reg);
+}
+
 static int mv88e6393x_serdes_erratum_4_6(struct mv88e6xxx_chip *chip, int lane)
 {
 	u16 reg;
@@ -1297,7 +1319,11 @@ static int mv88e6393x_serdes_erratum_4_6(struct mv88e6xxx_chip *chip, int lane)
 	if (err)
 		return err;
 
-	return mv88e6390_serdes_power_sgmii(chip, lane, false);
+	err = mv88e6390_serdes_power_sgmii(chip, lane, false);
+	if (err)
+		return err;
+
+	return mv88e6393x_serdes_power_lane(chip, lane, false);
 }
 
 int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip)
@@ -1362,17 +1388,29 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 		err = mv88e6393x_serdes_erratum_4_8(chip, lane);
 		if (err)
 			return err;
+
+		err = mv88e6393x_serdes_power_lane(chip, lane, true);
+		if (err)
+			return err;
 	}
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
 	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		return mv88e6390_serdes_power_sgmii(chip, lane, on);
+		err = mv88e6390_serdes_power_sgmii(chip, lane, on);
+		break;
 	case MV88E6393X_PORT_STS_CMODE_5GBASER:
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
-		return mv88e6390_serdes_power_10g(chip, lane, on);
+		err = mv88e6390_serdes_power_10g(chip, lane, on);
+		break;
 	}
 
-	return 0;
+	if (err)
+		return err;
+
+	if (!on)
+		err = mv88e6393x_serdes_power_lane(chip, lane, false);
+
+	return err;
 }
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index cbb3ba30caea..e9292c8beee4 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -93,6 +93,9 @@
 #define MV88E6393X_SERDES_POC_PCS_MASK		0x0007
 #define MV88E6393X_SERDES_POC_RESET		BIT(15)
 #define MV88E6393X_SERDES_POC_PDOWN		BIT(5)
+#define MV88E6393X_SERDES_CTRL1			0xf003
+#define MV88E6393X_SERDES_CTRL1_TX_PDOWN	BIT(9)
+#define MV88E6393X_SERDES_CTRL1_RX_PDOWN	BIT(8)
 
 #define MV88E6393X_ERRATA_4_8_REG		0xF074
 #define MV88E6393X_ERRATA_4_8_BIT		BIT(14)


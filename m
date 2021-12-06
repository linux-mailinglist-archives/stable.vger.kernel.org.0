Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41E7469DD5
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359591AbhLFPdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:33:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45424 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350411AbhLFP2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:28:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE90B61459;
        Mon,  6 Dec 2021 15:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F9BC34914;
        Mon,  6 Dec 2021 15:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804272;
        bh=Xu6XgOBcLtjlZepRtd9DqU9VQdJkez3CAEHgXN0+CgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUKEBAza9ZtMb13VxENoNR/APFH79wDBQaMZ0YHb4CaLjH6dHbpBeqM61F48eY6a7
         mBhbzYmNTR+pHlrGEGtACubdFQSo+k2I+07Uv0pWbVJBc6JqIQY8H5VQ/i/4BpcWJt
         hEsCExNmBvh7u5R1wpz4Xq4GTWd5fsR8LkdOsrn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 087/207] net: dsa: mv88e6xxx: Save power by disabling SerDes trasmitter and receiver
Date:   Mon,  6 Dec 2021 15:55:41 +0100
Message-Id: <20211206145613.249959346@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit 7527d66260ac0c603c6baca5146748061fcddbd6 upstream.

Save power on 88E6393X by disabling SerDes receiver and transmitter
after SerDes is SerDes is disabled.

Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org # de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c |   46 +++++++++++++++++++++++++++++++++----
 drivers/net/dsa/mv88e6xxx/serdes.h |    3 ++
 2 files changed, 45 insertions(+), 4 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1271,6 +1271,28 @@ void mv88e6390_serdes_get_regs(struct mv
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
@@ -1297,7 +1319,11 @@ static int mv88e6393x_serdes_erratum_4_6
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
@@ -1362,17 +1388,29 @@ int mv88e6393x_serdes_power(struct mv88e
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



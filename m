Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3ED469EBF
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385506AbhLFPn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358741AbhLFPi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:38:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CDEC08EB27;
        Mon,  6 Dec 2021 07:24:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 248FC61349;
        Mon,  6 Dec 2021 15:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080A7C341DB;
        Mon,  6 Dec 2021 15:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804266;
        bh=J5vOW0Nxlhi9TBHGN0OaFt8EO4L42AqRKq7rW2X0ssc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djoLqRsW8IM9yKdfNtSiL4UfuZt6ifv4VxRSl5osDrl1AmaJDnL7Irj1lB2GEApVp
         chMh6KbyAq5OhY+VzZeVCCMACS9YXDSNe6kzWtN+8GsZXZ4Wlb/ihGXqLfX75wE5QN
         YxHCViO0p1wmNWeOS6nKOLuIyLHAeNUmytM/jHII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 085/207] net: dsa: mv88e6xxx: Fix application of erratum 4.8 for 88E6393X
Date:   Mon,  6 Dec 2021 15:55:39 +0100
Message-Id: <20211206145613.181028359@linuxfoundation.org>
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

commit 21635d9203e1cf2b73b67e9a86059a62f62a3563 upstream.

According to SERDES scripts for 88E6393X, erratum 4.8 has to be applied
every time before SerDes is powered on.

Split the code for erratum 4.8 into separate function and call it in
mv88e6393x_serdes_power().

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c |   53 +++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 20 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1271,9 +1271,9 @@ void mv88e6390_serdes_get_regs(struct mv
 	}
 }
 
-static int mv88e6393x_serdes_port_errata(struct mv88e6xxx_chip *chip, int lane)
+static int mv88e6393x_serdes_erratum_4_6(struct mv88e6xxx_chip *chip, int lane)
 {
-	u16 reg, pcs;
+	u16 reg;
 	int err;
 
 	/* mv88e6393x family errata 4.6:
@@ -1300,11 +1300,32 @@ static int mv88e6393x_serdes_port_errata
 		if (err)
 			return err;
 
-		err = mv88e6390_serdes_power_sgmii(chip, lane, false);
-		if (err)
-			return err;
+		return mv88e6390_serdes_power_sgmii(chip, lane, false);
 	}
 
+	return 0;
+}
+
+int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip)
+{
+	int err;
+
+	err = mv88e6393x_serdes_erratum_4_6(chip, MV88E6393X_PORT0_LANE);
+	if (err)
+		return err;
+
+	err = mv88e6393x_serdes_erratum_4_6(chip, MV88E6393X_PORT9_LANE);
+	if (err)
+		return err;
+
+	return mv88e6393x_serdes_erratum_4_6(chip, MV88E6393X_PORT10_LANE);
+}
+
+static int mv88e6393x_serdes_erratum_4_8(struct mv88e6xxx_chip *chip, int lane)
+{
+	u16 reg, pcs;
+	int err;
+
 	/* mv88e6393x family errata 4.8:
 	 * When a SERDES port is operating in 1000BASE-X or SGMII mode link may
 	 * not come up after hardware reset or software reset of SERDES core.
@@ -1334,29 +1355,21 @@ static int mv88e6393x_serdes_port_errata
 				      MV88E6393X_ERRATA_4_8_REG, reg);
 }
 
-int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip)
-{
-	int err;
-
-	err = mv88e6393x_serdes_port_errata(chip, MV88E6393X_PORT0_LANE);
-	if (err)
-		return err;
-
-	err = mv88e6393x_serdes_port_errata(chip, MV88E6393X_PORT9_LANE);
-	if (err)
-		return err;
-
-	return mv88e6393x_serdes_port_errata(chip, MV88E6393X_PORT10_LANE);
-}
-
 int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			    bool on)
 {
 	u8 cmode = chip->ports[port].cmode;
+	int err;
 
 	if (port != 0 && port != 9 && port != 10)
 		return -EOPNOTSUPP;
 
+	if (on) {
+		err = mv88e6393x_serdes_erratum_4_8(chip, lane);
+		if (err)
+			return err;
+	}
+
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
 	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:



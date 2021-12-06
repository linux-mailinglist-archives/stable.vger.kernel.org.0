Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694AD469EC0
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391021AbhLFPn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378482AbhLFPif (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:38:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DDFC08EB2C;
        Mon,  6 Dec 2021 07:24:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03D8061349;
        Mon,  6 Dec 2021 15:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7683C33DE7;
        Mon,  6 Dec 2021 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804269;
        bh=EoesloKOMjkVdZkufub77Qzt8WCvvTDjuck6RLMw7Dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAGfLlBxzF2Sk7j8TieSyM8knXhWdXciL/87HWplfa2HRJYaFPo5J1h2olXK7KmGO
         ls46ASC5pFgS/RYtsKU+kOQ2byNOyVwlNDE46zxgt2qECbqdWLTG67eAlY12Bejfe8
         myS3pzp7Zh2jMEQ/3iCyupJVlkQXrh9At20khWHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 086/207] net: dsa: mv88e6xxx: Drop unnecessary check in mv88e6393x_serdes_erratum_4_6()
Date:   Mon,  6 Dec 2021 15:55:40 +0100
Message-Id: <20211206145613.219215776@linuxfoundation.org>
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

commit 8c3318b4874e2dee867f5ae8f6d38f78e044bf71 upstream.

The check for lane is unnecessary, since the function is called only
with allowed lane argument.

Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1284,26 +1284,20 @@ static int mv88e6393x_serdes_erratum_4_6
 	 * It seems that after this workaround the SERDES is automatically
 	 * powered up (the bit is cleared), so power it down.
 	 */
-	if (lane == MV88E6393X_PORT0_LANE || lane == MV88E6393X_PORT9_LANE ||
-	    lane == MV88E6393X_PORT10_LANE) {
-		err = mv88e6390_serdes_read(chip, lane,
-					    MDIO_MMD_PHYXS,
-					    MV88E6393X_SERDES_POC, &reg);
-		if (err)
-			return err;
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6393X_SERDES_POC, &reg);
+	if (err)
+		return err;
 
-		reg &= ~MV88E6393X_SERDES_POC_PDOWN;
-		reg |= MV88E6393X_SERDES_POC_RESET;
+	reg &= ~MV88E6393X_SERDES_POC_PDOWN;
+	reg |= MV88E6393X_SERDES_POC_RESET;
 
-		err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-					     MV88E6393X_SERDES_POC, reg);
-		if (err)
-			return err;
+	err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				     MV88E6393X_SERDES_POC, reg);
+	if (err)
+		return err;
 
-		return mv88e6390_serdes_power_sgmii(chip, lane, false);
-	}
-
-	return 0;
+	return mv88e6390_serdes_power_sgmii(chip, lane, false);
 }
 
 int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip)



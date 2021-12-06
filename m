Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18AC2469DCD
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357778AbhLFPdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:33:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33260 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240145AbhLFP2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:28:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 335C5B81180;
        Mon,  6 Dec 2021 15:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2D2C33B22;
        Mon,  6 Dec 2021 15:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804275;
        bh=0qoLfgMGBJ7fX0eHSL7m8jqpsVcGzkT9kEGvCT095fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRblQLU2YLtP5vRsxm3YO2JGRcDFmh982izlpwfbQtHrpuBzQsTKCvPS9CMx8oiuR
         SIcxEJUyd0V8VWOIN/6lSBGdsbqGQmHV9ydP1yE6ul81KdavSjLJTNRcg15wwFp9fb
         yRl4Z+ItkGUGdlZnp1g/WEbylxsGgDpS3E5qlx+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 088/207] net: dsa: mv88e6xxx: Add fix for erratum 5.2 of 88E6393X family
Date:   Mon,  6 Dec 2021 15:55:42 +0100
Message-Id: <20211206145613.283193518@linuxfoundation.org>
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

commit 93fd8207bed80ce19aaf59932cbe1c03d418a37d upstream.

Add fix for erratum 5.2 of the 88E6393X (Amethyst) family: for 10gbase-r
mode, some undocumented registers need to be written some special
values.

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c |   48 +++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1375,6 +1375,50 @@ static int mv88e6393x_serdes_erratum_4_8
 				      MV88E6393X_ERRATA_4_8_REG, reg);
 }
 
+static int mv88e6393x_serdes_erratum_5_2(struct mv88e6xxx_chip *chip, int lane,
+					 u8 cmode)
+{
+	static const struct {
+		u16 dev, reg, val, mask;
+	} fixes[] = {
+		{ MDIO_MMD_VEND1, 0x8093, 0xcb5a, 0xffff },
+		{ MDIO_MMD_VEND1, 0x8171, 0x7088, 0xffff },
+		{ MDIO_MMD_VEND1, 0x80c9, 0x311a, 0xffff },
+		{ MDIO_MMD_VEND1, 0x80a2, 0x8000, 0xff7f },
+		{ MDIO_MMD_VEND1, 0x80a9, 0x0000, 0xfff0 },
+		{ MDIO_MMD_VEND1, 0x80a3, 0x0000, 0xf8ff },
+		{ MDIO_MMD_PHYXS, MV88E6393X_SERDES_POC,
+		  MV88E6393X_SERDES_POC_RESET, MV88E6393X_SERDES_POC_RESET },
+	};
+	int err, i;
+	u16 reg;
+
+	/* mv88e6393x family errata 5.2:
+	 * For optimal signal integrity the following sequence should be applied
+	 * to SERDES operating in 10G mode. These registers only apply to 10G
+	 * operation and have no effect on other speeds.
+	 */
+	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(fixes); ++i) {
+		err = mv88e6390_serdes_read(chip, lane, fixes[i].dev,
+					    fixes[i].reg, &reg);
+		if (err)
+			return err;
+
+		reg &= ~fixes[i].mask;
+		reg |= fixes[i].val;
+
+		err = mv88e6390_serdes_write(chip, lane, fixes[i].dev,
+					     fixes[i].reg, reg);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			    bool on)
 {
@@ -1389,6 +1433,10 @@ int mv88e6393x_serdes_power(struct mv88e
 		if (err)
 			return err;
 
+		err = mv88e6393x_serdes_erratum_5_2(chip, lane, cmode);
+		if (err)
+			return err;
+
 		err = mv88e6393x_serdes_power_lane(chip, lane, true);
 		if (err)
 			return err;



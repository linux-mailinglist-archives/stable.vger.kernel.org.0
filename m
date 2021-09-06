Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4661401BDA
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243023AbhIFM77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242927AbhIFM7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:59:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 048066103D;
        Mon,  6 Sep 2021 12:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933097;
        bh=l//wTGK5/8pJwgdXTtA5HPjMBkYPj0M8VbpprPHxyIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yHPIFphRHRh8krTCENCBE/c1eIzTHzgMLBhy6pY+nt++ceF4N71ekNW1EM7DWd0V0
         tJV6a/nByXiQ9hQQwmOLCTYL7sHRN4n9tmonjlKkqS783HEL7A/jSqgZZYRLi6iwob
         s4zRjDRkTLCdUCuaFfCKTBTJ2XV2R7QWBA1PeN+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Rossi <nathan.rossi@digi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 06/24] net: dsa: mv88e6xxx: Update mv88e6393x serdes errata
Date:   Mon,  6 Sep 2021 14:55:35 +0200
Message-Id: <20210906125449.327459890@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.112564040@linuxfoundation.org>
References: <20210906125449.112564040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Rossi <nathan.rossi@digi.com>

[ Upstream commit 3b0720ba00a7413997ad331838d22c81f252556a ]

In early erratas this issue only covered port 0 when changing from
[x]MII (rev A 3.6). In subsequent errata versions this errata changed to
cover the additional "Hardware reset in CPU managed mode" condition, and
removed the note specifying that it only applied to port 0.

In designs where the device is configured with CPU managed mode
(CPU_MGD), on reset all SERDES ports (p0, p9, p10) have a stuck power
down bit and require this initial power up procedure. As such apply this
errata to all three SERDES ports of the mv88e6393x.

Signed-off-by: Nathan Rossi <nathan.rossi@digi.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index b1d46dd8eaab..6ea003678798 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1277,15 +1277,16 @@ static int mv88e6393x_serdes_port_errata(struct mv88e6xxx_chip *chip, int lane)
 	int err;
 
 	/* mv88e6393x family errata 4.6:
-	 * Cannot clear PwrDn bit on SERDES on port 0 if device is configured
-	 * CPU_MGD mode or P0_mode is configured for [x]MII.
-	 * Workaround: Set Port0 SERDES register 4.F002 bit 5=0 and bit 15=1.
+	 * Cannot clear PwrDn bit on SERDES if device is configured CPU_MGD
+	 * mode or P0_mode is configured for [x]MII.
+	 * Workaround: Set SERDES register 4.F002 bit 5=0 and bit 15=1.
 	 *
 	 * It seems that after this workaround the SERDES is automatically
 	 * powered up (the bit is cleared), so power it down.
 	 */
-	if (lane == MV88E6393X_PORT0_LANE) {
-		err = mv88e6390_serdes_read(chip, MV88E6393X_PORT0_LANE,
+	if (lane == MV88E6393X_PORT0_LANE || lane == MV88E6393X_PORT9_LANE ||
+	    lane == MV88E6393X_PORT10_LANE) {
+		err = mv88e6390_serdes_read(chip, lane,
 					    MDIO_MMD_PHYXS,
 					    MV88E6393X_SERDES_POC, &reg);
 		if (err)
-- 
2.30.2




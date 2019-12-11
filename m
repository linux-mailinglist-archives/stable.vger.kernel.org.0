Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAB4D11B58C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731535AbfLKPRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:17:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731235AbfLKPRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:17:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44DF42073D;
        Wed, 11 Dec 2019 15:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077473;
        bh=8013jwBuvI1srCrDO5iwcCxUJN4JuFZEz6Kzc/43Vz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZaYASGxIul/32e6kdzdmXCZ84VhrUQj6Ym9vQhrtoc9xV+pwBYG/bP3+wtEar3VnS
         H/8Z7/9YZrECZRIy1nWdKEYr21j2VO3YBXu+Dgqllk5zmVSrH5nx9eKHJvf0GU3g3G
         9JnDmKI+6saQ6jf4NpFNXy1StGi3Q2E4VfUzGGGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Healy <Chris.Healy@zii.aero>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/243] net: dsa: mv88e6xxx: Work around mv886e6161 SERDES missing MII_PHYSID2
Date:   Wed, 11 Dec 2019 16:03:34 +0100
Message-Id: <20191211150342.605556169@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit ddc49acb659a2d8bfc5fdb0de0ef197712c11d75 ]

We already have a workaround for a couple of switches whose internal
PHYs only have the Marvel OUI, but no model number. We detect such
PHYs and give them the 6390 ID as the model number. However the
mv88e6161 has two SERDES interfaces in the same address range as its
internal PHYs. These suffer from the same problem, the Marvell OUI,
but no model number. As a result, these SERDES interfaces were getting
the same PHY ID as the mv88e6390, even though they are not PHYs, and
the Marvell PHY driver was trying to drive them.

Add a special case to stop this from happen.

Reported-by: Chris Healy <Chris.Healy@zii.aero>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 411ae9961bf4f..43b00e8bcdcd7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2645,11 +2645,22 @@ static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
 	mutex_unlock(&chip->reg_lock);
 
 	if (reg == MII_PHYSID2) {
-		/* Some internal PHYS don't have a model number.  Use
-		 * the mv88e6390 family model number instead.
-		 */
-		if (!(val & 0x3f0))
-			val |= MV88E6XXX_PORT_SWITCH_ID_PROD_6390 >> 4;
+		/* Some internal PHYs don't have a model number. */
+		if (chip->info->family != MV88E6XXX_FAMILY_6165)
+			/* Then there is the 6165 family. It gets is
+			 * PHYs correct. But it can also have two
+			 * SERDES interfaces in the PHY address
+			 * space. And these don't have a model
+			 * number. But they are not PHYs, so we don't
+			 * want to give them something a PHY driver
+			 * will recognise.
+			 *
+			 * Use the mv88e6390 family model number
+			 * instead, for anything which really could be
+			 * a PHY,
+			 */
+			if (!(val & 0x3f0))
+				val |= MV88E6XXX_PORT_SWITCH_ID_PROD_6390 >> 4;
 	}
 
 	return err ? err : val;
-- 
2.20.1




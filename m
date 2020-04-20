Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFDD1B0B9B
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgDTM4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728623AbgDTMo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:44:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 484612223D;
        Mon, 20 Apr 2020 12:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386696;
        bh=XouSUB2txD38MHiqkRkXVgoIMazlZCnQGpTuJgqMjZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GV5PHEqbhqa3gMbCOUKTQCIdOU9ieMUtqgHrAy9KmN2KlDDMR7e9dszamWAE3wUNF
         WA0kmK3lI8GM9OHAHMeGzFiKibXoXPGw7snN3UdI0jNRHtollN7B2DR3iF2TREpd1I
         CgqivS8y61FhfEFKDAnQ5RsYOvXUPpFLA72KzXGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Clemens Gruber <clemens.gruber@pqgruber.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.6 21/71] net: phy: marvell: Fix pause frame negotiation
Date:   Mon, 20 Apr 2020 14:38:35 +0200
Message-Id: <20200420121512.569348523@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clemens Gruber <clemens.gruber@pqgruber.com>

[ Upstream commit 3b72f84f8fb65e83e85e9be58eabcf95a40b8f46 ]

The negotiation of flow control / pause frame modes was broken since
commit fcf1f59afc67 ("net: phy: marvell: rearrange to use
genphy_read_lpa()") moved the setting of phydev->duplex below the
phy_resolve_aneg_pause call. Due to a check of DUPLEX_FULL in that
function, phydev->pause was no longer set.

Fix it by moving the parsing of the status variable before the blocks
dealing with the pause frames.

As the Marvell 88E1510 datasheet does not specify the timing between the
link status and the "Speed and Duplex Resolved" bit, we have to force
the link down as long as the resolved bit is not set, to avoid reporting
link up before we even have valid Speed/Duplex.

Tested with a Marvell 88E1510 (RGMII to Copper/1000Base-T)

Fixes: fcf1f59afc67 ("net: phy: marvell: rearrange to use genphy_read_lpa()")
Signed-off-by: Clemens Gruber <clemens.gruber@pqgruber.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/marvell.c |   46 ++++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1278,6 +1278,30 @@ static int marvell_read_status_page_an(s
 	int lpa;
 	int err;
 
+	if (!(status & MII_M1011_PHY_STATUS_RESOLVED)) {
+		phydev->link = 0;
+		return 0;
+	}
+
+	if (status & MII_M1011_PHY_STATUS_FULLDUPLEX)
+		phydev->duplex = DUPLEX_FULL;
+	else
+		phydev->duplex = DUPLEX_HALF;
+
+	switch (status & MII_M1011_PHY_STATUS_SPD_MASK) {
+	case MII_M1011_PHY_STATUS_1000:
+		phydev->speed = SPEED_1000;
+		break;
+
+	case MII_M1011_PHY_STATUS_100:
+		phydev->speed = SPEED_100;
+		break;
+
+	default:
+		phydev->speed = SPEED_10;
+		break;
+	}
+
 	if (!fiber) {
 		err = genphy_read_lpa(phydev);
 		if (err < 0)
@@ -1306,28 +1330,6 @@ static int marvell_read_status_page_an(s
 		}
 	}
 
-	if (!(status & MII_M1011_PHY_STATUS_RESOLVED))
-		return 0;
-
-	if (status & MII_M1011_PHY_STATUS_FULLDUPLEX)
-		phydev->duplex = DUPLEX_FULL;
-	else
-		phydev->duplex = DUPLEX_HALF;
-
-	switch (status & MII_M1011_PHY_STATUS_SPD_MASK) {
-	case MII_M1011_PHY_STATUS_1000:
-		phydev->speed = SPEED_1000;
-		break;
-
-	case MII_M1011_PHY_STATUS_100:
-		phydev->speed = SPEED_100;
-		break;
-
-	default:
-		phydev->speed = SPEED_10;
-		break;
-	}
-
 	return 0;
 }
 



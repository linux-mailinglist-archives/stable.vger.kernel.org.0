Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C88520DA68
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732327AbgF2T4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387641AbgF2TkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7CBD24835;
        Mon, 29 Jun 2020 15:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444347;
        bh=+bMoGyWP/fESpWZ9O9+RuWU1Hnmv1KyLI11MaGLeVQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGMcYR6qLZobgBGrmvVNJD7VYrdQZuL8sZHrMlbLSdhP9Xnq9rI09Z634z1hN6CUu
         /EnmmLAbOFMAaaeL9BB8PNmTwzmyOGZrp7XTor5VikHljE374wY+3cskTnR/6Q3Szn
         IERFqpVsJBXCxnXu8sJDpKhWSpasyy27L2QZb2NQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 022/178] net: phy: Check harder for errors in get_phy_id()
Date:   Mon, 29 Jun 2020 11:22:47 -0400
Message-Id: <20200629152523.2494198-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit b2ffc75e2e990b09903f9d15ccd53bc5f3a4217c ]

Commit 02a6efcab675 ("net: phy: allow scanning busses with missing
phys") added a special condition to return -ENODEV in case -ENODEV or
-EIO was returned from the first read of the MII_PHYSID1 register.

In case the MDIO bus data line pull-up is not strong enough, the MDIO
bus controller will not flag this as a read error. This can happen when
a pluggable daughter card is not connected and weak internal pull-ups
are used (since that is the only option, otherwise the pins are
floating).

The second read of MII_PHYSID2 will be correctly flagged an error
though, but now we will return -EIO which will be treated as a hard
error, thus preventing MDIO bus scanning loops to continue succesfully.

Apply the same logic to both register reads, thus allowing the scanning
logic to proceed.

Fixes: 02a6efcab675 ("net: phy: allow scanning busses with missing phys")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 0907c3d8d94a2..dba52a5c378ad 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -797,8 +797,10 @@ static int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id,
 
 	/* Grab the bits from PHYIR2, and put them in the lower half */
 	phy_reg = mdiobus_read(bus, addr, MII_PHYSID2);
-	if (phy_reg < 0)
-		return -EIO;
+	if (phy_reg < 0) {
+		/* returning -ENODEV doesn't stop bus scanning */
+		return (phy_reg == -EIO || phy_reg == -ENODEV) ? -ENODEV : -EIO;
+	}
 
 	*phy_id |= phy_reg;
 
-- 
2.25.1


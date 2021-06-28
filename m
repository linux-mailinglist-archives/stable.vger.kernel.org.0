Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999D43B600B
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhF1OV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233161AbhF1OVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5890F61C82;
        Mon, 28 Jun 2021 14:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889946;
        bh=v/nOJmQQ08mnD/U/0+K6FWc6VBo1nCPFpakS1BX+18o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fe9ctVyWISiUu7wK5w7EnBbaBEnCwJlNIlxxms+uKT2EGcxVP8EUevg4gdJdMVktQ
         +cAKAHqiR0kanYy08NZnbZSI06vIvewO1QT6g7BCoGu991DcTRsGiynSGlxRHu1N84
         wldgIh6bwjGnmnNYSbAI2YwOkLrC5f0RgvQQrDv9RLDUVNKpT4dZlePr2Y3fSqGGSC
         t4j3K+/qKF+1u0hd0vDuR1bEBsdjXvGY93t3abfzTYS5YnnLQU8RrNEZmbVnGs7mSZ
         7KL9W9r4OFFvs1Wk3fIjAuio2nG+cUObbyZ3sMlCMHsvh6eHscd1TOSIsuuT5sXOJr
         16S2NZ7URnlCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Praneeth Bajjuri <praneeth@ti.com>, Geet Modi <geet.modi@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 042/110] net: phy: dp83867: perform soft reset and retain established link
Date:   Mon, 28 Jun 2021 10:17:20 -0400
Message-Id: <20210628141828.31757-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Praneeth Bajjuri <praneeth@ti.com>

[ Upstream commit da9ef50f545f86ffe6ff786174d26500c4db737a ]

Current logic is performing hard reset and causing the programmed
registers to be wiped out.

as per datasheet: https://www.ti.com/lit/ds/symlink/dp83867cr.pdf
8.6.26 Control Register (CTRL)

do SW_RESTART to perform a reset not including the registers,
If performed when link is already present,
it will drop the link and trigger re-auto negotiation.

Signed-off-by: Praneeth Bajjuri <praneeth@ti.com>
Signed-off-by: Geet Modi <geet.modi@ti.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83867.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 9bd9a5c0b1db..6bbc81ad295f 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -826,16 +826,12 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 {
 	int err;
 
-	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESET);
+	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESTART);
 	if (err < 0)
 		return err;
 
 	usleep_range(10, 20);
 
-	/* After reset FORCE_LINK_GOOD bit is set. Although the
-	 * default value should be unset. Disable FORCE_LINK_GOOD
-	 * for the phy to work properly.
-	 */
 	return phy_modify(phydev, MII_DP83867_PHYCTRL,
 			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
 }
-- 
2.30.2


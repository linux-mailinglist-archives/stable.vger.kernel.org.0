Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 504691480DB
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390226AbgAXLOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:14:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389867AbgAXLOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:14:36 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E21F22467B;
        Fri, 24 Jan 2020 11:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864475;
        bh=fkh3FgWL0E1pUimUwrTS1dFv2ZIouiEsPk4F+mvnZao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NG72FXYxFJfF2MiIjEW4jk0+obufLa6knM9TdtJ0wjO8YrGsZ3QQ8U1zx3KhVoZVJ
         0FAvfdOATPLDkXLZCU/XEl7dkCru/yyWd7dwHcPA5GQwyS/nUSgdaSGNccuRmi49IL
         Y+Ce+MhdMzE3uL5hXQi34FoXZnb5oS6xi09NBMVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Reid <preid@electromag.com.au>,
        liweihang <liweihang@hisilicon.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 276/639] net: phy: dont clear BMCR in genphy_soft_reset
Date:   Fri, 24 Jan 2020 10:27:26 +0100
Message-Id: <20200124093121.384723051@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit d29f5aa0bc0c321e1b9e4658a2a7e08e885da52a ]

So far we effectively clear the BMCR register. Some PHY's can deal
with this (e.g. because they reset BMCR to a default as part of a
soft-reset) whilst on others this causes issues because e.g. the
autoneg bit is cleared. Marvell is an example, see also thread [0].
So let's be a little bit more gentle and leave all bits we're not
interested in as-is. This change is needed for PHY drivers to
properly deal with the original patch.

[0] https://marc.info/?t=155264050700001&r=1&w=2

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Tested-by: Phil Reid <preid@electromag.com.au>
Tested-by: liweihang <liweihang@hisilicon.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9c7e51443f6b6..ae40d8137fd20 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1657,7 +1657,7 @@ int genphy_soft_reset(struct phy_device *phydev)
 {
 	int ret;
 
-	ret = phy_write(phydev, MII_BMCR, BMCR_RESET);
+	ret = phy_set_bits(phydev, MII_BMCR, BMCR_RESET);
 	if (ret < 0)
 		return ret;
 
-- 
2.20.1




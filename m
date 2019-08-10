Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A879D88D37
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfHJUny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:43:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54274 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726457AbfHJUnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:53 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-00053Y-Ss; Sat, 10 Aug 2019 21:43:48 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003bN-WD; Sat, 10 Aug 2019 21:43:46 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "Phil Reid" <preid@electromag.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "liweihang" <liweihang@hisilicon.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.97542613@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 049/157] net: phy: don't clear BMCR in genphy_soft_reset
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit d29f5aa0bc0c321e1b9e4658a2a7e08e885da52a upstream.

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
[bwh: Backported to 3.16: open-code phy_set_bits()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1072,7 +1072,10 @@ int genphy_soft_reset(struct phy_device
 {
 	int ret;
 
-	ret = phy_write(phydev, MII_BMCR, BMCR_RESET);
+	ret = phy_read(phydev, MII_BMCR);
+	if (ret < 0)
+		return ret;
+	ret = phy_write(phydev, MII_BMCR, ret | BMCR_RESET);
 	if (ret < 0)
 		return ret;
 


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E674F4123E8
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379221AbhITS2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:28:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378787AbhITS00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:26:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6056561244;
        Mon, 20 Sep 2021 17:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158751;
        bh=aHzs2Pypu+HwoFsHuPJXCeG8sMuoKR+6muI/CLd3l2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZnmUKQmidXegRZBvRDZ1Q8XiqJT/a42HlUj2SueX5KG7turx7C2oWFI+v8WlhddU
         uYYls0HFu6K4bo2AdFQ7Uea/CsWAM+C39+hSyZXiu8ixX7bEC1wd5KpHbAoi1MX1vu
         thfI2/zjzluYrmGvtkzwMlq2C/e8wUC70xZgLJKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 040/122] net: dsa: destroy the phylink instance on any error in dsa_slave_phy_setup
Date:   Mon, 20 Sep 2021 18:43:32 +0200
Message-Id: <20210920163917.103844544@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 6a52e73368038f47f6618623d75061dc263b26ae upstream.

DSA supports connecting to a phy-handle, and has a fallback to a non-OF
based method of connecting to an internal PHY on the switch's own MDIO
bus, if no phy-handle and no fixed-link nodes were present.

The -ENODEV error code from the first attempt (phylink_of_phy_connect)
is what triggers the second attempt (phylink_connect_phy).

However, when the first attempt returns a different error code than
-ENODEV, this results in an unbalance of calls to phylink_create and
phylink_destroy by the time we exit the function. The phylink instance
has leaked.

There are many other error codes that can be returned by
phylink_of_phy_connect. For example, phylink_validate returns -EINVAL.
So this is a practical issue too.

Fixes: aab9c4067d23 ("net: dsa: Plug in PHYLINK support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20210914134331.2303380-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/slave.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1728,13 +1728,11 @@ static int dsa_slave_phy_setup(struct ne
 		 * use the switch internal MDIO bus instead
 		 */
 		ret = dsa_slave_phy_connect(slave_dev, dp->index);
-		if (ret) {
-			netdev_err(slave_dev,
-				   "failed to connect to port %d: %d\n",
-				   dp->index, ret);
-			phylink_destroy(dp->pl);
-			return ret;
-		}
+	}
+	if (ret) {
+		netdev_err(slave_dev, "failed to connect to PHY: %pe\n",
+			   ERR_PTR(ret));
+		phylink_destroy(dp->pl);
 	}
 
 	return ret;



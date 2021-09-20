Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C384120C0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350074AbhITR5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349742AbhITRzv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:55:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40C5061C16;
        Mon, 20 Sep 2021 17:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158042;
        bh=kHtKFT2USIlX41377D96jYNFZHEDSLiS+PgJ1Z4aG0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oC3G4AC7J18OWxKK/NzDzVm6M1ir4nwvFlcQOTK7wnJbehHNPTpUgGMkzfSMJHCen
         9XwDuVegCVCUGeG51QdgiGc1QkYz0SkGyowMey7TyACDQCbeK+mwnCn2Fwej8ryP44
         qvN7gpl4Txzx3h6gsB3NctX/+jf7JRdVGR3oU/Vc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 268/293] net: dsa: destroy the phylink instance on any error in dsa_slave_phy_setup
Date:   Mon, 20 Sep 2021 18:43:50 +0200
Message-Id: <20210920163942.586707272@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
@@ -1226,13 +1226,11 @@ static int dsa_slave_phy_setup(struct ne
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



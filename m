Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5248B41256B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349460AbhITSpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:45:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382710AbhITSmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:42:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB6996333B;
        Mon, 20 Sep 2021 17:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159107;
        bh=25VZmXlBoEsaxOHHIKUAQV+S0QZHAPZdnMv/5iJxgwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kh6M0CsNMBlOyySBbYSAdOQDE/2E1cBJYDXQgSvXYBA04SjGb2uhnWE0xfkzGbOU+
         +0dPobgFQUnpkU+wWYkdf4ddCVsEZqTrTApJdzGb64HB2VQOrg29TVLecaC18z8v8E
         8/PvCl5CigECHUKfdEtVCdrD5+0l4PTpFsw0HnHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.14 062/168] net: dsa: destroy the phylink instance on any error in dsa_slave_phy_setup
Date:   Mon, 20 Sep 2021 18:43:20 +0200
Message-Id: <20210920163923.675441643@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
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
@@ -1784,13 +1784,11 @@ static int dsa_slave_phy_setup(struct ne
 		 * use the switch internal MDIO bus instead
 		 */
 		ret = dsa_slave_phy_connect(slave_dev, dp->index, phy_flags);
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



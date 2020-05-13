Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F021D0E3E
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387567AbgEMJyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:54:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388044AbgEMJyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:54:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C6B020769;
        Wed, 13 May 2020 09:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363643;
        bh=BdMqFTzEZHhelZ/QBJ0FxUzahoGtw5CGMIcdgLvZZp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1xvDIUSUjQNj/PBVV/5GN6hNJZy1dE9ur0jqxoAfW2D9y1WLAWRxfYK8QMZYL5Oa
         aPD1hm3kw6y++V8j9FMrooGSeP/Ya3IxTe777WpB7WVBTXkERxYvw+6MChP7tQv7mB
         mlI1ZMIOfHrm8x1DhW0lDS6pMmQ4KJF7QAeR/osk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Felice <tony.felice@timesys.com>,
        Akshay Bhat <akshay.bhat@timesys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 030/118] net: tc35815: Fix phydev supported/advertising mask
Date:   Wed, 13 May 2020 11:44:09 +0200
Message-Id: <20200513094420.203399386@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Felice <tony.felice@timesys.com>

[ Upstream commit 4b5b71f770e2edefbfe74203777264bfe6a9927c ]

Commit 3c1bcc8614db ("net: ethernet: Convert phydev advertize and
supported from u32 to link mode") updated ethernet drivers to use a
linkmode bitmap. It mistakenly dropped a bitwise negation in the
tc35815 ethernet driver on a bitmask to set the supported/advertising
flags.

Found by Anthony via code inspection, not tested as I do not have the
required hardware.

Fixes: 3c1bcc8614db ("net: ethernet: Convert phydev advertize and supported from u32 to link mode")
Signed-off-by: Anthony Felice <tony.felice@timesys.com>
Reviewed-by: Akshay Bhat <akshay.bhat@timesys.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/toshiba/tc35815.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -643,7 +643,7 @@ static int tc_mii_probe(struct net_devic
 		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, mask);
 		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, mask);
 	}
-	linkmode_and(phydev->supported, phydev->supported, mask);
+	linkmode_andnot(phydev->supported, phydev->supported, mask);
 	linkmode_copy(phydev->advertising, phydev->supported);
 
 	lp->link = 0;



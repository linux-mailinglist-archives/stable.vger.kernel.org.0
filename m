Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A39C33B6AF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbhCON6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232225AbhCON56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 908A764EF9;
        Mon, 15 Mar 2021 13:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816677;
        bh=oD4TM/SvGJHNIoZyCTwvQxsQZ3c7mMfWJYN44chZ208=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uT25VqoyQt1pDnk1D7hqckGkiCi2l2JcNXASRvOTGhuQkdpyVnqefnnY8WWB/o6My
         X80pDsD4t7PGDmbXeA0UVrLWJM0N9gM/tCxCAgGxs6Y5bAV2xDHtjySucHM9KT0MYo
         Tf4kJamIv++bSY3T2yzqs5dytEoDSQGFal/Xfrzg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 050/290] net: dsa: sja1105: fix SGMII PCS being forced to SPEED_UNKNOWN instead of SPEED_10
Date:   Mon, 15 Mar 2021 14:52:23 +0100
Message-Id: <20210315135543.615398964@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 053d8ad10d585adf9891fcd049637536e2fe9ea7 upstream.

When using MLO_AN_PHY or MLO_AN_FIXED, the MII_BMCR of the SGMII PCS is
read before resetting the switch so it can be reprogrammed afterwards.
This works for the speeds of 1Gbps and 100Mbps, but not for 10Mbps,
because SPEED_10 is actually 0, so AND-ing anything with 0 is false,
therefore that last branch is dead code.

Do what others do (genphy_read_status_fixed, phy_mii_ioctl) and just
remove the check for SPEED_10, let it fall into the default case.

Fixes: ffe10e679cec ("net: dsa: sja1105: Add support for the SGMII port")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1834,7 +1834,7 @@ out_unlock_ptp:
 				speed = SPEED_1000;
 			else if (bmcr & BMCR_SPEED100)
 				speed = SPEED_100;
-			else if (bmcr & BMCR_SPEED10)
+			else
 				speed = SPEED_10;
 
 			sja1105_sgmii_pcs_force_speed(priv, speed);



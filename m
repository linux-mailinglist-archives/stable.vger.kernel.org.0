Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52762528EEB
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346116AbiEPToi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345863AbiEPTn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:43:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73CC3ED2F;
        Mon, 16 May 2022 12:42:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AFBD61512;
        Mon, 16 May 2022 19:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2396EC385AA;
        Mon, 16 May 2022 19:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730176;
        bh=0qaYJ6t+jGn0y50xO1gdfkgcxkO0fPq+vjA0LCRL1/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNSVPWVCkaT9X7MIZrpRndcdafwpHqZbNJr0F2U+ylZ7R6zDj5Oq5qqaXElDJRK0P
         45p+ZByKk1iCzGGalkP0rk1/blD96ZGCIIuwCdV5gJqvHcsHOvEnfoQ/bmrIo2NkGW
         8DdBDCFg0ha6bFXafSbjquRi4XzuYFz1S4TuiCLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/43] net: emaclite: Dont advertise 1000BASE-T and do auto negotiation
Date:   Mon, 16 May 2022 21:36:34 +0200
Message-Id: <20220516193615.402849285@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.714657361@linuxfoundation.org>
References: <20220516193614.714657361@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shravya Kumbham <shravya.kumbham@xilinx.com>

[ Upstream commit b800528b97d0adc3a5ba42d78a8b0d3f07a31f44 ]

In xemaclite_open() function we are setting the max speed of
emaclite to 100Mb using phy_set_max_speed() function so,
there is no need to write the advertising registers to stop
giga-bit speed and the phy_start() function starts the
auto-negotiation so, there is no need to handle it separately
using advertising registers. Remove the phy_read and phy_write
of advertising registers in xemaclite_open() function.

Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index bec09008997d..6e5ea68b6a7e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -932,8 +932,6 @@ static int xemaclite_open(struct net_device *dev)
 	xemaclite_disable_interrupts(lp);
 
 	if (lp->phy_node) {
-		u32 bmcr;
-
 		lp->phy_dev = of_phy_connect(lp->ndev, lp->phy_node,
 					     xemaclite_adjust_link, 0,
 					     PHY_INTERFACE_MODE_MII);
@@ -944,19 +942,6 @@ static int xemaclite_open(struct net_device *dev)
 
 		/* EmacLite doesn't support giga-bit speeds */
 		phy_set_max_speed(lp->phy_dev, SPEED_100);
-
-		/* Don't advertise 1000BASE-T Full/Half duplex speeds */
-		phy_write(lp->phy_dev, MII_CTRL1000, 0);
-
-		/* Advertise only 10 and 100mbps full/half duplex speeds */
-		phy_write(lp->phy_dev, MII_ADVERTISE, ADVERTISE_ALL |
-			  ADVERTISE_CSMA);
-
-		/* Restart auto negotiation */
-		bmcr = phy_read(lp->phy_dev, MII_BMCR);
-		bmcr |= (BMCR_ANENABLE | BMCR_ANRESTART);
-		phy_write(lp->phy_dev, MII_BMCR, bmcr);
-
 		phy_start(lp->phy_dev);
 	}
 
-- 
2.35.1




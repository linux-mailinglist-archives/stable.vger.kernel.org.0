Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAD0529073
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239201AbiEPUEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348810AbiEPT66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:58:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F70B43AFC;
        Mon, 16 May 2022 12:51:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1151FB81612;
        Mon, 16 May 2022 19:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61024C34100;
        Mon, 16 May 2022 19:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730664;
        bh=RztfQ90jXpDs3wSaZIRAhybCdZaqmicuc1/LNiTgqz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbFyY0D6LP0PGJVIiL5w8Z7Q8SS4ujhy8/mVfYuKxubKt14q9MPK3Dht7uvQ6phCp
         cHnocMaBsPGwc/bU/aNcEyTCC8lwRzJUkCaau47w0o5+5H0KnC/8B+s7yIqw699jGm
         XuIyh0O17TYj87zs9ZKiqQdSpW0O9ekDHDzhTVH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/102] net: emaclite: Dont advertise 1000BASE-T and do auto negotiation
Date:   Mon, 16 May 2022 21:36:27 +0200
Message-Id: <20220516193625.519005771@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
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
index 642472de5a08..97c1d1ecba34 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -934,8 +934,6 @@ static int xemaclite_open(struct net_device *dev)
 	xemaclite_disable_interrupts(lp);
 
 	if (lp->phy_node) {
-		u32 bmcr;
-
 		lp->phy_dev = of_phy_connect(lp->ndev, lp->phy_node,
 					     xemaclite_adjust_link, 0,
 					     PHY_INTERFACE_MODE_MII);
@@ -946,19 +944,6 @@ static int xemaclite_open(struct net_device *dev)
 
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




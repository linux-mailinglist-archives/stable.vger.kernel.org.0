Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616534B47FA
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245263AbiBNJsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:48:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344336AbiBNJqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:46:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6AEBF66;
        Mon, 14 Feb 2022 01:40:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6BF6B80DC6;
        Mon, 14 Feb 2022 09:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD391C340E9;
        Mon, 14 Feb 2022 09:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831615;
        bh=AfJo0oaudbGhuFYqs9I47rvRQD9hhCLhsIx+mmkRoHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rY2SnVdvcu5L8oqBIB+10v2v5zAYhg4osRcTnd/eIq6Q4U3qXnNX4r8RfCr9ajSRc
         xjxnv5oAjtUHjnbBctiKyyMJI8d8na/yAvDQdPO9PvrO7O5dRd3JQhRqCk1d1ZqORD
         PoW1JPbl+1cqAK1RMhs3hpr5Bjc/DB4/UHHyPi4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 008/116] net: phy: marvell: Fix MDI-x polarity setting in 88e1118-compatible PHYs
Date:   Mon, 14 Feb 2022 10:25:07 +0100
Message-Id: <20220214092458.962983882@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>

commit aec12836e7196e4d360b2cbf20cf7aa5139ad2ec upstream.

When setting up autonegotiation for 88E1118R and compatible PHYs,
a software reset of PHY is issued before setting up polarity.
This is incorrect as changes of MDI Crossover Mode bits are
disruptive to the normal operation and must be followed by a
software reset to take effect. Let's patch m88e1118_config_aneg()
to fix the issue mentioned before by invoking software reset
of the PHY just after setting up MDI-x polarity.

Fixes: 605f196efbf8 ("phy: Add support for Marvell 88E1118 PHY")
Signed-off-by: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Cc: stable@vger.kernel.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/marvell.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1061,16 +1061,15 @@ static int m88e1118_config_aneg(struct p
 {
 	int err;
 
-	err = genphy_soft_reset(phydev);
+	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
 	if (err < 0)
 		return err;
 
-	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
+	err = genphy_config_aneg(phydev);
 	if (err < 0)
 		return err;
 
-	err = genphy_config_aneg(phydev);
-	return 0;
+	return genphy_soft_reset(phydev);
 }
 
 static int m88e1118_config_init(struct phy_device *phydev)



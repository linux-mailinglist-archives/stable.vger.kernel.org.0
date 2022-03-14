Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB2B4D81E0
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239941AbiCNL5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239886AbiCNL5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:57:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970081274C;
        Mon, 14 Mar 2022 04:56:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 804EBB80DE3;
        Mon, 14 Mar 2022 11:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F28C340E9;
        Mon, 14 Mar 2022 11:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647258966;
        bh=bMps1IWyihd+IApLTuN7q9Nk61AEbptapgwH3EKoC8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=st3Mu23vUCRzB1IC9AjXo3yP1bYRXELBQsIYBTbLoFOaKLSsD2GystoJrzKN97eZq
         0m+GmalYLq5hr37+eZQYtXER+bQCg1KBa9PeyDTsSK76743zvUURNkeqbTCxG3hOp3
         tG2Thr7dku2Un9yLdacH45NC+trS5Icx2lhvsfdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/43] net: phy: DP83822: clear MISR2 register to disable interrupts
Date:   Mon, 14 Mar 2022 12:53:29 +0100
Message-Id: <20220314112734.930123555@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clément Léger <clement.leger@bootlin.com>

[ Upstream commit 37c9d66c95564c85a001d8a035354f0220a1e1c3 ]

MISR1 was cleared twice but the original author intention was probably
to clear MISR1 & MISR2 to completely disable interrupts. Fix it to
clear MISR2.

Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220309142228.761153-1-clement.leger@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83822.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 8a4b1d167ce2..ae17d2f9d534 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -238,7 +238,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 		if (err < 0)
 			return err;
 
-		err = phy_write(phydev, MII_DP83822_MISR1, 0);
+		err = phy_write(phydev, MII_DP83822_MISR2, 0);
 		if (err < 0)
 			return err;
 
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61EE64D813B
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239152AbiCNLk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239173AbiCNLjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:39:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F88433B1;
        Mon, 14 Mar 2022 04:38:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9018461170;
        Mon, 14 Mar 2022 11:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758B9C340E9;
        Mon, 14 Mar 2022 11:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257879;
        bh=VcjH5Jsn3+AQ+dvXHRGMTxyE7MHAt3tEWwxqsk/f6FQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mR9yM64AYSZVo5wfaEAYzmrDALlRR531s5m3SqfHiLl8gDAbMIcQ8TflJHa1YHtkm
         2H6Bt3vMhjvhEkTvUsTTGke3PvGPEmGHaqF+SuBRkofy0LbL2qg6Ad4ldlOD9MpB8d
         cAQvyntSH4TgJJLbqnt0AKZu+11xbpml9DkWmC+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/30] net: phy: DP83822: clear MISR2 register to disable interrupts
Date:   Mon, 14 Mar 2022 12:34:29 +0100
Message-Id: <20220314112732.107830341@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112731.785042288@linuxfoundation.org>
References: <20220314112731.785042288@linuxfoundation.org>
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
index 6e8a2a4f3a6e..9e2ed98f7df2 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -244,7 +244,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 		if (err < 0)
 			return err;
 
-		err = phy_write(phydev, MII_DP83822_MISR1, 0);
+		err = phy_write(phydev, MII_DP83822_MISR2, 0);
 		if (err < 0)
 			return err;
 
-- 
2.34.1




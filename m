Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A715EA366
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237793AbiIZLYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237960AbiIZLXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:23:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938CC2980E;
        Mon, 26 Sep 2022 03:40:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 520C3609FE;
        Mon, 26 Sep 2022 10:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5559FC433D6;
        Mon, 26 Sep 2022 10:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188731;
        bh=a+AK/OSNEo4sC5t69e3uFhF99l4MJPwOAdRGtnxEFP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=av+O2YRwP2pCWjkzXCdwOwJomlMJZAKET+6tSR+TGrXC50NTBVI2z60vzaV3XwfW7
         m0A5oVaBFfXpYHtG88b/uPUQ/+mcqeMfJwE6PkUZV6MwXNzsHYKR1WsLlpxI1s8J/x
         qJ3O0GUU0y2SP1Y6aIn6iq/KPQrf69lBPDRPl/Iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/148] net: ravb: Fix PHY state warning splat during system resume
Date:   Mon, 26 Sep 2022 12:12:17 +0200
Message-Id: <20220926100759.966194866@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 4924c0cdce75575295f8fa682851fb8e5d619dd2 ]

Since commit 744d23c71af39c7d ("net: phy: Warn about incorrect
mdio_bus_phy_resume() state"), a warning splat is printed during system
resume with Wake-on-LAN disabled:

        WARNING: CPU: 0 PID: 1197 at drivers/net/phy/phy_device.c:323 mdio_bus_phy_resume+0xbc/0xc8

As the Renesas Ethernet AVB driver already calls phy_{stop,start}() in
its suspend/resume callbacks, it is sufficient to just mark the MAC
responsible for managing the power state of the PHY.

Fixes: fba863b816049b03 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/8ec796f47620980fdd0403e21bd8b7200b4fa1d4.1663598796.git.geert+renesas@glider.be
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 4e08b7219403..12420239c8ca 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1115,6 +1115,8 @@ static int ravb_phy_init(struct net_device *ndev)
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
 
+	/* Indicate that the MAC is responsible for managing PHY PM */
+	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	return 0;
-- 
2.35.1




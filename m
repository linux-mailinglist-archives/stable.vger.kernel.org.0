Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9BD55EA4DD
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238601AbiIZL4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238985AbiIZLyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:54:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6113E24F26;
        Mon, 26 Sep 2022 03:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB099B8085B;
        Mon, 26 Sep 2022 10:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310EEC433C1;
        Mon, 26 Sep 2022 10:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189303;
        bh=suDTPmLcdkGIXtvv6sdCMVRxwD7vN0GRy22VpzSrNuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qf5qhzAU43kMVtMgVBrA99Rdq9Oa+fm4i846OTVxBRs+cxktekI8OYUgJQiRoGQlJ
         l+8rJVPDj39VSzqiqyGr3jFuy2fszjgGuZqIs1eIB3pWJx3rHpZQL7hriPnuahe9Ue
         5f77wZYy8FhtaF0IhHbUboLhmN1zsRslb2I7OvGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 142/207] net: sh_eth: Fix PHY state warning splat during system resume
Date:   Mon, 26 Sep 2022 12:12:11 +0200
Message-Id: <20220926100812.860851945@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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

[ Upstream commit 6a1dbfefdae4f7809b3e277cc76785dac0ac1cd0 ]

Since commit 744d23c71af39c7d ("net: phy: Warn about incorrect
mdio_bus_phy_resume() state"), a warning splat is printed during system
resume with Wake-on-LAN disabled:

	WARNING: CPU: 0 PID: 626 at drivers/net/phy/phy_device.c:323 mdio_bus_phy_resume+0xbc/0xe4

As the Renesas SuperH Ethernet driver already calls phy_{stop,start}()
in its suspend/resume callbacks, it is sufficient to just mark the MAC
responsible for managing the power state of the PHY.

Fixes: fba863b816049b03 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/c6e1331b9bef61225fa4c09db3ba3e2e7214ba2d.1663598886.git.geert+renesas@glider.be
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 67ade78fb767..7fd8828d3a84 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2029,6 +2029,8 @@ static int sh_eth_phy_init(struct net_device *ndev)
 	if (mdp->cd->register_type != SH_ETH_REG_GIGABIT)
 		phy_set_max_speed(phydev, SPEED_100);
 
+	/* Indicate that the MAC is responsible for managing PHY PM */
+	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	return 0;
-- 
2.35.1




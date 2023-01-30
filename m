Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E936E68131F
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbjA3O2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237573AbjA3O2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:28:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4B141B5A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:26:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 421C7B811D3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BC1C433EF;
        Mon, 30 Jan 2023 14:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088508;
        bh=F2yG3WWNJLD6l8ZwPi0fb543XMI9dhiFCKhXETUNQ+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFnG5balqdN6be/o6Jiotg51F9vqoJeGTAO3IU8X+LUmrbe7YrLURQNmRqcvpxt6N
         0dnFKBIHS//k3/uoVLuhsQDFfNfvPAF5/LRlxEk51M3uiq3aFdYlcI/XZVQqWqWlnX
         48PYMhk6gPb3iptwPWTsjZ/SdiNA9DP96ovdwRCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/143] net: stmmac: fix invalid call to mdiobus_get_phy()
Date:   Mon, 30 Jan 2023 14:51:39 +0100
Message-Id: <20230130134308.584227856@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 1f3bd64ad921f051254591fbed04fd30b306cde6 ]

In a number of cases the driver assigns a default value of -1 to
priv->plat->phy_addr. This may result in calling mdiobus_get_phy()
with addr parameter being -1. Therefore check for this scenario and
bail out before calling mdiobus_get_phy().

Fixes: 42e87024f727 ("net: stmmac: Fix case when PHY handle is not present")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/669f9671-ecd1-a41b-2727-7b73e3003985@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 14ea0168b548..b52ca2fe04d8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1125,6 +1125,11 @@ static int stmmac_init_phy(struct net_device *dev)
 		int addr = priv->plat->phy_addr;
 		struct phy_device *phydev;
 
+		if (addr < 0) {
+			netdev_err(priv->dev, "no phy found\n");
+			return -ENODEV;
+		}
+
 		phydev = mdiobus_get_phy(priv->mii, addr);
 		if (!phydev) {
 			netdev_err(priv->dev, "no phy at addr %d\n", addr);
-- 
2.39.0




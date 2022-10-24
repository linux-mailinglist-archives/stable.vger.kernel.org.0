Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9550A60B7AD
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiJXTal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbiJXT37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:29:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498FA1DDC1A;
        Mon, 24 Oct 2022 11:01:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1DE15CE16BF;
        Mon, 24 Oct 2022 12:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327C9C433C1;
        Mon, 24 Oct 2022 12:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615573;
        bh=mPVjszT3wboNXS/Hfwq1BXiLQmXtBUP5WVrK5S+6wHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2Rdn/9E1sA87P3VyWs79wIGXbLsL/+zbUAEFNDNaecVvWnwcV+fPFiJSUWNqbp+/
         RhSIc/cB9kaUtqLHBITB6d4GX/vntdNya15Jt8osU60oXyBvIksHctVbnv7CBoJVi7
         MxNDUMzzGOGnfbXKTZZ/K97v8Z5Lbyl1uSdQMXpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 303/530] phy: amlogic: phy-meson-axg-mipi-pcie-analog: Hold reference returned by of_get_parent()
Date:   Mon, 24 Oct 2022 13:30:47 +0200
Message-Id: <20221024113058.780786005@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit c4c349be07aeec5f397a349046dc5fc0f2657691 ]

As the of_get_parent() will increase the refcount of the node->parent
and the reference will be discarded, so we should hold the reference
with which we can decrease the refcount when done.

Fixes: 8eff8b4e22d9 ("phy: amlogic: phy-meson-axg-mipi-pcie-analog: add support for MIPI DSI analog")
Signed-off-by: Liang He <windhl@126.com>

Link: https://lore.kernel.org/r/20220915093506.4009456-1-windhl@126.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/amlogic/phy-meson-axg-mipi-pcie-analog.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/amlogic/phy-meson-axg-mipi-pcie-analog.c b/drivers/phy/amlogic/phy-meson-axg-mipi-pcie-analog.c
index 1027ece6ca12..a3e1108b736d 100644
--- a/drivers/phy/amlogic/phy-meson-axg-mipi-pcie-analog.c
+++ b/drivers/phy/amlogic/phy-meson-axg-mipi-pcie-analog.c
@@ -197,7 +197,7 @@ static int phy_axg_mipi_pcie_analog_probe(struct platform_device *pdev)
 	struct phy_provider *phy;
 	struct device *dev = &pdev->dev;
 	struct phy_axg_mipi_pcie_analog_priv *priv;
-	struct device_node *np = dev->of_node;
+	struct device_node *np = dev->of_node, *parent_np;
 	struct regmap *map;
 	int ret;
 
@@ -206,7 +206,9 @@ static int phy_axg_mipi_pcie_analog_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	/* Get the hhi system controller node */
-	map = syscon_node_to_regmap(of_get_parent(dev->of_node));
+	parent_np = of_get_parent(dev->of_node);
+	map = syscon_node_to_regmap(parent_np);
+	of_node_put(parent_np);
 	if (IS_ERR(map)) {
 		dev_err(dev,
 			"failed to get HHI regmap\n");
-- 
2.35.1




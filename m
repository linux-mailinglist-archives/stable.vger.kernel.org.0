Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7F1549609
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377075AbiFMNZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377153AbiFMNYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:24:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1BE6BFDB;
        Mon, 13 Jun 2022 04:24:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EF274CE110D;
        Mon, 13 Jun 2022 11:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E4CC34114;
        Mon, 13 Jun 2022 11:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119438;
        bh=AsXd4pQ9cFEd10STZjFmrqlZ/EuZiXMpQlQ1ZA6OWnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ZUXP+vu7IkgYro+t2WsbSVAa9VB5zxKH9qaeieaNPCiJJ2a26e0jQ8lqR6iwWDwT
         J3DcrmBa87FoFRFzCUraX6Kvk4NnS+zrJatGVOGxYQtGsMPdnaknwWV/qSCG0jKzjm
         iS1yOL4FZWYmdQlM+PzSXE0z5znmApqS2hvbCVdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 015/339] phy: rockchip-inno-usb2: Fix muxed interrupt support
Date:   Mon, 13 Jun 2022 12:07:20 +0200
Message-Id: <20220613094926.971386619@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 6a98df08ccd55e87947d253b19925691763e755c ]

This commit fixes two issues with the muxed interrupt handler. First,
the OTG port has the "bvalid" interrupt enabled, not "linestate". Since
only the linestate interrupt was handled, and not the bvalid interrupt,
plugging in a cable to the OTG port caused an interrupt storm.

Second, the return values from the individual port IRQ handlers need to
be OR-ed together. Otherwise, the lack of an interrupt from the last
port would cause the handler to erroneously return IRQ_NONE.

Fixes: ed2b5a8e6b98 ("phy: phy-rockchip-inno-usb2: support muxed interrupts")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Tested-by: Michael Riesch <michael.riesch@wolfvision.net>
Link: https://lore.kernel.org/r/20220414032258.40984-2-samuel@sholland.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
index eca77e44a4c1..cba5c32cbaee 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
@@ -940,8 +940,14 @@ static irqreturn_t rockchip_usb2phy_irq(int irq, void *data)
 		if (!rport->phy)
 			continue;
 
-		/* Handle linestate irq for both otg port and host port */
-		ret = rockchip_usb2phy_linestate_irq(irq, rport);
+		switch (rport->port_id) {
+		case USB2PHY_PORT_OTG:
+			ret |= rockchip_usb2phy_otg_mux_irq(irq, rport);
+			break;
+		case USB2PHY_PORT_HOST:
+			ret |= rockchip_usb2phy_linestate_irq(irq, rport);
+			break;
+		}
 	}
 
 	return ret;
-- 
2.35.1




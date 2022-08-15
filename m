Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEED7595067
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbiHPEmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbiHPEkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:40:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C919D1E1D;
        Mon, 15 Aug 2022 13:33:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C71E3B81197;
        Mon, 15 Aug 2022 20:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A111C433C1;
        Mon, 15 Aug 2022 20:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595599;
        bh=jmK2cpuZJgzfFUBDT4X/tT4K1ZIqlymHVLMD9MRYZTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPLduvZRcHWT/K5p2Ba0G+tCWHtl42P3GuxpxBvjBczvDEVf5bBu1xAdlGmfpLzIG
         h6NFC6WQDJGPnIcLByFCbZ0x5po5XUwXCq1Dn5uURD940HtpjfYkXOfsp3xpFh9s8q
         eVit9G+y33DwZ3lefCEujZU2lQtJAzrjERhXyCfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>,
        Samuel Holland <samuel@sholland.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0815/1157] phy: rockchip-inno-usb2: Ignore OTG IRQs in host mode
Date:   Mon, 15 Aug 2022 20:02:51 +0200
Message-Id: <20220815180512.092521896@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit fd7d47484125c7d04578de9294faa7fec6e5df0a ]

When the OTG port is fixed to host mode, the driver does not request its
IRQs, nor does it enable those IRQs in hardware. Similarly, the driver
should ignore the OTG port IRQs when handling the shared interrupt.

Otherwise, it would update the extcon based on an ID pin which may be in
an undefined state, or try to queue a uninitialized work item.

Fixes: 6a98df08ccd5 ("phy: rockchip-inno-usb2: Fix muxed interrupt support")
Reported-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Tested-by: Peter Geis <pgwipeout@gmail.com>
Tested-by: Frank Wunderlich <frank-w@public-files.de>
Link: https://lore.kernel.org/r/20220708061434.38115-1-samuel@sholland.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
index 6e44069617df..5223d4c9afdf 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
@@ -978,7 +978,9 @@ static irqreturn_t rockchip_usb2phy_irq(int irq, void *data)
 
 		switch (rport->port_id) {
 		case USB2PHY_PORT_OTG:
-			ret |= rockchip_usb2phy_otg_mux_irq(irq, rport);
+			if (rport->mode != USB_DR_MODE_HOST &&
+			    rport->mode != USB_DR_MODE_UNKNOWN)
+				ret |= rockchip_usb2phy_otg_mux_irq(irq, rport);
 			break;
 		case USB2PHY_PORT_HOST:
 			ret |= rockchip_usb2phy_linestate_irq(irq, rport);
-- 
2.35.1




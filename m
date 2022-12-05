Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB676432DD
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbiLETbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233868AbiLETa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:30:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3432B2C11D
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:26:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 425AFB80EFD
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A54C433D6;
        Mon,  5 Dec 2022 19:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268396;
        bh=clZKKTGggwTEc4vqixsznUbxJmesubFaoeMVOleeTio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abnM8ae09LKVM8twj0ftz3jNpLZlulZruUHV72cxEg19okfkNQmORmnjlEoxctS+I
         hhJx6/rZNMMKgZ08ccSMAuoZ7L9JQ0brInpldb6cB90RzJQCKC3we22JQrDFQHlDXG
         WDYNvLnefh3jDqQIF6hmYRAnG/3M5lErD0KPPvdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Goh, Wei Sheng" <wei.sheng.goh@intel.com>,
        Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>,
        "David S. Miller" <davem@davemloft.net>, Goh@vger.kernel.org
Subject: [PATCH 6.0 086/124] net: stmmac: Set MACs flow control register to reflect current settings
Date:   Mon,  5 Dec 2022 20:09:52 +0100
Message-Id: <20221205190810.862023518@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Goh, Wei Sheng <wei.sheng.goh@intel.com>

commit cc3d2b5fc0d6f8ad8a52da5ea679e5c2ec2adbd4 upstream.

Currently, pause frame register GMAC_RX_FLOW_CTRL_RFE is not updated
correctly when 'ethtool -A <IFACE> autoneg off rx off tx off' command
is issued. This fix ensures the flow control change is reflected directly
in the GMAC_RX_FLOW_CTRL_RFE register.

Fixes: 46f69ded988d ("net: stmmac: Use resolved link config in mac_link_up()")
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Goh, Wei Sheng <wei.sheng.goh@intel.com>
Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |    2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -749,6 +749,8 @@ static void dwmac4_flow_ctrl(struct mac_
 	if (fc & FLOW_RX) {
 		pr_debug("\tReceive Flow-Control ON\n");
 		flow |= GMAC_RX_FLOW_CTRL_RFE;
+	} else {
+		pr_debug("\tReceive Flow-Control OFF\n");
 	}
 	writel(flow, ioaddr + GMAC_RX_FLOW_CTRL);
 
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1061,8 +1061,16 @@ static void stmmac_mac_link_up(struct ph
 		ctrl |= priv->hw->link.duplex;
 
 	/* Flow Control operation */
-	if (tx_pause && rx_pause)
-		stmmac_mac_flow_ctrl(priv, duplex);
+	if (rx_pause && tx_pause)
+		priv->flow_ctrl = FLOW_AUTO;
+	else if (rx_pause && !tx_pause)
+		priv->flow_ctrl = FLOW_RX;
+	else if (!rx_pause && tx_pause)
+		priv->flow_ctrl = FLOW_TX;
+	else
+		priv->flow_ctrl = FLOW_OFF;
+
+	stmmac_mac_flow_ctrl(priv, duplex);
 
 	if (ctrl != old_ctrl)
 		writel(ctrl, priv->ioaddr + MAC_CTRL_REG);



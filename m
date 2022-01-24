Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5D8499DB3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586100AbiAXWZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584585AbiAXWV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E9AC0424DE;
        Mon, 24 Jan 2022 12:51:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1986260C3E;
        Mon, 24 Jan 2022 20:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F265AC340E5;
        Mon, 24 Jan 2022 20:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057479;
        bh=uKmrqgjSA/5eJeqZdMw9hagnqck9mskx6h1Fw7fRqhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmm8p/94TW3mErVMalZBzvfpki0B0tN8nAgnOkw7i5RVjnhdFKe65qWG5QNqhI9u5
         R3cDinLk/wfzkRPlXP9NdRYVUpq/4ji6tthKKpG473QpUpvFcKOa7RTisUiE1vOGGn
         KXu9p5bx0GorJt5SZtDnUwWVOFKSKKqyesYR7Haw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 793/846] net: axienet: reset core on initialization prior to MDIO access
Date:   Mon, 24 Jan 2022 19:45:10 +0100
Message-Id: <20220124184128.306481427@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit 04cc2da39698efd7eb2e30c112538922d26f848e upstream.

In some cases where the Xilinx Ethernet core was used in 1000Base-X or
SGMII modes, which use the internal PCS/PMA PHY, and the MGT
transceiver clock source for the PCS was not running at the time the
FPGA logic was loaded, the core would come up in a state where the
PCS could not be found on the MDIO bus. To fix this, the Ethernet core
(including the PCS) should be reset after enabling the clocks, prior to
attempting to access the PCS using of_mdio_find_device.

Fixes: 1a02556086fc (net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode)
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2091,6 +2091,11 @@ static int axienet_probe(struct platform
 	lp->coalesce_count_rx = XAXIDMA_DFT_RX_THRESHOLD;
 	lp->coalesce_count_tx = XAXIDMA_DFT_TX_THRESHOLD;
 
+	/* Reset core now that clocks are enabled, prior to accessing MDIO */
+	ret = __axienet_device_reset(lp);
+	if (ret)
+		goto cleanup_clk;
+
 	lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
 	if (lp->phy_node) {
 		ret = axienet_mdio_setup(lp);



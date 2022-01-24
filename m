Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F2B49A4F3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2372095AbiAYAKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444974AbiAXVHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:07:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A36C06136F;
        Mon, 24 Jan 2022 12:07:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E930B6132F;
        Mon, 24 Jan 2022 20:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A839CC340E5;
        Mon, 24 Jan 2022 20:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054846;
        bh=SDhyJa7hfgQ8otNbA1lgN294AzUYzY6q7sgLiEq8GbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAlgqryjmsS88vz1kfqEECJlzQd7SBjVmaYDCpFPYj2J51KWH37gn/HC5jPiDZcOn
         ZTX7LbhRRxIxC/tPQs/Y4tiPQSHDVoNnQePChrZ4mADjm0mSTrv/BaEqqQrrkzr6fX
         xxwlkSslFF8Z0n3k9j9C0HZCK5UkOOAbZ0I7YUso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 522/563] net: axienet: reset core on initialization prior to MDIO access
Date:   Mon, 24 Jan 2022 19:44:47 +0100
Message-Id: <20220124184042.498641995@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -2024,6 +2024,11 @@ static int axienet_probe(struct platform
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



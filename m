Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEE165806A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiL1QRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbiL1QQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:16:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4735A1A220
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:14:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D69EA6156E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA92C433EF;
        Wed, 28 Dec 2022 16:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244080;
        bh=40NvcAwH9af5kvUWryB4t+zNxnNFzvoKp2r3x7H3c4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VA/r2k1boguTQEzg8i/ldxLUWl2JsIFhLwhM3H7ftv9S+5XQiFRBrTFChfh0iwazv
         zWNX902iG3NF8E/LoyGBSS2wA5rtVSbxA7GmPe/QTQlXW4xZE5eB8dK+N65m/cjyXX
         keQ9ut64qs7EYm+EdkT1Vsw0ERdJXDkRE+GNbnVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Richard Zhu <hongxing.zhu@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0606/1146] PCI: imx6: Initialize PHY before deasserting core reset
Date:   Wed, 28 Dec 2022 15:35:45 +0100
Message-Id: <20221228144346.633025261@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit ae6b9a65af480144da323436d90e149501ea8937 ]

When the PHY is the reference clock provider then it must be initialized
and powered on before the reset on the client is deasserted, otherwise
the link will never come up. The order was changed in cf236e0c0d59.
Restore the correct order to make the driver work again on boards where
the PHY provides the reference clock. This also changes the order for
boards where the Soc is the PHY reference clock divider, but this
shouldn't do any harm.

Link: https://lore.kernel.org/r/20221101095714.440001-1-s.hauer@pengutronix.de
Fixes: cf236e0c0d59 ("PCI: imx6: Do not hide PHY driver callbacks and refine the error handling")
Tested-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 2616585ca5f8..1dde5c579edc 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -952,12 +952,6 @@ static int imx6_pcie_host_init(struct dw_pcie_rp *pp)
 		}
 	}
 
-	ret = imx6_pcie_deassert_core_reset(imx6_pcie);
-	if (ret < 0) {
-		dev_err(dev, "pcie deassert core reset failed: %d\n", ret);
-		goto err_phy_off;
-	}
-
 	if (imx6_pcie->phy) {
 		ret = phy_power_on(imx6_pcie->phy);
 		if (ret) {
@@ -965,6 +959,13 @@ static int imx6_pcie_host_init(struct dw_pcie_rp *pp)
 			goto err_phy_off;
 		}
 	}
+
+	ret = imx6_pcie_deassert_core_reset(imx6_pcie);
+	if (ret < 0) {
+		dev_err(dev, "pcie deassert core reset failed: %d\n", ret);
+		goto err_phy_off;
+	}
+
 	imx6_setup_phy_mpll(imx6_pcie);
 
 	return 0;
-- 
2.35.1




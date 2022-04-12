Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B798D4FD053
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344866AbiDLGq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351314AbiDLGoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:44:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A48318E0F;
        Mon, 11 Apr 2022 23:38:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BA0661934;
        Tue, 12 Apr 2022 06:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27916C385A6;
        Tue, 12 Apr 2022 06:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745481;
        bh=avvCBGkEn1Gu3c6azG/sOg//X8jlduQ1c7l0KbXduts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLlrGcfif+pUfqNida6qpBCy+hJOoqoWVo/dq0wMwfmuSQgpL2R63jFNGBhgzeNXm
         Cg8ZeoHe+AO2sahDpSMcN9qsze/PJj6MfE/+H4jLF5Loj0sL1IWKMdBUqdGUBAgC5B
         tOreFOF8rtthS8QVyBwEny8WOTQB1GRKemaxDI3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amjad Ouled-Ameur <aouledameur@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/171] phy: amlogic: meson8b-usb2: Use dev_err_probe()
Date:   Tue, 12 Apr 2022 08:29:25 +0200
Message-Id: <20220412062930.026672227@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Amjad Ouled-Ameur <aouledameur@baylibre.com>

[ Upstream commit 6466ba1898d415b527e1013bd8551a6fdfece94c ]

Use the existing dev_err_probe() helper instead of open-coding the same
operation.

Signed-off-by: Amjad Ouled-Ameur <aouledameur@baylibre.com>
Reported-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20220111095255.176141-3-aouledameur@baylibre.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/amlogic/phy-meson8b-usb2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/amlogic/phy-meson8b-usb2.c b/drivers/phy/amlogic/phy-meson8b-usb2.c
index 03c061dd5f0d..8f40b9342a97 100644
--- a/drivers/phy/amlogic/phy-meson8b-usb2.c
+++ b/drivers/phy/amlogic/phy-meson8b-usb2.c
@@ -261,8 +261,9 @@ static int phy_meson8b_usb2_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->clk_usb);
 
 	priv->reset = devm_reset_control_get_optional_shared(&pdev->dev, NULL);
-	if (PTR_ERR(priv->reset) == -EPROBE_DEFER)
-		return PTR_ERR(priv->reset);
+	if (IS_ERR(priv->reset))
+		return dev_err_probe(&pdev->dev, PTR_ERR(priv->reset),
+				     "Failed to get the reset line");
 
 	priv->dr_mode = of_usb_get_dr_mode_by_phy(pdev->dev.of_node, -1);
 	if (priv->dr_mode == USB_DR_MODE_UNKNOWN) {
-- 
2.35.1




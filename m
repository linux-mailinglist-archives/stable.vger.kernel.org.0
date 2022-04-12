Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55464FD702
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377080AbiDLHrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357253AbiDLHjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE335F67;
        Tue, 12 Apr 2022 00:14:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C082661708;
        Tue, 12 Apr 2022 07:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4E7C385A1;
        Tue, 12 Apr 2022 07:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747661;
        bh=bAPP0KeYlE4Rw4hQig6h+AE3aP+2SVdMxEk/gwMuZbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cA2GC7/uj4coysw4y5OK7WK41CPcTzwIug32K2rqi5zeibHDCr7xBhSsdXNZ5aVVr
         WIQzWvaWZPI6ZOIiPt4Xbzz7gG398zOWK2bXsVDsqHdYGh7CZrK6b5J0bL5HtTuwUS
         Sdr/tIXDX4qD8zLEoW4C3HxRHIVi6tB7peUxw854=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amjad Ouled-Ameur <aouledameur@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 161/343] phy: amlogic: meson8b-usb2: Use dev_err_probe()
Date:   Tue, 12 Apr 2022 08:29:39 +0200
Message-Id: <20220412062956.021318385@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
index cf10bed40528..77e7e9b1428c 100644
--- a/drivers/phy/amlogic/phy-meson8b-usb2.c
+++ b/drivers/phy/amlogic/phy-meson8b-usb2.c
@@ -265,8 +265,9 @@ static int phy_meson8b_usb2_probe(struct platform_device *pdev)
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




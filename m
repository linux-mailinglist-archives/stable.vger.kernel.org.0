Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB11656F9E
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiL0Uwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiL0UfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:35:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DF9DECF;
        Tue, 27 Dec 2022 12:34:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E74D61252;
        Tue, 27 Dec 2022 20:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86147C43392;
        Tue, 27 Dec 2022 20:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173243;
        bh=W2OZh1cjB+KeqJYL7Y5y8ubMvj4vgTKkh4rZbUd8Yfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9R404D/ZzRkptlvHmGKMpkxry/eQZSc1XY79BHSW1Y7vORnb3ILF/kRDIsWxBWy/
         nv/nyRJurHlMAXyM3LqS8fwkS7iw7meV1Q5a2siLw8bYMU4IsKcCvJPb2PqVKfl9hx
         uzXMhBWk1l/G4GPV0rsq2c/MpRRYfhHN6j0jpz8IKG9Ov8irGf00LSYL/W3jVgihM3
         QR/Chlj3TvAwJ6+8NnJIf67HF61jEBToYS18WMMGaocK67sduZTr6i19rsu+txrHYK
         W8A/yR+YhRJvAoGVP7l+EQS3ZyrzrpGlwWzTZ+qaTaR9LaqkIcyy+e5Wn0QKkdrK4I
         TqMvRrM7Jcp6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Samuel Holland <samuel@sholland.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kishon@kernel.org, wens@csie.org, jernej.skrabec@gmail.com,
        wsa+renesas@sang-engineering.com, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 13/27] phy: sun4i-usb: Add support for the H616 USB PHY
Date:   Tue, 27 Dec 2022 15:33:28 -0500
Message-Id: <20221227203342.1213918-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203342.1213918-1-sashal@kernel.org>
References: <20221227203342.1213918-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 0f607406525d25019dd9c498bcc0b42734fc59d5 ]

The USB PHY used in the Allwinner H616 SoC inherits some traits from its
various predecessors: it has four full PHYs like the H3, needs some
extra bits to be set like the H6, and puts SIDDQ on a different bit like
the A100. Plus it needs this weird PHY2 quirk.

Name all those properties in a new config struct and assign a new
compatible name to it.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/r/20221031111358.3387297-5-andre.przywara@arm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/allwinner/phy-sun4i-usb.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/phy/allwinner/phy-sun4i-usb.c b/drivers/phy/allwinner/phy-sun4i-usb.c
index f094a4cd7cbc..77b058ed42e3 100644
--- a/drivers/phy/allwinner/phy-sun4i-usb.c
+++ b/drivers/phy/allwinner/phy-sun4i-usb.c
@@ -1032,6 +1032,17 @@ static const struct sun4i_usb_phy_cfg sun50i_h6_cfg = {
 	.missing_phys = BIT(1) | BIT(2),
 };
 
+static const struct sun4i_usb_phy_cfg sun50i_h616_cfg = {
+	.num_phys = 4,
+	.type = sun50i_h6_phy,
+	.disc_thresh = 3,
+	.phyctl_offset = REG_PHYCTL_A33,
+	.dedicated_clocks = true,
+	.phy0_dual_route = true,
+	.hci_phy_ctl_clear = PHY_CTL_SIDDQ,
+	.needs_phy2_siddq = true,
+};
+
 static const struct of_device_id sun4i_usb_phy_of_match[] = {
 	{ .compatible = "allwinner,sun4i-a10-usb-phy", .data = &sun4i_a10_cfg },
 	{ .compatible = "allwinner,sun5i-a13-usb-phy", .data = &sun5i_a13_cfg },
@@ -1047,6 +1058,7 @@ static const struct of_device_id sun4i_usb_phy_of_match[] = {
 	{ .compatible = "allwinner,sun50i-a64-usb-phy",
 	  .data = &sun50i_a64_cfg},
 	{ .compatible = "allwinner,sun50i-h6-usb-phy", .data = &sun50i_h6_cfg },
+	{ .compatible = "allwinner,sun50i-h616-usb-phy", .data = &sun50i_h616_cfg },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, sun4i_usb_phy_of_match);
-- 
2.35.1


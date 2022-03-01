Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648BB4C9629
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237816AbiCAUTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238135AbiCAUSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:18:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA448A31F;
        Tue,  1 Mar 2022 12:17:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C221461752;
        Tue,  1 Mar 2022 20:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369A3C340F1;
        Tue,  1 Mar 2022 20:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165823;
        bh=Xu0+i5k46GDbxoq5qyFGw7zlYHWQ576m6QBwAW8Us3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=px7bi9MJvKRcvCAoHft/wsj0Jk/nUuDzLZYRgJMOAHNFZOT/3E/2fDwQYIyKhSv8L
         d+mHVIy9qzP2gGW3TEd3UrmfRkat6NxLbnQjPi4OL14+s9r2UiweR7xAPjr+l9tD/0
         JxSwHynuoFoapvMPuDFtg75OK2vwJDfIxJneSThM4Ds3oSebZMsPzczx7et0V4Bxmk
         qyVKaBj6QbtxrNmpx6fvRrATF/rcvtX+v5UUOKO7juhi/bVJaq2gg2cmkfPFot3jrz
         RLDXHx4mogeEJz96QbRHYyHPTVggia2AJodjdmeAk9oYphKg2NAbkIEOL6cnUUIQlY
         bqjxsekA+hHGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Lin <jon.lin@rock-chips.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, heiko@sntech.de,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 07/23] spi: rockchip: Fix error in getting num-cs property
Date:   Tue,  1 Mar 2022 15:16:06 -0500
Message-Id: <20220301201629.18547-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201629.18547-1-sashal@kernel.org>
References: <20220301201629.18547-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Lin <jon.lin@rock-chips.com>

[ Upstream commit 9382df0a98aad5bbcd4d634790305a1d786ad224 ]

Get num-cs u32 from dts of_node property rather than u16.

Signed-off-by: Jon Lin <jon.lin@rock-chips.com>
Link: https://lore.kernel.org/r/20220216014028.8123-2-jon.lin@rock-chips.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 553b6b9d02222..4f65ba3dd19c2 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -654,7 +654,7 @@ static int rockchip_spi_probe(struct platform_device *pdev)
 	struct spi_controller *ctlr;
 	struct resource *mem;
 	struct device_node *np = pdev->dev.of_node;
-	u32 rsd_nsecs;
+	u32 rsd_nsecs, num_cs;
 	bool slave_mode;
 
 	slave_mode = of_property_read_bool(np, "spi-slave");
@@ -764,8 +764,9 @@ static int rockchip_spi_probe(struct platform_device *pdev)
 		 * rk spi0 has two native cs, spi1..5 one cs only
 		 * if num-cs is missing in the dts, default to 1
 		 */
-		if (of_property_read_u16(np, "num-cs", &ctlr->num_chipselect))
-			ctlr->num_chipselect = 1;
+		if (of_property_read_u32(np, "num-cs", &num_cs))
+			num_cs = 1;
+		ctlr->num_chipselect = num_cs;
 		ctlr->use_gpio_descriptors = true;
 	}
 	ctlr->dev.of_node = pdev->dev.of_node;
-- 
2.34.1


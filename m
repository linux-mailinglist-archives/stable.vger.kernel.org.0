Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A75E681024
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbjA3OA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236814AbjA3OAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:00:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17A139BBD
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 066296104A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98C5C433D2;
        Mon, 30 Jan 2023 13:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087178;
        bh=B0HY9CQrJXA1HXNbGEeVIt4pucNl79Eum9hyg5RIs0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HnZnZCyDLqDme8723s+KY2u0FXOSQbffS2TMri5lvZD4EGul+2aOHdosWvpu2jeeS
         xA1xCzoLZN8++dQJBYcqu7C1es+jYPJyYyAcC46d1jhqBl9ZWkGzTGfTRRinPGGL/D
         GFUg4iVgXt2vp/8hGr1IJDAPHVAxJUPBTlDInkjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/313] phy: phy-can-transceiver: Skip warning if no "max-bitrate"
Date:   Mon, 30 Jan 2023 14:49:17 +0100
Message-Id: <20230130134342.326519131@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit bc30c15f275484f9b9fe27c2fa0895f3022d9943 ]

According to the DT bindings, the "max-bitrate" property is optional.
However, when it is not present, a warning is printed.
Fix this by adding a missing check for -EINVAL.

Fixes: a4a86d273ff1b6f7 ("phy: phy-can-transceiver: Add support for generic CAN transceiver driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/88e158f97dd52ebaa7126cd9631f34764b9c0795.1674037334.git.geert+renesas@glider.be
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/phy-can-transceiver.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-can-transceiver.c b/drivers/phy/phy-can-transceiver.c
index 95c6dbb52da7..ce511ad5d369 100644
--- a/drivers/phy/phy-can-transceiver.c
+++ b/drivers/phy/phy-can-transceiver.c
@@ -99,6 +99,7 @@ static int can_transceiver_phy_probe(struct platform_device *pdev)
 	struct gpio_desc *standby_gpio;
 	struct gpio_desc *enable_gpio;
 	u32 max_bitrate = 0;
+	int err;
 
 	can_transceiver_phy = devm_kzalloc(dev, sizeof(struct can_transceiver_phy), GFP_KERNEL);
 	if (!can_transceiver_phy)
@@ -124,8 +125,8 @@ static int can_transceiver_phy_probe(struct platform_device *pdev)
 		return PTR_ERR(phy);
 	}
 
-	device_property_read_u32(dev, "max-bitrate", &max_bitrate);
-	if (!max_bitrate)
+	err = device_property_read_u32(dev, "max-bitrate", &max_bitrate);
+	if ((err != -EINVAL) && !max_bitrate)
 		dev_warn(dev, "Invalid value for transceiver max bitrate. Ignoring bitrate limit\n");
 	phy->attrs.max_link_rate = max_bitrate;
 
-- 
2.39.0




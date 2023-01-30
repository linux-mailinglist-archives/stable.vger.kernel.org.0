Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6221368116D
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbjA3ON1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237293AbjA3ONW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:13:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D833B65E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:13:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25FB0B8117E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1A4C4339C;
        Mon, 30 Jan 2023 14:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087986;
        bh=lSRO25A8E3Z3kOqONMsMnzCHU07AqcV+qrNNX6c5RlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UA37UFy51GkRw8Ps8z12gi3NpNy4KODYboPBDDJvkulr4APce8RB9WAm7JwZFkQSy
         h0/kTt0V6de9+TsbmS1TJw3iKPAOTx0gtsjWxSLZ2Y3iqaMoMIqlCOV4qUIMmL4fM/
         V+73sXiN9NwiKXvL4aq7nethaGNk9BGIToN9V2Fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/204] phy: phy-can-transceiver: Skip warning if no "max-bitrate"
Date:   Mon, 30 Jan 2023 14:50:42 +0100
Message-Id: <20230130134319.719859256@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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
index c2cb93b4df71..4525d3fd903a 100644
--- a/drivers/phy/phy-can-transceiver.c
+++ b/drivers/phy/phy-can-transceiver.c
@@ -87,6 +87,7 @@ static int can_transceiver_phy_probe(struct platform_device *pdev)
 	struct gpio_desc *standby_gpio;
 	struct gpio_desc *enable_gpio;
 	u32 max_bitrate = 0;
+	int err;
 
 	can_transceiver_phy = devm_kzalloc(dev, sizeof(struct can_transceiver_phy), GFP_KERNEL);
 	if (!can_transceiver_phy)
@@ -102,8 +103,8 @@ static int can_transceiver_phy_probe(struct platform_device *pdev)
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




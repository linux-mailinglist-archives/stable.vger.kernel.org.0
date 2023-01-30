Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA94F6810F2
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237131AbjA3OIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbjA3OIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:08:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF7A3802D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:08:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4722C61088
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD1DC433EF;
        Mon, 30 Jan 2023 14:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087718;
        bh=7FLw4lpAnRKk/OY7ol1GEUoAYKmM45l2YRaspYl3lbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6HlPjILXinJgguOzKZGEPbIX9C+4dngBrfDDJxF+pzfjIGBq1BZcGqMAFHieUt0/
         rAPeki0H7Qa3MDU7tOjc1Lu++HJp/OHPL5LYZA0YKMlUeDGjLrTzPioghOZsJdJUPe
         z6HLn+olRAn9zsXqfmd0WKGk0r4ceuPR95xu2k/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Lunn <andrew@lunn.ch>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 271/313] net: dsa: microchip: fix probe of I2C-connected KSZ8563
Date:   Mon, 30 Jan 2023 14:51:46 +0100
Message-Id: <20230130134349.361267420@linuxfoundation.org>
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

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 360fdc999d92db4a4adbba0db8641396dc9f1b13 ]

Starting with commit eee16b147121 ("net: dsa: microchip: perform the
compatibility check for dev probed"), the KSZ switch driver now bails
out if it thinks the DT compatible doesn't match the actual chip ID
read back from the hardware:

  ksz9477-switch 1-005f: Device tree specifies chip KSZ9893 but found
  KSZ8563, please fix it!

For the KSZ8563, which used ksz_switch_chips[KSZ9893], this was fine
at first, because it indeed shares the same chip id as the KSZ9893.

Commit b44908095612 ("net: dsa: microchip: add separate struct
ksz_chip_data for KSZ8563 chip") started differentiating KSZ9893
compatible chips by consulting the 0x1F register. The resulting breakage
was fixed for the SPI driver in the same commit by introducing the
appropriate ksz_switch_chips[KSZ8563], but not for the I2C driver.

Fix this for I2C-connected KSZ8563 now to get it probing again.

Fixes: b44908095612 ("net: dsa: microchip: add separate struct ksz_chip_data for KSZ8563 chip").
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230120110933.1151054-1-a.fatoum@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz9477_i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 3763930dc6fc..aae1dadef882 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -105,7 +105,7 @@ static const struct of_device_id ksz9477_dt_ids[] = {
 	},
 	{
 		.compatible = "microchip,ksz8563",
-		.data = &ksz_switch_chips[KSZ9893]
+		.data = &ksz_switch_chips[KSZ8563]
 	},
 	{
 		.compatible = "microchip,ksz9567",
-- 
2.39.0




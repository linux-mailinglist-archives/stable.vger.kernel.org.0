Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1475A4900
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiH2LTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbiH2LSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:18:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF006DADD;
        Mon, 29 Aug 2022 04:12:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F7B861211;
        Mon, 29 Aug 2022 11:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37949C433C1;
        Mon, 29 Aug 2022 11:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771499;
        bh=iwHUMGGtsoO99D6GssvpBUu3+2Wsmb3tknYbGIplBbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJyu5nukL5dLnoDzVnxOtbwQIO32YTRov8zbWA5h/yTiQOEbGZ4Gq0D80EMyYR5RR
         r9j3NyBuAtnfbqBduEK3WCcLZdI8kQgyOCvzef4psthXwrfNHnCGBhcyevyIuT0r6u
         jI8B9EPu/0uVZYtExrrIHBeiI9l9r8uh0CuoxXR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 037/158] net: dsa: microchip: ksz9477: cleanup the ksz9477_switch_detect
Date:   Mon, 29 Aug 2022 12:58:07 +0200
Message-Id: <20220829105810.347355399@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Arun Ramadoss <arun.ramadoss@microchip.com>

[ Upstream commit 27faa0aa85f6696d411bbbebaed9f0f723c2a175 ]

The ksz9477_switch_detect performs the detecting the chip id from the
location 0x00 and also check gigabit compatibility check & number of
ports based on the register global_options0. To prepare the common ksz
switch detect function, routine other than chip id read is moved to
ksz9477_switch_init.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz9477.c | 48 +++++++++++++----------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index ebad795e4e95f..876a801ac23a4 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1365,12 +1365,30 @@ static u32 ksz9477_get_port_addr(int port, int offset)
 
 static int ksz9477_switch_detect(struct ksz_device *dev)
 {
-	u8 data8;
-	u8 id_hi;
-	u8 id_lo;
 	u32 id32;
 	int ret;
 
+	/* read chip id */
+	ret = ksz_read32(dev, REG_CHIP_ID0__1, &id32);
+	if (ret)
+		return ret;
+
+	dev_dbg(dev->dev, "Switch detect: ID=%08x\n", id32);
+
+	dev->chip_id = id32 & 0x00FFFF00;
+
+	return 0;
+}
+
+static int ksz9477_switch_init(struct ksz_device *dev)
+{
+	u8 data8;
+	int ret;
+
+	dev->ds->ops = &ksz9477_switch_ops;
+
+	dev->port_mask = (1 << dev->info->port_cnt) - 1;
+
 	/* turn off SPI DO Edge select */
 	ret = ksz_read8(dev, REG_SW_GLOBAL_SERIAL_CTRL_0, &data8);
 	if (ret)
@@ -1381,10 +1399,6 @@ static int ksz9477_switch_detect(struct ksz_device *dev)
 	if (ret)
 		return ret;
 
-	/* read chip id */
-	ret = ksz_read32(dev, REG_CHIP_ID0__1, &id32);
-	if (ret)
-		return ret;
 	ret = ksz_read8(dev, REG_GLOBAL_OPTIONS, &data8);
 	if (ret)
 		return ret;
@@ -1395,10 +1409,7 @@ static int ksz9477_switch_detect(struct ksz_device *dev)
 	/* Default capability is gigabit capable. */
 	dev->features = GBIT_SUPPORT;
 
-	dev_dbg(dev->dev, "Switch detect: ID=%08x%02x\n", id32, data8);
-	id_hi = (u8)(id32 >> 16);
-	id_lo = (u8)(id32 >> 8);
-	if ((id_lo & 0xf) == 3) {
+	if (dev->chip_id == KSZ9893_CHIP_ID) {
 		/* Chip is from KSZ9893 design. */
 		dev_info(dev->dev, "Found KSZ9893\n");
 		dev->features |= IS_9893;
@@ -1416,21 +1427,6 @@ static int ksz9477_switch_detect(struct ksz_device *dev)
 		if (!(data8 & SW_GIGABIT_ABLE))
 			dev->features &= ~GBIT_SUPPORT;
 	}
-
-	/* Change chip id to known ones so it can be matched against them. */
-	id32 = (id_hi << 16) | (id_lo << 8);
-
-	dev->chip_id = id32;
-
-	return 0;
-}
-
-static int ksz9477_switch_init(struct ksz_device *dev)
-{
-	dev->ds->ops = &ksz9477_switch_ops;
-
-	dev->port_mask = (1 << dev->info->port_cnt) - 1;
-
 	return 0;
 }
 
-- 
2.35.1




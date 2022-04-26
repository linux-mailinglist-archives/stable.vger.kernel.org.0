Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE1D50F781
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiDZJIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347901AbiDZJGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6FFAD129;
        Tue, 26 Apr 2022 01:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77D7E604F5;
        Tue, 26 Apr 2022 08:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCACC385A0;
        Tue, 26 Apr 2022 08:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962814;
        bh=kh1oM6zhDY2AfxWFZwSmhLWkWY21yY0iNrd9a3v9HKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okTw30RaZZRt0gaMVkGIa0DNkHILQDa1KALlLXbDtVCTJD1F4xrcR/6dwxZtyOwYg
         jG7DBU3vKi0rU6/AvHHtNmJLJ/XI3/gJWdclayWqM2wcdZ9VMDGeurOQCFPrylYwDT
         HE7TM22FnyoPNYJ4CzXa7AeGjRS1xZmJsl1JkuFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kevin Groeneveld <kgroeneveld@lenbrook.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.17 096/146] dmaengine: imx-sdma: fix init of uart scripts
Date:   Tue, 26 Apr 2022 10:21:31 +0200
Message-Id: <20220426081752.756427771@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Groeneveld <kgroeneveld@lenbrook.com>

commit a3ae97f4c87d9570e7e9a3e3324c443757f6e29a upstream.

Commit b98ce2f4e32b ("dmaengine: imx-sdma: add uart rom script") broke
uart rx on imx5 when using sdma firmware from older Freescale 2.6.35
kernel. In this case reading addr->uartXX_2_mcu_addr was going out of
bounds of the firmware memory and corrupting the uart script addresses.

Simply adding a bounds check before accessing addr->uartXX_2_mcu_addr
does not work as the uartXX_2_mcu_addr members are now beyond the size
of the older firmware and the uart addresses would never be populated
in that case. There are other ways to fix this but overall the logic
seems clearer to me to revert the uartXX_2_mcu_ram_addr structure
entries back to uartXX_2_mcu_addr, change the newer entries to
uartXX_2_mcu_rom_addr and update the logic accordingly.

I have tested this patch on:
1. An i.MX53 system with sdma firmware from Freescale 2.6.35 kernel.
   Without this patch uart rx is broken in this scenario, with the
   patch uart rx is restored.
2. An i.MX6D system with no external sdma firmware. uart is okay with
   or without this patch.
3. An i.MX8MM system using current sdma-imx7d.bin firmware from
   linux-firmware. uart is okay with or without this patch and I
   confirmed the rom version of the uart script is being used which was
   the intention and reason for commit b98ce2f4e32b ("dmaengine:
   imx-sdma: add uart rom script") in the first place.

Fixes: b98ce2f4e32b ("dmaengine: imx-sdma: add uart rom script")
Cc: stable@vger.kernel.org
Signed-off-by: Kevin Groeneveld <kgroeneveld@lenbrook.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20220410223118.15086-1-kgroeneveld@lenbrook.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/imx-sdma.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -198,12 +198,12 @@ struct sdma_script_start_addrs {
 	s32 per_2_firi_addr;
 	s32 mcu_2_firi_addr;
 	s32 uart_2_per_addr;
-	s32 uart_2_mcu_ram_addr;
+	s32 uart_2_mcu_addr;
 	s32 per_2_app_addr;
 	s32 mcu_2_app_addr;
 	s32 per_2_per_addr;
 	s32 uartsh_2_per_addr;
-	s32 uartsh_2_mcu_ram_addr;
+	s32 uartsh_2_mcu_addr;
 	s32 per_2_shp_addr;
 	s32 mcu_2_shp_addr;
 	s32 ata_2_mcu_addr;
@@ -232,8 +232,8 @@ struct sdma_script_start_addrs {
 	s32 mcu_2_ecspi_addr;
 	s32 mcu_2_sai_addr;
 	s32 sai_2_mcu_addr;
-	s32 uart_2_mcu_addr;
-	s32 uartsh_2_mcu_addr;
+	s32 uart_2_mcu_rom_addr;
+	s32 uartsh_2_mcu_rom_addr;
 	/* End of v3 array */
 	s32 mcu_2_zqspi_addr;
 	/* End of v4 array */
@@ -1780,17 +1780,17 @@ static void sdma_add_scripts(struct sdma
 			saddr_arr[i] = addr_arr[i];
 
 	/*
-	 * get uart_2_mcu_addr/uartsh_2_mcu_addr rom script specially because
-	 * they are now replaced by uart_2_mcu_ram_addr/uartsh_2_mcu_ram_addr
-	 * to be compatible with legacy freescale/nxp sdma firmware, and they
-	 * are located in the bottom part of sdma_script_start_addrs which are
-	 * beyond the SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1.
+	 * For compatibility with NXP internal legacy kernel before 4.19 which
+	 * is based on uart ram script and mainline kernel based on uart rom
+	 * script, both uart ram/rom scripts are present in newer sdma
+	 * firmware. Use the rom versions if they are present (V3 or newer).
 	 */
-	if (addr->uart_2_mcu_addr)
-		sdma->script_addrs->uart_2_mcu_addr = addr->uart_2_mcu_addr;
-	if (addr->uartsh_2_mcu_addr)
-		sdma->script_addrs->uartsh_2_mcu_addr = addr->uartsh_2_mcu_addr;
-
+	if (sdma->script_number >= SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V3) {
+		if (addr->uart_2_mcu_rom_addr)
+			sdma->script_addrs->uart_2_mcu_addr = addr->uart_2_mcu_rom_addr;
+		if (addr->uartsh_2_mcu_rom_addr)
+			sdma->script_addrs->uartsh_2_mcu_addr = addr->uartsh_2_mcu_rom_addr;
+	}
 }
 
 static void sdma_load_firmware(const struct firmware *fw, void *context)



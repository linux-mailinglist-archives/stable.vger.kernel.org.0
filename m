Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9D44F2AA8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356047AbiDEKWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235369AbiDEJaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:30:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B18E2F74;
        Tue,  5 Apr 2022 02:17:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C5D4B81BBF;
        Tue,  5 Apr 2022 09:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5FDC385A2;
        Tue,  5 Apr 2022 09:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150223;
        bh=/yt+JKhK1iOBl6Kc9z8/VMaIFaoyhQMuQvEUN61MtuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2YphGftFuLvIdQ98ZfEIAajm/A1yFiDMLWh1hTy/XPm90OJuvpezSREgftI54gbo
         34xanM4GwFqBIwQmuGZRTLxF+GWgUftQQFZHzaBfApaWvGEATPUvlGaB3vgJR1+8MP
         jyAh+z9Cv1WQFpKCX1zmNJLWWaLI1sz2f+Jx4eSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leilk Liu <leilk.liu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 0997/1017] spi: mediatek: support tick_delay without enhance_timing
Date:   Tue,  5 Apr 2022 09:31:50 +0200
Message-Id: <20220405070423.796153423@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Leilk Liu <leilk.liu@mediatek.com>

commit 03b1be379dcee2e9c866c2a455a1a4a9581b3efd upstream.

this patch support tick_delay bit[31:30] without enhance_timing feature.

Fixes: f84d866ab43f("spi: mediatek: add tick_delay support")
Signed-off-by: Leilk Liu <leilk.liu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220315032411.2826-2-leilk.liu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mt65xx.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -43,8 +43,11 @@
 #define SPI_CFG1_PACKET_LOOP_OFFSET       8
 #define SPI_CFG1_PACKET_LENGTH_OFFSET     16
 #define SPI_CFG1_GET_TICK_DLY_OFFSET      29
+#define SPI_CFG1_GET_TICK_DLY_OFFSET_V1   30
 
 #define SPI_CFG1_GET_TICK_DLY_MASK        0xe0000000
+#define SPI_CFG1_GET_TICK_DLY_MASK_V1     0xc0000000
+
 #define SPI_CFG1_CS_IDLE_MASK             0xff
 #define SPI_CFG1_PACKET_LOOP_MASK         0xff00
 #define SPI_CFG1_PACKET_LENGTH_MASK       0x3ff0000
@@ -346,9 +349,15 @@ static int mtk_spi_prepare_message(struc
 
 	/* tick delay */
 	reg_val = readl(mdata->base + SPI_CFG1_REG);
-	reg_val &= ~SPI_CFG1_GET_TICK_DLY_MASK;
-	reg_val |= ((chip_config->tick_delay & 0x7)
-		<< SPI_CFG1_GET_TICK_DLY_OFFSET);
+	if (mdata->dev_comp->enhance_timing) {
+		reg_val &= ~SPI_CFG1_GET_TICK_DLY_MASK;
+		reg_val |= ((chip_config->tick_delay & 0x7)
+			    << SPI_CFG1_GET_TICK_DLY_OFFSET);
+	} else {
+		reg_val &= ~SPI_CFG1_GET_TICK_DLY_MASK_V1;
+		reg_val |= ((chip_config->tick_delay & 0x3)
+			    << SPI_CFG1_GET_TICK_DLY_OFFSET_V1);
+	}
 	writel(reg_val, mdata->base + SPI_CFG1_REG);
 
 	/* set hw cs timing */



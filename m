Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5311627FB0
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237689AbiKNNB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237691AbiKNNBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:01:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5017F28E0F
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:01:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E091A61184
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACD8C433D6;
        Mon, 14 Nov 2022 13:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430877;
        bh=UjaY3x5BYTiogatwDI42p2bqEu6nVgtpaU59IQtGH9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r4rW90E00LLWhmnDoo0ZPszgXyv6sJXAbkdq3UdOCuEcwbMXTZoAyrva8kWohw+B4
         L/HK+FjXKAom7Z/ml2ADJPo28BBlAebVw0oCgNQK8rxgqzHfOAhIfQ+HzCa7ZepYNj
         f12W4Dx0trD0T44XpznOBF2usUWaFZ3rDzFJ8EOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "zhichao.liu" <zhichao.liu@mediatek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 022/190] spi: mediatek: Fix package division error
Date:   Mon, 14 Nov 2022 13:44:06 +0100
Message-Id: <20221114124459.744185511@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: zhichao.liu <zhichao.liu@mediatek.com>

[ Upstream commit cf82d0ecb84e8ef9958721193f901609b408655b ]

Commit 7e963fb2a33ce ("spi: mediatek: add ipm design support
for MT7986") makes a mistake on package dividing operation
(one change is missing), need to fix it.

Background:
Ipm design is expanding the HW capability of dma (adjust package
length from 1KB to 64KB), and using "dev_comp->ipm_support" flag
to indicate it.

Issue description:
Ipm support patch (said above) is missing to handle remainder at
package dividing operation.
One case, a transmission length is 65KB, is will divide to 1K
(package length) * 65(package loop) in non-ipm desgin case, and
will divide to 64K(package length) * 1(package loop) + 1K(remainder)
in ipm design case. And the 1K remainder will be lost with the
current SW flow, and the transmission will be failure.
So, it should be fixed.

Solution:
Add "ipm_design" flag in function "mtk_spi_get_mult_delta()" to
indicate HW capability, and modify the parameters corespondingly.

fixes: 7e963fb2a33ce ("spi: mediatek: add ipm design support for MT7986")
Signed-off-by: zhichao.liu <zhichao.liu@mediatek.com>
Link: https://lore.kernel.org/r/20221021091653.18297-1-zhichao.liu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mt65xx.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index 0a3b9f7eed30..cd9dc358d396 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -551,14 +551,17 @@ static void mtk_spi_enable_transfer(struct spi_master *master)
 	writel(cmd, mdata->base + SPI_CMD_REG);
 }
 
-static int mtk_spi_get_mult_delta(u32 xfer_len)
+static int mtk_spi_get_mult_delta(struct mtk_spi *mdata, u32 xfer_len)
 {
-	u32 mult_delta;
+	u32 mult_delta = 0;
 
-	if (xfer_len > MTK_SPI_PACKET_SIZE)
-		mult_delta = xfer_len % MTK_SPI_PACKET_SIZE;
-	else
-		mult_delta = 0;
+	if (mdata->dev_comp->ipm_design) {
+		if (xfer_len > MTK_SPI_IPM_PACKET_SIZE)
+			mult_delta = xfer_len % MTK_SPI_IPM_PACKET_SIZE;
+	} else {
+		if (xfer_len > MTK_SPI_PACKET_SIZE)
+			mult_delta = xfer_len % MTK_SPI_PACKET_SIZE;
+	}
 
 	return mult_delta;
 }
@@ -570,22 +573,22 @@ static void mtk_spi_update_mdata_len(struct spi_master *master)
 
 	if (mdata->tx_sgl_len && mdata->rx_sgl_len) {
 		if (mdata->tx_sgl_len > mdata->rx_sgl_len) {
-			mult_delta = mtk_spi_get_mult_delta(mdata->rx_sgl_len);
+			mult_delta = mtk_spi_get_mult_delta(mdata, mdata->rx_sgl_len);
 			mdata->xfer_len = mdata->rx_sgl_len - mult_delta;
 			mdata->rx_sgl_len = mult_delta;
 			mdata->tx_sgl_len -= mdata->xfer_len;
 		} else {
-			mult_delta = mtk_spi_get_mult_delta(mdata->tx_sgl_len);
+			mult_delta = mtk_spi_get_mult_delta(mdata, mdata->tx_sgl_len);
 			mdata->xfer_len = mdata->tx_sgl_len - mult_delta;
 			mdata->tx_sgl_len = mult_delta;
 			mdata->rx_sgl_len -= mdata->xfer_len;
 		}
 	} else if (mdata->tx_sgl_len) {
-		mult_delta = mtk_spi_get_mult_delta(mdata->tx_sgl_len);
+		mult_delta = mtk_spi_get_mult_delta(mdata, mdata->tx_sgl_len);
 		mdata->xfer_len = mdata->tx_sgl_len - mult_delta;
 		mdata->tx_sgl_len = mult_delta;
 	} else if (mdata->rx_sgl_len) {
-		mult_delta = mtk_spi_get_mult_delta(mdata->rx_sgl_len);
+		mult_delta = mtk_spi_get_mult_delta(mdata, mdata->rx_sgl_len);
 		mdata->xfer_len = mdata->rx_sgl_len - mult_delta;
 		mdata->rx_sgl_len = mult_delta;
 	}
-- 
2.35.1




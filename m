Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE95657BF8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbiL1P1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbiL1P1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:27:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E400140A7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:27:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFB026155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01FEC433EF;
        Wed, 28 Dec 2022 15:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241240;
        bh=+PCmEb79SDjjzISklcarpKZ+wzHHePAD6e0LLyP0dxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCyc+JyUrwr4tfvrPUurmZdzkeSirSyyd12vWYfhvncoXojce64ApHogRX+03SCwX
         s3CHFKZR8VpzDJqKEOVcR6xUKbuS2WjgXrbkPkdGV7SffepbeH/KJt9eFFISsv/gis
         R9m+CCyFHsj+JgzA+ppBhwMRKzIWh2rfk6eT0djw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0223/1146] net: ethernet: adi: adin1110: Fix SPI transfers
Date:   Wed, 28 Dec 2022 15:29:22 +0100
Message-Id: <20221228144336.200559895@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Alexandru Tachici <alexandru.tachici@analog.com>

[ Upstream commit a526a3cc9c8d426713f8bebc18ebbe39a8495d82 ]

No need to use more than one SPI transfer for reads.
Use only one from now as ADIN1110/2111 does not tolerate
CS changes during reads.

The BCM2711/2708 SPI controllers worked fine, but the NXP
IMX8MM could not keep CS lowered during SPI bursts.

This change aims to make the ADIN1110/2111 driver compatible
with both SPI controllers, without any loss of bandwidth/other
capabilities.

Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/adi/adin1110.c | 37 +++++++++++++----------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 606c97610808..9d8dfe172994 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -196,7 +196,7 @@ static int adin1110_read_reg(struct adin1110_priv *priv, u16 reg, u32 *val)
 {
 	u32 header_len = ADIN1110_RD_HEADER_LEN;
 	u32 read_len = ADIN1110_REG_LEN;
-	struct spi_transfer t[2] = {0};
+	struct spi_transfer t = {0};
 	int ret;
 
 	priv->data[0] = ADIN1110_CD | FIELD_GET(GENMASK(12, 8), reg);
@@ -209,17 +209,15 @@ static int adin1110_read_reg(struct adin1110_priv *priv, u16 reg, u32 *val)
 		header_len++;
 	}
 
-	t[0].tx_buf = &priv->data[0];
-	t[0].len = header_len;
-
 	if (priv->append_crc)
 		read_len++;
 
 	memset(&priv->data[header_len], 0, read_len);
-	t[1].rx_buf = &priv->data[header_len];
-	t[1].len = read_len;
+	t.tx_buf = &priv->data[0];
+	t.rx_buf = &priv->data[0];
+	t.len = read_len + header_len;
 
-	ret = spi_sync_transfer(priv->spidev, t, 2);
+	ret = spi_sync_transfer(priv->spidev, &t, 1);
 	if (ret)
 		return ret;
 
@@ -296,7 +294,7 @@ static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
 {
 	struct adin1110_priv *priv = port_priv->priv;
 	u32 header_len = ADIN1110_RD_HEADER_LEN;
-	struct spi_transfer t[2] = {0};
+	struct spi_transfer t;
 	u32 frame_size_no_fcs;
 	struct sk_buff *rxb;
 	u32 frame_size;
@@ -327,12 +325,7 @@ static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
 		return ret;
 
 	frame_size_no_fcs = frame_size - ADIN1110_FRAME_HEADER_LEN - ADIN1110_FEC_LEN;
-
-	rxb = netdev_alloc_skb(port_priv->netdev, round_len);
-	if (!rxb)
-		return -ENOMEM;
-
-	memset(priv->data, 0, round_len + ADIN1110_RD_HEADER_LEN);
+	memset(priv->data, 0, ADIN1110_RD_HEADER_LEN);
 
 	priv->data[0] = ADIN1110_CD | FIELD_GET(GENMASK(12, 8), reg);
 	priv->data[1] = FIELD_GET(GENMASK(7, 0), reg);
@@ -342,21 +335,23 @@ static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
 		header_len++;
 	}
 
-	skb_put(rxb, frame_size_no_fcs + ADIN1110_FRAME_HEADER_LEN);
+	rxb = netdev_alloc_skb(port_priv->netdev, round_len + header_len);
+	if (!rxb)
+		return -ENOMEM;
 
-	t[0].tx_buf = &priv->data[0];
-	t[0].len = header_len;
+	skb_put(rxb, frame_size_no_fcs + header_len + ADIN1110_FRAME_HEADER_LEN);
 
-	t[1].rx_buf = &rxb->data[0];
-	t[1].len = round_len;
+	t.tx_buf = &priv->data[0];
+	t.rx_buf = &rxb->data[0];
+	t.len = header_len + round_len;
 
-	ret = spi_sync_transfer(priv->spidev, t, 2);
+	ret = spi_sync_transfer(priv->spidev, &t, 1);
 	if (ret) {
 		kfree_skb(rxb);
 		return ret;
 	}
 
-	skb_pull(rxb, ADIN1110_FRAME_HEADER_LEN);
+	skb_pull(rxb, header_len + ADIN1110_FRAME_HEADER_LEN);
 	rxb->protocol = eth_type_trans(rxb, port_priv->netdev);
 
 	if ((port_priv->flags & IFF_ALLMULTI && rxb->pkt_type == PACKET_MULTICAST) ||
-- 
2.35.1




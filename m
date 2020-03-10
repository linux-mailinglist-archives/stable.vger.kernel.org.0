Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D307017F981
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgCJM5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729754AbgCJM5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:57:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EBCB2468D;
        Tue, 10 Mar 2020 12:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845039;
        bh=Rk9wq54YArR8AwJkIfvtCrBBOr/4+oP9g+gu/tchcRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mI07pRisbL2WLiRQsXu9cP98er6AEYt5LZTM3atOB8zHKEubQK3FYufv59qGDI78Z
         jbwwbBWlfKQ7i8flfNQ2EUQPOv9SyutV4DHmSL4ydwSmwIJXVa4wk0grD+AX3cnTCw
         r9cz6t3pWqyH+pBpMATDXLdtD5gosHjsG9W5BzBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 033/189] net: ks8851-ml: Remove 8-bit bus accessors
Date:   Tue, 10 Mar 2020 13:37:50 +0100
Message-Id: <20200310123642.808235654@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 69233bba6543a37755158ca3382765387b8078df ]

This driver is mixing 8-bit and 16-bit bus accessors for reasons unknown,
however the speculation is that this was some sort of attempt to support
the 8-bit bus mode.

As per the KS8851-16MLL documentation, all two registers accessed via the
8-bit accessors are internally 16-bit registers, so reading them using
16-bit accessors is fine. The KS_CCR read can be converted to 16-bit read
outright, as it is already a concatenation of two 8-bit reads of that
register. The KS_RXQCR accesses are 8-bit only, however writing the top
8 bits of the register is OK as well, since the driver caches the entire
16-bit register value anyway.

Finally, the driver is not used by any hardware in the kernel right now.
The only hardware available to me is one with 16-bit bus, so I have no
way to test the 8-bit bus mode, however it is unlikely this ever really
worked anyway. If the 8-bit bus mode is ever required, it can be easily
added by adjusting the 16-bit accessors to do 2 consecutive accesses,
which is how this should have been done from the beginning.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851_mll.c | 45 +++---------------------
 1 file changed, 5 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index a41a90c589db2..e2fb20154511e 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -156,24 +156,6 @@ static int msg_enable;
  * chip is busy transferring packet data (RX/TX FIFO accesses).
  */
 
-/**
- * ks_rdreg8 - read 8 bit register from device
- * @ks	  : The chip information
- * @offset: The register address
- *
- * Read a 8bit register from the chip, returning the result
- */
-static u8 ks_rdreg8(struct ks_net *ks, int offset)
-{
-	u16 data;
-	u8 shift_bit = offset & 0x03;
-	u8 shift_data = (offset & 1) << 3;
-	ks->cmd_reg_cache = (u16) offset | (u16)(BE0 << shift_bit);
-	iowrite16(ks->cmd_reg_cache, ks->hw_addr_cmd);
-	data  = ioread16(ks->hw_addr);
-	return (u8)(data >> shift_data);
-}
-
 /**
  * ks_rdreg16 - read 16 bit register from device
  * @ks	  : The chip information
@@ -189,22 +171,6 @@ static u16 ks_rdreg16(struct ks_net *ks, int offset)
 	return ioread16(ks->hw_addr);
 }
 
-/**
- * ks_wrreg8 - write 8bit register value to chip
- * @ks: The chip information
- * @offset: The register address
- * @value: The value to write
- *
- */
-static void ks_wrreg8(struct ks_net *ks, int offset, u8 value)
-{
-	u8  shift_bit = (offset & 0x03);
-	u16 value_write = (u16)(value << ((offset & 1) << 3));
-	ks->cmd_reg_cache = (u16)offset | (BE0 << shift_bit);
-	iowrite16(ks->cmd_reg_cache, ks->hw_addr_cmd);
-	iowrite16(value_write, ks->hw_addr);
-}
-
 /**
  * ks_wrreg16 - write 16bit register value to chip
  * @ks: The chip information
@@ -324,8 +290,7 @@ static void ks_read_config(struct ks_net *ks)
 	u16 reg_data = 0;
 
 	/* Regardless of bus width, 8 bit read should always work.*/
-	reg_data = ks_rdreg8(ks, KS_CCR) & 0x00FF;
-	reg_data |= ks_rdreg8(ks, KS_CCR+1) << 8;
+	reg_data = ks_rdreg16(ks, KS_CCR);
 
 	/* addr/data bus are multiplexed */
 	ks->sharedbus = (reg_data & CCR_SHARED) == CCR_SHARED;
@@ -429,7 +394,7 @@ static inline void ks_read_qmu(struct ks_net *ks, u16 *buf, u32 len)
 
 	/* 1. set sudo DMA mode */
 	ks_wrreg16(ks, KS_RXFDPR, RXFDPR_RXFPAI);
-	ks_wrreg8(ks, KS_RXQCR, (ks->rc_rxqcr | RXQCR_SDA) & 0xff);
+	ks_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_SDA);
 
 	/* 2. read prepend data */
 	/**
@@ -446,7 +411,7 @@ static inline void ks_read_qmu(struct ks_net *ks, u16 *buf, u32 len)
 	ks_inblk(ks, buf, ALIGN(len, 4));
 
 	/* 4. reset sudo DMA Mode */
-	ks_wrreg8(ks, KS_RXQCR, ks->rc_rxqcr);
+	ks_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr);
 }
 
 /**
@@ -679,13 +644,13 @@ static void ks_write_qmu(struct ks_net *ks, u8 *pdata, u16 len)
 	ks->txh.txw[1] = cpu_to_le16(len);
 
 	/* 1. set sudo-DMA mode */
-	ks_wrreg8(ks, KS_RXQCR, (ks->rc_rxqcr | RXQCR_SDA) & 0xff);
+	ks_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_SDA);
 	/* 2. write status/lenth info */
 	ks_outblk(ks, ks->txh.txw, 4);
 	/* 3. write pkt data */
 	ks_outblk(ks, (u16 *)pdata, ALIGN(len, 4));
 	/* 4. reset sudo-DMA mode */
-	ks_wrreg8(ks, KS_RXQCR, ks->rc_rxqcr);
+	ks_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr);
 	/* 5. Enqueue Tx(move the pkt from TX buffer into TXQ) */
 	ks_wrreg16(ks, KS_TXQCR, TXQCR_METFE);
 	/* 6. wait until TXQCR_METFE is auto-cleared */
-- 
2.20.1




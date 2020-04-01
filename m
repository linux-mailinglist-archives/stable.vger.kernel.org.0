Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEE919B43A
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 19:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732807AbgDAQUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732844AbgDAQUP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:20:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0E082137B;
        Wed,  1 Apr 2020 16:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758014;
        bh=Op1Vmh9JkL9YwYuFWGMzfqjEvOf7teeWQwtofuAiVEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLW19/Zw6mGgzKBvTi+H07QdXiYXoBRakdup24asg5AcIqrMH8iRDZbJ94Itfx5xs
         Kj+fltyFqpRyNNLuYVD1rw83+bxaoOtDKF9kXfDZHljLEDIKtACRrDKboOuQhoVAoI
         HKnRB9z+5840AWx3s8KP1b4BumAJxhuUsq0skicQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH 5.5 16/30] net: ks8851-ml: Fix IO operations, again
Date:   Wed,  1 Apr 2020 18:17:20 +0200
Message-Id: <20200401161428.155460755@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.345528747@linuxfoundation.org>
References: <20200401161414.345528747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit 8262e6f9b1034ede34548a04dec4c302d92c9497 upstream.

This patch reverts 58292104832f ("net: ks8851-ml: Fix 16-bit IO operation")
and edacb098ea9c ("net: ks8851-ml: Fix 16-bit data access"), because it
turns out these were only necessary due to buggy hardware. This patch adds
a check for such a buggy hardware to prevent any such mistakes again.

While working further on the KS8851 driver, it came to light that the
KS8851-16MLL is capable of switching bus endianness by a hardware strap,
EESK pin. If this strap is incorrect, the IO accesses require such endian
swapping as is being reverted by this patch. Such swapping also impacts
the performance significantly.

Hence, in addition to removing it, detect that the hardware is broken,
report to user, and fail to bind with such hardware.

Fixes: 58292104832f ("net: ks8851-ml: Fix 16-bit IO operation")
Fixes: edacb098ea9c ("net: ks8851-ml: Fix 16-bit data access")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/micrel/ks8851_mll.c |   56 ++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -157,6 +157,50 @@ static int msg_enable;
  */
 
 /**
+ * ks_check_endian - Check whether endianness of the bus is correct
+ * @ks	  : The chip information
+ *
+ * The KS8851-16MLL EESK pin allows selecting the endianness of the 16bit
+ * bus. To maintain optimum performance, the bus endianness should be set
+ * such that it matches the endianness of the CPU.
+ */
+
+static int ks_check_endian(struct ks_net *ks)
+{
+	u16 cider;
+
+	/*
+	 * Read CIDER register first, however read it the "wrong" way around.
+	 * If the endian strap on the KS8851-16MLL in incorrect and the chip
+	 * is operating in different endianness than the CPU, then the meaning
+	 * of BE[3:0] byte-enable bits is also swapped such that:
+	 *    BE[3,2,1,0] becomes BE[1,0,3,2]
+	 *
+	 * Luckily for us, the byte-enable bits are the top four MSbits of
+	 * the address register and the CIDER register is at offset 0xc0.
+	 * Hence, by reading address 0xc0c0, which is not impacted by endian
+	 * swapping, we assert either BE[3:2] or BE[1:0] while reading the
+	 * CIDER register.
+	 *
+	 * If the bus configuration is correct, reading 0xc0c0 asserts
+	 * BE[3:2] and this read returns 0x0000, because to read register
+	 * with bottom two LSbits of address set to 0, BE[1:0] must be
+	 * asserted.
+	 *
+	 * If the bus configuration is NOT correct, reading 0xc0c0 asserts
+	 * BE[1:0] and this read returns non-zero 0x8872 value.
+	 */
+	iowrite16(BE3 | BE2 | KS_CIDER, ks->hw_addr_cmd);
+	cider = ioread16(ks->hw_addr);
+	if (!cider)
+		return 0;
+
+	netdev_err(ks->netdev, "incorrect EESK endian strap setting\n");
+
+	return -EINVAL;
+}
+
+/**
  * ks_rdreg16 - read 16 bit register from device
  * @ks	  : The chip information
  * @offset: The register address
@@ -166,7 +210,7 @@ static int msg_enable;
 
 static u16 ks_rdreg16(struct ks_net *ks, int offset)
 {
-	ks->cmd_reg_cache = (u16)offset | ((BE3 | BE2) >> (offset & 0x02));
+	ks->cmd_reg_cache = (u16)offset | ((BE1 | BE0) << (offset & 0x02));
 	iowrite16(ks->cmd_reg_cache, ks->hw_addr_cmd);
 	return ioread16(ks->hw_addr);
 }
@@ -181,7 +225,7 @@ static u16 ks_rdreg16(struct ks_net *ks,
 
 static void ks_wrreg16(struct ks_net *ks, int offset, u16 value)
 {
-	ks->cmd_reg_cache = (u16)offset | ((BE3 | BE2) >> (offset & 0x02));
+	ks->cmd_reg_cache = (u16)offset | ((BE1 | BE0) << (offset & 0x02));
 	iowrite16(ks->cmd_reg_cache, ks->hw_addr_cmd);
 	iowrite16(value, ks->hw_addr);
 }
@@ -197,7 +241,7 @@ static inline void ks_inblk(struct ks_ne
 {
 	len >>= 1;
 	while (len--)
-		*wptr++ = be16_to_cpu(ioread16(ks->hw_addr));
+		*wptr++ = (u16)ioread16(ks->hw_addr);
 }
 
 /**
@@ -211,7 +255,7 @@ static inline void ks_outblk(struct ks_n
 {
 	len >>= 1;
 	while (len--)
-		iowrite16(cpu_to_be16(*wptr++), ks->hw_addr);
+		iowrite16(*wptr++, ks->hw_addr);
 }
 
 static void ks_disable_int(struct ks_net *ks)
@@ -1218,6 +1262,10 @@ static int ks8851_probe(struct platform_
 		goto err_free;
 	}
 
+	err = ks_check_endian(ks);
+	if (err)
+		goto err_free;
+
 	netdev->irq = platform_get_irq(pdev, 0);
 
 	if ((int)netdev->irq < 0) {



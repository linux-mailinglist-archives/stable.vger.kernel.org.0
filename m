Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF792E408C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441499AbgL1ORq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:17:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:52536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501883AbgL1ORe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7B81207A9;
        Mon, 28 Dec 2020 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165008;
        bh=J8EDAHR5nrjdH7QAF5tISe7lha4W7Duhqv6amCs6azE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDZmqz3NfbvXJpt9yFDVkSHLXA9K8AJhwcFhJw6aSx6ZnMcBNlDOIyjXzW3kc735P
         Z+6q5yvt0iwxeB1h/M45XIxO6zh2zw/HKoLiorrhCzKTGPOVX1tq4mp6Y2zOMXotgK
         8f37FPnC5+SiwxtaBT3BK96K0hgV6380OlG1iglo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 347/717] mtd: spi-nor: ignore errors in spi_nor_unlock_all()
Date:   Mon, 28 Dec 2020 13:45:45 +0100
Message-Id: <20201228125037.652430535@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit bdb1a75e4b9df6861ec6a6e3e3997820d3cebabe ]

Just try to unlock the whole SPI-NOR flash array. Don't abort the
probing in case of an error. Justifications:
 (1) For some boards, this just works because
     spi_nor_write_16bit_sr_and_check() is broken and just checks the
     second half of the 16bit. Once that will be fixed, SPI probe will
     fail for boards which has hardware-write protected SPI-NOR flashes.
 (2) Until now, hardware write-protection was the only viable solution
     to use the block protection bits. This is because this very
     function spi_nor_unlock_all() will be called unconditionally on
     every linux boot. Therefore, this bits only makes sense in
     combination with the hardware write-protection. If we would fail
     the SPI probe on an error in spi_nor_unlock_all() we'd break
     virtually all users of the block protection bits.
 (3) We should try hard to keep the MTD working even if the flash might
     not be writable/erasable.

Fixes: 3e0930f109e7 ("mtd: spi-nor: Rework the disabling of block write protection")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20201203162959.29589-3-michael@walle.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index f0ae7a01703a1..61b00d4965475 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2915,20 +2915,27 @@ static int spi_nor_quad_enable(struct spi_nor *nor)
 }
 
 /**
- * spi_nor_unlock_all() - Unlocks the entire flash memory array.
+ * spi_nor_try_unlock_all() - Tries to unlock the entire flash memory array.
  * @nor:	pointer to a 'struct spi_nor'.
  *
  * Some SPI NOR flashes are write protected by default after a power-on reset
  * cycle, in order to avoid inadvertent writes during power-up. Backward
  * compatibility imposes to unlock the entire flash memory array at power-up
  * by default.
+ *
+ * Unprotecting the entire flash array will fail for boards which are hardware
+ * write-protected. Thus any errors are ignored.
  */
-static int spi_nor_unlock_all(struct spi_nor *nor)
+static void spi_nor_try_unlock_all(struct spi_nor *nor)
 {
-	if (nor->flags & SNOR_F_HAS_LOCK)
-		return spi_nor_unlock(&nor->mtd, 0, nor->params->size);
+	int ret;
 
-	return 0;
+	if (!(nor->flags & SNOR_F_HAS_LOCK))
+		return;
+
+	ret = spi_nor_unlock(&nor->mtd, 0, nor->params->size);
+	if (ret)
+		dev_dbg(nor->dev, "Failed to unlock the entire flash memory array\n");
 }
 
 static int spi_nor_init(struct spi_nor *nor)
@@ -2941,11 +2948,7 @@ static int spi_nor_init(struct spi_nor *nor)
 		return err;
 	}
 
-	err = spi_nor_unlock_all(nor);
-	if (err) {
-		dev_dbg(nor->dev, "Failed to unlock the entire flash memory array\n");
-		return err;
-	}
+	spi_nor_try_unlock_all(nor);
 
 	if (nor->addr_width == 4 && !(nor->flags & SNOR_F_4B_OPCODES)) {
 		/*
-- 
2.27.0




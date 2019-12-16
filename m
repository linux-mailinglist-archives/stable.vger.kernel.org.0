Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8549512175F
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfLPSet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:34:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730307AbfLPSIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:08:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 310E02072D;
        Mon, 16 Dec 2019 18:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519725;
        bh=02OOIG76Z/Iy1EgmCIZzU+/S2CzO0XCskta4452Yzj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zd6tzcjY2Hfa5UKQG9HEVUY4kYZ3hgqM6av8F7yO+nQGQc+U2c9GdupE2XZHNw7bX
         dv/r4m6usV/IKluyVuWVbaZWr1EefbPFabG5gRrBYtSCapzNoZ4SoZ1c1oa82t3RXG
         9vO9yU+JgyEA9IdLn4jhH73OE7SSnp/L3XDaYopM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.3 044/180] mtd: spear_smi: Fix Write Burst mode
Date:   Mon, 16 Dec 2019 18:48:04 +0100
Message-Id: <20191216174819.027145153@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 69c7f4618c16b4678f8a4949b6bb5ace259c0033 upstream.

Any write with either dd or flashcp to a device driven by the
spear_smi.c driver will pass through the spear_smi_cpy_toio()
function. This function will get called for chunks of up to 256 bytes.
If the amount of data is smaller, we may have a problem if the data
length is not 4-byte aligned. In this situation, the kernel panics
during the memcpy:

    # dd if=/dev/urandom bs=1001 count=1 of=/dev/mtd6
    spear_smi_cpy_toio [620] dest c9070000, src c7be8800, len 256
    spear_smi_cpy_toio [620] dest c9070100, src c7be8900, len 256
    spear_smi_cpy_toio [620] dest c9070200, src c7be8a00, len 256
    spear_smi_cpy_toio [620] dest c9070300, src c7be8b00, len 233
    Unhandled fault: external abort on non-linefetch (0x808) at 0xc90703e8
    [...]
    PC is at memcpy+0xcc/0x330

The above error occurs because the implementation of memcpy_toio()
tries to optimize the number of I/O by writing 4 bytes at a time as
much as possible, until there are less than 4 bytes left and then
switches to word or byte writes.

Unfortunately, the specification states about the Write Burst mode:

        "the next AHB Write request should point to the next
	incremented address and should have the same size (byte,
	half-word or word)"

This means ARM architecture implementation of memcpy_toio() cannot
reliably be used blindly here. Workaround this situation by update the
write path to stick to byte access when the burst length is not
multiple of 4.

Fixes: f18dbbb1bfe0 ("mtd: ST SPEAr: Add SMI driver for serial NOR flash")
Cc: Russell King <linux@armlinux.org.uk>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/devices/spear_smi.c |   38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

--- a/drivers/mtd/devices/spear_smi.c
+++ b/drivers/mtd/devices/spear_smi.c
@@ -592,6 +592,26 @@ static int spear_mtd_read(struct mtd_inf
 	return 0;
 }
 
+/*
+ * The purpose of this function is to ensure a memcpy_toio() with byte writes
+ * only. Its structure is inspired from the ARM implementation of _memcpy_toio()
+ * which also does single byte writes but cannot be used here as this is just an
+ * implementation detail and not part of the API. Not mentioning the comment
+ * stating that _memcpy_toio() should be optimized.
+ */
+static void spear_smi_memcpy_toio_b(volatile void __iomem *dest,
+				    const void *src, size_t len)
+{
+	const unsigned char *from = src;
+
+	while (len) {
+		len--;
+		writeb(*from, dest);
+		from++;
+		dest++;
+	}
+}
+
 static inline int spear_smi_cpy_toio(struct spear_smi *dev, u32 bank,
 		void __iomem *dest, const void *src, size_t len)
 {
@@ -614,7 +634,23 @@ static inline int spear_smi_cpy_toio(str
 	ctrlreg1 = readl(dev->io_base + SMI_CR1);
 	writel((ctrlreg1 | WB_MODE) & ~SW_MODE, dev->io_base + SMI_CR1);
 
-	memcpy_toio(dest, src, len);
+	/*
+	 * In Write Burst mode (WB_MODE), the specs states that writes must be:
+	 * - incremental
+	 * - of the same size
+	 * The ARM implementation of memcpy_toio() will optimize the number of
+	 * I/O by using as much 4-byte writes as possible, surrounded by
+	 * 2-byte/1-byte access if:
+	 * - the destination is not 4-byte aligned
+	 * - the length is not a multiple of 4-byte.
+	 * Avoid this alternance of write access size by using our own 'byte
+	 * access' helper if at least one of the two conditions above is true.
+	 */
+	if (IS_ALIGNED(len, sizeof(u32)) &&
+	    IS_ALIGNED((uintptr_t)dest, sizeof(u32)))
+		memcpy_toio(dest, src, len);
+	else
+		spear_smi_memcpy_toio_b(dest, src, len);
 
 	writel(ctrlreg1, dev->io_base + SMI_CR1);
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53391E04C1
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 15:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731914AbfJVNTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 09:19:35 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:39921 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730197AbfJVNTf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Oct 2019 09:19:35 -0400
Received: from localhost.localdomain (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id CCE3B200011;
        Tue, 22 Oct 2019 13:19:31 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     <linux-mtd@lists.infradead.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Russell King <linux@armlinux.org.uk>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] mtd: spear_smi: Fix Write Burst mode
Date:   Tue, 22 Oct 2019 15:19:18 +0200
Message-Id: <20191022131918.17668-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

Changes in v2:
==============
* This time I think the patch really fixes the problem: we use a
  memcpy_toio_b() function to force byte access only when needed. We
  don't use the _memcpy_toio() helper anymore as the fact that it is
  doing byte access is purely an implementation detail and is not part
  of the API, while the function is also flagged as "should be
  optimized".
* One could argue that potentially memcpy_toio() does not ensure by
  design 4-bytes access only but I think it is good enough to use it
  in this case as the ARM implementation of this function is already
  extensively optimized. I also find clearer to use it than 
  adding my own spear_smi_mempy_toio_l(). Please tell me if you disagree
  with this.
* The volatile keyword has been taken voluntarily from the _memcpy_toio()
  implementation I was about to use previously.

 drivers/mtd/devices/spear_smi.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/spear_smi.c b/drivers/mtd/devices/spear_smi.c
index 986f81d2f93e..84b7487d781d 100644
--- a/drivers/mtd/devices/spear_smi.c
+++ b/drivers/mtd/devices/spear_smi.c
@@ -592,6 +592,19 @@ static int spear_mtd_read(struct mtd_info *mtd, loff_t from, size_t len,
 	return 0;
 }
 
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
@@ -614,7 +627,17 @@ static inline int spear_smi_cpy_toio(struct spear_smi *dev, u32 bank,
 	ctrlreg1 = readl(dev->io_base + SMI_CR1);
 	writel((ctrlreg1 | WB_MODE) & ~SW_MODE, dev->io_base + SMI_CR1);
 
-	memcpy_toio(dest, src, len);
+	/*
+	 * In Write Burst mode (WB_MODE), the specs states that writes must be
+	 * incremental and of the same size, so we cannot use memcpy_toio() if
+	 * the length is not 4-byte aligned because in order to increase the
+	 * performances, it would proceed as much as possible with 4-byte access
+	 * and potentially finish with smaller access sizes.
+	 */
+	if (len % sizeof(u32))
+		spear_smi_memcpy_toio_b(dest, src, len);
+	else
+		memcpy_toio(dest, src, len);
 
 	writel(ctrlreg1, dev->io_base + SMI_CR1);
 
-- 
2.20.1


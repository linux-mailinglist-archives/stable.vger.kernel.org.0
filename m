Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B980D4F6C79
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 23:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbiDFVWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 17:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235705AbiDFVV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 17:21:58 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D840E25FA;
        Wed,  6 Apr 2022 13:15:54 -0700 (PDT)
Received: from quad ([82.142.17.26]) by mrelayeu.kundenserver.de (mreue107
 [212.227.15.183]) with ESMTPSA (Nemesis) id 1M2fM1-1nZAzA0k1P-0048Ka; Wed, 06
 Apr 2022 22:15:27 +0200
From:   Laurent Vivier <laurent@vivier.eu>
To:     linux-kernel@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-m68k@lists.linux-m68k.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-rtc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Laurent Vivier <laurent@vivier.eu>, stable@vger.kernel.org
Subject: [PATCH v16 1/4] tty: goldfish: introduce gf_ioread32()/gf_iowrite32()
Date:   Wed,  6 Apr 2022 22:15:20 +0200
Message-Id: <20220406201523.243733-2-laurent@vivier.eu>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406201523.243733-1-laurent@vivier.eu>
References: <20220406201523.243733-1-laurent@vivier.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:wuMO2Bh7JAmDELr/j2NzHCRZ260mn/HqS+sJXz/8jvBcByBBXwy
 S7CZAkWwnx0U1+myzlDfJLYeHpvPCI/JDsILXuAccjpkXr43IFT2vdWn0sNETcmyjn3sE6l
 YD9cWUFzJ18/HFRDs8Hw7Lt3aCqcPSN/+f5GOo0wII+h7sifC2CoSGbxMkJ6anzl7b+dPO2
 DGYZE9upQ5mQZ8YmEzaww==
X-UI-Out-Filterresults: notjunk:1;V03:K0:xJPwScI8HxM=:ENWHau2Mj8CE2+sESobuKu
 Mh7z1XIxRbSqwkfy0XepjQIZL16EL740mmjcYSfJx969Qh606ciPOVdr61W7C2BTPIm3M64fT
 ySuBVL5xAsgY/ZnXSo8UfWqLAtOXsijUuaaOQNu6nv8qKOEyoIaBck9xBPD0UaF7LMm4+pjtn
 wTKm6b4CX0LxTCXocExh4I1icDeJR/+n3Azh1jBjdRuhbheOPFXvEL+BCAAwE3Y0za/5KaeVg
 eThR/S3jmlF3pFHINWsCf2zK5aSYEVKQ1HXJK53Z30IcC2t4l72ryjtCmDpWjJdwUVkNCbJk/
 j2JWsKkksI9NvIj6gf9nugPqKnwhw/weaE9kjtEifA+Tu3txNb4vnzJ8ChLh+ggF9bJlu4uym
 i8hLut2SX1b7o7GRsTYLj37Ib0Y7CJlsVuPKLZXFGfQHh7OWZcfuBwdaaSZ9sAlTOVquYFJUb
 c3/ELoq3MTzUHkpB/k/rR9YeAriaDTZG3nzVz/qKFDwbQR7Hw9zNKmMCtpt5CteyKa75CNZWC
 Y7wfpqUeOdY18Shm4fOm1E8AUw7wPFtV2Szn/HPjr3s9VcCnnlIVmAOQD7iqsrRT8eSS/EZ5k
 D5hJs56RX17IUPJ4VX7OAvhXOJbVhnyXPU1pb95iscz6AG/JXifer30v1biSx/4A97f701W9l
 zh0hyUazQT82417wyBg5CnyHOBZUHu2R1uLhObaXzjERJGZwdwgrksaXlD5CN2kMUpWo=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Revert
commit da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")

and define gf_ioread32()/gf_iowrite32() to be able to use accessors
defined by the architecture.

Cc: stable@vger.kernel.org # v5.11+
Fixes: da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
Signed-off-by: Laurent Vivier <laurent@vivier.eu>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/tty/goldfish.c   | 20 ++++++++++----------
 include/linux/goldfish.h | 15 +++++++++++----
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
index ad13532e92fe..9e8ccb8ed6d6 100644
--- a/drivers/tty/goldfish.c
+++ b/drivers/tty/goldfish.c
@@ -61,13 +61,13 @@ static void do_rw_io(struct goldfish_tty *qtty,
 	spin_lock_irqsave(&qtty->lock, irq_flags);
 	gf_write_ptr((void *)address, base + GOLDFISH_TTY_REG_DATA_PTR,
 		     base + GOLDFISH_TTY_REG_DATA_PTR_HIGH);
-	__raw_writel(count, base + GOLDFISH_TTY_REG_DATA_LEN);
+	gf_iowrite32(count, base + GOLDFISH_TTY_REG_DATA_LEN);
 
 	if (is_write)
-		__raw_writel(GOLDFISH_TTY_CMD_WRITE_BUFFER,
+		gf_iowrite32(GOLDFISH_TTY_CMD_WRITE_BUFFER,
 		       base + GOLDFISH_TTY_REG_CMD);
 	else
-		__raw_writel(GOLDFISH_TTY_CMD_READ_BUFFER,
+		gf_iowrite32(GOLDFISH_TTY_CMD_READ_BUFFER,
 		       base + GOLDFISH_TTY_REG_CMD);
 
 	spin_unlock_irqrestore(&qtty->lock, irq_flags);
@@ -142,7 +142,7 @@ static irqreturn_t goldfish_tty_interrupt(int irq, void *dev_id)
 	unsigned char *buf;
 	u32 count;
 
-	count = __raw_readl(base + GOLDFISH_TTY_REG_BYTES_READY);
+	count = gf_ioread32(base + GOLDFISH_TTY_REG_BYTES_READY);
 	if (count == 0)
 		return IRQ_NONE;
 
@@ -159,7 +159,7 @@ static int goldfish_tty_activate(struct tty_port *port, struct tty_struct *tty)
 {
 	struct goldfish_tty *qtty = container_of(port, struct goldfish_tty,
 									port);
-	__raw_writel(GOLDFISH_TTY_CMD_INT_ENABLE, qtty->base + GOLDFISH_TTY_REG_CMD);
+	gf_iowrite32(GOLDFISH_TTY_CMD_INT_ENABLE, qtty->base + GOLDFISH_TTY_REG_CMD);
 	return 0;
 }
 
@@ -167,7 +167,7 @@ static void goldfish_tty_shutdown(struct tty_port *port)
 {
 	struct goldfish_tty *qtty = container_of(port, struct goldfish_tty,
 									port);
-	__raw_writel(GOLDFISH_TTY_CMD_INT_DISABLE, qtty->base + GOLDFISH_TTY_REG_CMD);
+	gf_iowrite32(GOLDFISH_TTY_CMD_INT_DISABLE, qtty->base + GOLDFISH_TTY_REG_CMD);
 }
 
 static int goldfish_tty_open(struct tty_struct *tty, struct file *filp)
@@ -202,7 +202,7 @@ static unsigned int goldfish_tty_chars_in_buffer(struct tty_struct *tty)
 {
 	struct goldfish_tty *qtty = &goldfish_ttys[tty->index];
 	void __iomem *base = qtty->base;
-	return __raw_readl(base + GOLDFISH_TTY_REG_BYTES_READY);
+	return gf_ioread32(base + GOLDFISH_TTY_REG_BYTES_READY);
 }
 
 static void goldfish_tty_console_write(struct console *co, const char *b,
@@ -355,7 +355,7 @@ static int goldfish_tty_probe(struct platform_device *pdev)
 	 * on Ranchu emulator (qemu2) returns 1 here and
 	 * driver will use physical addresses.
 	 */
-	qtty->version = __raw_readl(base + GOLDFISH_TTY_REG_VERSION);
+	qtty->version = gf_ioread32(base + GOLDFISH_TTY_REG_VERSION);
 
 	/*
 	 * Goldfish TTY device on Ranchu emulator (qemu2)
@@ -374,7 +374,7 @@ static int goldfish_tty_probe(struct platform_device *pdev)
 		}
 	}
 
-	__raw_writel(GOLDFISH_TTY_CMD_INT_DISABLE, base + GOLDFISH_TTY_REG_CMD);
+	gf_iowrite32(GOLDFISH_TTY_CMD_INT_DISABLE, base + GOLDFISH_TTY_REG_CMD);
 
 	ret = request_irq(irq, goldfish_tty_interrupt, IRQF_SHARED,
 			  "goldfish_tty", qtty);
@@ -436,7 +436,7 @@ static int goldfish_tty_remove(struct platform_device *pdev)
 #ifdef CONFIG_GOLDFISH_TTY_EARLY_CONSOLE
 static void gf_early_console_putchar(struct uart_port *port, unsigned char ch)
 {
-	__raw_writel(ch, port->membase);
+	gf_iowrite32(ch, port->membase);
 }
 
 static void gf_early_write(struct console *con, const char *s, unsigned int n)
diff --git a/include/linux/goldfish.h b/include/linux/goldfish.h
index 12be1601fd84..bcc17f95b906 100644
--- a/include/linux/goldfish.h
+++ b/include/linux/goldfish.h
@@ -8,14 +8,21 @@
 
 /* Helpers for Goldfish virtual platform */
 
+#ifndef gf_ioread32
+#define gf_ioread32 ioread32
+#endif
+#ifndef gf_iowrite32
+#define gf_iowrite32 iowrite32
+#endif
+
 static inline void gf_write_ptr(const void *ptr, void __iomem *portl,
 				void __iomem *porth)
 {
 	const unsigned long addr = (unsigned long)ptr;
 
-	__raw_writel(lower_32_bits(addr), portl);
+	gf_iowrite32(lower_32_bits(addr), portl);
 #ifdef CONFIG_64BIT
-	__raw_writel(upper_32_bits(addr), porth);
+	gf_iowrite32(upper_32_bits(addr), porth);
 #endif
 }
 
@@ -23,9 +30,9 @@ static inline void gf_write_dma_addr(const dma_addr_t addr,
 				     void __iomem *portl,
 				     void __iomem *porth)
 {
-	__raw_writel(lower_32_bits(addr), portl);
+	gf_iowrite32(lower_32_bits(addr), portl);
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-	__raw_writel(upper_32_bits(addr), porth);
+	gf_iowrite32(upper_32_bits(addr), porth);
 #endif
 }
 
-- 
2.35.1


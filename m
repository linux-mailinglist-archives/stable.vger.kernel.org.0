Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13ACF49662E
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 21:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiAUUIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 15:08:14 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:39115 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbiAUUIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 15:08:13 -0500
Received: from quad ([82.142.13.186]) by mrelayeu.kundenserver.de (mreue009
 [212.227.15.167]) with ESMTPSA (Nemesis) id 1MV6G6-1mlG9V0pyI-00S4PR; Fri, 21
 Jan 2022 21:07:47 +0100
From:   Laurent Vivier <laurent@vivier.eu>
To:     linux-kernel@vger.kernel.org
Cc:     linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        John Stultz <john.stultz@linaro.org>,
        Laurent Vivier <laurent@vivier.eu>, stable@vger.kernel.org
Subject: [PATCH v12 2/5] tty: goldfish: introduce gf_ioread32()/gf_iowrite32()
Date:   Fri, 21 Jan 2022 21:07:35 +0100
Message-Id: <20220121200738.2577697-3-laurent@vivier.eu>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220121200738.2577697-1-laurent@vivier.eu>
References: <20220121200738.2577697-1-laurent@vivier.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:68hn+CHtxfXnKEYUsL+yL+WbhBHUV/OM1pLbeoSTTo/oip5nHtB
 j649/0zO1dfELhae3r1B+BG0r4/7r1xfO56S1F5mhBHIyTTsdMtYC0zfr2YksyF1/wnT3Hy
 v5Bz/PfcCmxMd+m2Iwf/Pv7L8wzOUO3gsIRXABX99LVlHamN76WWJHC7gMFiEr2Dhbko8aw
 mB/4DCe/zUKK+INAvJyXQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qiUkaceAwQg=:gFT4MrHO5CMUfoL/PnnjM7
 GRNxjmb/50B22/AqpMD2KgCuKo3pk2RhC9yOMgZbkIlEplz7/9Y6yDv4Zr2mvDoU5jn0l+j1y
 hzGX52cs19FlTXK0WmF/bwSZr46WdZzXUo7+EgdrT07n3+SFPcIF3vnrdS67Q9oJJSW8xsS2Q
 agJFBoeHK1Aht14/t51WNYCKu7hOMiXB1MDAKANAZexcUEu1w2gI9Z6MmTuhmznPqk4u1+wdu
 Xj80PfycZLSk+7lI21OkET0zko7FS5iT9/uWuXMyraXlSVyjlhi8rJkANcV09ifIlDkwKrEdD
 2dk1c1KYUzR7zseCxjZrMYjpbyymIHngYYPKanYWScleC+tIMH+PgswGShBKLJnrC4fL0X65L
 QfVSPeZ/GpYInetnYuU7cvweZ3xiEIlpVPOWatvXVDK2eNrIW9w/LTeWZezZdYUIqcJN6Lujr
 TkbmKx3v9+xUzp7N/X9XVb1KeNXipTljGddfUV0zvINHYlBx/rn0Xb5HW+ymtJtd/TJC/mul/
 xah7F/dns3VzNRWb+hcgDaEtLK1HLRDiPN5d26qJLDfCb2ThBtU0LR7Hds8v+UVs8DiEkVc8g
 SrxY+e/sa2MxjZWqtd8M1INtV7w+JhRUAEexMtxuDQOuuZoRzyPrMJAo5bp4Z69OzyXKYvYM3
 tUuzkTUAo89qcsEuR5h6ilrImCqu351gpaIz4lqEcNeVx5HfsMBQCofOG/Hx68FhCIsw=
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
---
 drivers/tty/goldfish.c   | 20 ++++++++++----------
 include/linux/goldfish.h | 15 +++++++++++----
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
index 5ed19a9857ad..10c13b93ed52 100644
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
 static void gf_early_console_putchar(struct uart_port *port, int ch)
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
2.34.1


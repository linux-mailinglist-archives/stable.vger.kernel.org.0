Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D234A36AF
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 15:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355003AbiA3Odx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 09:33:53 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:44575 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355011AbiA3Odw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 09:33:52 -0500
Received: from quad ([82.142.10.94]) by mrelayeu.kundenserver.de (mreue107
 [212.227.15.183]) with ESMTPSA (Nemesis) id 1MJn4B-1mz8IM3nuD-00KBmy; Sun, 30
 Jan 2022 15:33:40 +0100
From:   Laurent Vivier <laurent@vivier.eu>
To:     linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-rtc@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Stephen Boyd <sboyd@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Laurent Vivier <laurent@vivier.eu>, stable@vger.kernel.org
Subject: [PATCH v14 2/5] tty: goldfish: introduce gf_ioread32()/gf_iowrite32()
Date:   Sun, 30 Jan 2022 15:33:30 +0100
Message-Id: <20220130143333.552646-3-laurent@vivier.eu>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220130143333.552646-1-laurent@vivier.eu>
References: <20220130143333.552646-1-laurent@vivier.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:GDMx2XT+d9n7WypZPPYjcEVTVTvlAAyx/oEPSpfs1Ookc5d9ozY
 2DNxrndeZ05hHdD8VDYG++EeOKJAhxD5X0mZHCj/AL08/geB/O/t6zzlI0wL6qetjQAAZBD
 WCPcbFNSdJHMhHdHibCLlvfseMk0AwJv5+2k9HJfQYnHd7yeiJ16yyjTWkFyJ6R9iAAMZIp
 zmKQZ/KPx4mPXw9Y4KAMA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:SgrEka7cSOU=:Oxcf1mGPW6i3JJSdI0RLvb
 +nM9stW7F0JydnMPXt/3dAEBQAm3PggfP3kJM9XlwaVzxvGt3CrRxZ3JH5pGJTywLaKHkvGKc
 +/XMEtWVqM+C8QC0TLidgfzt30w/6VQevLjFVxO9MaQJHmh4mU2U3xnUVKhIiAerWGQZkDNh4
 9czT8FJNGU4N35Qfqgwna0X5zPVrBu82HOPsObXDxFWEaA7EmFC35HKBHAjswuY3vXr7y/atH
 NstmjNuhx+pgM0XohOC5/XiTLyun7HUk3HHZIGqXtLd98PA6e3x1JWLARnnabwMz6duir5u71
 CYo6e4YcLIzJ686CMhBgBtjQrc+fEVtXNuQFfjVB7w0UFlGJcOjzFS67Zcm/eb/FRLrAWXb9o
 MX7yGCNkpIkUPK1c3sfr6Dc1HZmvMKmxLbSMebl7gfjKC/7+wf4BJn9bfNLIVxgMPBhFdwQDF
 sfl/ow/liHmZ2bHEE0s6ZLVJJQ+bONVXiUFBGABMStgUPqAuKGVoMG9feGU+w/nkZcYVeRd4n
 mYZZ3Vuff0NuwWV3lbNFUlwdaCKMtUUfzUvQMoGNTYZvQhCiIisTUtampRDHNEu240yYANmrj
 OCFDMT0BQxvnI3/bnUPqjirhLas4VIMyMxkg+ntkvZvIMuPKAk6LBkatAnyi67I/8fr/TOD15
 cObEt7jRwMdgVoCcoEdplefQGNzTNzi3xmeIFqyo2wCbBVkQJk4pxt0dp/LPBMRA4FkI=
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


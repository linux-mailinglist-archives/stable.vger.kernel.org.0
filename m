Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89D73C3BD2
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhGKLYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232718AbhGKLYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Jul 2021 07:24:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 233FB61209;
        Sun, 11 Jul 2021 11:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626002513;
        bh=I09gttTmqG+3gHOphZ31Q1cW6AwqN9VA4E6vVZCwYRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjNXAC1T2VSkxKONG83Pr+vY5TWTaG/ATZQcdWdgO76arEG99s8rKUeK/4rbAvNIO
         M2LYcx+F0CMpXAvSJMnHlLNPZiwP2mmgjDAWEMW8zNhCpJfU7binfH73PlNUjJDNrT
         jLa5YfP0/zaEX+njvIzdtuHjPZfNw4MrFzX2hHso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.12.16
Date:   Sun, 11 Jul 2021 13:21:43 +0200
Message-Id: <1626002501118137@kroah.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1626002501134199@kroah.com>
References: <1626002501134199@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 09e1a0967bab..bf6accb2328c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 12
-SUBLEVEL = 15
+SUBLEVEL = 16
 EXTRAVERSION =
 NAME = Frozen Wasteland
 
diff --git a/arch/hexagon/Makefile b/arch/hexagon/Makefile
index c168c6980d05..74b644ea8a00 100644
--- a/arch/hexagon/Makefile
+++ b/arch/hexagon/Makefile
@@ -10,6 +10,9 @@ LDFLAGS_vmlinux += -G0
 # Do not use single-byte enums; these will overflow.
 KBUILD_CFLAGS += -fno-short-enums
 
+# We must use long-calls:
+KBUILD_CFLAGS += -mlong-calls
+
 # Modules must use either long-calls, or use pic/plt.
 # Use long-calls for now, it's easier.  And faster.
 # KBUILD_CFLAGS_MODULE += -fPIC
@@ -30,9 +33,6 @@ TIR_NAME := r19
 KBUILD_CFLAGS += -ffixed-$(TIR_NAME) -DTHREADINFO_REG=$(TIR_NAME) -D__linux__
 KBUILD_AFLAGS += -DTHREADINFO_REG=$(TIR_NAME)
 
-LIBGCC := $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name 2>/dev/null)
-libs-y += $(LIBGCC)
-
 head-y := arch/hexagon/kernel/head.o
 
 core-y += arch/hexagon/kernel/ \
diff --git a/arch/hexagon/include/asm/futex.h b/arch/hexagon/include/asm/futex.h
index 6b9c554aee78..9fb00a0ae89f 100644
--- a/arch/hexagon/include/asm/futex.h
+++ b/arch/hexagon/include/asm/futex.h
@@ -21,7 +21,7 @@
 	"3:\n" \
 	".section .fixup,\"ax\"\n" \
 	"4: %1 = #%5;\n" \
-	"   jump 3b\n" \
+	"   jump ##3b\n" \
 	".previous\n" \
 	".section __ex_table,\"a\"\n" \
 	".long 1b,4b,2b,4b\n" \
@@ -90,7 +90,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr, u32 oldval,
 	"3:\n"
 	".section .fixup,\"ax\"\n"
 	"4: %0 = #%6\n"
-	"   jump 3b\n"
+	"   jump ##3b\n"
 	".previous\n"
 	".section __ex_table,\"a\"\n"
 	".long 1b,4b,2b,4b\n"
diff --git a/arch/hexagon/include/asm/timex.h b/arch/hexagon/include/asm/timex.h
index 78338d8ada83..8d4ec76fceb4 100644
--- a/arch/hexagon/include/asm/timex.h
+++ b/arch/hexagon/include/asm/timex.h
@@ -8,6 +8,7 @@
 
 #include <asm-generic/timex.h>
 #include <asm/timer-regs.h>
+#include <asm/hexagon_vm.h>
 
 /* Using TCX0 as our clock.  CLOCK_TICK_RATE scheduled to be removed. */
 #define CLOCK_TICK_RATE              TCX0_CLK_RATE
@@ -16,7 +17,7 @@
 
 static inline int read_current_timer(unsigned long *timer_val)
 {
-	*timer_val = (unsigned long) __vmgettime();
+	*timer_val = __vmgettime();
 	return 0;
 }
 
diff --git a/arch/hexagon/kernel/hexagon_ksyms.c b/arch/hexagon/kernel/hexagon_ksyms.c
index 6fb1aaab1c29..35545a7386a0 100644
--- a/arch/hexagon/kernel/hexagon_ksyms.c
+++ b/arch/hexagon/kernel/hexagon_ksyms.c
@@ -35,8 +35,8 @@ EXPORT_SYMBOL(_dflt_cache_att);
 DECLARE_EXPORT(__hexagon_memcpy_likely_aligned_min32bytes_mult8bytes);
 
 /* Additional functions */
-DECLARE_EXPORT(__divsi3);
-DECLARE_EXPORT(__modsi3);
-DECLARE_EXPORT(__udivsi3);
-DECLARE_EXPORT(__umodsi3);
+DECLARE_EXPORT(__hexagon_divsi3);
+DECLARE_EXPORT(__hexagon_modsi3);
+DECLARE_EXPORT(__hexagon_udivsi3);
+DECLARE_EXPORT(__hexagon_umodsi3);
 DECLARE_EXPORT(csum_tcpudp_magic);
diff --git a/arch/hexagon/kernel/ptrace.c b/arch/hexagon/kernel/ptrace.c
index a5a89e944257..8975f9b4cedf 100644
--- a/arch/hexagon/kernel/ptrace.c
+++ b/arch/hexagon/kernel/ptrace.c
@@ -35,7 +35,7 @@ void user_disable_single_step(struct task_struct *child)
 
 static int genregs_get(struct task_struct *target,
 		   const struct user_regset *regset,
-		   srtuct membuf to)
+		   struct membuf to)
 {
 	struct pt_regs *regs = task_pt_regs(target);
 
@@ -54,7 +54,7 @@ static int genregs_get(struct task_struct *target,
 	membuf_store(&to, regs->m0);
 	membuf_store(&to, regs->m1);
 	membuf_store(&to, regs->usr);
-	membuf_store(&to, regs->p3_0);
+	membuf_store(&to, regs->preds);
 	membuf_store(&to, regs->gp);
 	membuf_store(&to, regs->ugp);
 	membuf_store(&to, pt_elr(regs)); // pc
diff --git a/arch/hexagon/lib/Makefile b/arch/hexagon/lib/Makefile
index 54be529d17a2..a64641e89d5f 100644
--- a/arch/hexagon/lib/Makefile
+++ b/arch/hexagon/lib/Makefile
@@ -2,4 +2,5 @@
 #
 # Makefile for hexagon-specific library files.
 #
-obj-y = checksum.o io.o memcpy.o memset.o
+obj-y = checksum.o io.o memcpy.o memset.o memcpy_likely_aligned.o \
+         divsi3.o modsi3.o udivsi3.o  umodsi3.o
diff --git a/arch/hexagon/lib/divsi3.S b/arch/hexagon/lib/divsi3.S
new file mode 100644
index 000000000000..783e09424c2c
--- /dev/null
+++ b/arch/hexagon/lib/divsi3.S
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ */
+
+#include <linux/linkage.h>
+
+SYM_FUNC_START(__hexagon_divsi3)
+        {
+                p0 = cmp.gt(r0,#-1)
+                p1 = cmp.gt(r1,#-1)
+                r3:2 = vabsw(r1:0)
+        }
+        {
+                p3 = xor(p0,p1)
+                r4 = sub(r2,r3)
+                r6 = cl0(r2)
+                p0 = cmp.gtu(r3,r2)
+        }
+        {
+                r0 = mux(p3,#-1,#1)
+                r7 = cl0(r3)
+                p1 = cmp.gtu(r3,r4)
+        }
+        {
+                r0 = mux(p0,#0,r0)
+                p0 = or(p0,p1)
+                if (p0.new) jumpr:nt r31
+                r6 = sub(r7,r6)
+        }
+        {
+                r7 = r6
+                r5:4 = combine(#1,r3)
+                r6 = add(#1,lsr(r6,#1))
+                p0 = cmp.gtu(r6,#4)
+        }
+        {
+                r5:4 = vaslw(r5:4,r7)
+                if (!p0) r6 = #3
+        }
+        {
+                loop0(1f,r6)
+                r7:6 = vlsrw(r5:4,#1)
+                r1:0 = #0
+        }
+        .falign
+1:
+        {
+                r5:4 = vlsrw(r5:4,#2)
+                if (!p0.new) r0 = add(r0,r5)
+                if (!p0.new) r2 = sub(r2,r4)
+                p0 = cmp.gtu(r4,r2)
+        }
+        {
+                r7:6 = vlsrw(r7:6,#2)
+                if (!p0.new) r0 = add(r0,r7)
+                if (!p0.new) r2 = sub(r2,r6)
+                p0 = cmp.gtu(r6,r2)
+        }:endloop0
+        {
+                if (!p0) r0 = add(r0,r7)
+        }
+        {
+                if (p3) r0 = sub(r1,r0)
+                jumpr r31
+        }
+SYM_FUNC_END(__hexagon_divsi3)
diff --git a/arch/hexagon/lib/memcpy_likely_aligned.S b/arch/hexagon/lib/memcpy_likely_aligned.S
new file mode 100644
index 000000000000..6a541fb90a54
--- /dev/null
+++ b/arch/hexagon/lib/memcpy_likely_aligned.S
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ */
+
+#include <linux/linkage.h>
+
+SYM_FUNC_START(__hexagon_memcpy_likely_aligned_min32bytes_mult8bytes)
+        {
+                p0 = bitsclr(r1,#7)
+                p0 = bitsclr(r0,#7)
+                if (p0.new) r5:4 = memd(r1)
+                if (p0.new) r7:6 = memd(r1+#8)
+        }
+        {
+                if (!p0) jump:nt .Lmemcpy_call
+                if (p0) r9:8 = memd(r1+#16)
+                if (p0) r11:10 = memd(r1+#24)
+                p0 = cmp.gtu(r2,#64)
+        }
+        {
+                if (p0) jump:nt .Lmemcpy_call
+                if (!p0) memd(r0) = r5:4
+                if (!p0) memd(r0+#8) = r7:6
+                p0 = cmp.gtu(r2,#32)
+        }
+        {
+                p1 = cmp.gtu(r2,#40)
+                p2 = cmp.gtu(r2,#48)
+                if (p0) r13:12 = memd(r1+#32)
+                if (p1.new) r15:14 = memd(r1+#40)
+        }
+        {
+                memd(r0+#16) = r9:8
+                memd(r0+#24) = r11:10
+        }
+        {
+                if (p0) memd(r0+#32) = r13:12
+                if (p1) memd(r0+#40) = r15:14
+                if (!p2) jumpr:t r31
+        }
+        {
+                p0 = cmp.gtu(r2,#56)
+                r5:4 = memd(r1+#48)
+                if (p0.new) r7:6 = memd(r1+#56)
+        }
+        {
+                memd(r0+#48) = r5:4
+                if (p0) memd(r0+#56) = r7:6
+                jumpr r31
+        }
+
+.Lmemcpy_call:
+        jump memcpy
+
+SYM_FUNC_END(__hexagon_memcpy_likely_aligned_min32bytes_mult8bytes)
diff --git a/arch/hexagon/lib/modsi3.S b/arch/hexagon/lib/modsi3.S
new file mode 100644
index 000000000000..9ea1c86efac2
--- /dev/null
+++ b/arch/hexagon/lib/modsi3.S
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ */
+
+#include <linux/linkage.h>
+
+SYM_FUNC_START(__hexagon_modsi3)
+        {
+                p2 = cmp.ge(r0,#0)
+                r2 = abs(r0)
+                r1 = abs(r1)
+        }
+        {
+                r3 = cl0(r2)
+                r4 = cl0(r1)
+                p0 = cmp.gtu(r1,r2)
+        }
+        {
+                r3 = sub(r4,r3)
+                if (p0) jumpr r31
+        }
+        {
+                p1 = cmp.eq(r3,#0)
+                loop0(1f,r3)
+                r0 = r2
+                r2 = lsl(r1,r3)
+        }
+        .falign
+1:
+        {
+                p0 = cmp.gtu(r2,r0)
+                if (!p0.new) r0 = sub(r0,r2)
+                r2 = lsr(r2,#1)
+                if (p1) r1 = #0
+        }:endloop0
+        {
+                p0 = cmp.gtu(r2,r0)
+                if (!p0.new) r0 = sub(r0,r1)
+                if (p2) jumpr r31
+        }
+        {
+                r0 = neg(r0)
+                jumpr r31
+        }
+SYM_FUNC_END(__hexagon_modsi3)
diff --git a/arch/hexagon/lib/udivsi3.S b/arch/hexagon/lib/udivsi3.S
new file mode 100644
index 000000000000..477f27b9311c
--- /dev/null
+++ b/arch/hexagon/lib/udivsi3.S
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ */
+
+#include <linux/linkage.h>
+
+SYM_FUNC_START(__hexagon_udivsi3)
+        {
+                r2 = cl0(r0)
+                r3 = cl0(r1)
+                r5:4 = combine(#1,#0)
+                p0 = cmp.gtu(r1,r0)
+        }
+        {
+                r6 = sub(r3,r2)
+                r4 = r1
+                r1:0 = combine(r0,r4)
+                if (p0) jumpr r31
+        }
+        {
+                r3:2 = vlslw(r5:4,r6)
+                loop0(1f,r6)
+        }
+        .falign
+1:
+        {
+                p0 = cmp.gtu(r2,r1)
+                if (!p0.new) r1 = sub(r1,r2)
+                if (!p0.new) r0 = add(r0,r3)
+                r3:2 = vlsrw(r3:2,#1)
+        }:endloop0
+        {
+                p0 = cmp.gtu(r2,r1)
+                if (!p0.new) r0 = add(r0,r3)
+                jumpr r31
+        }
+SYM_FUNC_END(__hexagon_udivsi3)
diff --git a/arch/hexagon/lib/umodsi3.S b/arch/hexagon/lib/umodsi3.S
new file mode 100644
index 000000000000..280bf06a55e7
--- /dev/null
+++ b/arch/hexagon/lib/umodsi3.S
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ */
+
+#include <linux/linkage.h>
+
+SYM_FUNC_START(__hexagon_umodsi3)
+        {
+                r2 = cl0(r0)
+                r3 = cl0(r1)
+                p0 = cmp.gtu(r1,r0)
+        }
+        {
+                r2 = sub(r3,r2)
+                if (p0) jumpr r31
+        }
+        {
+                loop0(1f,r2)
+                p1 = cmp.eq(r2,#0)
+                r2 = lsl(r1,r2)
+        }
+        .falign
+1:
+        {
+                p0 = cmp.gtu(r2,r0)
+                if (!p0.new) r0 = sub(r0,r2)
+                r2 = lsr(r2,#1)
+                if (p1) r1 = #0
+        }:endloop0
+        {
+                p0 = cmp.gtu(r2,r0)
+                if (!p0.new) r0 = sub(r0,r1)
+                jumpr r31
+        }
+SYM_FUNC_END(__hexagon_umodsi3)
diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 7196fa9047e6..426787f4b2ae 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -79,13 +79,38 @@ mt76_free_pending_txwi(struct mt76_dev *dev)
 	local_bh_enable();
 }
 
+static void
+mt76_dma_sync_idx(struct mt76_dev *dev, struct mt76_queue *q)
+{
+	writel(q->desc_dma, &q->regs->desc_base);
+	writel(q->ndesc, &q->regs->ring_size);
+	q->head = readl(&q->regs->dma_idx);
+	q->tail = q->head;
+}
+
+static void
+mt76_dma_queue_reset(struct mt76_dev *dev, struct mt76_queue *q)
+{
+	int i;
+
+	if (!q)
+		return;
+
+	/* clear descriptors */
+	for (i = 0; i < q->ndesc; i++)
+		q->desc[i].ctrl = cpu_to_le32(MT_DMA_CTL_DMA_DONE);
+
+	writel(0, &q->regs->cpu_idx);
+	writel(0, &q->regs->dma_idx);
+	mt76_dma_sync_idx(dev, q);
+}
+
 static int
 mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q,
 		     int idx, int n_desc, int bufsize,
 		     u32 ring_base)
 {
 	int size;
-	int i;
 
 	spin_lock_init(&q->lock);
 	spin_lock_init(&q->cleanup_lock);
@@ -105,14 +130,7 @@ mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q,
 	if (!q->entry)
 		return -ENOMEM;
 
-	/* clear descriptors */
-	for (i = 0; i < q->ndesc; i++)
-		q->desc[i].ctrl = cpu_to_le32(MT_DMA_CTL_DMA_DONE);
-
-	writel(q->desc_dma, &q->regs->desc_base);
-	writel(0, &q->regs->cpu_idx);
-	writel(0, &q->regs->dma_idx);
-	writel(q->ndesc, &q->regs->ring_size);
+	mt76_dma_queue_reset(dev, q);
 
 	return 0;
 }
@@ -201,15 +219,6 @@ mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 	memset(e, 0, sizeof(*e));
 }
 
-static void
-mt76_dma_sync_idx(struct mt76_dev *dev, struct mt76_queue *q)
-{
-	writel(q->desc_dma, &q->regs->desc_base);
-	writel(q->ndesc, &q->regs->ring_size);
-	q->head = readl(&q->regs->dma_idx);
-	q->tail = q->head;
-}
-
 static void
 mt76_dma_kick_queue(struct mt76_dev *dev, struct mt76_queue *q)
 {
@@ -640,9 +649,11 @@ mt76_dma_init(struct mt76_dev *dev)
 static const struct mt76_queue_ops mt76_dma_ops = {
 	.init = mt76_dma_init,
 	.alloc = mt76_dma_alloc_queue,
+	.reset_q = mt76_dma_queue_reset,
 	.tx_queue_skb_raw = mt76_dma_tx_queue_skb_raw,
 	.tx_queue_skb = mt76_dma_tx_queue_skb,
 	.tx_cleanup = mt76_dma_tx_cleanup,
+	.rx_cleanup = mt76_dma_rx_cleanup,
 	.rx_reset = mt76_dma_rx_reset,
 	.kick = mt76_dma_kick_queue,
 };
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 36a430f09f64..967fe3e11d94 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -190,7 +190,11 @@ struct mt76_queue_ops {
 	void (*tx_cleanup)(struct mt76_dev *dev, struct mt76_queue *q,
 			   bool flush);
 
+	void (*rx_cleanup)(struct mt76_dev *dev, struct mt76_queue *q);
+
 	void (*kick)(struct mt76_dev *dev, struct mt76_queue *q);
+
+	void (*reset_q)(struct mt76_dev *dev, struct mt76_queue *q);
 };
 
 enum mt76_wcid_flags {
@@ -784,8 +788,10 @@ static inline u16 mt76_rev(struct mt76_dev *dev)
 #define mt76_tx_queue_skb_raw(dev, ...)	(dev)->mt76.queue_ops->tx_queue_skb_raw(&((dev)->mt76), __VA_ARGS__)
 #define mt76_tx_queue_skb(dev, ...)	(dev)->mt76.queue_ops->tx_queue_skb(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_rx_reset(dev, ...)	(dev)->mt76.queue_ops->rx_reset(&((dev)->mt76), __VA_ARGS__)
-#define mt76_queue_tx_cleanup(dev, ...)        (dev)->mt76.queue_ops->tx_cleanup(&((dev)->mt76), __VA_ARGS__)
+#define mt76_queue_tx_cleanup(dev, ...)	(dev)->mt76.queue_ops->tx_cleanup(&((dev)->mt76), __VA_ARGS__)
+#define mt76_queue_rx_cleanup(dev, ...)	(dev)->mt76.queue_ops->rx_cleanup(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_kick(dev, ...)	(dev)->mt76.queue_ops->kick(&((dev)->mt76), __VA_ARGS__)
+#define mt76_queue_reset(dev, ...)	(dev)->mt76.queue_ops->reset_q(&((dev)->mt76), __VA_ARGS__)
 
 #define mt76_for_each_q_rx(dev, i)	\
 	for (i = 0; i < ARRAY_SIZE((dev)->q_rx) && \
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index c0001e38fcce..a0797cec136e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -142,7 +142,7 @@ mt7921_mac_init_band(struct mt7921_dev *dev, u8 band)
 	mt76_clear(dev, MT_DMA_DCR0(band), MT_DMA_DCR0_RXD_G5_EN);
 }
 
-static void mt7921_mac_init(struct mt7921_dev *dev)
+void mt7921_mac_init(struct mt7921_dev *dev)
 {
 	int i;
 
@@ -232,7 +232,6 @@ int mt7921_register_device(struct mt7921_dev *dev)
 	INIT_LIST_HEAD(&dev->sta_poll_list);
 	spin_lock_init(&dev->sta_poll_lock);
 
-	init_waitqueue_head(&dev->reset_wait);
 	INIT_WORK(&dev->reset_work, mt7921_mac_reset_work);
 
 	ret = mt7921_init_hardware(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index a6d2a25b3495..ce4eae7f1e44 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1184,43 +1184,77 @@ void mt7921_update_channel(struct mt76_dev *mdev)
 	mt76_connac_power_save_sched(&dev->mphy, &dev->pm);
 }
 
-static bool
-mt7921_wait_reset_state(struct mt7921_dev *dev, u32 state)
+static int
+mt7921_wfsys_reset(struct mt7921_dev *dev)
 {
-	bool ret;
+	mt76_set(dev, 0x70002600, BIT(0));
+	msleep(200);
+	mt76_clear(dev, 0x70002600, BIT(0));
 
-	ret = wait_event_timeout(dev->reset_wait,
-				 (READ_ONCE(dev->reset_state) & state),
-				 MT7921_RESET_TIMEOUT);
-
-	WARN(!ret, "Timeout waiting for MCU reset state %x\n", state);
-	return ret;
+	return __mt76_poll_msec(&dev->mt76, MT_WFSYS_SW_RST_B,
+				WFSYS_SW_INIT_DONE, WFSYS_SW_INIT_DONE, 500);
 }
 
 static void
-mt7921_dma_reset(struct mt7921_phy *phy)
+mt7921_dma_reset(struct mt7921_dev *dev)
 {
-	struct mt7921_dev *dev = phy->dev;
 	int i;
 
+	/* reset */
+	mt76_clear(dev, MT_WFDMA0_RST,
+		   MT_WFDMA0_RST_DMASHDL_ALL_RST | MT_WFDMA0_RST_LOGIC_RST);
+
+	mt76_set(dev, MT_WFDMA0_RST,
+		 MT_WFDMA0_RST_DMASHDL_ALL_RST | MT_WFDMA0_RST_LOGIC_RST);
+
+	/* disable WFDMA0 */
 	mt76_clear(dev, MT_WFDMA0_GLO_CFG,
-		   MT_WFDMA0_GLO_CFG_TX_DMA_EN | MT_WFDMA0_GLO_CFG_RX_DMA_EN);
+		   MT_WFDMA0_GLO_CFG_TX_DMA_EN | MT_WFDMA0_GLO_CFG_RX_DMA_EN |
+		   MT_WFDMA0_GLO_CFG_CSR_DISP_BASE_PTR_CHAIN_EN |
+		   MT_WFDMA0_GLO_CFG_OMIT_TX_INFO |
+		   MT_WFDMA0_GLO_CFG_OMIT_RX_INFO |
+		   MT_WFDMA0_GLO_CFG_OMIT_RX_INFO_PFET2);
 
-	usleep_range(1000, 2000);
+	mt76_poll(dev, MT_WFDMA0_GLO_CFG,
+		  MT_WFDMA0_GLO_CFG_TX_DMA_BUSY |
+		  MT_WFDMA0_GLO_CFG_RX_DMA_BUSY, 0, 1000);
 
-	mt76_queue_tx_cleanup(dev, dev->mt76.q_mcu[MT_MCUQ_WA], true);
+	/* reset hw queues */
 	for (i = 0; i < __MT_TXQ_MAX; i++)
-		mt76_queue_tx_cleanup(dev, phy->mt76->q_tx[i], true);
+		mt76_queue_reset(dev, dev->mphy.q_tx[i]);
 
-	mt76_for_each_q_rx(&dev->mt76, i) {
-		mt76_queue_rx_reset(dev, i);
-	}
+	for (i = 0; i < __MT_MCUQ_MAX; i++)
+		mt76_queue_reset(dev, dev->mt76.q_mcu[i]);
 
-	/* re-init prefetch settings after reset */
+	mt76_for_each_q_rx(&dev->mt76, i)
+		mt76_queue_reset(dev, &dev->mt76.q_rx[i]);
+
+	/* configure perfetch settings */
 	mt7921_dma_prefetch(dev);
 
+	/* reset dma idx */
+	mt76_wr(dev, MT_WFDMA0_RST_DTX_PTR, ~0);
+
+	/* configure delay interrupt */
+	mt76_wr(dev, MT_WFDMA0_PRI_DLY_INT_CFG0, 0);
+
+	mt76_set(dev, MT_WFDMA0_GLO_CFG,
+		 MT_WFDMA0_GLO_CFG_TX_WB_DDONE |
+		 MT_WFDMA0_GLO_CFG_FIFO_LITTLE_ENDIAN |
+		 MT_WFDMA0_GLO_CFG_CLK_GAT_DIS |
+		 MT_WFDMA0_GLO_CFG_OMIT_TX_INFO |
+		 MT_WFDMA0_GLO_CFG_CSR_DISP_BASE_PTR_CHAIN_EN |
+		 MT_WFDMA0_GLO_CFG_OMIT_RX_INFO_PFET2);
+
 	mt76_set(dev, MT_WFDMA0_GLO_CFG,
 		 MT_WFDMA0_GLO_CFG_TX_DMA_EN | MT_WFDMA0_GLO_CFG_RX_DMA_EN);
+
+	mt76_set(dev, 0x54000120, BIT(1));
+
+	/* enable interrupts for TX/RX rings */
+	mt7921_irq_enable(dev,
+			  MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
+			  MT_INT_MCU_CMD);
 }
 
 void mt7921_tx_token_put(struct mt7921_dev *dev)
@@ -1244,71 +1278,133 @@ void mt7921_tx_token_put(struct mt7921_dev *dev)
 	idr_destroy(&dev->token);
 }
 
-/* system error recovery */
-void mt7921_mac_reset_work(struct work_struct *work)
+static void
+mt7921_vif_connect_iter(void *priv, u8 *mac,
+			struct ieee80211_vif *vif)
 {
-	struct mt7921_dev *dev;
+	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
+	struct mt7921_dev *dev = mvif->phy->dev;
 
-	dev = container_of(work, struct mt7921_dev, reset_work);
+	ieee80211_disconnect(vif, true);
 
-	if (!(READ_ONCE(dev->reset_state) & MT_MCU_CMD_STOP_DMA))
-		return;
+	mt76_connac_mcu_uni_add_dev(&dev->mphy, vif, &mvif->sta.wcid, true);
+	mt7921_mcu_set_tx(dev, vif);
+}
 
-	ieee80211_stop_queues(mt76_hw(dev));
+static int
+mt7921_mac_reset(struct mt7921_dev *dev)
+{
+	int i, err;
+
+	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
+
+	mt76_wr(dev, MT_WFDMA0_HOST_INT_ENA, 0);
+	mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0x0);
 
-	set_bit(MT76_RESET, &dev->mphy.state);
 	set_bit(MT76_MCU_RESET, &dev->mphy.state);
 	wake_up(&dev->mt76.mcu.wait);
-	cancel_delayed_work_sync(&dev->mphy.mac_work);
+	skb_queue_purge(&dev->mt76.mcu.res_q);
 
-	/* lock/unlock all queues to ensure that no tx is pending */
 	mt76_txq_schedule_all(&dev->mphy);
 
 	mt76_worker_disable(&dev->mt76.tx_worker);
-	napi_disable(&dev->mt76.napi[0]);
-	napi_disable(&dev->mt76.napi[1]);
-	napi_disable(&dev->mt76.napi[2]);
+	napi_disable(&dev->mt76.napi[MT_RXQ_MAIN]);
+	napi_disable(&dev->mt76.napi[MT_RXQ_MCU]);
+	napi_disable(&dev->mt76.napi[MT_RXQ_MCU_WA]);
 	napi_disable(&dev->mt76.tx_napi);
 
-	mt7921_mutex_acquire(dev);
-
-	mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_DMA_STOPPED);
-
 	mt7921_tx_token_put(dev);
 	idr_init(&dev->token);
 
-	if (mt7921_wait_reset_state(dev, MT_MCU_CMD_RESET_DONE)) {
-		mt7921_dma_reset(&dev->phy);
+	/* clean up hw queues */
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.phy.q_tx); i++)
+		mt76_queue_tx_cleanup(dev, dev->mphy.q_tx[i], true);
 
-		mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_DMA_INIT);
-		mt7921_wait_reset_state(dev, MT_MCU_CMD_RECOVERY_DONE);
-	}
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.q_mcu); i++)
+		mt76_queue_tx_cleanup(dev, dev->mt76.q_mcu[i], true);
 
-	clear_bit(MT76_MCU_RESET, &dev->mphy.state);
-	clear_bit(MT76_RESET, &dev->mphy.state);
+	mt76_for_each_q_rx(&dev->mt76, i)
+		mt76_queue_rx_cleanup(dev, &dev->mt76.q_rx[i]);
+
+	mt7921_wfsys_reset(dev);
+	mt7921_dma_reset(dev);
+
+	mt76_for_each_q_rx(&dev->mt76, i) {
+		mt76_queue_rx_reset(dev, i);
+		napi_enable(&dev->mt76.napi[i]);
+		napi_schedule(&dev->mt76.napi[i]);
+	}
 
-	mt76_worker_enable(&dev->mt76.tx_worker);
 	napi_enable(&dev->mt76.tx_napi);
 	napi_schedule(&dev->mt76.tx_napi);
+	mt76_worker_enable(&dev->mt76.tx_worker);
 
-	napi_enable(&dev->mt76.napi[0]);
-	napi_schedule(&dev->mt76.napi[0]);
+	clear_bit(MT76_MCU_RESET, &dev->mphy.state);
 
-	napi_enable(&dev->mt76.napi[1]);
-	napi_schedule(&dev->mt76.napi[1]);
+	mt76_wr(dev, MT_WFDMA0_HOST_INT_ENA, 0);
+	mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0xff);
+	mt7921_irq_enable(dev,
+			  MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
+			  MT_INT_MCU_CMD);
 
-	napi_enable(&dev->mt76.napi[2]);
-	napi_schedule(&dev->mt76.napi[2]);
+	err = mt7921_run_firmware(dev);
+	if (err)
+		return err;
 
-	ieee80211_wake_queues(mt76_hw(dev));
+	err = mt7921_mcu_set_eeprom(dev);
+	if (err)
+		return err;
 
-	mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_RESET_DONE);
-	mt7921_wait_reset_state(dev, MT_MCU_CMD_NORMAL_STATE);
+	mt7921_mac_init(dev);
+	return __mt7921_start(&dev->phy);
+}
 
-	mt7921_mutex_release(dev);
+/* system error recovery */
+void mt7921_mac_reset_work(struct work_struct *work)
+{
+	struct ieee80211_hw *hw;
+	struct mt7921_dev *dev;
+	int i;
 
-	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mphy.mac_work,
-				     MT7921_WATCHDOG_TIME);
+	dev = container_of(work, struct mt7921_dev, reset_work);
+	hw = mt76_hw(dev);
+
+	dev_err(dev->mt76.dev, "chip reset\n");
+	ieee80211_stop_queues(hw);
+
+	cancel_delayed_work_sync(&dev->mphy.mac_work);
+	cancel_delayed_work_sync(&dev->pm.ps_work);
+	cancel_work_sync(&dev->pm.wake_work);
+
+	mutex_lock(&dev->mt76.mutex);
+	for (i = 0; i < 10; i++) {
+		if (!mt7921_mac_reset(dev))
+			break;
+	}
+	mutex_unlock(&dev->mt76.mutex);
+
+	if (i == 10)
+		dev_err(dev->mt76.dev, "chip reset failed\n");
+
+	if (test_and_clear_bit(MT76_HW_SCANNING, &dev->mphy.state)) {
+		struct cfg80211_scan_info info = {
+			.aborted = true,
+		};
+
+		ieee80211_scan_completed(dev->mphy.hw, &info);
+	}
+
+	ieee80211_wake_queues(hw);
+	ieee80211_iterate_active_interfaces(hw,
+					    IEEE80211_IFACE_ITER_RESUME_ALL,
+					    mt7921_vif_connect_iter, 0);
+}
+
+void mt7921_reset(struct mt76_dev *mdev)
+{
+	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
+
+	queue_work(dev->mt76.wq, &dev->reset_work);
 }
 
 static void
@@ -1505,4 +1601,5 @@ void mt7921_coredump_work(struct work_struct *work)
 	}
 	dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ,
 		      GFP_KERNEL);
+	mt7921_reset(&dev->mt76);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 2c781b6f89e5..c6e8857067a3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -168,28 +168,44 @@ void mt7921_set_stream_he_caps(struct mt7921_phy *phy)
 	}
 }
 
-static int mt7921_start(struct ieee80211_hw *hw)
+int __mt7921_start(struct mt7921_phy *phy)
 {
-	struct mt7921_dev *dev = mt7921_hw_dev(hw);
-	struct mt7921_phy *phy = mt7921_hw_phy(hw);
+	struct mt76_phy *mphy = phy->mt76;
+	int err;
 
-	mt7921_mutex_acquire(dev);
+	err = mt76_connac_mcu_set_mac_enable(mphy->dev, 0, true, false);
+	if (err)
+		return err;
 
-	mt76_connac_mcu_set_mac_enable(&dev->mt76, 0, true, false);
-	mt76_connac_mcu_set_channel_domain(phy->mt76);
+	err = mt76_connac_mcu_set_channel_domain(mphy);
+	if (err)
+		return err;
+
+	err = mt7921_mcu_set_chan_info(phy, MCU_EXT_CMD_SET_RX_PATH);
+	if (err)
+		return err;
 
-	mt7921_mcu_set_chan_info(phy, MCU_EXT_CMD_SET_RX_PATH);
 	mt7921_mac_reset_counters(phy);
-	set_bit(MT76_STATE_RUNNING, &phy->mt76->state);
+	set_bit(MT76_STATE_RUNNING, &mphy->state);
 
-	ieee80211_queue_delayed_work(hw, &phy->mt76->mac_work,
+	ieee80211_queue_delayed_work(mphy->hw, &mphy->mac_work,
 				     MT7921_WATCHDOG_TIME);
 
-	mt7921_mutex_release(dev);
-
 	return 0;
 }
 
+static int mt7921_start(struct ieee80211_hw *hw)
+{
+	struct mt7921_phy *phy = mt7921_hw_phy(hw);
+	int err;
+
+	mt7921_mutex_acquire(phy->dev);
+	err = __mt7921_start(phy);
+	mt7921_mutex_release(phy->dev);
+
+	return err;
+}
+
 static void mt7921_stop(struct ieee80211_hw *hw)
 {
 	struct mt7921_dev *dev = mt7921_hw_dev(hw);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index be88c9f5637a..a4f070cd78fd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -161,6 +161,8 @@ mt7921_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 	if (!skb) {
 		dev_err(mdev->dev, "Message %d (seq %d) timeout\n",
 			cmd, seq);
+		mt7921_reset(mdev);
+
 		return -ETIMEDOUT;
 	}
 
@@ -927,6 +929,24 @@ int mt7921_mcu_fw_log_2_host(struct mt7921_dev *dev, u8 ctrl)
 				 sizeof(data), false);
 }
 
+int mt7921_run_firmware(struct mt7921_dev *dev)
+{
+	int err;
+
+	err = mt7921_driver_own(dev);
+	if (err)
+		return err;
+
+	err = mt7921_load_firmware(dev);
+	if (err)
+		return err;
+
+	set_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state);
+	mt7921_mcu_fw_log_2_host(dev, 1);
+
+	return 0;
+}
+
 int mt7921_mcu_init(struct mt7921_dev *dev)
 {
 	static const struct mt76_mcu_ops mt7921_mcu_ops = {
@@ -935,22 +955,10 @@ int mt7921_mcu_init(struct mt7921_dev *dev)
 		.mcu_parse_response = mt7921_mcu_parse_response,
 		.mcu_restart = mt7921_mcu_restart,
 	};
-	int ret;
 
 	dev->mt76.mcu_ops = &mt7921_mcu_ops;
 
-	ret = mt7921_driver_own(dev);
-	if (ret)
-		return ret;
-
-	ret = mt7921_load_firmware(dev);
-	if (ret)
-		return ret;
-
-	set_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state);
-	mt7921_mcu_fw_log_2_host(dev, 1);
-
-	return 0;
+	return mt7921_run_firmware(dev);
 }
 
 void mt7921_mcu_exit(struct mt7921_dev *dev)
@@ -1263,6 +1271,7 @@ int mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
 
 	if (i == MT7921_DRV_OWN_RETRY_COUNT) {
 		dev_err(dev->mt76.dev, "driver own failed\n");
+		mt7921_reset(&dev->mt76);
 		return -EIO;
 	}
 
@@ -1289,6 +1298,7 @@ int mt7921_mcu_fw_pmctrl(struct mt7921_dev *dev)
 
 	if (i == MT7921_DRV_OWN_RETRY_COUNT) {
 		dev_err(dev->mt76.dev, "firmware own failed\n");
+		mt7921_reset(&dev->mt76);
 		return -EIO;
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 25a1a6acb6ba..bc26639695bd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -151,8 +151,6 @@ struct mt7921_dev {
 
 	struct work_struct init_work;
 	struct work_struct reset_work;
-	wait_queue_head_t reset_wait;
-	u32 reset_state;
 
 	struct list_head sta_poll_list;
 	spinlock_t sta_poll_lock;
@@ -209,6 +207,7 @@ extern struct pci_driver mt7921_pci_driver;
 
 u32 mt7921_reg_map(struct mt7921_dev *dev, u32 addr);
 
+int __mt7921_start(struct mt7921_phy *phy);
 int mt7921_register_device(struct mt7921_dev *dev);
 void mt7921_unregister_device(struct mt7921_dev *dev);
 int mt7921_eeprom_init(struct mt7921_dev *dev);
@@ -220,6 +219,7 @@ void mt7921_eeprom_init_sku(struct mt7921_dev *dev);
 int mt7921_dma_init(struct mt7921_dev *dev);
 void mt7921_dma_prefetch(struct mt7921_dev *dev);
 void mt7921_dma_cleanup(struct mt7921_dev *dev);
+int mt7921_run_firmware(struct mt7921_dev *dev);
 int mt7921_mcu_init(struct mt7921_dev *dev);
 int mt7921_mcu_add_bss_info(struct mt7921_phy *phy,
 			    struct ieee80211_vif *vif, int enable);
@@ -281,6 +281,7 @@ mt7921_l1_rmw(struct mt7921_dev *dev, u32 addr, u32 mask, u32 val)
 #define mt7921_l1_set(dev, addr, val)	mt7921_l1_rmw(dev, addr, 0, val)
 #define mt7921_l1_clear(dev, addr, val)	mt7921_l1_rmw(dev, addr, val, 0)
 
+void mt7921_mac_init(struct mt7921_dev *dev);
 bool mt7921_mac_wtbl_update(struct mt7921_dev *dev, int idx, u32 mask);
 void mt7921_mac_reset_counters(struct mt7921_phy *phy);
 void mt7921_mac_write_txwi(struct mt7921_dev *dev, __le32 *txwi,
@@ -296,6 +297,7 @@ void mt7921_mac_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta);
 void mt7921_mac_work(struct work_struct *work);
 void mt7921_mac_reset_work(struct work_struct *work);
+void mt7921_reset(struct mt76_dev *mdev);
 int mt7921_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 			  enum mt76_txq_id qid, struct mt76_wcid *wcid,
 			  struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
index 73878d3e2495..50249e9571a6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
@@ -418,6 +418,10 @@
 #define PCIE_LPCR_HOST_CLR_OWN		BIT(1)
 #define PCIE_LPCR_HOST_SET_OWN		BIT(0)
 
+#define MT_WFSYS_SW_RST_B		0x18000140
+#define WFSYS_SW_RST_B			BIT(0)
+#define WFSYS_SW_INIT_DONE		BIT(4)
+
 #define MT_CONN_ON_MISC			0x7c0600f0
 #define MT_TOP_MISC2_FW_N9_RDY		GENMASK(1, 0)
 

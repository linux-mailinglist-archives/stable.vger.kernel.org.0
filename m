Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB6B2017D2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388118AbgFSQoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:44:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388470AbgFSOnW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:43:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A66321582;
        Fri, 19 Jun 2020 14:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577802;
        bh=Z2mSk/qCvpI46ERhuMl3WEC01xeCmk5UXtIGeuXct2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOCc0js1NoB14lFiJGtQZr0/rOls/qNqwYVygOkEkax/7m9qb7UVzrTFJ6h57FqN+
         W84o/4fk2k1MXcZk1Id5gZRk18Qn0VhEYiK4JRuLvLnk1bWjd34tPFjnmppiKaDlbR
         cKImNtkk3NVMkIelC7KIp7qn8NJzyKapeENcud2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finn Thain <fthain@telegraphics.com.au>,
        Joshua Thompson <funaho@jurai.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        Stan Johnson <userm57@yahoo.com>
Subject: [PATCH 4.9 088/128] m68k: mac: Dont call via_flush_cache() on Mac IIfx
Date:   Fri, 19 Jun 2020 16:33:02 +0200
Message-Id: <20200619141624.800587128@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit bcc44f6b74106b31f0b0408b70305a40360d63b7 ]

There is no VIA2 chip on the Mac IIfx, so don't call via_flush_cache().
This avoids a boot crash which appeared in v5.4.

printk: console [ttyS0] enabled
printk: bootconsole [debug0] disabled
printk: bootconsole [debug0] disabled
Calibrating delay loop... 9.61 BogoMIPS (lpj=48064)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
devtmpfs: initialized
random: get_random_u32 called from bucket_table_alloc.isra.27+0x68/0x194 with crng_init=0
clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
futex hash table entries: 256 (order: -1, 3072 bytes, linear)
NET: Registered protocol family 16
Data read fault at 0x00000000 in Super Data (pc=0x8a6a)
BAD KERNEL BUSERR
Oops: 00000000
Modules linked in:
PC: [<00008a6a>] via_flush_cache+0x12/0x2c
SR: 2700  SP: 01c1fe3c  a2: 01c24000
d0: 00001119    d1: 0000000c    d2: 00012000    d3: 0000000f
d4: 01c06840    d5: 00033b92    a0: 00000000    a1: 00000000
Process swapper (pid: 1, task=01c24000)
Frame format=B ssw=0755 isc=0200 isb=fff7 daddr=00000000 dobuf=01c1fed0
baddr=00008a6e dibuf=0000004e ver=f
Stack from 01c1fec4:
        01c1fed0 00007d7e 00010080 01c1fedc 0000792e 00000001 01c1fef4 00006b40
        01c80000 00040000 00000006 00000003 01c1ff1c 004a545e 004ff200 00040000
        00000000 00000003 01c06840 00033b92 004a5410 004b6c88 01c1ff84 000021e2
        00000073 00000003 01c06840 00033b92 0038507a 004bb094 004b6ca8 004b6c88
        004b6ca4 004b6c88 000021ae 00020002 00000000 01c0685d 00000000 01c1ffb4
        0049f938 00409c85 01c06840 0045bd40 00000073 00000002 00000002 00000000
Call Trace: [<00007d7e>] mac_cache_card_flush+0x12/0x1c
 [<00010080>] fix_dnrm+0x2/0x18
 [<0000792e>] cache_push+0x46/0x5a
 [<00006b40>] arch_dma_prep_coherent+0x60/0x6e
 [<00040000>] switched_to_dl+0x76/0xd0
 [<004a545e>] dma_atomic_pool_init+0x4e/0x188
 [<00040000>] switched_to_dl+0x76/0xd0
 [<00033b92>] parse_args+0x0/0x370
 [<004a5410>] dma_atomic_pool_init+0x0/0x188
 [<000021e2>] do_one_initcall+0x34/0x1be
 [<00033b92>] parse_args+0x0/0x370
 [<0038507a>] strcpy+0x0/0x1e
 [<000021ae>] do_one_initcall+0x0/0x1be
 [<00020002>] do_proc_dointvec_conv+0x54/0x74
 [<0049f938>] kernel_init_freeable+0x126/0x190
 [<0049f94c>] kernel_init_freeable+0x13a/0x190
 [<004a5410>] dma_atomic_pool_init+0x0/0x188
 [<00041798>] complete+0x0/0x3c
 [<000b9b0c>] kfree+0x0/0x20a
 [<0038df98>] schedule+0x0/0xd0
 [<0038d604>] kernel_init+0x0/0xda
 [<0038d610>] kernel_init+0xc/0xda
 [<0038d604>] kernel_init+0x0/0xda
 [<00002d38>] ret_from_kernel_thread+0xc/0x14
Code: 0000 2079 0048 10da 2279 0048 10c8 d3c8 <1011> 0200 fff7 1280 d1f9 0048 10c8 1010 0000 0008 1080 4e5e 4e75 4e56 0000 2039
Disabling lock debugging due to kernel taint
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Thanks to Stan Johnson for capturing the console log and running git
bisect.

Git bisect said commit 8e3a68fb55e0 ("dma-mapping: make
dma_atomic_pool_init self-contained") is the first "bad" commit. I don't
know why. Perhaps mach_l2_flush first became reachable with that commit.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-and-tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Cc: Joshua Thompson <funaho@jurai.org>
Link: https://lore.kernel.org/r/b8bbeef197d6b3898e82ed0d231ad08f575a4b34.1589949122.git.fthain@telegraphics.com.au
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/mac_via.h |  1 +
 arch/m68k/mac/config.c          | 21 ++-------------------
 arch/m68k/mac/via.c             |  6 +++++-
 3 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/arch/m68k/include/asm/mac_via.h b/arch/m68k/include/asm/mac_via.h
index 53c632c85b03..dff6db19ae4d 100644
--- a/arch/m68k/include/asm/mac_via.h
+++ b/arch/m68k/include/asm/mac_via.h
@@ -256,6 +256,7 @@ extern int rbv_present,via_alt_mapping;
 
 struct irq_desc;
 
+extern void via_l2_flush(int writeback);
 extern void via_register_interrupts(void);
 extern void via_irq_enable(int);
 extern void via_irq_disable(int);
diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index e46895316eb0..dcf18e1ca0bb 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -61,7 +61,6 @@ extern void iop_preinit(void);
 extern void iop_init(void);
 extern void via_init(void);
 extern void via_init_clock(irq_handler_t func);
-extern void via_flush_cache(void);
 extern void oss_init(void);
 extern void psc_init(void);
 extern void baboon_init(void);
@@ -132,21 +131,6 @@ int __init mac_parse_bootinfo(const struct bi_record *record)
 	return unknown;
 }
 
-/*
- * Flip into 24bit mode for an instant - flushes the L2 cache card. We
- * have to disable interrupts for this. Our IRQ handlers will crap
- * themselves if they take an IRQ in 24bit mode!
- */
-
-static void mac_cache_card_flush(int writeback)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	via_flush_cache();
-	local_irq_restore(flags);
-}
-
 void __init config_mac(void)
 {
 	if (!MACH_IS_MAC)
@@ -179,9 +163,8 @@ void __init config_mac(void)
 	 * not.
 	 */
 
-	if (macintosh_config->ident == MAC_MODEL_IICI
-	    || macintosh_config->ident == MAC_MODEL_IIFX)
-		mach_l2_flush = mac_cache_card_flush;
+	if (macintosh_config->ident == MAC_MODEL_IICI)
+		mach_l2_flush = via_l2_flush;
 }
 
 
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index a435aced6e43..35382c1b563f 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -299,10 +299,14 @@ void via_debug_dump(void)
  * the system into 24-bit mode for an instant.
  */
 
-void via_flush_cache(void)
+void via_l2_flush(int writeback)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	via2[gBufB] &= ~VIA2B_vMode32;
 	via2[gBufB] |= VIA2B_vMode32;
+	local_irq_restore(flags);
 }
 
 /*
-- 
2.25.1




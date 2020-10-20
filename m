Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B4D28DFB2
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 13:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgJNLQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 07:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgJNLQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 07:16:28 -0400
X-Greylist: delayed 374 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 14 Oct 2020 04:16:28 PDT
Received: from orcam.me.uk (unknown [IPv6:2001:4190:8020::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29D8FC061755
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 04:16:28 -0700 (PDT)
Received: from bugs.linux-mips.org (eddie.linux-mips.org [IPv6:2a01:4f8:201:92aa::3])
        by orcam.me.uk (Postfix) with ESMTPS id E01212BE086;
        Wed, 14 Oct 2020 12:10:10 +0100 (BST)
Date:   Wed, 14 Oct 2020 12:10:09 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@linux-mips.org>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
cc:     Serge Semin <fancer.lancer@gmail.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] MIPS: DEC: Restore bootmem reservation for firmware working
 memory area
Message-ID: <alpine.LFD.2.21.2010141123010.866917@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix a crash on DEC platforms starting with:

VFS: Mounted root (nfs filesystem) on device 0:11.
Freeing unused PROM memory: 124k freed
BUG: Bad page state in process swapper  pfn:00001
page:(ptrval) refcount:0 mapcount:-128 mapping:00000000 index:0x1 pfn:0x1
flags: 0x0()
raw: 00000000 00000100 00000122 00000000 00000001 00000000 ffffff7f 00000000
page dumped because: nonzero mapcount
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Not tainted 5.9.0-00858-g865c50e1d279 #1
Stack : 8065dc48 0000000b 8065d2b8 9bc27dcc 80645bfc 9bc259a4 806a1b97 80703124
        80710000 8064a900 00000001 80099574 806b116c 1000ec00 9bc27d88 806a6f30
        00000000 00000000 80645bfc 00000000 31232039 80706ba4 2e392e35 8039f348
        2d383538 00000070 0000000a 35363867 00000000 806c2830 80710000 806b0000
        80710000 8064a900 00000001 81000000 00000000 00000000 8035af2c 80700000
        ...
Call Trace:
[<8004bc5c>] show_stack+0x34/0x104
[<8015675c>] bad_page+0xfc/0x128
[<80157714>] free_pcppages_bulk+0x1f4/0x5dc
[<801591cc>] free_unref_page+0xc0/0x130
[<8015cb04>] free_reserved_area+0x144/0x1d8
[<805abd78>] kernel_init+0x20/0x100
[<80046070>] ret_from_kernel_thread+0x14/0x1c
Disabling lock debugging due to kernel taint

caused by an attempt to free bootmem space that as from commit 
b93ddc4f9156 ("mips: Reserve memory for the kernel image resources") has 
not been anymore reserved due to the removal of generic MIPS arch code 
that used to reserve all the memory from the beginning of RAM up to the 
kernel load address.

This memory does need to be reserved on DEC platforms however as it is 
used by REX firmware as working area, as per the TURBOchannel firmware 
specification[1]:

Table 2-2  REX Memory Regions
-------------------------------------------------------------------------
        Starting        Ending
Region  Address         Address         Use
-------------------------------------------------------------------------
0       0xa0000000      0xa000ffff      Restart block, exception vectors,
                                        REX stack and bss
1       0xa0010000      0xa0017fff      Keyboard or tty drivers

2       0xa0018000      0xa001f3ff 1)   CRT driver

3       0xa0020000      0xa002ffff      boot, cnfg, init and t objects

4       0xa0020000      0xa002ffff      64KB scratch space
-------------------------------------------------------------------------
1) Note that the last 3 Kbytes of region 2 are reserved for backward
compatibility with previous system software.
-------------------------------------------------------------------------

(this table uses KSEG2 unmapped virtual addresses, which in the MIPS 
architecture are offset from physical addresses by a fixed value of 
0xa0000000 and therefore the regions referred do correspond to the 
beginning of the physical address space) and we call into the firmware 
on several occasions throughout the bootstrap process.  It is believed 
that pre-REX firmware used with non-TURBOchannel DEC platforms has the 
same requirements, as hinted by note #1 cited.

Recreate the discarded reservation then, in DEC platform code, removing 
the crash.

References:

[1] "TURBOchannel Firmware Specification", On-line version, 
    EK-TCAAD-FS-004, Digital Equipment Corporation, January 1993, 
    Chapter 2 "System Module Firmware", p. 2-5

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Fixes: b93ddc4f9156 ("mips: Reserve memory for the kernel image resources")
Cc: stable@vger.kernel.org # v5.2+
---
 arch/mips/dec/setup.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

linux-dec-prom-memblock-reserve.diff
Index: linux-3maxp/arch/mips/dec/setup.c
===================================================================
--- linux-3maxp.orig/arch/mips/dec/setup.c
+++ linux-3maxp/arch/mips/dec/setup.c
@@ -6,7 +6,7 @@
  * for more details.
  *
  * Copyright (C) 1998 Harald Koerfgen
- * Copyright (C) 2000, 2001, 2002, 2003, 2005  Maciej W. Rozycki
+ * Copyright (C) 2000, 2001, 2002, 2003, 2005, 2020  Maciej W. Rozycki
  */
 #include <linux/console.h>
 #include <linux/export.h>
@@ -15,6 +15,7 @@
 #include <linux/ioport.h>
 #include <linux/irq.h>
 #include <linux/irqnr.h>
+#include <linux/memblock.h>
 #include <linux/param.h>
 #include <linux/percpu-defs.h>
 #include <linux/sched.h>
@@ -22,6 +23,7 @@
 #include <linux/types.h>
 #include <linux/pm.h>
 
+#include <asm/addrspace.h>
 #include <asm/bootinfo.h>
 #include <asm/cpu.h>
 #include <asm/cpu-features.h>
@@ -29,7 +31,9 @@
 #include <asm/irq.h>
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
+#include <asm/page.h>
 #include <asm/reboot.h>
+#include <asm/sections.h>
 #include <asm/time.h>
 #include <asm/traps.h>
 #include <asm/wbflush.h>
@@ -146,6 +150,9 @@ void __init plat_mem_setup(void)
 
 	ioport_resource.start = ~0UL;
 	ioport_resource.end = 0UL;
+
+	/* Stay away from the firmware working memory area for now. */
+	memblock_reserve(PHYS_OFFSET, __pa_symbol(&_text));
 }
 
 /*

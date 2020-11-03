Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10102A5687
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731845AbgKCV24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:28:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730234AbgKCU7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:59:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9063722453;
        Tue,  3 Nov 2020 20:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437163;
        bh=MfROGCovpGH4jfCoV5G/MmWYAWWM3w4Qwj9K0Z7rKLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q965ogNfWMYW6BPXtULCZGiOVgQIQTn1K8DTWOKFWk0+qc218FqezF3anYBROAHTC
         rtOLDktI51u4f32rofF3Hm5CuZGoCP/XOABzf/ls7ogrJdOAcvie4YjDIFZ/4TjW8g
         wZX1VOIaUo/SuczYh0dI7x6lW9547xAF6s6TBzEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.4 156/214] MIPS: DEC: Restore bootmem reservation for firmware working memory area
Date:   Tue,  3 Nov 2020 21:36:44 +0100
Message-Id: <20201103203305.408602237@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@linux-mips.org>

commit cf3af0a4d3b62ab48e0b90180ea161d0f5d4953f upstream.

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

caused by an attempt to free bootmem space that as from
commit b93ddc4f9156 ("mips: Reserve memory for the kernel image resources")
has not been anymore reserved due to the removal of generic MIPS arch code
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


[1] "TURBOchannel Firmware Specification", On-line version,
    EK-TCAAD-FS-004, Digital Equipment Corporation, January 1993,
    Chapter 2 "System Module Firmware", p. 2-5

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Fixes: b93ddc4f9156 ("mips: Reserve memory for the kernel image resources")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

---
 arch/mips/dec/setup.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/mips/dec/setup.c
+++ b/arch/mips/dec/setup.c
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
@@ -166,6 +170,9 @@ void __init plat_mem_setup(void)
 
 	ioport_resource.start = ~0UL;
 	ioport_resource.end = 0UL;
+
+	/* Stay away from the firmware working memory area for now. */
+	memblock_reserve(PHYS_OFFSET, __pa_symbol(&_text) - PHYS_OFFSET);
 }
 
 /*



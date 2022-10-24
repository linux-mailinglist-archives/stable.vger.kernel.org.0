Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB6360AA8E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiJXNfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbiJXNdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:33:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A5D2DF0;
        Mon, 24 Oct 2022 05:34:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6F0561257;
        Mon, 24 Oct 2022 12:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAAAC433D6;
        Mon, 24 Oct 2022 12:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614883;
        bh=SlhrStvTgx3c8uQcJilQEUVVLx+czvdw+gcouuyd9TU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tn/N+npbSBRnJ65F0S6YGjqkjqbh00CjpJWIGzOrUz/ucFeepPqxeKlvx5Qxph7BH
         d9G9Vtj8Jj0Q4iwkQhg6abgyO+8qq1jWJ/wqdmRS7KPmyuUQ03c70o+Na3eDxIuKcu
         e34U40SycptvUDedGv/CZ75jvKUw1aS7MWtloPdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 040/530] RISC-V: Make port I/O string accessors actually work
Date:   Mon, 24 Oct 2022 13:26:24 +0200
Message-Id: <20221024113046.831949752@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 9cc205e3c17d5716da7ebb7fa0c985555e95d009 upstream.

Fix port I/O string accessors such as `insb', `outsb', etc. which use
the physical PCI port I/O address rather than the corresponding memory
mapping to get at the requested location, which in turn breaks at least
accesses made by our parport driver to a PCIe parallel port such as:

PCI parallel port detected: 1415:c118, I/O at 0x1000(0x1008), IRQ 20
parport0: PC-style at 0x1000 (0x1008), irq 20, using FIFO [PCSPP,TRISTATE,COMPAT,EPP,ECP]

causing a memory access fault:

Unable to handle kernel access to user memory without uaccess routines at virtual address 0000000000001008
Oops [#1]
Modules linked in:
CPU: 1 PID: 350 Comm: cat Not tainted 6.0.0-rc2-00283-g10d4879f9ef0-dirty #23
Hardware name: SiFive HiFive Unmatched A00 (DT)
epc : parport_pc_fifo_write_block_pio+0x266/0x416
 ra : parport_pc_fifo_write_block_pio+0xb4/0x416
epc : ffffffff80542c3e ra : ffffffff80542a8c sp : ffffffd88899fc60
 gp : ffffffff80fa2700 tp : ffffffd882b1e900 t0 : ffffffd883d0b000
 t1 : ffffffffff000002 t2 : 4646393043330a38 s0 : ffffffd88899fcf0
 s1 : 0000000000001000 a0 : 0000000000000010 a1 : 0000000000000000
 a2 : ffffffd883d0a010 a3 : 0000000000000023 a4 : 00000000ffff8fbb
 a5 : ffffffd883d0a001 a6 : 0000000100000000 a7 : ffffffc800000000
 s2 : ffffffffff000002 s3 : ffffffff80d28880 s4 : ffffffff80fa1f50
 s5 : 0000000000001008 s6 : 0000000000000008 s7 : ffffffd883d0a000
 s8 : 0004000000000000 s9 : ffffffff80dc1d80 s10: ffffffd8807e4000
 s11: 0000000000000000 t3 : 00000000000000ff t4 : 393044410a303930
 t5 : 0000000000001000 t6 : 0000000000040000
status: 0000000200000120 badaddr: 0000000000001008 cause: 000000000000000f
[<ffffffff80543212>] parport_pc_compat_write_block_pio+0xfe/0x200
[<ffffffff8053bbc0>] parport_write+0x46/0xf8
[<ffffffff8050530e>] lp_write+0x158/0x2d2
[<ffffffff80185716>] vfs_write+0x8e/0x2c2
[<ffffffff80185a74>] ksys_write+0x52/0xc2
[<ffffffff80185af2>] sys_write+0xe/0x16
[<ffffffff80003770>] ret_from_syscall+0x0/0x2
---[ end trace 0000000000000000 ]---

For simplicity address the problem by adding PCI_IOBASE to the physical
address requested in the respective wrapper macros only, observing that
the raw accessors such as `__insb', `__outsb', etc. are not supposed to
be used other than by said macros.  Remove the cast to `long' that is no
longer needed on `addr' now that it is used as an offset from PCI_IOBASE
and add parentheses around `addr' needed for predictable evaluation in
macro expansion.  No need to make said adjustments in separate changes
given that current code is gravely broken and does not ever work.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: fab957c11efe2 ("RISC-V: Atomic and Locking Code")
Cc: stable@vger.kernel.org # v4.15+
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2209220223080.29493@angie.orcam.me.uk
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/io.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/riscv/include/asm/io.h
+++ b/arch/riscv/include/asm/io.h
@@ -101,9 +101,9 @@ __io_reads_ins(reads, u32, l, __io_br(),
 __io_reads_ins(ins,  u8, b, __io_pbr(), __io_par(addr))
 __io_reads_ins(ins, u16, w, __io_pbr(), __io_par(addr))
 __io_reads_ins(ins, u32, l, __io_pbr(), __io_par(addr))
-#define insb(addr, buffer, count) __insb((void __iomem *)(long)addr, buffer, count)
-#define insw(addr, buffer, count) __insw((void __iomem *)(long)addr, buffer, count)
-#define insl(addr, buffer, count) __insl((void __iomem *)(long)addr, buffer, count)
+#define insb(addr, buffer, count) __insb(PCI_IOBASE + (addr), buffer, count)
+#define insw(addr, buffer, count) __insw(PCI_IOBASE + (addr), buffer, count)
+#define insl(addr, buffer, count) __insl(PCI_IOBASE + (addr), buffer, count)
 
 __io_writes_outs(writes,  u8, b, __io_bw(), __io_aw())
 __io_writes_outs(writes, u16, w, __io_bw(), __io_aw())
@@ -115,22 +115,22 @@ __io_writes_outs(writes, u32, l, __io_bw
 __io_writes_outs(outs,  u8, b, __io_pbw(), __io_paw())
 __io_writes_outs(outs, u16, w, __io_pbw(), __io_paw())
 __io_writes_outs(outs, u32, l, __io_pbw(), __io_paw())
-#define outsb(addr, buffer, count) __outsb((void __iomem *)(long)addr, buffer, count)
-#define outsw(addr, buffer, count) __outsw((void __iomem *)(long)addr, buffer, count)
-#define outsl(addr, buffer, count) __outsl((void __iomem *)(long)addr, buffer, count)
+#define outsb(addr, buffer, count) __outsb(PCI_IOBASE + (addr), buffer, count)
+#define outsw(addr, buffer, count) __outsw(PCI_IOBASE + (addr), buffer, count)
+#define outsl(addr, buffer, count) __outsl(PCI_IOBASE + (addr), buffer, count)
 
 #ifdef CONFIG_64BIT
 __io_reads_ins(reads, u64, q, __io_br(), __io_ar(addr))
 #define readsq(addr, buffer, count) __readsq(addr, buffer, count)
 
 __io_reads_ins(ins, u64, q, __io_pbr(), __io_par(addr))
-#define insq(addr, buffer, count) __insq((void __iomem *)addr, buffer, count)
+#define insq(addr, buffer, count) __insq(PCI_IOBASE + (addr), buffer, count)
 
 __io_writes_outs(writes, u64, q, __io_bw(), __io_aw())
 #define writesq(addr, buffer, count) __writesq(addr, buffer, count)
 
 __io_writes_outs(outs, u64, q, __io_pbr(), __io_paw())
-#define outsq(addr, buffer, count) __outsq((void __iomem *)addr, buffer, count)
+#define outsq(addr, buffer, count) __outsq(PCI_IOBASE + (addr), buffer, count)
 #endif
 
 #include <asm-generic/io.h>



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873D2344362
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhCVMuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232835AbhCVMsR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:48:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60791619DC;
        Mon, 22 Mar 2021 12:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417068;
        bh=csEDHaGiGz95T2hFcn+4A2Nc9jq13tmY/hcqh1IU/Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YUm0g63Z5u+Axd61rRB/Pbqm7CMs9YxBQNkuB4ZhnxbdhYB/u23BLrggk0c4uBP5l
         J2HSMYWsj8UllGqUkXjpwjF3Oyn1TVYaDBG9TQ14tFssqLmALMWoZ15QfpC/TWOjoB
         8wVZPFQwVmz0uLFgCj1W+e7dA7U3sMFs0Cxk3x20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicolas Boichat <drinkcat@chromium.org>
Subject: [PATCH 4.19 06/43] lkdtm: dont move ctors to .rodata
Date:   Mon, 22 Mar 2021 13:28:20 +0100
Message-Id: <20210322121920.142955352@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121919.936671417@linuxfoundation.org>
References: <20210322121919.936671417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Boichat <drinkcat@chromium.org>

From: Mark Rutland <mark.rutland@arm.com>

commit 3f618ab3323407ee4c6a6734a37eb6e9663ebfb9 upstream.

When building with KASAN and LKDTM, clang may implictly generate an
asan.module_ctor function in the LKDTM rodata object. The Makefile moves
the lkdtm_rodata_do_nothing() function into .rodata by renaming the
file's .text section to .rodata, and consequently also moves the ctor
function into .rodata, leading to a boot time crash (splat below) when
the ctor is invoked by do_ctors().

Let's prevent this by marking the function as noinstr rather than
notrace, and renaming the file's .noinstr.text to .rodata. Marking the
function as noinstr will prevent tracing and kprobes, and will inhibit
any undesireable compiler instrumentation.

The ctor function (if any) will be placed in .text and will work
correctly.

Example splat before this patch is applied:

[    0.916359] Unable to handle kernel execute from non-executable memory at virtual address ffffa0006b60f5ac
[    0.922088] Mem abort info:
[    0.922828]   ESR = 0x8600000e
[    0.923635]   EC = 0x21: IABT (current EL), IL = 32 bits
[    0.925036]   SET = 0, FnV = 0
[    0.925838]   EA = 0, S1PTW = 0
[    0.926714] swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000000427b3000
[    0.928489] [ffffa0006b60f5ac] pgd=000000023ffff003, p4d=000000023ffff003, pud=000000023fffe003, pmd=0068000042000f01
[    0.931330] Internal error: Oops: 8600000e [#1] PREEMPT SMP
[    0.932806] Modules linked in:
[    0.933617] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.10.0-rc7 #2
[    0.935620] Hardware name: linux,dummy-virt (DT)
[    0.936924] pstate: 40400005 (nZcv daif +PAN -UAO -TCO BTYPE=--)
[    0.938609] pc : asan.module_ctor+0x0/0x14
[    0.939759] lr : do_basic_setup+0x4c/0x70
[    0.940889] sp : ffff27b600177e30
[    0.941815] x29: ffff27b600177e30 x28: 0000000000000000
[    0.943306] x27: 0000000000000000 x26: 0000000000000000
[    0.944803] x25: 0000000000000000 x24: 0000000000000000
[    0.946289] x23: 0000000000000001 x22: 0000000000000000
[    0.947777] x21: ffffa0006bf4a890 x20: ffffa0006befb6c0
[    0.949271] x19: ffffa0006bef9358 x18: 0000000000000068
[    0.950756] x17: fffffffffffffff8 x16: 0000000000000000
[    0.952246] x15: 0000000000000000 x14: 0000000000000000
[    0.953734] x13: 00000000838a16d5 x12: 0000000000000001
[    0.955223] x11: ffff94000da74041 x10: dfffa00000000000
[    0.956715] x9 : 0000000000000000 x8 : ffffa0006b60f5ac
[    0.958199] x7 : f9f9f9f9f9f9f9f9 x6 : 000000000000003f
[    0.959683] x5 : 0000000000000040 x4 : 0000000000000000
[    0.961178] x3 : ffffa0006bdc15a0 x2 : 0000000000000005
[    0.962662] x1 : 00000000000000f9 x0 : ffffa0006bef9350
[    0.964155] Call trace:
[    0.964844]  asan.module_ctor+0x0/0x14
[    0.965895]  kernel_init_freeable+0x158/0x198
[    0.967115]  kernel_init+0x14/0x19c
[    0.968104]  ret_from_fork+0x10/0x30
[    0.969110] Code: 00000003 00000000 00000000 00000000 (00000000)
[    0.970815] ---[ end trace b5339784e20d015c ]---

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20201207170533.10738-1-mark.rutland@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

(no changes since v1)

 drivers/misc/lkdtm/Makefile |    2 +-
 drivers/misc/lkdtm/rodata.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -13,7 +13,7 @@ KCOV_INSTRUMENT_rodata.o	:= n
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_rodata_objcopy.o	:= \
-			--rename-section .text=.rodata,alloc,readonly,load
+			--rename-section .noinstr.text=.rodata,alloc,readonly,load
 targets += rodata.o rodata_objcopy.o
 $(obj)/rodata_objcopy.o: $(obj)/rodata.o FORCE
 	$(call if_changed,objcopy)
--- a/drivers/misc/lkdtm/rodata.c
+++ b/drivers/misc/lkdtm/rodata.c
@@ -5,7 +5,7 @@
  */
 #include "lkdtm.h"
 
-void notrace lkdtm_rodata_do_nothing(void)
+void noinstr lkdtm_rodata_do_nothing(void)
 {
 	/* Does nothing. We just want an architecture agnostic "return". */
 }



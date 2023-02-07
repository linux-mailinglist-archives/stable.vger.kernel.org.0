Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8D568D12B
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 09:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjBGIB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 03:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjBGIB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 03:01:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E21B367CA
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 00:01:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AF0F61204
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 08:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20237C433D2;
        Tue,  7 Feb 2023 08:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675756872;
        bh=x0R8KhTLUoO8CkejbGXYa3ImxphYEkMChMOeIENOy9o=;
        h=Subject:To:Cc:From:Date:From;
        b=O6X5kDd3GfHM9R5fQzzP997LWggfmUlhTH5fj4mvBhCgGAgJBKtOUsLWJOd2QtpwB
         adDQhDLIaDdTP3XACo2TTdMY9rqoqtiEEiG28+TUpQ8La+dYcWxEW3eQ30gn8CKjVc
         qF4+FVleFE2Frps9Of3rqgfCdRB0D15gfitHX974=
Subject: FAILED: patch "[PATCH] riscv: Fix build with CONFIG_CC_OPTIMIZE_FOR_SIZE=y" failed to apply to 6.1-stable tree
To:     samuel@sholland.org, conor.dooley@microchip.com,
        palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 09:01:09 +0100
Message-ID: <167575686919491@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

0b1d60d6dd9e ("riscv: Fix build with CONFIG_CC_OPTIMIZE_FOR_SIZE=y")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0b1d60d6dd9e2e867cc6e4277d73ea5a7ff2d4d0 Mon Sep 17 00:00:00 2001
From: Samuel Holland <samuel@sholland.org>
Date: Thu, 22 Sep 2022 01:09:58 -0500
Subject: [PATCH] riscv: Fix build with CONFIG_CC_OPTIMIZE_FOR_SIZE=y

commit 8eb060e10185 ("arch/riscv: add Zihintpause support") broke
building with CONFIG_CC_OPTIMIZE_FOR_SIZE enabled (gcc 11.1.0):

  CC      arch/riscv/kernel/vdso/vgettimeofday.o
In file included from <command-line>:
./arch/riscv/include/asm/jump_label.h: In function 'cpu_relax':
././include/linux/compiler_types.h:285:33: warning: 'asm' operand 0 probably does not match constraints
  285 | #define asm_volatile_goto(x...) asm goto(x)
      |                                 ^~~
./arch/riscv/include/asm/jump_label.h:41:9: note: in expansion of macro 'asm_volatile_goto'
   41 |         asm_volatile_goto(
      |         ^~~~~~~~~~~~~~~~~
././include/linux/compiler_types.h:285:33: error: impossible constraint in 'asm'
  285 | #define asm_volatile_goto(x...) asm goto(x)
      |                                 ^~~
./arch/riscv/include/asm/jump_label.h:41:9: note: in expansion of macro 'asm_volatile_goto'
   41 |         asm_volatile_goto(
      |         ^~~~~~~~~~~~~~~~~
make[1]: *** [scripts/Makefile.build:249: arch/riscv/kernel/vdso/vgettimeofday.o] Error 1
make: *** [arch/riscv/Makefile:128: vdso_prepare] Error 2

Having a static branch in cpu_relax() is problematic because that
function is widely inlined, including in some quite complex functions
like in the VDSO. A quick measurement shows this static branch is
responsible by itself for around 40% of the jump table.

Drop the static branch, which ends up being the same number of
instructions anyway. If Zihintpause is supported, we trade the nop from
the static branch for a div. If Zihintpause is unsupported, we trade the
jump from the static branch for (what gets interpreted as) a nop.

Fixes: 8eb060e10185 ("arch/riscv: add Zihintpause support")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 3c8a5ca95c72..3bf10a8e665a 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -67,7 +67,6 @@ enum riscv_isa_ext_id {
  */
 enum riscv_isa_ext_key {
 	RISCV_ISA_EXT_KEY_FPU,		/* For 'F' and 'D' */
-	RISCV_ISA_EXT_KEY_ZIHINTPAUSE,
 	RISCV_ISA_EXT_KEY_MAX,
 };
 
@@ -87,8 +86,6 @@ static __always_inline int riscv_isa_ext2key(int num)
 		return RISCV_ISA_EXT_KEY_FPU;
 	case RISCV_ISA_EXT_d:
 		return RISCV_ISA_EXT_KEY_FPU;
-	case RISCV_ISA_EXT_ZIHINTPAUSE:
-		return RISCV_ISA_EXT_KEY_ZIHINTPAUSE;
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/riscv/include/asm/vdso/processor.h b/arch/riscv/include/asm/vdso/processor.h
index 1e4f8b4aef79..789bdb8211a2 100644
--- a/arch/riscv/include/asm/vdso/processor.h
+++ b/arch/riscv/include/asm/vdso/processor.h
@@ -4,30 +4,25 @@
 
 #ifndef __ASSEMBLY__
 
-#include <linux/jump_label.h>
 #include <asm/barrier.h>
-#include <asm/hwcap.h>
 
 static inline void cpu_relax(void)
 {
-	if (!static_branch_likely(&riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_ZIHINTPAUSE])) {
 #ifdef __riscv_muldiv
-		int dummy;
-		/* In lieu of a halt instruction, induce a long-latency stall. */
-		__asm__ __volatile__ ("div %0, %0, zero" : "=r" (dummy));
+	int dummy;
+	/* In lieu of a halt instruction, induce a long-latency stall. */
+	__asm__ __volatile__ ("div %0, %0, zero" : "=r" (dummy));
 #endif
-	} else {
-		/*
-		 * Reduce instruction retirement.
-		 * This assumes the PC changes.
-		 */
+	/*
+	 * Reduce instruction retirement.
+	 * This assumes the PC changes.
+	 */
 #ifdef __riscv_zihintpause
-		__asm__ __volatile__ ("pause");
+	__asm__ __volatile__ ("pause");
 #else
-		/* Encoding of the pause instruction */
-		__asm__ __volatile__ (".4byte 0x100000F");
+	/* Encoding of the pause instruction */
+	__asm__ __volatile__ (".4byte 0x100000F");
 #endif
-	}
 	barrier();
 }
 


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F69D6AE5CA
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbjCGQDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbjCGQCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:02:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E43B9B2D4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 08:00:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B1E661493
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AD7C433EF;
        Tue,  7 Mar 2023 16:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678204840;
        bh=8s2VNzpm/OzGu6ILbkN4syy2+L9myhxn5VJCspx7fPA=;
        h=Subject:To:Cc:From:Date:From;
        b=iEkKkvSVv33gSsf7pGtYxhy54ziQyNhf5X7FK2jKVtPIw2d6fvkiZ9mmYcqOiCMTA
         UGxs/O4Ju3PFU85E6ok/1OdBmvw78g+ePrkoIobuAxZAQz7G4lO/OnI+lTHNfjdrNJ
         raYZ9X+uqB5zqVTk6l7jht1Ylr4Rwpqsu98fzN9U=
Subject: FAILED: patch "[PATCH] RISC-V: take text_mutex during alternative patching" failed to apply to 6.1-stable tree
To:     conor.dooley@microchip.com, linux@roeck-us.net,
        palmer@rivosinc.com, samuel@sholland.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 17:00:38 +0100
Message-ID: <1678204838254140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 9493e6f3ce02f44c21aa19f3cbf3b9aa05479d06
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678204838254140@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

9493e6f3ce02 ("RISC-V: take text_mutex during alternative patching")
bfd6fc5d8014 ("riscv: Fix early alternative patching")
8d23e94a4433 ("riscv: switch to relative alternative entries")
4bf8860760d9 ("riscv: cpufeature: extend riscv_cpufeature_patch_func to all ISA extensions")
abcc445acdbe ("riscv: move riscv_noncoherent_supported() out of ZICBOM probe")
61a9b7129070 ("Merge patch series "Putting some basic order on isa extension lists"")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9493e6f3ce02f44c21aa19f3cbf3b9aa05479d06 Mon Sep 17 00:00:00 2001
From: Conor Dooley <conor.dooley@microchip.com>
Date: Sun, 12 Feb 2023 19:47:36 +0000
Subject: [PATCH] RISC-V: take text_mutex during alternative patching

Guenter reported a splat during boot, that Samuel pointed out was the
lockdep assertion failing in patch_insn_write():

WARNING: CPU: 0 PID: 0 at arch/riscv/kernel/patch.c:63 patch_insn_write+0x222/0x2f6
epc : patch_insn_write+0x222/0x2f6
 ra : patch_insn_write+0x21e/0x2f6
epc : ffffffff800068c6 ra : ffffffff800068c2 sp : ffffffff81803df0
 gp : ffffffff81a1ab78 tp : ffffffff81814f80 t0 : ffffffffffffe000
 t1 : 0000000000000001 t2 : 4c45203a76637369 s0 : ffffffff81803e40
 s1 : 0000000000000004 a0 : 0000000000000000 a1 : ffffffffffffffff
 a2 : 0000000000000004 a3 : 0000000000000000 a4 : 0000000000000001
 a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000052464e43
 s2 : ffffffff80b4889c s3 : 000000000000082c s4 : ffffffff80b48828
 s5 : 0000000000000828 s6 : ffffffff8131a0a0 s7 : 0000000000000fff
 s8 : 0000000008000200 s9 : ffffffff8131a520 s10: 0000000000000018
 s11: 000000000000000b t3 : 0000000000000001 t4 : 000000000000000d
 t5 : ffffffffd8180000 t6 : ffffffff81803bc8
status: 0000000200000100 badaddr: 0000000000000000 cause: 0000000000000003
[<ffffffff800068c6>] patch_insn_write+0x222/0x2f6
[<ffffffff80006a36>] patch_text_nosync+0xc/0x2a
[<ffffffff80003b86>] riscv_cpufeature_patch_func+0x52/0x98
[<ffffffff80003348>] _apply_alternatives+0x46/0x86
[<ffffffff80c02d36>] apply_boot_alternatives+0x3c/0xfa
[<ffffffff80c03ad8>] setup_arch+0x584/0x5b8
[<ffffffff80c0075a>] start_kernel+0xa2/0x8f8

This issue was exposed by 702e64550b12 ("riscv: fpu: switch has_fpu() to
riscv_has_extension_likely()"), as it is the patching in has_fpu() that
triggers the splats in Guenter's report.

Take the text_mutex before doing any code patching to satisfy lockdep.

Fixes: ff689fd21cb1 ("riscv: add RISC-V Svpbmt extension support")
Fixes: a35707c3d850 ("riscv: add memory-type errata for T-Head")
Fixes: 1a0e5dbd3723 ("riscv: sifive: Add SiFive alternative ports")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/all/20230212154333.GA3760469@roeck-us.net/
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Samuel Holland <samuel@sholland.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230212194735.491785-1-conor@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/errata/sifive/errata.c b/arch/riscv/errata/sifive/errata.c
index ef9a4eec0dba..da55cb247e89 100644
--- a/arch/riscv/errata/sifive/errata.c
+++ b/arch/riscv/errata/sifive/errata.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/memory.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/bug.h>
@@ -107,8 +108,10 @@ void __init_or_module sifive_errata_patch_func(struct alt_entry *begin,
 
 		tmp = (1U << alt->errata_id);
 		if (cpu_req_errata & tmp) {
+			mutex_lock(&text_mutex);
 			patch_text_nosync(ALT_OLD_PTR(alt), ALT_ALT_PTR(alt),
 					  alt->alt_len);
+			mutex_lock(&text_mutex);
 			cpu_apply_errata |= tmp;
 		}
 	}
diff --git a/arch/riscv/errata/thead/errata.c b/arch/riscv/errata/thead/errata.c
index 1dd90a5f86f0..3b96a06d3c54 100644
--- a/arch/riscv/errata/thead/errata.c
+++ b/arch/riscv/errata/thead/errata.c
@@ -5,6 +5,7 @@
 
 #include <linux/bug.h>
 #include <linux/kernel.h>
+#include <linux/memory.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
@@ -101,10 +102,13 @@ void __init_or_module thead_errata_patch_func(struct alt_entry *begin, struct al
 			altptr = ALT_ALT_PTR(alt);
 
 			/* On vm-alternatives, the mmu isn't running yet */
-			if (stage == RISCV_ALTERNATIVES_EARLY_BOOT)
+			if (stage == RISCV_ALTERNATIVES_EARLY_BOOT) {
 				memcpy(oldptr, altptr, alt->alt_len);
-			else
+			} else {
+				mutex_lock(&text_mutex);
 				patch_text_nosync(oldptr, altptr, alt->alt_len);
+				mutex_unlock(&text_mutex);
+			}
 		}
 	}
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 21fb567e1b22..59d58ee0f68d 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -10,6 +10,7 @@
 #include <linux/ctype.h>
 #include <linux/libfdt.h>
 #include <linux/log2.h>
+#include <linux/memory.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <asm/alternative.h>
@@ -292,8 +293,11 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
 
 		oldptr = ALT_OLD_PTR(alt);
 		altptr = ALT_ALT_PTR(alt);
+
+		mutex_lock(&text_mutex);
 		patch_text_nosync(oldptr, altptr, alt->alt_len);
 		riscv_alternative_fix_offsets(oldptr, alt->alt_len, oldptr - altptr);
+		mutex_unlock(&text_mutex);
 	}
 }
 #endif


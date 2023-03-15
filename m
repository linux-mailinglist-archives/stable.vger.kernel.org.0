Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533956BB35C
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbjCOMnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbjCOMna (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:43:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EAFA3B7A
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:42:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A3F9B81E0A
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF05BC433EF;
        Wed, 15 Mar 2023 12:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884115;
        bh=pCBr1gp1Lt4TOniMBhE+17n9OoubI3QD4cVa2z4Oaos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bP8hmUogs47IipdOd/Vev/CKIkI8Kep9lZFW3XxhCyjePwvNEsYM/1JjzMxKT7b+m
         2yGoJ5gHG6zVfeG8zeNkRQrY6uqesbay8ewqo5/8RdSfr7MwB2r3EiYeIo2Wv+uqQD
         vCX/myLiQyPT83ta1YXdSPulH8QoEB0IlewlV3NM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guenter Roeck <linux@roeck-us.net>,
        Conor Dooley <conor.dooley@microchip.com>,
        Samuel Holland <samuel@sholland.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 113/141] RISC-V: take text_mutex during alternative patching
Date:   Wed, 15 Mar 2023 13:13:36 +0100
Message-Id: <20230315115743.437505798@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9493e6f3ce02f44c21aa19f3cbf3b9aa05479d06 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/errata/sifive/errata.c | 3 +++
 arch/riscv/errata/thead/errata.c  | 8 ++++++--
 arch/riscv/kernel/cpufeature.c    | 6 +++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/errata/sifive/errata.c b/arch/riscv/errata/sifive/errata.c
index 1031038423e74..5b77d7310e391 100644
--- a/arch/riscv/errata/sifive/errata.c
+++ b/arch/riscv/errata/sifive/errata.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/memory.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/bug.h>
@@ -107,7 +108,9 @@ void __init_or_module sifive_errata_patch_func(struct alt_entry *begin,
 
 		tmp = (1U << alt->errata_id);
 		if (cpu_req_errata & tmp) {
+			mutex_lock(&text_mutex);
 			patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
+			mutex_lock(&text_mutex);
 			cpu_apply_errata |= tmp;
 		}
 	}
diff --git a/arch/riscv/errata/thead/errata.c b/arch/riscv/errata/thead/errata.c
index fac5742d1c1e6..9d71fe3d35c77 100644
--- a/arch/riscv/errata/thead/errata.c
+++ b/arch/riscv/errata/thead/errata.c
@@ -5,6 +5,7 @@
 
 #include <linux/bug.h>
 #include <linux/kernel.h>
+#include <linux/memory.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
@@ -97,11 +98,14 @@ void __init_or_module thead_errata_patch_func(struct alt_entry *begin, struct al
 		tmp = (1U << alt->errata_id);
 		if (cpu_req_errata & tmp) {
 			/* On vm-alternatives, the mmu isn't running yet */
-			if (stage == RISCV_ALTERNATIVES_EARLY_BOOT)
+			if (stage == RISCV_ALTERNATIVES_EARLY_BOOT) {
 				memcpy((void *)__pa_symbol(alt->old_ptr),
 				       (void *)__pa_symbol(alt->alt_ptr), alt->alt_len);
-			else
+			} else {
+				mutex_lock(&text_mutex);
 				patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
+				mutex_unlock(&text_mutex);
+			}
 		}
 	}
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 93e45560af307..5a82d5520a1fd 100644
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
@@ -339,8 +340,11 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
 		}
 
 		tmp = (1U << alt->errata_id);
-		if (cpu_req_feature & tmp)
+		if (cpu_req_feature & tmp) {
+			mutex_lock(&text_mutex);
 			patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
+			mutex_unlock(&text_mutex);
+		}
 	}
 }
 #endif
-- 
2.39.2




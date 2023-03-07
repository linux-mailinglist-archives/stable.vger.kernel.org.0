Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C518F6AE5CD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbjCGQDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjCGQDO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:03:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368018EA0C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 08:01:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 180C1B81920
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47219C433D2;
        Tue,  7 Mar 2023 16:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678204803;
        bh=Rnn3OHN6ijgWrK31hNRJfO5ZuuX+jaSTcBwemM5o2tg=;
        h=Subject:To:Cc:From:Date:From;
        b=K33MyNdW4NE2wv5iC5/MH+12P1/y4Rrf3p8JjpCIGSty5hCnHYL3fXw8KjQUYmCHI
         rnTIk3GjVyRjHpoKCZ+Pof4MFgtd1HnCaOml/YkUfADmKmvOVMe328jwu2KW6cPHsf
         Z718Y7VvJNqi4F7OcXMkoMl5648VXNRqiXV/dGQE=
Subject: FAILED: patch "[PATCH] riscv: Add header include guards to insn.h" failed to apply to 6.1-stable tree
To:     liaochang1@huawei.com, ajones@ventanamicro.com,
        conor.dooley@microchip.com, palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 17:00:00 +0100
Message-ID: <16782048001545@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 8ac6e619d9d51b3eb5bae817db8aa94e780a0db4
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16782048001545@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

8ac6e619d9d5 ("riscv: Add header include guards to insn.h")
47f05757d3d8 ("RISC-V: add helpers for handling immediates in U-type and I-type pairs")
c9c1af3f186a ("RISC-V: rename parse_asm.h to insn.h")
ec5f90877516 ("RISC-V: Move riscv_insn_is_* macros into a common header")
bf0cc402d7cd ("RISC-V: add prefix to all constants/macros in parse_asm.h")
a3775634f6da ("RISC-V: fix funct4 definition for c.jalr in parse_asm.h")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8ac6e619d9d51b3eb5bae817db8aa94e780a0db4 Mon Sep 17 00:00:00 2001
From: Liao Chang <liaochang1@huawei.com>
Date: Sun, 29 Jan 2023 17:42:42 +0800
Subject: [PATCH] riscv: Add header include guards to insn.h

Add header include guards to insn.h to prevent repeating declaration of
any identifiers in insn.h.

Fixes: edde5584c7ab ("riscv: Add SW single-step support for KDB")
Signed-off-by: Liao Chang <liaochang1@huawei.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Fixes: c9c1af3f186a ("RISC-V: rename parse_asm.h to insn.h")
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230129094242.282620-1-liaochang1@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
index 6567cd5ed6ba..8d5c84f2d5ef 100644
--- a/arch/riscv/include/asm/insn.h
+++ b/arch/riscv/include/asm/insn.h
@@ -3,6 +3,9 @@
  * Copyright (C) 2020 SiFive
  */
 
+#ifndef _ASM_RISCV_INSN_H
+#define _ASM_RISCV_INSN_H
+
 #include <linux/bits.h>
 
 #define RV_INSN_FUNCT3_MASK	GENMASK(14, 12)
@@ -375,3 +378,4 @@ static inline void riscv_insn_insert_utype_itype_imm(u32 *utype_insn, u32 *itype
 	*utype_insn |= (imm & RV_U_IMM_31_12_MASK) + ((imm & BIT(11)) << 1);
 	*itype_insn |= ((imm & RV_I_IMM_11_0_MASK) << RV_I_IMM_11_0_OPOFF);
 }
+#endif /* _ASM_RISCV_INSN_H */


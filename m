Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69FAC591A27
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 14:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239445AbiHMMlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 08:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239447AbiHMMlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 08:41:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB41811449
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 05:41:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64AF460D32
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 12:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA3CC433D6;
        Sat, 13 Aug 2022 12:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660394469;
        bh=ccjBRIQwg5IGx1RzTMLhIOgaWxR7PxYgXJa8SnRNsVA=;
        h=Subject:To:Cc:From:Date:From;
        b=sR1mAkrTukRykcv8Pdh6qh599EjLwC5OZb2rWTPGbJ6H9HzqgjxJBnPRrHFWcfmsD
         YaQygz8VkE2Na3fgFDLv5xhERmGh2b9vkHj2R5Re2VzstRy6vbILMGJvOWuZ+3i1f+
         PGH27MwjxWuYOWxmYpWAKIuWlArPENVhF2sVFe7I=
Subject: FAILED: patch "[PATCH] riscv: lib: uaccess: fix CSR_STATUS SR_SUM bit" failed to apply to 4.19-stable tree
To:     chenlifu@huawei.com, ben.dooks@codethink.co.uk, palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 14:40:57 +0200
Message-ID: <166039445731234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c08b4848f596fd95543197463b5162bd7bab2442 Mon Sep 17 00:00:00 2001
From: Chen Lifu <chenlifu@huawei.com>
Date: Wed, 15 Jun 2022 09:47:14 +0800
Subject: [PATCH] riscv: lib: uaccess: fix CSR_STATUS SR_SUM bit

Since commit 5d8544e2d007 ("RISC-V: Generic library routines and assembly")
and commit ebcbd75e3962 ("riscv: Fix the bug in memory access fixup code"),
if __clear_user and __copy_user return from an fixup branch,
CSR_STATUS SR_SUM bit will be set, it is a vulnerability, so that
S-mode memory accesses to pages that are accessible by U-mode will success.
Disable S-mode access to U-mode memory should clear SR_SUM bit.

Fixes: 5d8544e2d007 ("RISC-V: Generic library routines and assembly")
Fixes: ebcbd75e3962 ("riscv: Fix the bug in memory access fixup code")
Signed-off-by: Chen Lifu <chenlifu@huawei.com>
Reviewed-by: Ben Dooks <ben.dooks@codethink.co.uk>
Link: https://lore.kernel.org/r/20220615014714.1650349-1-chenlifu@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
index 8c475f4da308..ec486e5369d9 100644
--- a/arch/riscv/lib/uaccess.S
+++ b/arch/riscv/lib/uaccess.S
@@ -175,7 +175,7 @@ ENTRY(__asm_copy_from_user)
 	/* Exception fixup code */
 10:
 	/* Disable access to user memory */
-	csrs CSR_STATUS, t6
+	csrc CSR_STATUS, t6
 	mv a0, t5
 	ret
 ENDPROC(__asm_copy_to_user)
@@ -227,7 +227,7 @@ ENTRY(__clear_user)
 	/* Exception fixup code */
 11:
 	/* Disable access to user memory */
-	csrs CSR_STATUS, t6
+	csrc CSR_STATUS, t6
 	mv a0, a1
 	ret
 ENDPROC(__clear_user)


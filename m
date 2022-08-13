Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06FDA591A29
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 14:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239271AbiHMMlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 08:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239445AbiHMMlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 08:41:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A5B1144B
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 05:41:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01ACCB80025
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 12:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CB7C4314A;
        Sat, 13 Aug 2022 12:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660394458;
        bh=8B4ul0iY0CIZm9r/UyT84WClQgTHchuwHkShIidcyHg=;
        h=Subject:To:Cc:From:Date:From;
        b=Vv+V/rVP4t4RwfdWUed57QsuvDwdLAW+FIcvYMmdv9P+Aqkj3dJAlOKJnZxZo//Tu
         p0cAIhdDJGtl87qs1XLTECko0P5A1YEYEcLoP7DmP2Oq9AZm27+j7q0AN1jUtSVaEW
         we6Vm3gGDgwAkVeb9e7ljBGvmZpuCl7rkp4h4xHE=
Subject: FAILED: patch "[PATCH] riscv: lib: uaccess: fix CSR_STATUS SR_SUM bit" failed to apply to 5.15-stable tree
To:     chenlifu@huawei.com, ben.dooks@codethink.co.uk, palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 14:40:55 +0200
Message-ID: <1660394455235225@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
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


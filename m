Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAFB36AE5D1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjCGQEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjCGQDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:03:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F7B80918
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 08:01:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C54CCB81977
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3521C4339C;
        Tue,  7 Mar 2023 16:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678204821;
        bh=kOW19JHVNKShcOtGjPM4ucBgp/Uo0ugUK2s1X6PnR4A=;
        h=Subject:To:Cc:From:Date:From;
        b=CmqjxGY0MN8mt2Y2Rszn+grNUsE9mRFzMDgyKTBaMZuG9ixJ0qWaVZkrE1zPsTKoF
         6IWECHrLygKBgTwJ/Pj/n8bSXFA3I1hQaQWXB/lFIzVmVw9L//JUhqq63txrLxpaGl
         IIiNtIpkYRetj2O7izVogNH6M787x46CWLm/wYTI=
Subject: FAILED: patch "[PATCH] riscv: hwcap: Don't alphabetize ISA extension IDs" failed to apply to 6.2-stable tree
To:     ajones@ventanamicro.com, conor.dooley@microchip.com,
        palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 17:00:15 +0100
Message-ID: <167820481563250@kroah.com>
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


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x dac8bf14bb49aecd1de99ebb5498fa03152f2d40
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167820481563250@kroah.com' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

dac8bf14bb49 ("riscv: hwcap: Don't alphabetize ISA extension IDs")
9daca9a5b9ac ("Merge patch series "riscv: improve boot time isa extensions handling"")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dac8bf14bb49aecd1de99ebb5498fa03152f2d40 Mon Sep 17 00:00:00 2001
From: Andrew Jones <ajones@ventanamicro.com>
Date: Thu, 9 Feb 2023 13:36:36 +0100
Subject: [PATCH] riscv: hwcap: Don't alphabetize ISA extension IDs

While the comment above the ISA extension ID definitions says
"Entries are sorted alphabetically.", this stopped being good
advice with commit d8a3d8a75206 ("riscv: hwcap: make ISA extension
ids can be used in asm"), as we now use macros instead of enums.
Reshuffling defines is error-prone, so, since they don't need to be
in any particular order, change the advice to just adding new
extensions at the bottom. Also, take the opportunity to change
spaces to tabs, merge three comments into one, and move the base
and max defines into more logical locations wrt the ID definitions.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230209123636.123537-1-ajones@ventanamicro.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 831bebacb7fb..8f3994a7f0ca 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -24,29 +24,27 @@
 #define RISCV_ISA_EXT_u		('u' - 'a')
 
 /*
- * Increse this to higher value as kernel support more ISA extensions.
- */
-#define RISCV_ISA_EXT_MAX	64
-#define RISCV_ISA_EXT_NAME_LEN_MAX 32
-
-/* The base ID for multi-letter ISA extensions */
-#define RISCV_ISA_EXT_BASE 26
-
-/*
- * These macros represent the logical ID for each multi-letter RISC-V ISA extension.
- * The logical ID should start from RISCV_ISA_EXT_BASE and must not exceed
- * RISCV_ISA_EXT_MAX. 0-25 range is reserved for single letter
- * extensions while all the multi-letter extensions should define the next
- * available logical extension id.
- * Entries are sorted alphabetically.
+ * These macros represent the logical IDs of each multi-letter RISC-V ISA
+ * extension and are used in the ISA bitmap. The logical IDs start from
+ * RISCV_ISA_EXT_BASE, which allows the 0-25 range to be reserved for single
+ * letter extensions. The maximum, RISCV_ISA_EXT_MAX, is defined in order
+ * to allocate the bitmap and may be increased when necessary.
+ *
+ * New extensions should just be added to the bottom, rather than added
+ * alphabetically, in order to avoid unnecessary shuffling.
  */
-#define RISCV_ISA_EXT_SSCOFPMF         26
-#define RISCV_ISA_EXT_SSTC             27
-#define RISCV_ISA_EXT_SVINVAL          28
-#define RISCV_ISA_EXT_SVPBMT           29
-#define RISCV_ISA_EXT_ZBB              30
-#define RISCV_ISA_EXT_ZICBOM           31
-#define RISCV_ISA_EXT_ZIHINTPAUSE      32
+#define RISCV_ISA_EXT_BASE		26
+
+#define RISCV_ISA_EXT_SSCOFPMF		26
+#define RISCV_ISA_EXT_SSTC		27
+#define RISCV_ISA_EXT_SVINVAL		28
+#define RISCV_ISA_EXT_SVPBMT		29
+#define RISCV_ISA_EXT_ZBB		30
+#define RISCV_ISA_EXT_ZICBOM		31
+#define RISCV_ISA_EXT_ZIHINTPAUSE	32
+
+#define RISCV_ISA_EXT_MAX		64
+#define RISCV_ISA_EXT_NAME_LEN_MAX	32
 
 #ifndef __ASSEMBLY__
 


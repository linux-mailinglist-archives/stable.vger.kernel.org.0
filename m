Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9556B5405F5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347004AbiFGRcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347116AbiFGRaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2178D104C8F;
        Tue,  7 Jun 2022 10:25:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAB6CB81F38;
        Tue,  7 Jun 2022 17:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4B6C385A5;
        Tue,  7 Jun 2022 17:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622743;
        bh=z730l/hM8SDXiaGceR/3433bWesNUKQQorlQzL8FC/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKd/tHdIBrHR3dKuEtIa9XWUl2jLdVUKDq2yHw1iJCcsseoIcCOTlIbakngsXjm6Y
         DVugRvuoYW7Fw7hyWk8kHcN38PbJUo9dTm3tzzPpYTXZqj3YVAOeJH6dJWbPiAzAi8
         7xvLspOKg5k9OLRUe6OAF4fOzS8LvucfXnr+/t+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Borislav Petkov <bp@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/452] x86/pm: Fix false positive kmemleak report in msr_build_context()
Date:   Tue,  7 Jun 2022 19:00:25 +0200
Message-Id: <20220607164913.570471703@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

[ Upstream commit b0b592cf08367719e1d1ef07c9f136e8c17f7ec3 ]

Since

  e2a1256b17b1 ("x86/speculation: Restore speculation related MSRs during S3 resume")

kmemleak reports this issue:

  unreferenced object 0xffff888009cedc00 (size 256):
    comm "swapper/0", pid 1, jiffies 4294693823 (age 73.764s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 48 00 00 00 00 00 00 00  ........H.......
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      msr_build_context (include/linux/slab.h:621)
      pm_check_save_msr (arch/x86/power/cpu.c:520)
      do_one_initcall (init/main.c:1298)
      kernel_init_freeable (init/main.c:1370)
      kernel_init (init/main.c:1504)
      ret_from_fork (arch/x86/entry/entry_64.S:304)

Reproducer:

  - boot the VM with a debug kernel config (see
    https://github.com/multipath-tcp/mptcp_net-next/issues/268)
  - wait ~1 minute
  - start a kmemleak scan

The root cause here is alignment within the packed struct saved_context
(from suspend_64.h). Kmemleak only searches for pointers that are
aligned (see how pointers are scanned in kmemleak.c), but pahole shows
that the saved_msrs struct member and all members after it in the
structure are unaligned:

  struct saved_context {
    struct pt_regs             regs;                 /*     0   168 */
    /* --- cacheline 2 boundary (128 bytes) was 40 bytes ago --- */
    u16                        ds;                   /*   168     2 */

    ...

    u64                        misc_enable;          /*   232     8 */
    bool                       misc_enable_saved;    /*   240     1 */

   /* Note below odd offset values for the remainder of this struct */

    struct saved_msrs          saved_msrs;           /*   241    16 */
    /* --- cacheline 4 boundary (256 bytes) was 1 bytes ago --- */
    long unsigned int          efer;                 /*   257     8 */
    u16                        gdt_pad;              /*   265     2 */
    struct desc_ptr            gdt_desc;             /*   267    10 */
    u16                        idt_pad;              /*   277     2 */
    struct desc_ptr            idt;                  /*   279    10 */
    u16                        ldt;                  /*   289     2 */
    u16                        tss;                  /*   291     2 */
    long unsigned int          tr;                   /*   293     8 */
    long unsigned int          safety;               /*   301     8 */
    long unsigned int          return_address;       /*   309     8 */

    /* size: 317, cachelines: 5, members: 25 */
    /* last cacheline: 61 bytes */
  } __attribute__((__packed__));

Move misc_enable_saved to the end of the struct declaration so that
saved_msrs fits in before the cacheline 4 boundary.

The comment above the saved_context declaration says to fix wakeup_64.S
file and __save/__restore_processor_state() if the struct is modified:
it looks like all the accesses in wakeup_64.S are done through offsets
which are computed at build-time. Update that comment accordingly.

At the end, the false positive kmemleak report is due to a limitation
from kmemleak but it is always good to avoid unaligned members for
optimisation purposes.

Please note that it looks like this issue is not new, e.g.

  https://lore.kernel.org/all/9f1bb619-c4ee-21c4-a251-870bd4db04fa@lwfinger.net/
  https://lore.kernel.org/all/94e48fcd-1dbd-ebd2-4c91-f39941735909@molgen.mpg.de/

  [ bp: Massage + cleanup commit message. ]

Fixes: 7a9c2dd08ead ("x86/pm: Introduce quirk framework to save/restore extra MSR registers around suspend/resume")
Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20220426202138.498310-1-matthieu.baerts@tessares.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/suspend_32.h |  2 +-
 arch/x86/include/asm/suspend_64.h | 12 ++++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/suspend_32.h b/arch/x86/include/asm/suspend_32.h
index fdbd9d7b7bca..3b97aa921543 100644
--- a/arch/x86/include/asm/suspend_32.h
+++ b/arch/x86/include/asm/suspend_32.h
@@ -21,7 +21,6 @@ struct saved_context {
 #endif
 	unsigned long cr0, cr2, cr3, cr4;
 	u64 misc_enable;
-	bool misc_enable_saved;
 	struct saved_msrs saved_msrs;
 	struct desc_ptr gdt_desc;
 	struct desc_ptr idt;
@@ -30,6 +29,7 @@ struct saved_context {
 	unsigned long tr;
 	unsigned long safety;
 	unsigned long return_address;
+	bool misc_enable_saved;
 } __attribute__((packed));
 
 /* routines for saving/restoring kernel state */
diff --git a/arch/x86/include/asm/suspend_64.h b/arch/x86/include/asm/suspend_64.h
index 35bb35d28733..54df06687d83 100644
--- a/arch/x86/include/asm/suspend_64.h
+++ b/arch/x86/include/asm/suspend_64.h
@@ -14,9 +14,13 @@
  * Image of the saved processor state, used by the low level ACPI suspend to
  * RAM code and by the low level hibernation code.
  *
- * If you modify it, fix arch/x86/kernel/acpi/wakeup_64.S and make sure that
- * __save/__restore_processor_state(), defined in arch/x86/kernel/suspend_64.c,
- * still work as required.
+ * If you modify it, check how it is used in arch/x86/kernel/acpi/wakeup_64.S
+ * and make sure that __save/__restore_processor_state(), defined in
+ * arch/x86/power/cpu.c, still work as required.
+ *
+ * Because the structure is packed, make sure to avoid unaligned members. For
+ * optimisation purposes but also because tools like kmemleak only search for
+ * pointers that are aligned.
  */
 struct saved_context {
 	struct pt_regs regs;
@@ -36,7 +40,6 @@ struct saved_context {
 
 	unsigned long cr0, cr2, cr3, cr4;
 	u64 misc_enable;
-	bool misc_enable_saved;
 	struct saved_msrs saved_msrs;
 	unsigned long efer;
 	u16 gdt_pad; /* Unused */
@@ -48,6 +51,7 @@ struct saved_context {
 	unsigned long tr;
 	unsigned long safety;
 	unsigned long return_address;
+	bool misc_enable_saved;
 } __attribute__((packed));
 
 #define loaddebug(thread,register) \
-- 
2.35.1




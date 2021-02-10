Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F61B315D61
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 03:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbhBJCfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 21:35:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235227AbhBJCea (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 21:34:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BDB264E28;
        Wed, 10 Feb 2021 02:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612924429;
        bh=3PofB5kHE1Droc1l/x/NzzxCy7Pe3oO6umr2zP7azEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVqAKWrTDchR3ibGOojrsPOepUBo1IWclpu6zNhM/ncnlVE2/5GEbBtRoc2Og9s0o
         eU7IEX/qcoXjlagmQWfpuP2K0fgUX4trY2WceU5c8usJnzIUepONb8T5/WwLK09c7D
         uosXUrRrP5rZ+PZ/11eelL4Ix4sekq8STINju44whmaRiYR48hVojq78X5EGW7J3/Q
         e0WzGc3Tle2+EAkfi4onhioOicwGEhgByPL70ChRPDjt6b8CNkJVNCg8VFNhwoDCiS
         JJGv4fZz7TFuYjEFYLY2je0ReUDqtUfkVSTw07oxiddLjSJQMmJsGtYGxjbBU2nRLY
         iAzpaxO/H5BVg==
From:   Andy Lutomirski <luto@kernel.org>
To:     x86@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 01/14] x86/fault: Fix AMD erratum #91 errata fixup for user code
Date:   Tue,  9 Feb 2021 18:33:33 -0800
Message-Id: <b91f7f92f3367d2d3a88eec3b09c6aab1b2dc8ef.1612924255.git.luto@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1612924255.git.luto@kernel.org>
References: <cover.1612924255.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The recent rework of probe_kernel_address() and its conversion to
get_kernel_nofault() inadvertently broke is_prefetch(). Before this change,
probe_kernel_address() was used as a sloppy "read user or kernel memory"
helper, but it doesn't do that any more.  The new get_kernel_nofault()
reads *kernel* memory only, which completely broke is_prefetch() for user
access.

Adjust the code to the the correct accessor based on access mode.  The
manual address bounds check is no longer necessary, since the accessor
helpers (get_user() / get_kernel_nofault()) do the right thing all by
themselves.  As a bonus, by using the correct accessor, we don't need the
open-coded address bounds check.

Fixes: eab0c6089b68 ("maccess: unify the probe kernel arch hooks")
Cc: stable@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/mm/fault.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f1f1b5a0956a..441c3e9b8971 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -54,7 +54,7 @@ kmmio_fault(struct pt_regs *regs, unsigned long addr)
  * 32-bit mode:
  *
  *   Sometimes AMD Athlon/Opteron CPUs report invalid exceptions on prefetch.
- *   Check that here and ignore it.
+ *   Check that here and ignore it.  This is AMD erratum #91.
  *
  * 64-bit mode:
  *
@@ -83,11 +83,7 @@ check_prefetch_opcode(struct pt_regs *regs, unsigned char *instr,
 #ifdef CONFIG_X86_64
 	case 0x40:
 		/*
-		 * In AMD64 long mode 0x40..0x4F are valid REX prefixes
-		 * Need to figure out under what instruction mode the
-		 * instruction was issued. Could check the LDT for lm,
-		 * but for now it's good enough to assume that long
-		 * mode only uses well known segments or kernel.
+		 * In 64-bit mode 0x40..0x4F are valid REX prefixes
 		 */
 		return (!user_mode(regs) || user_64bit_mode(regs));
 #endif
@@ -127,20 +123,31 @@ is_prefetch(struct pt_regs *regs, unsigned long error_code, unsigned long addr)
 	instr = (void *)convert_ip_to_linear(current, regs);
 	max_instr = instr + 15;
 
-	if (user_mode(regs) && instr >= (unsigned char *)TASK_SIZE_MAX)
-		return 0;
+	/*
+	 * This code has historically always bailed out if IP points to a
+	 * not-present page (e.g. due to a race).  No one has ever
+	 * complained about this.
+	 */
+	pagefault_disable();
 
 	while (instr < max_instr) {
 		unsigned char opcode;
 
-		if (get_kernel_nofault(opcode, instr))
-			break;
+		if (user_mode(regs)) {
+			if (get_user(opcode, instr))
+				break;
+		} else {
+			if (get_kernel_nofault(opcode, instr))
+				break;
+		}
 
 		instr++;
 
 		if (!check_prefetch_opcode(regs, instr, opcode, &prefetch))
 			break;
 	}
+
+	pagefault_enable();
 	return prefetch;
 }
 
-- 
2.29.2


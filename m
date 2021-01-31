Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DC6309E7B
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 21:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbhAaUA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 15:00:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:52048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231627AbhAaTys (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 31 Jan 2021 14:54:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E2CA64E29;
        Sun, 31 Jan 2021 17:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612113888;
        bh=Pgx1xQlhxhvc42+ZU5Of6p7hke3nHkCDSMZPPWV20MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRwJZlNBMjLMTVToV0i6u22MXY6CBw1J8Y/fBNV7iJHUUenqSxm9CMSnZ1gNW9vAC
         2JQlfL3fPYV8EjhFRkEkTbnFG4pOw2f4BSQC39cWDmDJ/far8IWx5RKVG3Ij7GpCvL
         rlCFj44otlIEfCFF2ygjvn0z79cN4i+D20lFy00wzzRUpMUto4Cp3eY7Yx+9FdFU/A
         rqrMoDiXQn37UYPcgSl3cReM9vz1eCELrY7FP0fWUjc20DpWpxdR1jmF/t+MehB4fL
         nTwZQhGtfu5Q6j9AYXtOWy23xm/4SGb+2+nc80gFMcHm47qAovxOsB0NmAGOtR4Bgu
         gqE+l5L6qYDqw==
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
Subject: [PATCH 01/11] x86/fault: Fix AMD erratum #91 errata fixup for user code
Date:   Sun, 31 Jan 2021 09:24:32 -0800
Message-Id: <7aaa6ff8d29faea5a9324a85e5ad6c41c654e9e0.1612113550.git.luto@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1612113550.git.luto@kernel.org>
References: <cover.1612113550.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The recent rework of probe_kernel_read() and its conversion to
get_kernel_nofault() inadvertently broke is_prefetch().  We were using
probe_kernel_read() as a sloppy "read user or kernel memory" helper, but it
doens't do that any more.  The new get_kernel_nofault() reads *kernel*
memory only, which completely broke is_prefetch() for user access.

Adjust the code to the the correct accessor based on access mode.  The
manual address bounds check is no longer necessary, since the accessor
helpers (get_user() / get_kernel_nofault()) do the right thing all by
themselves.  As a bonus, by using the correct accessor, we don't need the
open-coded address bounds check.

While we're at it, disable the workaround on all CPUs except AMD Family
0xF.  By my reading of the Revision Guide for AMD Athlon™ 64 and AMD
Opteron™ Processors, only family 0xF is affected.

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
 arch/x86/mm/fault.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 106b22d1d189..50dfdc71761e 100644
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
@@ -124,23 +120,38 @@ is_prefetch(struct pt_regs *regs, unsigned long error_code, unsigned long addr)
 	if (error_code & X86_PF_INSTR)
 		return 0;
 
+	if (likely(boot_cpu_data.x86_vendor != X86_VENDOR_AMD
+		   || boot_cpu_data.x86 != 0xf))
+		return 0;
+
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


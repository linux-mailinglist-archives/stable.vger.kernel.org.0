Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F0F329182
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241215AbhCAU1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:27:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242929AbhCAUVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:21:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BED3D64F4D;
        Mon,  1 Mar 2021 18:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621866;
        bh=L38SFZeTvskcp+RdHGxsVI9yUjtX5EJdHPnncN75XY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgQS8PXBF7gU7Kz1vQtUHeF+HmTDJ+s20lnEmJZbXkFZ369FJC65mwMRsn4PU4TKt
         MxWDF9IF7zTwtzd/uZmRj9M1Z7vo4PGw9IhoXNUzEpr1jUI/Q8pq4ghcPdDTsN/Cw8
         WzyG/By24Xd2hL11BGRM9fENJ8sXHwNYwuiJVmUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.11 673/775] x86/fault: Fix AMD erratum #91 errata fixup for user code
Date:   Mon,  1 Mar 2021 17:14:01 +0100
Message-Id: <20210301161234.639893701@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 35f1c89b0cce247bf0213df243ed902989b1dcda upstream.

The recent rework of probe_kernel_address() and its conversion to
get_kernel_nofault() inadvertently broke is_prefetch(). Before this
change, probe_kernel_address() was used as a sloppy "read user or
kernel memory" helper, but it doesn't do that any more. The new
get_kernel_nofault() reads *kernel* memory only, which completely broke
is_prefetch() for user access.

Adjust the code to the correct accessor based on access mode. The
manual address bounds check is no longer necessary, since the accessor
helpers (get_user() / get_kernel_nofault()) do the right thing all by
themselves. As a bonus, by using the correct accessor, the open-coded
address bounds check is not needed anymore.

 [ bp: Massage commit message. ]

Fixes: eab0c6089b68 ("maccess: unify the probe kernel arch hooks")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/b91f7f92f3367d2d3a88eec3b09c6aab1b2dc8ef.1612924255.git.luto@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/fault.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -54,7 +54,7 @@ kmmio_fault(struct pt_regs *regs, unsign
  * 32-bit mode:
  *
  *   Sometimes AMD Athlon/Opteron CPUs report invalid exceptions on prefetch.
- *   Check that here and ignore it.
+ *   Check that here and ignore it.  This is AMD erratum #91.
  *
  * 64-bit mode:
  *
@@ -83,11 +83,7 @@ check_prefetch_opcode(struct pt_regs *re
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
@@ -127,20 +123,31 @@ is_prefetch(struct pt_regs *regs, unsign
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
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130493C5E55
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 16:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbhGLOas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 10:30:48 -0400
Received: from foss.arm.com ([217.140.110.172]:56390 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231154AbhGLOas (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 10:30:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5645F1FB;
        Mon, 12 Jul 2021 07:27:59 -0700 (PDT)
Received: from e110467-lin.cambridge.arm.com (e110467-lin.cambridge.arm.com [10.1.196.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3A4CE3F774;
        Mon, 12 Jul 2021 07:27:58 -0700 (PDT)
From:   Robin Murphy <robin.murphy@arm.com>
To:     will@kernel.org, catalin.marinas@arm.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chen Huang <chenhuang5@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] arm64: Avoid premature usercopy failure
Date:   Mon, 12 Jul 2021 15:27:46 +0100
Message-Id: <dc03d5c675731a1f24a62417dba5429ad744234e.1626098433.git.robin.murphy@arm.com>
X-Mailer: git-send-email 2.21.0.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Al reminds us that the usercopy API must only return complete failure
if absolutely nothing could be copied. Currently, if userspace does
something silly like giving us an unaligned pointer to Device memory,
or a size which overruns MTE tag bounds, we may fail to honour that
requirement when faulting on a multi-byte access even though a smaller
access could have succeeded.

Add a mitigation to the fixup routines to fall back to a single-byte
copy if we faulted on a larger access before anything has been written
to the destination, to guarantee making *some* forward progress. We
needn't be too concerned about the overall performance since this should
only occur when callers are doing something a bit dodgy in the first
place. Particularly broken userspace might still be able to trick
generic_perform_write() into an infinite loop by targeting write() at
an mmap() of some read-only device register where the fault-in load
succeeds but any store synchronously aborts such that copy_to_user() is
genuinely unable to make progress, but, well, don't do that...

CC: stable@vger.kernel.org
Reported-by: Chen Huang <chenhuang5@huawei.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---

I've started trying the "replay" approach for figuring out more precise
remainders in general, but that quickly got more complicated with
rebasing the fault address passing stuff, so I'm resending this now as
a point fix and will continue to explore that as an improvement on top.

Robin.

 arch/arm64/lib/copy_from_user.S | 13 ++++++++++---
 arch/arm64/lib/copy_in_user.S   | 21 ++++++++++++++-------
 arch/arm64/lib/copy_to_user.S   | 14 +++++++++++---
 3 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/lib/copy_from_user.S b/arch/arm64/lib/copy_from_user.S
index 95cd62d67371..2cf999e41d30 100644
--- a/arch/arm64/lib/copy_from_user.S
+++ b/arch/arm64/lib/copy_from_user.S
@@ -29,7 +29,7 @@
 	.endm
 
 	.macro ldrh1 reg, ptr, val
-	user_ldst 9998f, ldtrh, \reg, \ptr, \val
+	user_ldst 9997f, ldtrh, \reg, \ptr, \val
 	.endm
 
 	.macro strh1 reg, ptr, val
@@ -37,7 +37,7 @@
 	.endm
 
 	.macro ldr1 reg, ptr, val
-	user_ldst 9998f, ldtr, \reg, \ptr, \val
+	user_ldst 9997f, ldtr, \reg, \ptr, \val
 	.endm
 
 	.macro str1 reg, ptr, val
@@ -45,7 +45,7 @@
 	.endm
 
 	.macro ldp1 reg1, reg2, ptr, val
-	user_ldp 9998f, \reg1, \reg2, \ptr, \val
+	user_ldp 9997f, \reg1, \reg2, \ptr, \val
 	.endm
 
 	.macro stp1 reg1, reg2, ptr, val
@@ -53,8 +53,10 @@
 	.endm
 
 end	.req	x5
+srcin	.req	x15
 SYM_FUNC_START(__arch_copy_from_user)
 	add	end, x0, x2
+	mov	srcin, x1
 #include "copy_template.S"
 	mov	x0, #0				// Nothing to copy
 	ret
@@ -63,6 +65,11 @@ EXPORT_SYMBOL(__arch_copy_from_user)
 
 	.section .fixup,"ax"
 	.align	2
+9997:	cmp	dst, dstin
+	b.ne	9998f
+	// Before being absolutely sure we couldn't copy anything, try harder
+USER(9998f, ldtrb tmp1w, [srcin])
+	strb	tmp1w, [dst], #1
 9998:	sub	x0, end, dst			// bytes not copied
 	ret
 	.previous
diff --git a/arch/arm64/lib/copy_in_user.S b/arch/arm64/lib/copy_in_user.S
index 1f61cd0df062..dbea3799c3ef 100644
--- a/arch/arm64/lib/copy_in_user.S
+++ b/arch/arm64/lib/copy_in_user.S
@@ -30,33 +30,34 @@
 	.endm
 
 	.macro ldrh1 reg, ptr, val
-	user_ldst 9998f, ldtrh, \reg, \ptr, \val
+	user_ldst 9997f, ldtrh, \reg, \ptr, \val
 	.endm
 
 	.macro strh1 reg, ptr, val
-	user_ldst 9998f, sttrh, \reg, \ptr, \val
+	user_ldst 9997f, sttrh, \reg, \ptr, \val
 	.endm
 
 	.macro ldr1 reg, ptr, val
-	user_ldst 9998f, ldtr, \reg, \ptr, \val
+	user_ldst 9997f, ldtr, \reg, \ptr, \val
 	.endm
 
 	.macro str1 reg, ptr, val
-	user_ldst 9998f, sttr, \reg, \ptr, \val
+	user_ldst 9997f, sttr, \reg, \ptr, \val
 	.endm
 
 	.macro ldp1 reg1, reg2, ptr, val
-	user_ldp 9998f, \reg1, \reg2, \ptr, \val
+	user_ldp 9997f, \reg1, \reg2, \ptr, \val
 	.endm
 
 	.macro stp1 reg1, reg2, ptr, val
-	user_stp 9998f, \reg1, \reg2, \ptr, \val
+	user_stp 9997f, \reg1, \reg2, \ptr, \val
 	.endm
 
 end	.req	x5
-
+srcin	.req	x15
 SYM_FUNC_START(__arch_copy_in_user)
 	add	end, x0, x2
+	mov	srcin, x1
 #include "copy_template.S"
 	mov	x0, #0
 	ret
@@ -65,6 +66,12 @@ EXPORT_SYMBOL(__arch_copy_in_user)
 
 	.section .fixup,"ax"
 	.align	2
+9997:	cmp	dst, dstin
+	b.ne	9998f
+	// Before being absolutely sure we couldn't copy anything, try harder
+USER(9998f, ldtrb tmp1w, [srcin])
+USER(9998f, sttrb tmp1w, [dst])
+	add	dst, dst, #1
 9998:	sub	x0, end, dst			// bytes not copied
 	ret
 	.previous
diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/copy_to_user.S
index 043da90f5dd7..9f380eecf653 100644
--- a/arch/arm64/lib/copy_to_user.S
+++ b/arch/arm64/lib/copy_to_user.S
@@ -32,7 +32,7 @@
 	.endm
 
 	.macro strh1 reg, ptr, val
-	user_ldst 9998f, sttrh, \reg, \ptr, \val
+	user_ldst 9997f, sttrh, \reg, \ptr, \val
 	.endm
 
 	.macro ldr1 reg, ptr, val
@@ -40,7 +40,7 @@
 	.endm
 
 	.macro str1 reg, ptr, val
-	user_ldst 9998f, sttr, \reg, \ptr, \val
+	user_ldst 9997f, sttr, \reg, \ptr, \val
 	.endm
 
 	.macro ldp1 reg1, reg2, ptr, val
@@ -48,12 +48,14 @@
 	.endm
 
 	.macro stp1 reg1, reg2, ptr, val
-	user_stp 9998f, \reg1, \reg2, \ptr, \val
+	user_stp 9997f, \reg1, \reg2, \ptr, \val
 	.endm
 
 end	.req	x5
+srcin	.req	x15
 SYM_FUNC_START(__arch_copy_to_user)
 	add	end, x0, x2
+	mov	srcin, x1
 #include "copy_template.S"
 	mov	x0, #0
 	ret
@@ -62,6 +64,12 @@ EXPORT_SYMBOL(__arch_copy_to_user)
 
 	.section .fixup,"ax"
 	.align	2
+9997:	cmp	dst, dstin
+	b.ne	9998f
+	// Before being absolutely sure we couldn't copy anything, try harder
+	ldrb	tmp1w, [srcin]
+USER(9998f, sttrb tmp1w, [dst])
+	add	dst, dst, #1
 9998:	sub	x0, end, dst			// bytes not copied
 	ret
 	.previous
-- 
2.21.0.dirty


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C628F441685
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhKAJ00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232649AbhKAJYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:24:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F8D360C41;
        Mon,  1 Nov 2021 09:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758476;
        bh=/PP40bfOoNscls4zJOclm14j9CllvYQYtKEMaLuPfsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ug01yaAi00yHXy8CaX5vXflX8gfuC0I6K1x8ePjZHTqtC2ZTG8vizST+BrVrpWqnr
         0xTLm18sy/NepfKBPFpc21tT4ZE0/DY4J9LyV9FWJWWWb7vhZML33ji3+BrR0W0r0Z
         nUoPVAI+Tb38oSxlFfgQOajcOOokmBzrSRN0hKu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Huang <chenhuang5@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 06/35] arm64: Avoid premature usercopy failure
Date:   Mon,  1 Nov 2021 10:17:18 +0100
Message-Id: <20211101082453.101156122@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082451.430720900@linuxfoundation.org>
References: <20211101082451.430720900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit 295cf156231ca3f9e3a66bde7fab5e09c41835e0 upstream.

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
Link: https://lore.kernel.org/r/dc03d5c675731a1f24a62417dba5429ad744234e.1626098433.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chen Huang <chenhuang5@huawei.com>
---
 arch/arm64/lib/copy_from_user.S |   13 ++++++++++---
 arch/arm64/lib/copy_in_user.S   |   20 ++++++++++++++------
 arch/arm64/lib/copy_to_user.S   |   14 +++++++++++---
 3 files changed, 35 insertions(+), 12 deletions(-)

--- a/arch/arm64/lib/copy_from_user.S
+++ b/arch/arm64/lib/copy_from_user.S
@@ -39,7 +39,7 @@
 	.endm
 
 	.macro ldrh1 ptr, regB, val
-	uao_user_alternative 9998f, ldrh, ldtrh, \ptr, \regB, \val
+	uao_user_alternative 9997f, ldrh, ldtrh, \ptr, \regB, \val
 	.endm
 
 	.macro strh1 ptr, regB, val
@@ -47,7 +47,7 @@
 	.endm
 
 	.macro ldr1 ptr, regB, val
-	uao_user_alternative 9998f, ldr, ldtr, \ptr, \regB, \val
+	uao_user_alternative 9997f, ldr, ldtr, \ptr, \regB, \val
 	.endm
 
 	.macro str1 ptr, regB, val
@@ -55,7 +55,7 @@
 	.endm
 
 	.macro ldp1 ptr, regB, regC, val
-	uao_ldp 9998f, \ptr, \regB, \regC, \val
+	uao_ldp 9997f, \ptr, \regB, \regC, \val
 	.endm
 
 	.macro stp1 ptr, regB, regC, val
@@ -63,9 +63,11 @@
 	.endm
 
 end	.req	x5
+srcin	.req	x15
 ENTRY(__arch_copy_from_user)
 	uaccess_enable_not_uao x3, x4, x5
 	add	end, x0, x2
+	mov	srcin, x1
 #include "copy_template.S"
 	uaccess_disable_not_uao x3, x4
 	mov	x0, #0				// Nothing to copy
@@ -74,6 +76,11 @@ ENDPROC(__arch_copy_from_user)
 
 	.section .fixup,"ax"
 	.align	2
+9997:	cmp	dst, dstin
+	b.ne	9998f
+	// Before being absolutely sure we couldn't copy anything, try harder
+USER(9998f, ldtrb tmp1w, [srcin])
+	strb	tmp1w, [dst], #1
 9998:	sub	x0, end, dst			// bytes not copied
 	uaccess_disable_not_uao x3, x4
 	ret
--- a/arch/arm64/lib/copy_in_user.S
+++ b/arch/arm64/lib/copy_in_user.S
@@ -40,34 +40,36 @@
 	.endm
 
 	.macro ldrh1 ptr, regB, val
-	uao_user_alternative 9998f, ldrh, ldtrh, \ptr, \regB, \val
+	uao_user_alternative 9997f, ldrh, ldtrh, \ptr, \regB, \val
 	.endm
 
 	.macro strh1 ptr, regB, val
-	uao_user_alternative 9998f, strh, sttrh, \ptr, \regB, \val
+	uao_user_alternative 9997f, strh, sttrh, \ptr, \regB, \val
 	.endm
 
 	.macro ldr1 ptr, regB, val
-	uao_user_alternative 9998f, ldr, ldtr, \ptr, \regB, \val
+	uao_user_alternative 9997f, ldr, ldtr, \ptr, \regB, \val
 	.endm
 
 	.macro str1 ptr, regB, val
-	uao_user_alternative 9998f, str, sttr, \ptr, \regB, \val
+	uao_user_alternative 9997f, str, sttr, \ptr, \regB, \val
 	.endm
 
 	.macro ldp1 ptr, regB, regC, val
-	uao_ldp 9998f, \ptr, \regB, \regC, \val
+	uao_ldp 9997f, \ptr, \regB, \regC, \val
 	.endm
 
 	.macro stp1 ptr, regB, regC, val
-	uao_stp 9998f, \ptr, \regB, \regC, \val
+	uao_stp 9997f, \ptr, \regB, \regC, \val
 	.endm
 
 end	.req	x5
+srcin	.req	x15
 
 ENTRY(__arch_copy_in_user)
 	uaccess_enable_not_uao x3, x4, x5
 	add	end, x0, x2
+	mov	srcin, x1
 #include "copy_template.S"
 	uaccess_disable_not_uao x3, x4
 	mov	x0, #0
@@ -76,6 +78,12 @@ ENDPROC(__arch_copy_in_user)
 
 	.section .fixup,"ax"
 	.align	2
+9997:	cmp	dst, dstin
+	b.ne	9998f
+	// Before being absolutely sure we couldn't copy anything, try harder
+USER(9998f, ldtrb tmp1w, [srcin])
+USER(9998f, sttrb tmp1w, [dst])
+	add	dst, dst, #1
 9998:	sub	x0, end, dst			// bytes not copied
 	uaccess_disable_not_uao x3, x4
 	ret
--- a/arch/arm64/lib/copy_to_user.S
+++ b/arch/arm64/lib/copy_to_user.S
@@ -42,7 +42,7 @@
 	.endm
 
 	.macro strh1 ptr, regB, val
-	uao_user_alternative 9998f, strh, sttrh, \ptr, \regB, \val
+	uao_user_alternative 9997f, strh, sttrh, \ptr, \regB, \val
 	.endm
 
 	.macro ldr1 ptr, regB, val
@@ -50,7 +50,7 @@
 	.endm
 
 	.macro str1 ptr, regB, val
-	uao_user_alternative 9998f, str, sttr, \ptr, \regB, \val
+	uao_user_alternative 9997f, str, sttr, \ptr, \regB, \val
 	.endm
 
 	.macro ldp1 ptr, regB, regC, val
@@ -58,13 +58,15 @@
 	.endm
 
 	.macro stp1 ptr, regB, regC, val
-	uao_stp 9998f, \ptr, \regB, \regC, \val
+	uao_stp 9997f, \ptr, \regB, \regC, \val
 	.endm
 
 end	.req	x5
+srcin	.req	x15
 ENTRY(__arch_copy_to_user)
 	uaccess_enable_not_uao x3, x4, x5
 	add	end, x0, x2
+	mov	srcin, x1
 #include "copy_template.S"
 	uaccess_disable_not_uao x3, x4
 	mov	x0, #0
@@ -73,6 +75,12 @@ ENDPROC(__arch_copy_to_user)
 
 	.section .fixup,"ax"
 	.align	2
+9997:	cmp	dst, dstin
+	b.ne	9998f
+	// Before being absolutely sure we couldn't copy anything, try harder
+	ldrb	tmp1w, [srcin]
+USER(9998f, sttrb tmp1w, [dst])
+	add	dst, dst, #1
 9998:	sub	x0, end, dst			// bytes not copied
 	uaccess_disable_not_uao x3, x4
 	ret



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65D444176F
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhKAJgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233752AbhKAJeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:34:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65295610FC;
        Mon,  1 Nov 2021 09:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758739;
        bh=qsz/k60FUzE87zRkbyNGVt88R4f8mye/n3bPift+Ulk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atfWUCiwk0KBqMnEz++B3F4Un9na70hhQoqs9DwH6Dhry8eu/4GdlDQXCkQV5CH5x
         GXrXNPvR289Z/aQH/1y1zQwrXBOgyxxCAeqikCH+iS0Gkw+tSIUVuQRJPvqFUqsljR
         XSfQOSN/rIEYK7Ua0la3p09rbocoo7cv2G8aoaBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Huang <chenhuang5@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 09/77] arm64: Avoid premature usercopy failure
Date:   Mon,  1 Nov 2021 10:16:57 +0100
Message-Id: <20211101082513.930721560@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
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
Signed-off-by: Chen Huang <chenhuang5@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/lib/copy_from_user.S |   13 ++++++++++---
 arch/arm64/lib/copy_in_user.S   |   21 ++++++++++++++-------
 arch/arm64/lib/copy_to_user.S   |   14 +++++++++++---
 3 files changed, 35 insertions(+), 13 deletions(-)

--- a/arch/arm64/lib/copy_from_user.S
+++ b/arch/arm64/lib/copy_from_user.S
@@ -29,7 +29,7 @@
 	.endm
 
 	.macro ldrh1 reg, ptr, val
-	uao_user_alternative 9998f, ldrh, ldtrh, \reg, \ptr, \val
+	uao_user_alternative 9997f, ldrh, ldtrh, \reg, \ptr, \val
 	.endm
 
 	.macro strh1 reg, ptr, val
@@ -37,7 +37,7 @@
 	.endm
 
 	.macro ldr1 reg, ptr, val
-	uao_user_alternative 9998f, ldr, ldtr, \reg, \ptr, \val
+	uao_user_alternative 9997f, ldr, ldtr, \reg, \ptr, \val
 	.endm
 
 	.macro str1 reg, ptr, val
@@ -45,7 +45,7 @@
 	.endm
 
 	.macro ldp1 reg1, reg2, ptr, val
-	uao_ldp 9998f, \reg1, \reg2, \ptr, \val
+	uao_ldp 9997f, \reg1, \reg2, \ptr, \val
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
--- a/arch/arm64/lib/copy_in_user.S
+++ b/arch/arm64/lib/copy_in_user.S
@@ -30,33 +30,34 @@
 	.endm
 
 	.macro ldrh1 reg, ptr, val
-	uao_user_alternative 9998f, ldrh, ldtrh, \reg, \ptr, \val
+	uao_user_alternative 9997f, ldrh, ldtrh, \reg, \ptr, \val
 	.endm
 
 	.macro strh1 reg, ptr, val
-	uao_user_alternative 9998f, strh, sttrh, \reg, \ptr, \val
+	uao_user_alternative 9997f, strh, sttrh, \reg, \ptr, \val
 	.endm
 
 	.macro ldr1 reg, ptr, val
-	uao_user_alternative 9998f, ldr, ldtr, \reg, \ptr, \val
+	uao_user_alternative 9997f, ldr, ldtr, \reg, \ptr, \val
 	.endm
 
 	.macro str1 reg, ptr, val
-	uao_user_alternative 9998f, str, sttr, \reg, \ptr, \val
+	uao_user_alternative 9997f, str, sttr, \reg, \ptr, \val
 	.endm
 
 	.macro ldp1 reg1, reg2, ptr, val
-	uao_ldp 9998f, \reg1, \reg2, \ptr, \val
+	uao_ldp 9997f, \reg1, \reg2, \ptr, \val
 	.endm
 
 	.macro stp1 reg1, reg2, ptr, val
-	uao_stp 9998f, \reg1, \reg2, \ptr, \val
+	uao_stp 9997f, \reg1, \reg2, \ptr, \val
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
--- a/arch/arm64/lib/copy_to_user.S
+++ b/arch/arm64/lib/copy_to_user.S
@@ -32,7 +32,7 @@
 	.endm
 
 	.macro strh1 reg, ptr, val
-	uao_user_alternative 9998f, strh, sttrh, \reg, \ptr, \val
+	uao_user_alternative 9997f, strh, sttrh, \reg, \ptr, \val
 	.endm
 
 	.macro ldr1 reg, ptr, val
@@ -40,7 +40,7 @@
 	.endm
 
 	.macro str1 reg, ptr, val
-	uao_user_alternative 9998f, str, sttr, \reg, \ptr, \val
+	uao_user_alternative 9997f, str, sttr, \reg, \ptr, \val
 	.endm
 
 	.macro ldp1 reg1, reg2, ptr, val
@@ -48,12 +48,14 @@
 	.endm
 
 	.macro stp1 reg1, reg2, ptr, val
-	uao_stp 9998f, \reg1, \reg2, \ptr, \val
+	uao_stp 9997f, \reg1, \reg2, \ptr, \val
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



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9220343BF6D
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 04:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhJ0CR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 22:17:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:25314 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbhJ0CR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 22:17:27 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HfBws6886zbhPY;
        Wed, 27 Oct 2021 10:10:21 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 10:14:59 +0800
Received: from localhost.localdomain (10.175.112.125) by
 kwepemm600008.china.huawei.com (7.193.23.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 10:14:58 +0800
From:   Chen Huang <chenhuang5@huawei.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>,
        <linux-mm@kvack.org>, Chen Huang <chenhuang5@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.19.y] arm64: Avoid premature usercopy failure
Date:   Wed, 27 Oct 2021 02:29:07 +0000
Message-ID: <20211027022907.2617558-1-chenhuang5@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600008.china.huawei.com (7.193.23.88)
X-CFilter-Loop: Reflected
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
---
 arch/arm64/lib/copy_from_user.S | 13 ++++++++++---
 arch/arm64/lib/copy_in_user.S   | 20 ++++++++++++++------
 arch/arm64/lib/copy_to_user.S   | 14 +++++++++++---
 3 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/lib/copy_from_user.S b/arch/arm64/lib/copy_from_user.S
index 96b22c0fa343..7cd6eeaa216c 100644
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
diff --git a/arch/arm64/lib/copy_in_user.S b/arch/arm64/lib/copy_in_user.S
index e56c705f1f23..b20d3a0b3237 100644
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
diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/copy_to_user.S
index 6b99b939c50f..cfdbb1fe8d51 100644
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
-- 
2.25.1


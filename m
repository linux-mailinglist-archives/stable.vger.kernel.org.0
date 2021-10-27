Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7CE43BEFA
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 03:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237425AbhJ0B2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 21:28:53 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14867 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbhJ0B2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 21:28:52 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hf9y54pN5z90MT;
        Wed, 27 Oct 2021 09:26:21 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 09:26:24 +0800
Received: from localhost.localdomain (10.175.112.125) by
 kwepemm600008.china.huawei.com (7.193.23.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 09:26:23 +0800
From:   Chen Huang <chenhuang5@huawei.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>,
        <linux-mm@kvack.org>, Chen Huang <chenhuang5@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.10.y] arm64: Avoid premature usercopy failure
Date:   Wed, 27 Oct 2021 01:40:47 +0000
Message-ID: <20211027014047.2317325-1-chenhuang5@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
 arch/arm64/lib/copy_in_user.S   | 21 ++++++++++++++-------
 arch/arm64/lib/copy_to_user.S   | 14 +++++++++++---
 3 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/lib/copy_from_user.S b/arch/arm64/lib/copy_from_user.S
index 0f8a3a9e3795..957a6d092d7a 100644
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
diff --git a/arch/arm64/lib/copy_in_user.S b/arch/arm64/lib/copy_in_user.S
index 80e37ada0ee1..35c01da09323 100644
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
diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/copy_to_user.S
index 4ec59704b8f2..85705350ff35 100644
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
-- 
2.25.1


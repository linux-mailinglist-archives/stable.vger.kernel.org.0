Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 347D611B56D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbfLKPSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:18:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732119AbfLKPSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 544AA208C3;
        Wed, 11 Dec 2019 15:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077518;
        bh=F48gZ5TXRMMYLe3Vj2WfuRy8MFjjsSBteqk38X6Fkjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbMrG/b9YkvOsQH5+Hxm1fQ/l1/XecRU82M/R+Qof9Dbt70/bCC+3BukXcvuWp9Wv
         YODzRD34FeXhdvUVykYsymzzIiWmVIbz5t11+lqNsNX50Ls7BJ5xANSZKIMjhfhR4h
         8p5qnQjYWLUf8C6D1XzcFMipZfbdMj9qUDda+ma4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 032/243] ARM: 8813/1: Make aligned 2-byte getuser()/putuser() atomic on ARMv6+
Date:   Wed, 11 Dec 2019 16:03:14 +0100
Message-Id: <20191211150341.456666899@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 344eb5539abf3e0b6ce22568c03e86450073e097 ]

getuser() and putuser() (and there underscored variants) use two
strb[t]/ldrb[t] instructions when they are asked to get/put 16-bits.
This means that the read/write is not atomic even when performed to a
16-bit-aligned address.

This leads to problems with vhost: vhost uses __getuser() to read the
vring's 16-bit avail.index field, and if it happens to observe a partial
update of the index, wrong descriptors will be used which will lead to a
breakdown of the virtio communication.  A similar problem exists for
__putuser() which is used to write to the vring's used.index field.

The reason these functions use strb[t]/ldrb[t] is because strht/ldrht
instructions did not exist until ARMv6T2/ARMv7.  So we should be easily
able to fix this on ARMv7.  Also, since all ARMv6 processors also don't
actually use the unprivileged instructions anymore for uaccess (since
CONFIG_CPU_USE_DOMAINS is not used) we can easily fix them too.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/uaccess.h | 18 ++++++++++++++++++
 arch/arm/lib/getuser.S         | 11 +++++++++++
 arch/arm/lib/putuser.S         | 20 ++++++++++----------
 3 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index c136eef8f690b..6390a40f16e73 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -349,6 +349,13 @@ do {									\
 #define __get_user_asm_byte(x, addr, err)			\
 	__get_user_asm(x, addr, err, ldrb)
 
+#if __LINUX_ARM_ARCH__ >= 6
+
+#define __get_user_asm_half(x, addr, err)			\
+	__get_user_asm(x, addr, err, ldrh)
+
+#else
+
 #ifndef __ARMEB__
 #define __get_user_asm_half(x, __gu_addr, err)			\
 ({								\
@@ -367,6 +374,8 @@ do {									\
 })
 #endif
 
+#endif /* __LINUX_ARM_ARCH__ >= 6 */
+
 #define __get_user_asm_word(x, addr, err)			\
 	__get_user_asm(x, addr, err, ldr)
 #endif
@@ -442,6 +451,13 @@ do {									\
 #define __put_user_asm_byte(x, __pu_addr, err)			\
 	__put_user_asm(x, __pu_addr, err, strb)
 
+#if __LINUX_ARM_ARCH__ >= 6
+
+#define __put_user_asm_half(x, __pu_addr, err)			\
+	__put_user_asm(x, __pu_addr, err, strh)
+
+#else
+
 #ifndef __ARMEB__
 #define __put_user_asm_half(x, __pu_addr, err)			\
 ({								\
@@ -458,6 +474,8 @@ do {									\
 })
 #endif
 
+#endif /* __LINUX_ARM_ARCH__ >= 6 */
+
 #define __put_user_asm_word(x, __pu_addr, err)			\
 	__put_user_asm(x, __pu_addr, err, str)
 
diff --git a/arch/arm/lib/getuser.S b/arch/arm/lib/getuser.S
index 746e7801dcdf7..b2e4bc3a635e2 100644
--- a/arch/arm/lib/getuser.S
+++ b/arch/arm/lib/getuser.S
@@ -42,6 +42,12 @@ _ASM_NOKPROBE(__get_user_1)
 
 ENTRY(__get_user_2)
 	check_uaccess r0, 2, r1, r2, __get_user_bad
+#if __LINUX_ARM_ARCH__ >= 6
+
+2: TUSER(ldrh)	r2, [r0]
+
+#else
+
 #ifdef CONFIG_CPU_USE_DOMAINS
 rb	.req	ip
 2:	ldrbt	r2, [r0], #1
@@ -56,6 +62,9 @@ rb	.req	r0
 #else
 	orr	r2, rb, r2, lsl #8
 #endif
+
+#endif /* __LINUX_ARM_ARCH__ >= 6 */
+
 	mov	r0, #0
 	ret	lr
 ENDPROC(__get_user_2)
@@ -145,7 +154,9 @@ _ASM_NOKPROBE(__get_user_bad8)
 .pushsection __ex_table, "a"
 	.long	1b, __get_user_bad
 	.long	2b, __get_user_bad
+#if __LINUX_ARM_ARCH__ < 6
 	.long	3b, __get_user_bad
+#endif
 	.long	4b, __get_user_bad
 	.long	5b, __get_user_bad8
 	.long	6b, __get_user_bad8
diff --git a/arch/arm/lib/putuser.S b/arch/arm/lib/putuser.S
index 38d660d3705f4..515eeaa9975c6 100644
--- a/arch/arm/lib/putuser.S
+++ b/arch/arm/lib/putuser.S
@@ -41,16 +41,13 @@ ENDPROC(__put_user_1)
 
 ENTRY(__put_user_2)
 	check_uaccess r0, 2, r1, ip, __put_user_bad
-	mov	ip, r2, lsr #8
-#ifdef CONFIG_THUMB2_KERNEL
-#ifndef __ARMEB__
-2: TUSER(strb)	r2, [r0]
-3: TUSER(strb)	ip, [r0, #1]
+#if __LINUX_ARM_ARCH__ >= 6
+
+2: TUSER(strh)	r2, [r0]
+
 #else
-2: TUSER(strb)	ip, [r0]
-3: TUSER(strb)	r2, [r0, #1]
-#endif
-#else	/* !CONFIG_THUMB2_KERNEL */
+
+	mov	ip, r2, lsr #8
 #ifndef __ARMEB__
 2: TUSER(strb)	r2, [r0], #1
 3: TUSER(strb)	ip, [r0]
@@ -58,7 +55,8 @@ ENTRY(__put_user_2)
 2: TUSER(strb)	ip, [r0], #1
 3: TUSER(strb)	r2, [r0]
 #endif
-#endif	/* CONFIG_THUMB2_KERNEL */
+
+#endif /* __LINUX_ARM_ARCH__ >= 6 */
 	mov	r0, #0
 	ret	lr
 ENDPROC(__put_user_2)
@@ -91,7 +89,9 @@ ENDPROC(__put_user_bad)
 .pushsection __ex_table, "a"
 	.long	1b, __put_user_bad
 	.long	2b, __put_user_bad
+#if __LINUX_ARM_ARCH__ < 6
 	.long	3b, __put_user_bad
+#endif
 	.long	4b, __put_user_bad
 	.long	5b, __put_user_bad
 	.long	6b, __put_user_bad
-- 
2.20.1




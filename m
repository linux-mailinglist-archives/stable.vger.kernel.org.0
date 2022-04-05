Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89944F36B7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240040AbiDELHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348546AbiDEJsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210CC55BDA;
        Tue,  5 Apr 2022 02:34:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59152B81B75;
        Tue,  5 Apr 2022 09:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA648C385AA;
        Tue,  5 Apr 2022 09:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151246;
        bh=guVlBzD+z8QYs49QmnLxHxL7TQNESW7NlPWrZw/7gKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHoNgilw539W5JUArm2I5cXiaI1QVt3KALMrVkSZyVBhDfMp4tVWwD3MbNK3F9our
         PX6RioZcBq6/W0xMge5EiUTkI7aqudxbojKUsENbaNB1v1c3dq7/KNyaTVtxAo4NgW
         DIhcaOCNNSCFb3VpEDFcFiEhRs5Mm7C1N5GJDop0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 329/913] uaccess: fix nios2 and microblaze get_user_8()
Date:   Tue,  5 Apr 2022 09:23:11 +0200
Message-Id: <20220405070349.712138376@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a97b693c3712f040c5802f32b2d685352e08cefa ]

These two architectures implement 8-byte get_user() through
a memcpy() into a four-byte variable, which won't fit.

Use a temporary 64-bit variable instead here, and use a double
cast the way that risc-v and openrisc do to avoid compile-time
warnings.

Fixes: 6a090e97972d ("arch/microblaze: support get_user() of size 8 bytes")
Fixes: 5ccc6af5e88e ("nios2: Memory management")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/include/asm/uaccess.h | 18 +++++++++---------
 arch/nios2/include/asm/uaccess.h      | 26 ++++++++++++++++----------
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
index 5b6e0e7788f4..3fe96979d2c6 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -130,27 +130,27 @@ extern long __user_bad(void);
 
 #define __get_user(x, ptr)						\
 ({									\
-	unsigned long __gu_val = 0;					\
 	long __gu_err;							\
 	switch (sizeof(*(ptr))) {					\
 	case 1:								\
-		__get_user_asm("lbu", (ptr), __gu_val, __gu_err);	\
+		__get_user_asm("lbu", (ptr), x, __gu_err);		\
 		break;							\
 	case 2:								\
-		__get_user_asm("lhu", (ptr), __gu_val, __gu_err);	\
+		__get_user_asm("lhu", (ptr), x, __gu_err);		\
 		break;							\
 	case 4:								\
-		__get_user_asm("lw", (ptr), __gu_val, __gu_err);	\
+		__get_user_asm("lw", (ptr), x, __gu_err);		\
 		break;							\
-	case 8:								\
-		__gu_err = __copy_from_user(&__gu_val, ptr, 8);		\
-		if (__gu_err)						\
-			__gu_err = -EFAULT;				\
+	case 8: {							\
+		__u64 __x = 0;						\
+		__gu_err = raw_copy_from_user(&__x, ptr, 8) ?		\
+							-EFAULT : 0;	\
+		(x) = (typeof(x))(typeof((x) - (x)))__x;		\
 		break;							\
+	}								\
 	default:							\
 		/* __gu_val = 0; __gu_err = -EINVAL;*/ __gu_err = __user_bad();\
 	}								\
-	x = (__force __typeof__(*(ptr))) __gu_val;			\
 	__gu_err;							\
 })
 
diff --git a/arch/nios2/include/asm/uaccess.h b/arch/nios2/include/asm/uaccess.h
index ba9340e96fd4..ca9285a915ef 100644
--- a/arch/nios2/include/asm/uaccess.h
+++ b/arch/nios2/include/asm/uaccess.h
@@ -88,6 +88,7 @@ extern __must_check long strnlen_user(const char __user *s, long n);
 /* Optimized macros */
 #define __get_user_asm(val, insn, addr, err)				\
 {									\
+	unsigned long __gu_val;						\
 	__asm__ __volatile__(						\
 	"       movi    %0, %3\n"					\
 	"1:   " insn " %1, 0(%2)\n"					\
@@ -96,14 +97,20 @@ extern __must_check long strnlen_user(const char __user *s, long n);
 	"       .section __ex_table,\"a\"\n"				\
 	"       .word 1b, 2b\n"						\
 	"       .previous"						\
-	: "=&r" (err), "=r" (val)					\
+	: "=&r" (err), "=r" (__gu_val)					\
 	: "r" (addr), "i" (-EFAULT));					\
+	val = (__force __typeof__(*(addr)))__gu_val;			\
 }
 
-#define __get_user_unknown(val, size, ptr, err) do {			\
+extern void __get_user_unknown(void);
+
+#define __get_user_8(val, ptr, err) do {				\
+	u64 __val = 0;							\
 	err = 0;							\
-	if (__copy_from_user(&(val), ptr, size)) {			\
+	if (raw_copy_from_user(&(__val), ptr, sizeof(val))) {		\
 		err = -EFAULT;						\
+	} else {							\
+		val = (typeof(val))(typeof((val) - (val)))__val;	\
 	}								\
 	} while (0)
 
@@ -119,8 +126,11 @@ do {									\
 	case 4:								\
 		__get_user_asm(val, "ldw", ptr, err);			\
 		break;							\
+	case 8:								\
+		__get_user_8(val, ptr, err);				\
+		break;							\
 	default:							\
-		__get_user_unknown(val, size, ptr, err);		\
+		__get_user_unknown();					\
 		break;							\
 	}								\
 } while (0)
@@ -129,9 +139,7 @@ do {									\
 	({								\
 	long __gu_err = -EFAULT;					\
 	const __typeof__(*(ptr)) __user *__gu_ptr = (ptr);		\
-	unsigned long __gu_val = 0;					\
-	__get_user_common(__gu_val, sizeof(*(ptr)), __gu_ptr, __gu_err);\
-	(x) = (__force __typeof__(x))__gu_val;				\
+	__get_user_common(x, sizeof(*(ptr)), __gu_ptr, __gu_err);	\
 	__gu_err;							\
 	})
 
@@ -139,11 +147,9 @@ do {									\
 ({									\
 	long __gu_err = -EFAULT;					\
 	const __typeof__(*(ptr)) __user *__gu_ptr = (ptr);		\
-	unsigned long __gu_val = 0;					\
 	if (access_ok( __gu_ptr, sizeof(*__gu_ptr)))	\
-		__get_user_common(__gu_val, sizeof(*__gu_ptr),		\
+		__get_user_common(x, sizeof(*__gu_ptr),			\
 			__gu_ptr, __gu_err);				\
-	(x) = (__force __typeof__(x))__gu_val;				\
 	__gu_err;							\
 })
 
-- 
2.34.1




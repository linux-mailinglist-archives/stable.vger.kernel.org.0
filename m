Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B0950155C
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343710AbiDNNtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343978AbiDNNjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:39:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B306029CBE;
        Thu, 14 Apr 2022 06:36:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51E4361D70;
        Thu, 14 Apr 2022 13:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C205C385A1;
        Thu, 14 Apr 2022 13:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943370;
        bh=EU4Slk4Q8gyxEduV72kD+AGQbRHJaz2gtjEeHLEpv9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3MUwh6KGKZld75WZ12VnD0Dwu4RkhWZ4nhC3Q4lb2O72lgC50b/RxIoBorDzox6M
         iO9M04a8xDtp3cmSq7j5Z46/rXKxG2d0KDv8T5jGNawTXYLzlcS6W+fSGxf9uDE5MU
         02QnCd9VYgs5Ach2Ep5egvkFTxkJ/wArH9VOEe90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/475] uaccess: fix nios2 and microblaze get_user_8()
Date:   Thu, 14 Apr 2022 15:08:34 +0200
Message-Id: <20220414110858.760491922@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index a1f206b90753..c8cd66c8d257 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -171,27 +171,27 @@ extern long __user_bad(void);
 
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
index e83f831a76f9..6be5e913c42e 100644
--- a/arch/nios2/include/asm/uaccess.h
+++ b/arch/nios2/include/asm/uaccess.h
@@ -89,6 +89,7 @@ extern __must_check long strnlen_user(const char __user *s, long n);
 /* Optimized macros */
 #define __get_user_asm(val, insn, addr, err)				\
 {									\
+	unsigned long __gu_val;						\
 	__asm__ __volatile__(						\
 	"       movi    %0, %3\n"					\
 	"1:   " insn " %1, 0(%2)\n"					\
@@ -97,14 +98,20 @@ extern __must_check long strnlen_user(const char __user *s, long n);
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
 
@@ -120,8 +127,11 @@ do {									\
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
@@ -130,9 +140,7 @@ do {									\
 	({								\
 	long __gu_err = -EFAULT;					\
 	const __typeof__(*(ptr)) __user *__gu_ptr = (ptr);		\
-	unsigned long __gu_val = 0;					\
-	__get_user_common(__gu_val, sizeof(*(ptr)), __gu_ptr, __gu_err);\
-	(x) = (__force __typeof__(x))__gu_val;				\
+	__get_user_common(x, sizeof(*(ptr)), __gu_ptr, __gu_err);	\
 	__gu_err;							\
 	})
 
@@ -140,11 +148,9 @@ do {									\
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




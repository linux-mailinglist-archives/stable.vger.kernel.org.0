Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D86421F37A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbfEOLDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbfEOLDQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:03:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C02FE2084F;
        Wed, 15 May 2019 11:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918195;
        bh=+XedDf6gpjXn+W8nm8hFEnJf5jpvQh8vCiRbxi6DSsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0hlL5mwDkjlKOMbiz2oiDOwXy1Kb3Sb4qhqzKXyl99RkXaXc6PJFaR/5lFiwokqA
         GNh1j0sPVWE3uIMgqBLJPb0iPGYb9eisTjuQ/s2efp1qrHt749Aro2Jim8ldfrJtHU
         oyXeD78XJlCA82r2mfp07iGWaHm/WTRtVUK86txk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 042/266] powerpc: Use barrier_nospec in copy_from_user()
Date:   Wed, 15 May 2019 12:52:29 +0200
Message-Id: <20190515090723.903682880@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit ddf35cf3764b5a182b178105f57515b42e2634f8 upstream.

Based on the x86 commit doing the same.

See commit 304ec1b05031 ("x86/uaccess: Use __uaccess_begin_nospec()
and uaccess_try_nospec") and b3bbfb3fb5d2 ("x86: Introduce
__uaccess_begin_nospec() and uaccess_try_nospec") for more detail.

In all cases we are ordering the load from the potentially
user-controlled pointer vs a previous branch based on an access_ok()
check or similar.

Base on a patch from Michal Suchanek.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/uaccess.h |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -269,6 +269,7 @@ do {								\
 	__chk_user_ptr(ptr);					\
 	if (!is_kernel_addr((unsigned long)__gu_addr))		\
 		might_fault();					\
+	barrier_nospec();					\
 	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
 	(x) = (__typeof__(*(ptr)))__gu_val;			\
 	__gu_err;						\
@@ -283,6 +284,7 @@ do {								\
 	__chk_user_ptr(ptr);					\
 	if (!is_kernel_addr((unsigned long)__gu_addr))		\
 		might_fault();					\
+	barrier_nospec();					\
 	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
 	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__gu_err;						\
@@ -295,8 +297,10 @@ do {								\
 	unsigned long  __gu_val = 0;					\
 	__typeof__(*(ptr)) __user *__gu_addr = (ptr);		\
 	might_fault();							\
-	if (access_ok(VERIFY_READ, __gu_addr, (size)))			\
+	if (access_ok(VERIFY_READ, __gu_addr, (size))) {		\
+		barrier_nospec();					\
 		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
+	}								\
 	(x) = (__force __typeof__(*(ptr)))__gu_val;				\
 	__gu_err;							\
 })
@@ -307,6 +311,7 @@ do {								\
 	unsigned long __gu_val;					\
 	__typeof__(*(ptr)) __user *__gu_addr = (ptr);	\
 	__chk_user_ptr(ptr);					\
+	barrier_nospec();					\
 	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
 	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__gu_err;						\
@@ -323,8 +328,10 @@ extern unsigned long __copy_tofrom_user(
 static inline unsigned long copy_from_user(void *to,
 		const void __user *from, unsigned long n)
 {
-	if (likely(access_ok(VERIFY_READ, from, n)))
+	if (likely(access_ok(VERIFY_READ, from, n))) {
+		barrier_nospec();
 		return __copy_tofrom_user((__force void __user *)to, from, n);
+	}
 	memset(to, 0, n);
 	return n;
 }
@@ -359,21 +366,27 @@ static inline unsigned long __copy_from_
 
 		switch (n) {
 		case 1:
+			barrier_nospec();
 			__get_user_size(*(u8 *)to, from, 1, ret);
 			break;
 		case 2:
+			barrier_nospec();
 			__get_user_size(*(u16 *)to, from, 2, ret);
 			break;
 		case 4:
+			barrier_nospec();
 			__get_user_size(*(u32 *)to, from, 4, ret);
 			break;
 		case 8:
+			barrier_nospec();
 			__get_user_size(*(u64 *)to, from, 8, ret);
 			break;
 		}
 		if (ret == 0)
 			return 0;
 	}
+
+	barrier_nospec();
 	return __copy_tofrom_user((__force void __user *)to, from, n);
 }
 
@@ -400,6 +413,7 @@ static inline unsigned long __copy_to_us
 		if (ret == 0)
 			return 0;
 	}
+
 	return __copy_tofrom_user(to, (__force const void __user *)from, n);
 }
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FA72BA8AB
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgKTLEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:04:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728015AbgKTLEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:04:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7465E22264;
        Fri, 20 Nov 2020 11:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870280;
        bh=rW92cS6AXh3BL1XGA0yxQH8z6NDRrd3MybpMxJ23wSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjcMe7XgSu+tci0p7lsFeVqIB7pJEFMoNeDr21ufNa8dfTbwvxzrFp09QKELRpK5w
         PmFsypj24JqTj7tE7LutxtDq41a9YULM/pFUBtAl+x08cncjkZq16+1hqU1HJ3W2y2
         9SvWCZWMa4B1G2lB5rAPqA3SzMGeoYgLu6Xylek0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.9 07/16] powerpc/uaccess: Evaluate macro arguments once, before user access is allowed
Date:   Fri, 20 Nov 2020 12:03:12 +0100
Message-Id: <20201120104540.087576936@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.706905067@linuxfoundation.org>
References: <20201120104539.706905067@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit d02f6b7dab8228487268298ea1f21081c0b4b3eb upstream.

get/put_user() can be called with nontrivial arguments. fs/proc/page.c
has a good example:

    if (put_user(stable_page_flags(ppage), out)) {

stable_page_flags() is quite a lot of code, including spin locks in
the page allocator.

Ensure these arguments are evaluated before user access is allowed.

This improves security by reducing code with access to userspace, but
it also fixes a PREEMPT bug with KUAP on powerpc/64s:
stable_page_flags() is currently called with AMR set to allow writes,
it ends up calling spin_unlock(), which can call preempt_schedule. But
the task switch code can not be called with AMR set (it relies on
interrupts saving the register), so this blows up.

It's fine if the code inside allow_user_access() is preemptible,
because a timer or IPI will save the AMR, but it's not okay to
explicitly cause a reschedule.

Fixes: de78a9c42a79 ("powerpc: Add a framework for Kernel Userspace Access Protection")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200407041245.600651-1-npiggin@gmail.com
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/uaccess.h |   49 ++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 14 deletions(-)

--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -190,13 +190,17 @@ do {								\
 ({								\
 	long __pu_err;						\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);		\
+	__typeof__(*(ptr)) __pu_val = (x);			\
+	__typeof__(size) __pu_size = (size);			\
+								\
 	if (!is_kernel_addr((unsigned long)__pu_addr))		\
 		might_fault();					\
-	__chk_user_ptr(ptr);					\
+	__chk_user_ptr(__pu_addr);				\
 	if (do_allow)								\
-		__put_user_size((x), __pu_addr, (size), __pu_err);		\
+		__put_user_size(__pu_val, __pu_addr, __pu_size, __pu_err);	\
 	else									\
-		__put_user_size_allowed((x), __pu_addr, (size), __pu_err);	\
+		__put_user_size_allowed(__pu_val, __pu_addr, __pu_size, __pu_err); \
+								\
 	__pu_err;						\
 })
 
@@ -204,9 +208,13 @@ do {								\
 ({									\
 	long __pu_err = -EFAULT;					\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);			\
+	__typeof__(*(ptr)) __pu_val = (x);				\
+	__typeof__(size) __pu_size = (size);				\
+									\
 	might_fault();							\
-	if (access_ok(VERIFY_WRITE, __pu_addr, size))			\
-		__put_user_size((x), __pu_addr, (size), __pu_err);	\
+	if (access_ok(VERIFY_WRITE, __pu_addr, __pu_size))			\
+		__put_user_size(__pu_val, __pu_addr, __pu_size, __pu_err); \
+									\
 	__pu_err;							\
 })
 
@@ -214,8 +222,12 @@ do {								\
 ({								\
 	long __pu_err;						\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);		\
-	__chk_user_ptr(ptr);					\
-	__put_user_size((x), __pu_addr, (size), __pu_err);	\
+	__typeof__(*(ptr)) __pu_val = (x);			\
+	__typeof__(size) __pu_size = (size);			\
+								\
+	__chk_user_ptr(__pu_addr);				\
+	__put_user_size(__pu_val, __pu_addr, __pu_size, __pu_err); \
+								\
 	__pu_err;						\
 })
 
@@ -289,15 +301,18 @@ do {								\
 	long __gu_err;						\
 	unsigned long __gu_val;					\
 	__typeof__(*(ptr)) __user *__gu_addr = (ptr);	\
-	__chk_user_ptr(ptr);					\
+	__typeof__(size) __gu_size = (size);			\
+								\
+	__chk_user_ptr(__gu_addr);				\
 	if (!is_kernel_addr((unsigned long)__gu_addr))		\
 		might_fault();					\
 	barrier_nospec();					\
 	if (do_allow)								\
-		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);		\
+		__get_user_size(__gu_val, __gu_addr, __gu_size, __gu_err);	\
 	else									\
-		__get_user_size_allowed(__gu_val, __gu_addr, (size), __gu_err);	\
+		__get_user_size_allowed(__gu_val, __gu_addr, __gu_size, __gu_err); \
 	(x) = (__typeof__(*(ptr)))__gu_val;			\
+								\
 	__gu_err;						\
 })
 
@@ -306,12 +321,15 @@ do {								\
 	long __gu_err = -EFAULT;					\
 	unsigned long  __gu_val = 0;					\
 	__typeof__(*(ptr)) __user *__gu_addr = (ptr);		\
+	__typeof__(size) __gu_size = (size);				\
+									\
 	might_fault();							\
-	if (access_ok(VERIFY_READ, __gu_addr, (size))) {		\
+	if (access_ok(VERIFY_READ, __gu_addr, __gu_size)) {		\
 		barrier_nospec();					\
-		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
+		__get_user_size(__gu_val, __gu_addr, __gu_size, __gu_err); \
 	}								\
 	(x) = (__force __typeof__(*(ptr)))__gu_val;				\
+									\
 	__gu_err;							\
 })
 
@@ -320,10 +338,13 @@ do {								\
 	long __gu_err;						\
 	unsigned long __gu_val;					\
 	__typeof__(*(ptr)) __user *__gu_addr = (ptr);	\
-	__chk_user_ptr(ptr);					\
+	__typeof__(size) __gu_size = (size);			\
+								\
+	__chk_user_ptr(__gu_addr);				\
 	barrier_nospec();					\
-	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
+	__get_user_size(__gu_val, __gu_addr, __gu_size, __gu_err); \
 	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
+								\
 	__gu_err;						\
 })
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3957D2B9EF4
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgKSX6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbgKSX6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:58:13 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F3EC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:58:13 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id t37so5629055pga.7
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WRTxiPO0ok1vI94GoN4Oz3ukryy2f2qIAh0OFz41j/M=;
        b=lDbQpZ9NOs4B4Kwzvc6vYlpu3+u2iBoVMZlr0irTqGe/3zajN0eB9ZSQAyhmCw9kMJ
         XxJo+i/YV9g6PPqbNlbjzvmgZzkVqoxVrbXW9q5gbJ9iTElj4iR32mlE17yMUz3b6Hrx
         dl5eYp5HvcMy8PFFDxCTyMzsLapyHnXq5cG8c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WRTxiPO0ok1vI94GoN4Oz3ukryy2f2qIAh0OFz41j/M=;
        b=p4phWxu0Uph6/Ph6R2VY0Li8GRGoMG4j44+ZIypvBiB32xD5CqOAcDkYAv5/Lj/Hb3
         Bgr17g5EqnuvmorrwGO7MGzQKQrC32QYKmkwVgk2uLJDlnfrCxtJr5vBGqGjiQaSD5Na
         DeBD6F3y90njweWnR1QOHa9tf/8IN1S1dHEaoLVAjsYUtVW4eZkzKm/vEJZScHsh3qnw
         U7lxpy5aWzy9ba1rBpcwFDu+Asj3fx7C+TcURMrXTZFuF/UgzW2xrxhxgonALnR/ntzd
         1ms1lx4gSDri+l6eFWAspLRrfN9V/BTKVpPOc8PJfkH2zaR/FkdoSgTTCPJH067BTwI5
         4lrQ==
X-Gm-Message-State: AOAM532fY7j9bMK5kHbX03eV2g1Y3SFBzJlnMt0P4whYMWu0acQR6gci
        llYLll+7rUXphJJy8S0muWwAmz83+dPSyg==
X-Google-Smtp-Source: ABdhPJwax8n3Tgj0lU40jYBIp/Jf+ZCnOxt1Z5kPkMFYPMfQr3ofWXdxNBd1WnfvQtxGxYVkHPqaqA==
X-Received: by 2002:a65:6649:: with SMTP id z9mr14368753pgv.156.1605830292776;
        Thu, 19 Nov 2020 15:58:12 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id x2sm1176706pfp.13.2020.11.19.15.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:58:12 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.9 7/8] powerpc/uaccess: Evaluate macro arguments once, before user access is allowed
Date:   Fri, 20 Nov 2020 10:57:42 +1100
Message-Id: <20201119235743.373635-8-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119235743.373635-1-dja@axtens.net>
References: <20201119235743.373635-1-dja@axtens.net>
MIME-Version: 1.0
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
---
 arch/powerpc/include/asm/uaccess.h | 49 +++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 5fc6a9f410f2..fde865a4e2cb 100644
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
 
-- 
2.25.1


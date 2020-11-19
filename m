Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413B42B9E9E
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgKSXmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgKSXmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:42:31 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096ADC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:42:31 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id t21so5694298pgl.3
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7lw9HVZRzvmNYG22FBPrzZtyW98tcxmjmYt/1ELcXSA=;
        b=PFrq3xUC+2YQ0on7xcRKpK2hGkroMRxaRP1JfsYbPnT/gcnmVz2vLnuHU8/9bKnQlo
         jExwIdld1Ne2S1Rjc9u3nUjNsCm0EJRRpIEed283MV0HTU6TKhC4hE9kwrR0vp/4+WEa
         uXkvW+OXTTdHFOYZ3QhULomVs0PzGR/xRO6bU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7lw9HVZRzvmNYG22FBPrzZtyW98tcxmjmYt/1ELcXSA=;
        b=PRQiPfluQw7ZJ68WftoIcEEQFVu0mXDQCmakngG0nSespY1zz2hbqt3bJkpKog9C0U
         FU9ep0GHBfwJ++8FK4Lyy3SIKz1a7OpnkXvTcHxQwmjyRpS01tKLtzlLDfsl1WxO9SgW
         iInSjYOVLN5oNPMQX4cOWtATHVUPSV0OORC95EO+xiSK3SJX8Cgz0Za1YE+pGGLdQ2KF
         ep5BNXTtXkScWZ9MMoSCtJn1KfD6jGtPv/sPVGQGSczrckySXMS5Gupm8nhF2dP6gphJ
         OCE6vl/rsLXU/wDFOEwtY142ZgvMfmIIOwScNlIT+5Nm2d/Ci94J1/dLc65cgADFbo91
         RXoA==
X-Gm-Message-State: AOAM532eFnciYY6nzB8TejtbKK/sXP9LERFLBqZKBLBlRcdjwFPhUQXN
        A7gyBHlDRUOB/zxRsT+nttSgQIXEc6zP7Q==
X-Google-Smtp-Source: ABdhPJwD39xyTu5SfhOcX9I93L1SJ1K90LmxMXqskwGFJJ1ZXqrbFQEwLX94s9MGZNwvGqStbUdIkQ==
X-Received: by 2002:a17:90a:e603:: with SMTP id j3mr7009588pjy.58.1605829350322;
        Thu, 19 Nov 2020 15:42:30 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id f18sm1113366pfa.167.2020.11.19.15.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:42:29 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.19 6/7] powerpc/uaccess: Evaluate macro arguments once, before user access is allowed
Date:   Fri, 20 Nov 2020 10:42:02 +1100
Message-Id: <20201119234203.370400-7-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119234203.370400-1-dja@axtens.net>
References: <20201119234203.370400-1-dja@axtens.net>
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
index 15d9706a9f9c..ab6612e35ace 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -167,13 +167,17 @@ do {								\
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
 
@@ -181,9 +185,13 @@ do {								\
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
 
@@ -191,8 +199,12 @@ do {								\
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
 
@@ -284,15 +296,18 @@ do {								\
 	long __gu_err;						\
 	__long_type(*(ptr)) __gu_val;				\
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
 
@@ -301,12 +316,15 @@ do {								\
 	long __gu_err = -EFAULT;					\
 	__long_type(*(ptr)) __gu_val = 0;				\
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
 
@@ -315,10 +333,13 @@ do {								\
 	long __gu_err;						\
 	__long_type(*(ptr)) __gu_val;				\
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


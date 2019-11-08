Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A358F54CB
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732943AbfKHSy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:54:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732894AbfKHSy1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:54:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C2842178F;
        Fri,  8 Nov 2019 18:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239266;
        bh=zwYyAJLSObBEsF9dCOOxn6zbulyaGRBnJ+Jk5+Fl4hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynGhRzntsXVJ/YSyVQszQi1DLQBYEMNzCpRoTiFnlueXgjKRRACoex+N1wcHICTqq
         VN9P5Xps5KkAjKVihU4LYGFu88GCMg0dHgc4gLnQmjUbDGaAreXH7FJnF0IZOqF9pC
         KDDny+s0M0NB2eBA5t9R1TpWadW1kcrxknD7o8vY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk, Ard Biesheuvel" 
        <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David A. Long" <dave.long@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 56/75] ARM: use __inttype() in get_user()
Date:   Fri,  8 Nov 2019 19:50:13 +0100
Message-Id: <20191108174758.172101214@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit d09fbb327d670737ab40fd8bbb0765ae06b8b739 upstream.

Borrow the x86 implementation of __inttype() to use in get_user() to
select an integer type suitable to temporarily hold the result value.
This is necessary to avoid propagating the volatile nature of the
result argument, which can cause the following warning:

lib/iov_iter.c:413:5: warning: optimization may eliminate reads and/or writes to register variables [-Wvolatile-register-var]

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/uaccess.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -123,6 +123,13 @@ static inline void set_fs(mm_segment_t f
 	flag; })
 
 /*
+ * This is a type: either unsigned long, if the argument fits into
+ * that type, or otherwise unsigned long long.
+ */
+#define __inttype(x) \
+	__typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
+
+/*
  * Single-value transfer routines.  They automatically use the right
  * size if we just have the right pointer type.  Note that the functions
  * which read from user space (*get_*) need to take care not to leak
@@ -191,7 +198,7 @@ extern int __get_user_64t_4(void *);
 	({								\
 		unsigned long __limit = current_thread_info()->addr_limit - 1; \
 		register const typeof(*(p)) __user *__p asm("r0") = (p);\
-		register typeof(x) __r2 asm("r2");			\
+		register __inttype(x) __r2 asm("r2");			\
 		register unsigned long __l asm("r1") = __limit;		\
 		register int __e asm("r0");				\
 		unsigned int __ua_flags = uaccess_save_and_enable();	\



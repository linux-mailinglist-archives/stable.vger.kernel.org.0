Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3B48F4BE9
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfKHMhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:37:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbfKHMhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:37:18 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 476122245C;
        Fri,  8 Nov 2019 12:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216637;
        bh=h4vs9NF4uH90oYj9MkiodEwh4RctUT/XuHp5FZsThUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3hfSTOOl3lE5SGca8ZKPBik8uzpHhU8N8hvFUoy+PkBAVX+Ai44Js5LVB17yTwlQ
         cVgDi+TAKyHXZw65tzGB2o0CyMSQwOWHdVkRlhctDXkQe36xOcu77sgx6vUVuxSmWb
         tunVkhB2hkzbKwj4OPMhg4cNor5c/7MptMUhr6JM=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Julien Thierry <julien.thierry@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 41/50] ARM: 8795/1: spectre-v1.1: use put_user() for __put_user()
Date:   Fri,  8 Nov 2019 13:35:45 +0100
Message-Id: <20191108123554.29004-42-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Commit e3aa6243434fd9a82e84bb79ab1abd14f2d9a5a7 upstream.

When Spectre mitigation is required, __put_user() needs to include
check_uaccess. This is already the case for put_user(), so just make
__put_user() an alias of put_user().

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/uaccess.h | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 0404dd101331..98bbf89763a6 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -408,6 +408,14 @@ do {									\
 	__pu_err;							\
 })
 
+#ifdef CONFIG_CPU_SPECTRE
+/*
+ * When mitigating Spectre variant 1.1, all accessors need to include
+ * verification of the address space.
+ */
+#define __put_user(x, ptr) put_user(x, ptr)
+
+#else
 #define __put_user(x, ptr)						\
 ({									\
 	long __pu_err = 0;						\
@@ -415,12 +423,6 @@ do {									\
 	__pu_err;							\
 })
 
-#define __put_user_error(x, ptr, err)					\
-({									\
-	__put_user_switch((x), (ptr), (err), __put_user_nocheck);	\
-	(void) 0;							\
-})
-
 #define __put_user_nocheck(x, __pu_ptr, __err, __size)			\
 	do {								\
 		unsigned long __pu_addr = (unsigned long)__pu_ptr;	\
@@ -500,6 +502,7 @@ do {									\
 	: "r" (x), "i" (-EFAULT)				\
 	: "cc")
 
+#endif /* !CONFIG_CPU_SPECTRE */
 
 #ifdef CONFIG_MMU
 extern unsigned long __must_check
-- 
2.20.1


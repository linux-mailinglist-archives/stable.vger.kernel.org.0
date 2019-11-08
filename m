Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 705ACF4BE2
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfKHMhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:37:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbfKHMhG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:37:06 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8C19224F0;
        Fri,  8 Nov 2019 12:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216625;
        bh=53FQ8X91NrEghsOpJRFTqfqKzLnGzfP1FkJ4ahTHjRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBlSwRAt296M+eLPHEeUgfeesLFYaZVyNr7jSSpH88jmywme2eYTQfqOhD+QPMDME
         kybpmSeChaehUFCNbpl863JnZ5tcpjB+e7kX1VPv4Ro+VTRGako1/Gg5p1Y9EJ/2Y9
         H6WK/RYanM/1MQC8Ge6yOYh1Dy+KCzMrHdHiAynk=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 34/50] ARM: spectre-v1: use get_user() for __get_user()
Date:   Fri,  8 Nov 2019 13:35:38 +0100
Message-Id: <20191108123554.29004-35-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit b1cd0a14806321721aae45f5446ed83a3647c914 upstream.

Fixing __get_user() for spectre variant 1 is not sane: we would have to
add address space bounds checking in order to validate that the location
should be accessed, and then zero the address if found to be invalid.

Since __get_user() is supposed to avoid the bounds check, and this is
exactly what get_user() does, there's no point having two different
implementations that are doing the same thing.  So, when the Spectre
workarounds are required, make __get_user() an alias of get_user().

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/uaccess.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 99005567fb92..fd33021da6f6 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -288,6 +288,16 @@ static inline void set_fs(mm_segment_t fs)
 #define user_addr_max() \
 	(segment_eq(get_fs(), KERNEL_DS) ? ~0UL : get_fs())
 
+#ifdef CONFIG_CPU_SPECTRE
+/*
+ * When mitigating Spectre variant 1, it is not worth fixing the non-
+ * verifying accessors, because we need to add verification of the
+ * address space there.  Force these to use the standard get_user()
+ * version instead.
+ */
+#define __get_user(x, ptr) get_user(x, ptr)
+#else
+
 /*
  * The "__xxx" versions of the user access functions do not verify the
  * address space - it must have been done previously with a separate
@@ -304,12 +314,6 @@ static inline void set_fs(mm_segment_t fs)
 	__gu_err;							\
 })
 
-#define __get_user_error(x, ptr, err)					\
-({									\
-	__get_user_err((x), (ptr), err);				\
-	(void) 0;							\
-})
-
 #define __get_user_err(x, ptr, err)					\
 do {									\
 	unsigned long __gu_addr = (unsigned long)(ptr);			\
@@ -369,6 +373,7 @@ do {									\
 
 #define __get_user_asm_word(x, addr, err)			\
 	__get_user_asm(x, addr, err, ldr)
+#endif
 
 
 #define __put_user_switch(x, ptr, __err, __fn)				\
-- 
2.20.1


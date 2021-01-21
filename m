Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DB22FE176
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 06:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbhAUFTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 00:19:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:46856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbhAUFKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 00:10:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82A66238EE;
        Thu, 21 Jan 2021 05:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611205794;
        bh=7DNRp6WNtdeilktzFhBTnZxvvhrAqZFiRFv1t5H9vSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnylOiFr8w6hafHWQ24ixd1sGaIIF+W+WI8k4G9lOH9xGHk2vAm6reHp/IyB2L+wr
         +sCyoVNPPGmi+PSoM/yEshqdiNlRtiNxRLltdnvJybLHI7jwUx5bnvJeo9CHZp7hue
         WHIVpwGAcf9kSOxDLoAQATzUtStvmR522esE2XNmrRdCJaDOLyjD+xyna8WhZj9n1R
         YjAIECbqjYQ5fy7DG/3bj3KBsUFHfIy3HB4AWcQjPdpuNQNpMeLLzDEeAkPeNroN0K
         5lLYuoAmJv2x8NipNa3WOLP8GLaYGRNN3lkD/vGl3Mkvmctl4ovvJVuzJQcwmkNbE5
         LZ1o7lQKFEhaQ==
From:   Andy Lutomirski <luto@kernel.org>
To:     x86@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        =?UTF-8?q?Krzysztof=20Ol=C4=99dzki?= <ole@ans.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v3 2/4] x86/mmx: Use KFPU_387 for MMX string operations
Date:   Wed, 20 Jan 2021 21:09:49 -0800
Message-Id: <e7bf21855fe99e5f3baa27446e32623358f69e8d.1611205691.git.luto@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611205691.git.luto@kernel.org>
References: <cover.1611205691.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The default kernel_fpu_begin() doesn't work on systems that support XMM but
haven't yet enabled CR4.OSFXSR.  This causes crashes when _mmx_memcpy() is
called too early because LDMXCSR generates #UD when the aforementioned bit
is clear.

Fix it by using kernel_fpu_begin_mask(KFPU_387) explicitly.

Fixes: 7ad816762f9b ("x86/fpu: Reset MXCSR to default in kernel_fpu_begin()")
Cc: <stable@vger.kernel.org>
Reported-by: Krzysztof Mazur <krzysiek@podlesie.net>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/lib/mmx_32.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/lib/mmx_32.c b/arch/x86/lib/mmx_32.c
index 4321fa02e18d..ad1dabce931e 100644
--- a/arch/x86/lib/mmx_32.c
+++ b/arch/x86/lib/mmx_32.c
@@ -26,6 +26,16 @@
 #include <asm/fpu/api.h>
 #include <asm/asm.h>
 
+/*
+ * Use KFPU_387.  MMX instructions are not affected by MXCSR,
+ * but both AMD and Intel documentation states that even integer MMX
+ * operations will result in #MF if an exception is pending in FCW.
+ *
+ * EMMS is not needed afterwards because, after we call kernel_fpu_end(),
+ * any subsequent user of the 387 stack will reinitialize it using
+ * KFPU_387.
+ */
+
 void *_mmx_memcpy(void *to, const void *from, size_t len)
 {
 	void *p;
@@ -37,7 +47,7 @@ void *_mmx_memcpy(void *to, const void *from, size_t len)
 	p = to;
 	i = len >> 6; /* len/64 */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(KFPU_387);
 
 	__asm__ __volatile__ (
 		"1: prefetch (%0)\n"		/* This set is 28 bytes */
@@ -127,7 +137,7 @@ static void fast_clear_page(void *page)
 {
 	int i;
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(KFPU_387);
 
 	__asm__ __volatile__ (
 		"  pxor %%mm0, %%mm0\n" : :
@@ -160,7 +170,7 @@ static void fast_copy_page(void *to, void *from)
 {
 	int i;
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(KFPU_387);
 
 	/*
 	 * maybe the prefetch stuff can go before the expensive fnsave...
@@ -247,7 +257,7 @@ static void fast_clear_page(void *page)
 {
 	int i;
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(KFPU_387);
 
 	__asm__ __volatile__ (
 		"  pxor %%mm0, %%mm0\n" : :
@@ -282,7 +292,7 @@ static void fast_copy_page(void *to, void *from)
 {
 	int i;
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(KFPU_387);
 
 	__asm__ __volatile__ (
 		"1: prefetch (%0)\n"
-- 
2.29.2


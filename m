Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE55302A9E
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbhAYSqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:46:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbhAYSqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:46:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40D7A221E7;
        Mon, 25 Jan 2021 18:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600314;
        bh=Hz/PhX6BP8NQZxm3lsKRW4iLuewYuhA1lT9S6nwoeSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGyJWia/utqjrdGzOSkqemezVBkmLJSB4cfWq1RyxU9bI7HOBE85A7D+HUvIMzkrH
         l9k3Tx9e2/ogoYofM88hMqZ5WgJyY0OMsbFiYz6tgX5voxCUTnAfC9EMajwfIpN78f
         QFuBcFdLqrXUfmDH+OxOkKncY1SDLtSy1pMU94RI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Mazur <krzysiek@podlesie.net>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        =?UTF-8?q?Krzysztof=20Piotr=20Ol=C4=99dzki?= <ole@ans.pl>
Subject: [PATCH 5.4 55/86] x86/mmx: Use KFPU_387 for MMX string operations
Date:   Mon, 25 Jan 2021 19:39:37 +0100
Message-Id: <20210125183203.376765980@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 67de8dca50c027ca0fa3b62a488ee5035036a0da upstream.

The default kernel_fpu_begin() doesn't work on systems that support XMM but
haven't yet enabled CR4.OSFXSR.  This causes crashes when _mmx_memcpy() is
called too early because LDMXCSR generates #UD when the aforementioned bit
is clear.

Fix it by using kernel_fpu_begin_mask(KFPU_387) explicitly.

Fixes: 7ad816762f9b ("x86/fpu: Reset MXCSR to default in kernel_fpu_begin()")
Reported-by: Krzysztof Mazur <krzysiek@podlesie.net>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Krzysztof Piotr Olędzki <ole@ans.pl>
Tested-by: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/e7bf21855fe99e5f3baa27446e32623358f69e8d.1611205691.git.luto@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/lib/mmx_32.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

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
+ * EMMS is not needed afterwards because, after calling kernel_fpu_end(),
+ * any subsequent user of the 387 stack will reinitialize it using
+ * KFPU_387.
+ */
+
 void *_mmx_memcpy(void *to, const void *from, size_t len)
 {
 	void *p;
@@ -37,7 +47,7 @@ void *_mmx_memcpy(void *to, const void *
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
@@ -160,7 +170,7 @@ static void fast_copy_page(void *to, voi
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
@@ -282,7 +292,7 @@ static void fast_copy_page(void *to, voi
 {
 	int i;
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(KFPU_387);
 
 	__asm__ __volatile__ (
 		"1: prefetch (%0)\n"



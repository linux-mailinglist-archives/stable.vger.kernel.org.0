Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CED2FECEE
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 15:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730314AbhAUOcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 09:32:31 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:47646 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbhAUO1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 09:27:38 -0500
Date:   Thu, 21 Jan 2021 14:26:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611239203;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bzwjVho+2OyP/AQhkMHO4a5VDsFSHtORj/v+BApyk2w=;
        b=tBiSockZ6FVIS6nYW9hEyprszqdTBJwi+EvqOEopg5wlJ7npK8AdgRwC20l3SuYBPuBxQx
        TQcjnlF6VXqA+ZhoOdT0eizhYaVAmN8vbpxqpJ8PoS+ljgBiUGUJ0YhVNodDV9Uo3u3b/T
        dnp7bQBXLvZHvqnW/c0T6tgk6Jdk12ohcbb0JZTfeyif9HnIoK1PpP5jxHMzJ3qAXOCJ2j
        UN1WlV8RCrt9z57aIYTPOOhf+bvVVVxHEQDStcjRXFTL9ELazkiaSiVqR+lHJTccHQ1xaL
        w9DvlfaoBFKcbURao39wTo8TI8MUaDu4uPFDd6mxugoWscjwh93WfhyJ8adEnQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611239203;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bzwjVho+2OyP/AQhkMHO4a5VDsFSHtORj/v+BApyk2w=;
        b=DMQC3xGhgarpWroOd79NaZywI90ew7aqUOJJtd53d0rp4MJHDMpyl4gX0THGo1/FGeg1TU
        RGBAYYLK9y4AqeAQ==
From:   "tip-bot2 for Andy Lutomirski" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/mmx: Use KFPU_387 for MMX string operations
Cc:     Krzysztof Mazur <krzysiek@podlesie.net>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>, ole@ans.pl,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <e7bf21855fe99e5f3baa27446e32623358f69e8d.1611205691.git.luto@kernel.org>
References: <e7bf21855fe99e5f3baa27446e32623358f69e8d.1611205691.git.luto@kernel.org>
MIME-Version: 1.0
Message-ID: <161123920300.414.18251492577685466357.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     67de8dca50c027ca0fa3b62a488ee5035036a0da
Gitweb:        https://git.kernel.org/tip/67de8dca50c027ca0fa3b62a488ee503503=
6a0da
Author:        Andy Lutomirski <luto@kernel.org>
AuthorDate:    Wed, 20 Jan 2021 21:09:49 -08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Thu, 21 Jan 2021 13:39:36 +01:00

x86/mmx: Use KFPU_387 for MMX string operations

The default kernel_fpu_begin() doesn't work on systems that support XMM but
haven't yet enabled CR4.OSFXSR.  This causes crashes when _mmx_memcpy() is
called too early because LDMXCSR generates #UD when the aforementioned bit
is clear.

Fix it by using kernel_fpu_begin_mask(KFPU_387) explicitly.

Fixes: 7ad816762f9b ("x86/fpu: Reset MXCSR to default in kernel_fpu_begin()")
Reported-by: Krzysztof Mazur <krzysiek@podlesie.net>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Krzysztof Piotr Ol=C4=99dzki <ole@ans.pl>
Tested-by: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/e7bf21855fe99e5f3baa27446e32623358f69e8d.1611=
205691.git.luto@kernel.org
---
 arch/x86/lib/mmx_32.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/lib/mmx_32.c b/arch/x86/lib/mmx_32.c
index 4321fa0..419365c 100644
--- a/arch/x86/lib/mmx_32.c
+++ b/arch/x86/lib/mmx_32.c
@@ -26,6 +26,16 @@
 #include <asm/fpu/api.h>
 #include <asm/asm.h>
=20
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
@@ -37,7 +47,7 @@ void *_mmx_memcpy(void *to, const void *from, size_t len)
 	p =3D to;
 	i =3D len >> 6; /* len/64 */
=20
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(KFPU_387);
=20
 	__asm__ __volatile__ (
 		"1: prefetch (%0)\n"		/* This set is 28 bytes */
@@ -127,7 +137,7 @@ static void fast_clear_page(void *page)
 {
 	int i;
=20
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(KFPU_387);
=20
 	__asm__ __volatile__ (
 		"  pxor %%mm0, %%mm0\n" : :
@@ -160,7 +170,7 @@ static void fast_copy_page(void *to, void *from)
 {
 	int i;
=20
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(KFPU_387);
=20
 	/*
 	 * maybe the prefetch stuff can go before the expensive fnsave...
@@ -247,7 +257,7 @@ static void fast_clear_page(void *page)
 {
 	int i;
=20
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(KFPU_387);
=20
 	__asm__ __volatile__ (
 		"  pxor %%mm0, %%mm0\n" : :
@@ -282,7 +292,7 @@ static void fast_copy_page(void *to, void *from)
 {
 	int i;
=20
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(KFPU_387);
=20
 	__asm__ __volatile__ (
 		"1: prefetch (%0)\n"

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D0238AD46
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 14:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241822AbhETMBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 08:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241924AbhETMAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 08:00:52 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4F8C04FF32;
        Thu, 20 May 2021 03:22:21 -0700 (PDT)
Date:   Thu, 20 May 2021 10:22:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621506139;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IB5WzEny1VMFztKI/99vS1hgVslzBteBSCM3j6Jl6P8=;
        b=RjTutPHA9BN4olBfxAtmwR9szJ+hrDlIc4QumZx2b8Jup330HvXbS0UoJOGdF940K+obfS
        dWiAuPre3m3JWwrnnbcQbm2TiqRucJIRmpTvZnOtj1P7n4m6oRMtaOiaIPKpEXF9pD8xHm
        xuTZVhgNtilCddHrDFD/C+7q+1ZMmerK8m6c7/wQXxiEFUl3JsXU4GS+8oiTm38Xjg12ca
        mbP2n13jQ14XXtgTqmknnX/4hudlAgUMeOduHGLu5LmxBj6RqujnDYC+s4QdSLfF52oQs/
        LVO2EE2aMUu2KdjFYp070V1CIUjUW4qLOWDrNDC0Q1PVBgeYtfHqw6Rsg5Wrkw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621506139;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IB5WzEny1VMFztKI/99vS1hgVslzBteBSCM3j6Jl6P8=;
        b=9U4K/E3zYbkPZFgmIbKXY+Iyl3xc8yc43UcXBMYen+DY0+jvKYmQ3rF8GHIlihG09gHerN
        5J2acNOIGCeCi9Bg==
From:   "tip-bot2 for Joerg Roedel" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sev-es: Use __put_user()/__get_user() for data accesses
Cc:     Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        v5.10+@tip-bot2.tec.linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210519135251.30093-4-joro@8bytes.org>
References: <20210519135251.30093-4-joro@8bytes.org>
MIME-Version: 1.0
Message-ID: <162150613809.29796.2550841094526532766.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     4954f5b8ef0baf70fe978d1a99a5f70e4dd5c877
Gitweb:        https://git.kernel.org/tip/4954f5b8ef0baf70fe978d1a99a5f70e4dd5c877
Author:        Joerg Roedel <jroedel@suse.de>
AuthorDate:    Wed, 19 May 2021 15:52:46 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 19 May 2021 18:45:37 +02:00

x86/sev-es: Use __put_user()/__get_user() for data accesses

The put_user() and get_user() functions do checks on the address which is
passed to them. They check whether the address is actually a user-space
address and whether its fine to access it. They also call might_fault()
to indicate that they could fault and possibly sleep.

All of these checks are neither wanted nor needed in the #VC exception
handler, which can be invoked from almost any context and also for MMIO
instructions from kernel space on kernel memory. All the #VC handler
wants to know is whether a fault happened when the access was tried.

This is provided by __put_user()/__get_user(), which just do the access
no matter what. Also add comments explaining why __get_user() and
__put_user() are the best choice here and why it is safe to use them
in this context. Also explain why copy_to/from_user can't be used.

In addition, also revert commit

  7024f60d6552 ("x86/sev-es: Handle string port IO to kernel memory properly")

because using __get_user()/__put_user() fixes the same problem while
the above commit introduced several problems:

  1) It uses access_ok() which is only allowed in task context.

  2) It uses memcpy() which has no fault handling at all and is
     thus unsafe to use here.

  [ bp: Fix up commit ID of the reverted commit above. ]

Fixes: f980f9c31a92 ("x86/sev-es: Compile early handler code into kernel image")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # v5.10+
Link: https://lkml.kernel.org/r/20210519135251.30093-4-joro@8bytes.org
---
 arch/x86/kernel/sev.c | 66 +++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 1f428f4..651b81c 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -315,31 +315,44 @@ static enum es_result vc_write_mem(struct es_em_ctxt *ctxt,
 	u16 d2;
 	u8  d1;
 
-	/* If instruction ran in kernel mode and the I/O buffer is in kernel space */
-	if (!user_mode(ctxt->regs) && !access_ok(target, size)) {
-		memcpy(dst, buf, size);
-		return ES_OK;
-	}
-
+	/*
+	 * This function uses __put_user() independent of whether kernel or user
+	 * memory is accessed. This works fine because __put_user() does no
+	 * sanity checks of the pointer being accessed. All that it does is
+	 * to report when the access failed.
+	 *
+	 * Also, this function runs in atomic context, so __put_user() is not
+	 * allowed to sleep. The page-fault handler detects that it is running
+	 * in atomic context and will not try to take mmap_sem and handle the
+	 * fault, so additional pagefault_enable()/disable() calls are not
+	 * needed.
+	 *
+	 * The access can't be done via copy_to_user() here because
+	 * vc_write_mem() must not use string instructions to access unsafe
+	 * memory. The reason is that MOVS is emulated by the #VC handler by
+	 * splitting the move up into a read and a write and taking a nested #VC
+	 * exception on whatever of them is the MMIO access. Using string
+	 * instructions here would cause infinite nesting.
+	 */
 	switch (size) {
 	case 1:
 		memcpy(&d1, buf, 1);
-		if (put_user(d1, target))
+		if (__put_user(d1, target))
 			goto fault;
 		break;
 	case 2:
 		memcpy(&d2, buf, 2);
-		if (put_user(d2, target))
+		if (__put_user(d2, target))
 			goto fault;
 		break;
 	case 4:
 		memcpy(&d4, buf, 4);
-		if (put_user(d4, target))
+		if (__put_user(d4, target))
 			goto fault;
 		break;
 	case 8:
 		memcpy(&d8, buf, 8);
-		if (put_user(d8, target))
+		if (__put_user(d8, target))
 			goto fault;
 		break;
 	default:
@@ -370,30 +383,43 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
 	u16 d2;
 	u8  d1;
 
-	/* If instruction ran in kernel mode and the I/O buffer is in kernel space */
-	if (!user_mode(ctxt->regs) && !access_ok(s, size)) {
-		memcpy(buf, src, size);
-		return ES_OK;
-	}
-
+	/*
+	 * This function uses __get_user() independent of whether kernel or user
+	 * memory is accessed. This works fine because __get_user() does no
+	 * sanity checks of the pointer being accessed. All that it does is
+	 * to report when the access failed.
+	 *
+	 * Also, this function runs in atomic context, so __get_user() is not
+	 * allowed to sleep. The page-fault handler detects that it is running
+	 * in atomic context and will not try to take mmap_sem and handle the
+	 * fault, so additional pagefault_enable()/disable() calls are not
+	 * needed.
+	 *
+	 * The access can't be done via copy_from_user() here because
+	 * vc_read_mem() must not use string instructions to access unsafe
+	 * memory. The reason is that MOVS is emulated by the #VC handler by
+	 * splitting the move up into a read and a write and taking a nested #VC
+	 * exception on whatever of them is the MMIO access. Using string
+	 * instructions here would cause infinite nesting.
+	 */
 	switch (size) {
 	case 1:
-		if (get_user(d1, s))
+		if (__get_user(d1, s))
 			goto fault;
 		memcpy(buf, &d1, 1);
 		break;
 	case 2:
-		if (get_user(d2, s))
+		if (__get_user(d2, s))
 			goto fault;
 		memcpy(buf, &d2, 2);
 		break;
 	case 4:
-		if (get_user(d4, s))
+		if (__get_user(d4, s))
 			goto fault;
 		memcpy(buf, &d4, 4);
 		break;
 	case 8:
-		if (get_user(d8, s))
+		if (__get_user(d8, s))
 			goto fault;
 		memcpy(buf, &d8, 8);
 		break;

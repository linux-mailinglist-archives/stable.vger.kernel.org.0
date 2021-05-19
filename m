Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B14388F81
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 15:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353779AbhESNyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 09:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353776AbhESNyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 09:54:32 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8C0C06175F;
        Wed, 19 May 2021 06:53:12 -0700 (PDT)
Received: from cap.home.8bytes.org (p549ad305.dip0.t-ipconnect.de [84.154.211.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 9D3EB416;
        Wed, 19 May 2021 15:53:09 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org, Hyunwook Baek <baekhw@google.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH v2 3/8] x86/sev-es: Use __put_user()/__get_user() for data accesses
Date:   Wed, 19 May 2021 15:52:46 +0200
Message-Id: <20210519135251.30093-4-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519135251.30093-1-joro@8bytes.org>
References: <20210519135251.30093-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

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

	024f60d6552 x86/sev-es: ("Handle string port IO to kernel memory properly")

because using __get_user()/__put_user() fixes the same problem while
the above commit introduced several problems:

	1) It uses access_ok() which is only allowed in task context.

	2) It uses memcpy() which has no fault handling at all and is
	   thus unsafe to use here.

Fixes: f980f9c31a92 ("x86/sev-es: Compile early handler code into kernel image")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev.c | 66 ++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 1f428f401bed..651b81cd648e 100644
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
-- 
2.31.1


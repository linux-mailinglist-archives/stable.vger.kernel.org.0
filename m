Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A20D10BB66
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733265AbfK0VMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:12:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:42196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733264AbfK0VMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:12:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CC48217BC;
        Wed, 27 Nov 2019 21:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889127;
        bh=k6AYE9IRxjT7DXWWP/QLm26U5fRTVcN27W+J5Ij7gIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wivpTDMSayhN4xSYshWk4s0eU2lcYqE30EWe2cppOqvlUOD982orFsEDyrpjfqIwK
         RvHj5orVh/klxY0gen4LawC03Db2jmhJ+M0d+dWju7iLQ2iOk4KQuOxRZ8gq7O8UjE
         zrx/8wNeiZ8RFMFosSi+DEk/sQf3rec+hi7pbkUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.3 51/95] x86/stackframe/32: Repair 32-bit Xen PV
Date:   Wed, 27 Nov 2019 21:32:08 +0100
Message-Id: <20191127202918.214267481@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit 81ff2c37f9e5d77593928df0536d86443195fd64 upstream.

Once again RPL checks have been introduced which don't account for a 32-bit
kernel living in ring 1 when running in a PV Xen domain. The case in
FIXUP_FRAME has been preventing boot.

Adjust BUG_IF_WRONG_CR3 as well to guard against future uses of the macro
on a code path reachable when running in PV mode under Xen; I have to admit
that I stopped at a certain point trying to figure out whether there are
present ones.

Fixes: 3c88c692c287 ("x86/stackframe/32: Provide consistent pt_regs")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Stable Team <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/0fad341f-b7f5-f859-d55d-f0084ee7087e@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_32.S      |    4 ++--
 arch/x86/include/asm/segment.h |   12 ++++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -172,7 +172,7 @@
 	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_PTI
 	.if \no_user_check == 0
 	/* coming from usermode? */
-	testl	$SEGMENT_RPL_MASK, PT_CS(%esp)
+	testl	$USER_SEGMENT_RPL_MASK, PT_CS(%esp)
 	jz	.Lend_\@
 	.endif
 	/* On user-cr3? */
@@ -217,7 +217,7 @@
 	testl	$X86_EFLAGS_VM, 4*4(%esp)
 	jnz	.Lfrom_usermode_no_fixup_\@
 #endif
-	testl	$SEGMENT_RPL_MASK, 3*4(%esp)
+	testl	$USER_SEGMENT_RPL_MASK, 3*4(%esp)
 	jnz	.Lfrom_usermode_no_fixup_\@
 
 	orl	$CS_FROM_KERNEL, 3*4(%esp)
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -31,6 +31,18 @@
  */
 #define SEGMENT_RPL_MASK	0x3
 
+/*
+ * When running on Xen PV, the actual privilege level of the kernel is 1,
+ * not 0. Testing the Requested Privilege Level in a segment selector to
+ * determine whether the context is user mode or kernel mode with
+ * SEGMENT_RPL_MASK is wrong because the PV kernel's privilege level
+ * matches the 0x3 mask.
+ *
+ * Testing with USER_SEGMENT_RPL_MASK is valid for both native and Xen PV
+ * kernels because privilege level 2 is never used.
+ */
+#define USER_SEGMENT_RPL_MASK	0x2
+
 /* User mode is privilege level 3: */
 #define USER_RPL		0x3
 



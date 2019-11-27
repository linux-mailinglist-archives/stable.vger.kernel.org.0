Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4F1E10BBEC
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731756AbfK0VNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:13:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387419AbfK0VNF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:13:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64C5E2154A;
        Wed, 27 Nov 2019 21:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889184;
        bh=uO8J9GrsInOqTtJumeYPqJ41rEgZjMm0EPfbFPPGY0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENAPP8cGYyxMpGML2MVCCcC92Xye/rBmz8zRPIOkSA1vQE7dv9fr13lPUe/l7duMu
         XRAyPJk+vhtWa66Qk76zNPFFFo8B2+WYjzgMok0jvQ8jJZzSBTzSzopgxIxhCJ/BA8
         Z2fWuw5q5E5umMwhD3LBkCkPmw1q9vSziX+hsao4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>, stable@kernel.org
Subject: [PATCH 5.4 21/66] x86/entry/32: Move FIXUP_FRAME after pushing %fs in SAVE_ALL
Date:   Wed, 27 Nov 2019 21:32:16 +0100
Message-Id: <20191127202656.074211218@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 82cb8a0b1d8d07817b5d59f7fa1438e1fceafab2 upstream.

This will allow us to get percpu access working before FIXUP_FRAME,
which will allow us to unwind ESPFIX earlier.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_32.S |   66 ++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -213,54 +213,58 @@
 	 *
 	 * Be careful: we may have nonzero SS base due to ESPFIX.
 	 */
-	andl	$0x0000ffff, 3*4(%esp)
+	andl	$0x0000ffff, 4*4(%esp)
 
 #ifdef CONFIG_VM86
-	testl	$X86_EFLAGS_VM, 4*4(%esp)
+	testl	$X86_EFLAGS_VM, 5*4(%esp)
 	jnz	.Lfrom_usermode_no_fixup_\@
 #endif
-	testl	$USER_SEGMENT_RPL_MASK, 3*4(%esp)
+	testl	$USER_SEGMENT_RPL_MASK, 4*4(%esp)
 	jnz	.Lfrom_usermode_no_fixup_\@
 
-	orl	$CS_FROM_KERNEL, 3*4(%esp)
+	orl	$CS_FROM_KERNEL, 4*4(%esp)
 
 	/*
 	 * When we're here from kernel mode; the (exception) stack looks like:
 	 *
-	 *  5*4(%esp) - <previous context>
-	 *  4*4(%esp) - flags
-	 *  3*4(%esp) - cs
-	 *  2*4(%esp) - ip
-	 *  1*4(%esp) - orig_eax
-	 *  0*4(%esp) - gs / function
+	 *  6*4(%esp) - <previous context>
+	 *  5*4(%esp) - flags
+	 *  4*4(%esp) - cs
+	 *  3*4(%esp) - ip
+	 *  2*4(%esp) - orig_eax
+	 *  1*4(%esp) - gs / function
+	 *  0*4(%esp) - fs
 	 *
 	 * Lets build a 5 entry IRET frame after that, such that struct pt_regs
 	 * is complete and in particular regs->sp is correct. This gives us
-	 * the original 5 enties as gap:
+	 * the original 6 enties as gap:
 	 *
-	 * 12*4(%esp) - <previous context>
-	 * 11*4(%esp) - gap / flags
-	 * 10*4(%esp) - gap / cs
-	 *  9*4(%esp) - gap / ip
-	 *  8*4(%esp) - gap / orig_eax
-	 *  7*4(%esp) - gap / gs / function
-	 *  6*4(%esp) - ss
-	 *  5*4(%esp) - sp
-	 *  4*4(%esp) - flags
-	 *  3*4(%esp) - cs
-	 *  2*4(%esp) - ip
-	 *  1*4(%esp) - orig_eax
-	 *  0*4(%esp) - gs / function
+	 * 14*4(%esp) - <previous context>
+	 * 13*4(%esp) - gap / flags
+	 * 12*4(%esp) - gap / cs
+	 * 11*4(%esp) - gap / ip
+	 * 10*4(%esp) - gap / orig_eax
+	 *  9*4(%esp) - gap / gs / function
+	 *  8*4(%esp) - gap / fs
+	 *  7*4(%esp) - ss
+	 *  6*4(%esp) - sp
+	 *  5*4(%esp) - flags
+	 *  4*4(%esp) - cs
+	 *  3*4(%esp) - ip
+	 *  2*4(%esp) - orig_eax
+	 *  1*4(%esp) - gs / function
+	 *  0*4(%esp) - fs
 	 */
 
 	pushl	%ss		# ss
 	pushl	%esp		# sp (points at ss)
-	addl	$6*4, (%esp)	# point sp back at the previous context
-	pushl	6*4(%esp)	# flags
-	pushl	6*4(%esp)	# cs
-	pushl	6*4(%esp)	# ip
-	pushl	6*4(%esp)	# orig_eax
-	pushl	6*4(%esp)	# gs / function
+	addl	$7*4, (%esp)	# point sp back at the previous context
+	pushl	7*4(%esp)	# flags
+	pushl	7*4(%esp)	# cs
+	pushl	7*4(%esp)	# ip
+	pushl	7*4(%esp)	# orig_eax
+	pushl	7*4(%esp)	# gs / function
+	pushl	7*4(%esp)	# fs
 .Lfrom_usermode_no_fixup_\@:
 .endm
 
@@ -308,8 +312,8 @@
 .if \skip_gs == 0
 	PUSH_GS
 .endif
-	FIXUP_FRAME
 	pushl	%fs
+	FIXUP_FRAME
 	pushl	%es
 	pushl	%ds
 	pushl	\pt_regs_ax



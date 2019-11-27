Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D9E10BB7B
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387412AbfK0VND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:13:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387406AbfK0VNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:13:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFE73217F9;
        Wed, 27 Nov 2019 21:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889182;
        bh=Xm1l4jck4nbnQDoioOAsUALDtTZS1OsKdbYJlQLPRdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1dHAwH+ONp1QzF3PHF5Wmt4sF6KGglBQ9t7Cpf1o7ASIlOaAtz7Z0dl8oEfjrPGU
         9jUJyZbkpsRKProigj+rSUQRNFIAAsZFkViqT1ZrLdJUl9zSzN2w/XQPy/omomwoT2
         Eu2L0EeyS2gEA7sDEH+aZ4On0N3j9PKxcmGEt2H4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>, stable@kernel.org
Subject: [PATCH 5.4 20/66] x86/entry/32: Use %ss segment where required
Date:   Wed, 27 Nov 2019 21:32:15 +0100
Message-Id: <20191127202655.050736858@linuxfoundation.org>
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

commit 4c4fd55d3d59a41ddfa6ecba7e76928921759f43 upstream.

When re-building the IRET frame we use %eax as an destination %esp,
make sure to then also match the segment for when there is a nonzero
SS base (ESPFIX).

[peterz: Changelog and minor edits]
Fixes: 3c88c692c287 ("x86/stackframe/32: Provide consistent pt_regs")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_32.S |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -210,6 +210,8 @@
 	/*
 	 * The high bits of the CS dword (__csh) are used for CS_FROM_*.
 	 * Clear them in case hardware didn't do this for us.
+	 *
+	 * Be careful: we may have nonzero SS base due to ESPFIX.
 	 */
 	andl	$0x0000ffff, 3*4(%esp)
 
@@ -263,6 +265,13 @@
 .endm
 
 .macro IRET_FRAME
+	/*
+	 * We're called with %ds, %es, %fs, and %gs from the interrupted
+	 * frame, so we shouldn't use them.  Also, we may be in ESPFIX
+	 * mode and therefore have a nonzero SS base and an offset ESP,
+	 * so any attempt to access the stack needs to use SS.  (except for
+	 * accesses through %esp, which automatically use SS.)
+	 */
 	testl $CS_FROM_KERNEL, 1*4(%esp)
 	jz .Lfinished_frame_\@
 
@@ -276,20 +285,20 @@
 	movl	5*4(%esp), %eax		# (modified) regs->sp
 
 	movl	4*4(%esp), %ecx		# flags
-	movl	%ecx, -4(%eax)
+	movl	%ecx, %ss:-1*4(%eax)
 
 	movl	3*4(%esp), %ecx		# cs
 	andl	$0x0000ffff, %ecx
-	movl	%ecx, -8(%eax)
+	movl	%ecx, %ss:-2*4(%eax)
 
 	movl	2*4(%esp), %ecx		# ip
-	movl	%ecx, -12(%eax)
+	movl	%ecx, %ss:-3*4(%eax)
 
 	movl	1*4(%esp), %ecx		# eax
-	movl	%ecx, -16(%eax)
+	movl	%ecx, %ss:-4*4(%eax)
 
 	popl	%ecx
-	lea	-16(%eax), %esp
+	lea	-4*4(%eax), %esp
 	popl	%eax
 .Lfinished_frame_\@:
 .endm



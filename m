Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBD110BB2D
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733021AbfK0VKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:10:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733012AbfK0VKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:10:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D01D321555;
        Wed, 27 Nov 2019 21:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889019;
        bh=8dLYzmD6yVg83Y8rOOwXkUvVYdDu+qUDgfphnIUNfzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgSsqEpxPQ+Khjv3SYMFs6/+wko1IbuzsvhmchI1JegDK0vda+dfPHWSuGyonqrj6
         flWByCJDKsgvm/E5cgGgNgRMU6207gEC4Pnl/jMPwDMQFTEgIjd3TAxQOFRVYifsFI
         aos5cWyNo4amyi9/y7Ro8Zpk0VDfkqsgFOuPaNhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.3 53/95] x86/xen/32: Simplify ring check in xen_iret_crit_fixup()
Date:   Wed, 27 Nov 2019 21:32:10 +0100
Message-Id: <20191127202919.224124606@linuxfoundation.org>
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

commit 922eea2ce5c799228d9ff1be9890e6873ce8fff6 upstream.

This can be had with two instead of six insns, by just checking the high
CS.RPL bit.

Also adjust the comment - there would be no #GP in the mentioned cases, as
there's no segment limit violation or alike. Instead there'd be #PF, but
that one reports the target EIP of said branch, not the address of the
branch insn itself.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lkml.kernel.org/r/a5986837-01eb-7bf8-bf42-4d3084d6a1f5@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/xen-asm_32.S |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -153,22 +153,15 @@ hyper_iret:
  * it's still on stack), we need to restore its value here.
  */
 ENTRY(xen_iret_crit_fixup)
-	pushl %ecx
 	/*
 	 * Paranoia: Make sure we're really coming from kernel space.
 	 * One could imagine a case where userspace jumps into the
 	 * critical range address, but just before the CPU delivers a
-	 * GP, it decides to deliver an interrupt instead.  Unlikely?
-	 * Definitely.  Easy to avoid?  Yes.  The Intel documents
-	 * explicitly say that the reported EIP for a bad jump is the
-	 * jump instruction itself, not the destination, but some
-	 * virtual environments get this wrong.
+	 * PF, it decides to deliver an interrupt instead.  Unlikely?
+	 * Definitely.  Easy to avoid?  Yes.
 	 */
-	movl 3*4(%esp), %ecx		/* nested CS */
-	andl $SEGMENT_RPL_MASK, %ecx
-	cmpl $USER_RPL, %ecx
-	popl %ecx
-	je 2f
+	testb $2, 2*4(%esp)		/* nested CS */
+	jnz 2f
 
 	/*
 	 * If eip is before iret_restore_end then stack



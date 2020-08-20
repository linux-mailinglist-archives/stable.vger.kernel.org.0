Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE8924B240
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgHTJ0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:26:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727794AbgHTJZq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:25:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1931D21744;
        Thu, 20 Aug 2020 09:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915533;
        bh=n3so6R77g/5ICdm/NwPemyOsyMTa3kJfmjr8hXCUdWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wdHWT5co0vcM4rcUH3UguFPUP7w2fA+awdzS0nVpC0bxFJdYFNPNYsM63AJsuSGII
         Xt6JcKsjW94B/rYikXbxSiRj7rQr3gfcsgTivrzRRaac0wDL05CvETyEkahu1ECAS7
         IiOog94Wt+TTdYnMfzcTuuI74E44S0WEATsbShH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.8 047/232] xtensa: add missing exclusive access state management
Date:   Thu, 20 Aug 2020 11:18:18 +0200
Message-Id: <20200820091615.060069169@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit a0fc1436f1f4f84e93144480bf30e0c958d135b6 upstream.

The result of the s32ex opcode is recorded in the ATOMCTL special
register and must be retrieved with the getex opcode. Context switch
between s32ex and getex may trash the ATOMCTL register and result in
duplicate update or missing update of the atomic variable.
Add atomctl8 field to the struct thread_info and use getex to swap
ATOMCTL bit 8 as a part of context switch.
Clear exclusive access monitor on kernel entry.

Cc: stable@vger.kernel.org
Fixes: f7c34874f04a ("xtensa: add exclusive atomics support")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/include/asm/thread_info.h |    4 ++++
 arch/xtensa/kernel/asm-offsets.c      |    3 +++
 arch/xtensa/kernel/entry.S            |   11 +++++++++++
 3 files changed, 18 insertions(+)

--- a/arch/xtensa/include/asm/thread_info.h
+++ b/arch/xtensa/include/asm/thread_info.h
@@ -55,6 +55,10 @@ struct thread_info {
 	mm_segment_t		addr_limit;	/* thread address space */
 
 	unsigned long		cpenable;
+#if XCHAL_HAVE_EXCLUSIVE
+	/* result of the most recent exclusive store */
+	unsigned long		atomctl8;
+#endif
 
 	/* Allocate storage for extra user states and coprocessor states. */
 #if XTENSA_HAVE_COPROCESSORS
--- a/arch/xtensa/kernel/asm-offsets.c
+++ b/arch/xtensa/kernel/asm-offsets.c
@@ -93,6 +93,9 @@ int main(void)
 	DEFINE(THREAD_RA, offsetof (struct task_struct, thread.ra));
 	DEFINE(THREAD_SP, offsetof (struct task_struct, thread.sp));
 	DEFINE(THREAD_CPENABLE, offsetof (struct thread_info, cpenable));
+#if XCHAL_HAVE_EXCLUSIVE
+	DEFINE(THREAD_ATOMCTL8, offsetof (struct thread_info, atomctl8));
+#endif
 #if XTENSA_HAVE_COPROCESSORS
 	DEFINE(THREAD_XTREGS_CP0, offsetof(struct thread_info, xtregs_cp.cp0));
 	DEFINE(THREAD_XTREGS_CP1, offsetof(struct thread_info, xtregs_cp.cp1));
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -374,6 +374,11 @@ common_exception:
 	s32i	a2, a1, PT_LCOUNT
 #endif
 
+#if XCHAL_HAVE_EXCLUSIVE
+	/* Clear exclusive access monitor set by interrupted code */
+	clrex
+#endif
+
 	/* It is now save to restore the EXC_TABLE_FIXUP variable. */
 
 	rsr	a2, exccause
@@ -2020,6 +2025,12 @@ ENTRY(_switch_to)
 	s32i	a3, a4, THREAD_CPENABLE
 #endif
 
+#if XCHAL_HAVE_EXCLUSIVE
+	l32i	a3, a5, THREAD_ATOMCTL8
+	getex	a3
+	s32i	a3, a4, THREAD_ATOMCTL8
+#endif
+
 	/* Flush register file. */
 
 	spill_registers_kernel



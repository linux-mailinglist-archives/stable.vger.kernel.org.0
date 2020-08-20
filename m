Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42B624BC4A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbgHTMnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729053AbgHTJpx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:45:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78C1220724;
        Thu, 20 Aug 2020 09:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916753;
        bh=hvLq017YKuKJqdlqg6mrYFBEKl8k/M4CsCHwLiU5pmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s2XfahqFV0tEuSYmlzg7YPCGu7YpfCWp4pLkqCIQ9a7gfT7uB9wKvO7Axxd/tZhLI
         F9duT3eLBGrQk9zldIBPYhC6x8iDkjFsniSkXexevNdM0xplQ++BaBq5ex2bOGK82J
         QMXXSdQluVC0HdLcAW8hh1sL6qebsmwZChWgqVI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.4 033/152] xtensa: add missing exclusive access state management
Date:   Thu, 20 Aug 2020 11:20:00 +0200
Message-Id: <20200820091555.361883936@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
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
@@ -2024,6 +2029,12 @@ ENTRY(_switch_to)
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



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F6934444A
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhCVM7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232395AbhCVM5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:57:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F28CF61A43;
        Mon, 22 Mar 2021 12:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417345;
        bh=gb4jHTXsVwMzTQ/u3yzOWzTn1m80SlvBJa4XX531drg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3Yez7cE0gBbWhgqWWbcagBWfDyTXigKERMIdWsOyQ2g1AY3Dto+KZ2x/yzuZWHRw
         tG/VTaZmI2srqmX9GlN1z/h1pwTmRV8Q+LqoEa2K2MXN+pLg85eraWYvE8eKhjxKIR
         zjgoEkuukUpeumWZxQHQaMwxmwaA7qHDjz72eAp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 38/43] x86: Move TS_COMPAT back to asm/thread_info.h
Date:   Mon, 22 Mar 2021 13:29:19 +0100
Message-Id: <20210322121921.252134818@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
References: <20210322121920.053255560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit 66c1b6d74cd7035e85c426f0af4aede19e805c8a upstream.

Move TS_COMPAT back to asm/thread_info.h, close to TS_I386_REGS_POKED.

It was moved to asm/processor.h by b9d989c7218a ("x86/asm: Move the
thread_info::status field to thread_struct"), then later 37a8f7c38339
("x86/asm: Move 'status' from thread_struct to thread_info") moved the
'status' field back but TS_COMPAT was forgotten.

Preparatory patch to fix the COMPAT case for get_nr_restart_syscall()

Fixes: 609c19a385c8 ("x86/ptrace: Stop setting TS_COMPAT in ptrace code")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210201174649.GA17880@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/processor.h   |    9 ---------
 arch/x86/include/asm/thread_info.h |    9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -512,15 +512,6 @@ struct thread_struct {
 };
 
 /*
- * Thread-synchronous status.
- *
- * This is different from the flags in that nobody else
- * ever touches our thread-synchronous status, so we don't
- * have to worry about atomic accesses.
- */
-#define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
-
-/*
  * Set IOPL bits in EFLAGS from given mask
  */
 static inline void native_set_iopl_mask(unsigned mask)
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -229,6 +229,15 @@ static inline int arch_within_stack_fram
 
 #endif
 
+/*
+ * Thread-synchronous status.
+ *
+ * This is different from the flags in that nobody else
+ * ever touches our thread-synchronous status, so we don't
+ * have to worry about atomic accesses.
+ */
+#define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
+
 #ifdef CONFIG_COMPAT
 #define TS_I386_REGS_POKED	0x0004	/* regs poked by 32-bit ptracer */
 #endif



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE462F9F53
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390149AbhARMRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:17:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:38996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390884AbhARLqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C602922E01;
        Mon, 18 Jan 2021 11:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970352;
        bh=J+oOPG5dBmRmyaGUTMr3wmnObqARNhc1x/ztIVufPjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7IKkUZsD/aKqIfuJT9Abc6tvQhfCH4YXFn8MCejZYliwfeIrELElJHeiuqUd3EBH
         1WnI6bQzDtqRsseFBa0Bu0D1Apj+3vClQ3zn3EMp/pB2z6jAmmj+dwuhI28+BBRNZU
         N/u2pQQLOBvbjZIo2EEUZ8hAKvUcHuhnOR0u6o10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10 144/152] riscv: Trace irq on only interrupt is enabled
Date:   Mon, 18 Jan 2021 12:35:19 +0100
Message-Id: <20210118113359.623848792@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

commit 7cd1af107a92eb63b93a96dc07406dcbc5269436 upstream.

We should call irq trace only if interrupt is going to be enabled during
excecption handling. Otherwise, it results in following warning during
boot with lock debugging enabled.

[    0.000000] ------------[ cut here ]------------
[    0.000000] DEBUG_LOCKS_WARN_ON(early_boot_irqs_disabled)
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/locking/lockdep.c:4085 lockdep_hardirqs_on_prepare+0x22a/0x22e
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.10.0-00022-ge20097fb37e2-dirty #548
[    0.000000] epc: c005d5d4 ra : c005d5d4 sp : c1c01e80
[    0.000000]  gp : c1d456e0 tp : c1c0a980 t0 : 00000000
[    0.000000]  t1 : ffffffff t2 : 00000000 s0 : c1c01ea0
[    0.000000]  s1 : c100f360 a0 : 0000002d a1 : c00666ee
[    0.000000]  a2 : 00000000 a3 : 00000000 a4 : 00000000
[    0.000000]  a5 : 00000000 a6 : c1c6b390 a7 : 3ffff00e
[    0.000000]  s2 : c2384fe8 s3 : 00000000 s4 : 00000001
[    0.000000]  s5 : c1c0a980 s6 : c1d48000 s7 : c1613b4c
[    0.000000]  s8 : 00000fff s9 : 80000200 s10: c1613b40
[    0.000000]  s11: 00000000 t3 : 00000000 t4 : 00000000
[    0.000000]  t5 : 00000001 t6 : 00000000

Fixes: 3c4697982982 ("riscv:Enable LOCKDEP_SUPPORT & fixup TRACE_IRQFLAGS_SUPPORT")

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/riscv/kernel/entry.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -124,15 +124,15 @@ skip_context_tracking:
 	REG_L a1, (a1)
 	jr a1
 1:
-#ifdef CONFIG_TRACE_IRQFLAGS
-	call trace_hardirqs_on
-#endif
 	/*
 	 * Exceptions run with interrupts enabled or disabled depending on the
 	 * state of SR_PIE in m/sstatus.
 	 */
 	andi t0, s1, SR_PIE
 	beqz t0, 1f
+#ifdef CONFIG_TRACE_IRQFLAGS
+	call trace_hardirqs_on
+#endif
 	csrs CSR_STATUS, SR_IE
 
 1:



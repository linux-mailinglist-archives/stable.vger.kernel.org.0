Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4C03A6382
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbhFNLN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234761AbhFNLL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:11:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F65161453;
        Mon, 14 Jun 2021 10:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667689;
        bh=uOsOqwolP7c9rOMG4+2LkO2+PqcZGbkXk1XA/biK5Uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOab+e4vNPSZGlE8pU2orq+GJN64XXrKpZAddCvQL5+PZv5+KvWMFmYh93hWAZ3gW
         jnQZhTVCzIg3XxqIkyBXRDUBaO1EuaxB/sEKWXinU96nGLd/k2rlH+ik+7x8xu+0iI
         rmtB5w0J+R42a8J6ozB38hO/hNmDw2l9Y/0xmndE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 037/173] MIPS: Fix kernel hang under FUNCTION_GRAPH_TRACER and PREEMPT_TRACER
Date:   Mon, 14 Jun 2021 12:26:09 +0200
Message-Id: <20210614102659.388178664@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 78cf0eb926cb1abeff2106bae67752e032fe5f3e ]

When update the latest mainline kernel with the following three configs,
the kernel hangs during startup:

(1) CONFIG_FUNCTION_GRAPH_TRACER=y
(2) CONFIG_PREEMPT_TRACER=y
(3) CONFIG_FTRACE_STARTUP_TEST=y

When update the latest mainline kernel with the above two configs (1)
and (2), the kernel starts normally, but it still hangs when execute
the following command:

echo "function_graph" > /sys/kernel/debug/tracing/current_tracer

Without CONFIG_PREEMPT_TRACER=y, the above two kinds of kernel hangs
disappeared, so it seems that CONFIG_PREEMPT_TRACER has some influences
with function_graph tracer at the first glance.

I use ejtag to find out the epc address is related with preempt_enable()
in the file arch/mips/lib/mips-atomic.c, because function tracing can
trace the preempt_{enable,disable} calls that are traced, replace them
with preempt_{enable,disable}_notrace to prevent function tracing from
going into an infinite loop, and then it can fix the kernel hang issue.

By the way, it seems that this commit is a complement and improvement of
commit f93a1a00f2bd ("MIPS: Fix crash that occurs when function tracing
is enabled").

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lib/mips-atomic.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/mips/lib/mips-atomic.c b/arch/mips/lib/mips-atomic.c
index de03838b343b..a9b72eacfc0b 100644
--- a/arch/mips/lib/mips-atomic.c
+++ b/arch/mips/lib/mips-atomic.c
@@ -37,7 +37,7 @@
  */
 notrace void arch_local_irq_disable(void)
 {
-	preempt_disable();
+	preempt_disable_notrace();
 
 	__asm__ __volatile__(
 	"	.set	push						\n"
@@ -53,7 +53,7 @@ notrace void arch_local_irq_disable(void)
 	: /* no inputs */
 	: "memory");
 
-	preempt_enable();
+	preempt_enable_notrace();
 }
 EXPORT_SYMBOL(arch_local_irq_disable);
 
@@ -61,7 +61,7 @@ notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags;
 
-	preempt_disable();
+	preempt_disable_notrace();
 
 	__asm__ __volatile__(
 	"	.set	push						\n"
@@ -78,7 +78,7 @@ notrace unsigned long arch_local_irq_save(void)
 	: /* no inputs */
 	: "memory");
 
-	preempt_enable();
+	preempt_enable_notrace();
 
 	return flags;
 }
@@ -88,7 +88,7 @@ notrace void arch_local_irq_restore(unsigned long flags)
 {
 	unsigned long __tmp1;
 
-	preempt_disable();
+	preempt_disable_notrace();
 
 	__asm__ __volatile__(
 	"	.set	push						\n"
@@ -106,7 +106,7 @@ notrace void arch_local_irq_restore(unsigned long flags)
 	: "0" (flags)
 	: "memory");
 
-	preempt_enable();
+	preempt_enable_notrace();
 }
 EXPORT_SYMBOL(arch_local_irq_restore);
 
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4CC39A8D6
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbhFCRSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233699AbhFCRQT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:16:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F06161445;
        Thu,  3 Jun 2021 17:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740290;
        bh=2NVq7XYzDTyqtrhj14PtMlCHTHI8xeDSUJOP8zruYow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEYfyh9HMv2Xr4PecdCpt8JtiY1y6nx6fws1mdlSSQumcBZ0uMwgkRNtIti3oey64
         xMDNmb57ZI/wNkU2T7V6qSKDM4WUWLkBUGdY8t+ZAEZATJBCFMaoFDeAfBzDKf730/
         m76MWE9Fqs8nEAwFc6U/MkHNgkSV6AiMcmCQUiMPUzO1jAHXpBX+JyflBeUIMmZnlF
         xfB4vGpR2+sPSW6ZnK6TozAvQTgSX1Q+yyi6BnUpZ8TYhUC8vl1WBr1fR3/Nu80e46
         +5Yk01Q4NiKV2Hk98Tdjh7VTSGFbZC20WpgSrvhlQpxpWBrsTpfvbbUxoB9tlQHRzP
         SsogoBkiFBBgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 12/15] MIPS: Fix kernel hang under FUNCTION_GRAPH_TRACER and PREEMPT_TRACER
Date:   Thu,  3 Jun 2021 13:11:11 -0400
Message-Id: <20210603171114.3170086-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171114.3170086-1-sashal@kernel.org>
References: <20210603171114.3170086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 272af8ac2425..fd50aa7b178a 100644
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
 
@@ -62,7 +62,7 @@ notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags;
 
-	preempt_disable();
+	preempt_disable_notrace();
 
 	__asm__ __volatile__(
 	"	.set	push						\n"
@@ -79,7 +79,7 @@ notrace unsigned long arch_local_irq_save(void)
 	: /* no inputs */
 	: "memory");
 
-	preempt_enable();
+	preempt_enable_notrace();
 
 	return flags;
 }
@@ -89,7 +89,7 @@ notrace void arch_local_irq_restore(unsigned long flags)
 {
 	unsigned long __tmp1;
 
-	preempt_disable();
+	preempt_disable_notrace();
 
 	__asm__ __volatile__(
 	"	.set	push						\n"
@@ -107,7 +107,7 @@ notrace void arch_local_irq_restore(unsigned long flags)
 	: "0" (flags)
 	: "memory");
 
-	preempt_enable();
+	preempt_enable_notrace();
 }
 EXPORT_SYMBOL(arch_local_irq_restore);
 
-- 
2.30.2


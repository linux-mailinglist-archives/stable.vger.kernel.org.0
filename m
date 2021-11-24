Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7D745B9ED
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242352AbhKXMGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:06:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242119AbhKXMFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:05:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5E3060FDA;
        Wed, 24 Nov 2021 12:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755366;
        bh=apf7TYrkHRTSmQxheXA6LGWGkZTFg0co63K6qKThD10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwRk3OusNkYXSq7HzKLJ75bkhLAWknHn+z9/2arpLdi4kVZZ/gI/MTltZ6L+8AP+c
         wtyTbe+vwh0mvwHhbNfYh2JYfWHdvxTOsbQ1+x4o/1cPAKXZ0NzBWrYaWw+cudq8HN
         nAmWsYJABYjRMStXwYtVh3dTx+TwD4s6VtMOq0Bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@stackframe.org>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 070/162] parisc/kgdb: add kgdb_roundup() to make kgdb work with idle polling
Date:   Wed, 24 Nov 2021 12:56:13 +0100
Message-Id: <20211124115700.590766959@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@stackframe.org>

[ Upstream commit 66e29fcda1824f0427966fbee2bd2c85bf362c82 ]

With idle polling, IPIs are not sent when a CPU idle, but queued
and run later from do_idle(). The default kgdb_call_nmi_hook()
implementation gets the pointer to struct pt_regs from get_irq_reqs(),
which doesn't work in that case because it was not called from the
IPI interrupt handler. Fix it by defining our own kgdb_roundup()
function which sents an IPI_ENTER_KGDB. When that IPI is received
on the target CPU kgdb_nmicallback() is called.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/smp.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 52e85973a283c..5a2c4771e9d1f 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -32,6 +32,7 @@
 #include <linux/bitops.h>
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
+#include <linux/kgdb.h>
 
 #include <linux/atomic.h>
 #include <asm/current.h>
@@ -74,7 +75,10 @@ enum ipi_message_type {
 	IPI_CALL_FUNC,
 	IPI_CPU_START,
 	IPI_CPU_STOP,
-	IPI_CPU_TEST
+	IPI_CPU_TEST,
+#ifdef CONFIG_KGDB
+	IPI_ENTER_KGDB,
+#endif
 };
 
 
@@ -170,7 +174,12 @@ ipi_interrupt(int irq, void *dev_id)
 			case IPI_CPU_TEST:
 				smp_debug(100, KERN_DEBUG "CPU%d is alive!\n", this_cpu);
 				break;
-
+#ifdef CONFIG_KGDB
+			case IPI_ENTER_KGDB:
+				smp_debug(100, KERN_DEBUG "CPU%d ENTER_KGDB\n", this_cpu);
+				kgdb_nmicallback(raw_smp_processor_id(), get_irq_regs());
+				break;
+#endif
 			default:
 				printk(KERN_CRIT "Unknown IPI num on CPU%d: %lu\n",
 					this_cpu, which);
@@ -226,6 +235,12 @@ send_IPI_allbutself(enum ipi_message_type op)
 	}
 }
 
+#ifdef CONFIG_KGDB
+void kgdb_roundup_cpus(void)
+{
+	send_IPI_allbutself(IPI_ENTER_KGDB);
+}
+#endif
 
 inline void 
 smp_send_stop(void)	{ send_IPI_allbutself(IPI_CPU_STOP); }
-- 
2.33.0




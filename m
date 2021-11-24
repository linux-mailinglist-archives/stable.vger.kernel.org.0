Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4664E45BDC7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343762AbhKXMkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:40:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343798AbhKXMiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:38:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4813F61100;
        Wed, 24 Nov 2021 12:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756574;
        bh=mYGN1jchXqhP2XlrV8PgHBb3nJFQbw9yzoF3deh2WXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FPLI/hu/vtFUzNoYqz9pZl9fdKgJAJUK2n+eiyb80SsfdgSFE8dTtW/gy29NSbHPP
         0Sdz3ijrhXfLsOuTlFyviy9RexmVqM309GhRLKjkwDMaqkcVLRpxl9ymaHa57BiVaI
         zunf+0czE0CVp8CqI/gDvez7nB/0qDGkbXxa2F30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@stackframe.org>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 105/251] parisc/kgdb: add kgdb_roundup() to make kgdb work with idle polling
Date:   Wed, 24 Nov 2021 12:55:47 +0100
Message-Id: <20211124115713.898522913@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index ab4d5580bb02b..45e3aadcecd2f 100644
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




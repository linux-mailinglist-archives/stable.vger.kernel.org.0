Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1FD44A360
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243102AbhKIB0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:26:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243781AbhKIBXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:23:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E90E361A6E;
        Tue,  9 Nov 2021 01:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420157;
        bh=JcKkz6vxP5igJuFgPAAu78qQkQPahoeXJfDXVhy647I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IytRvpYDmFmzI9z5GveJwl6mF7WvcTSDgKSd5BwZMyZkeQvGzb5o+ylyUgFUfcIqO
         pnDo5MhNbDeVdshBr09Rg7gorN731kqTrLI5IpIU2LdLZsRY0TGufAuDRn3DaGnCW1
         kuJEQUYfFIT5VmPaF/SO9ax+NLGsaq4vY4orL6AuxDAGtzPFrq6rXOj6+XxBbWwpS8
         52RvM1sfoLSyxxY/+wl0KltmAd11x9tt6ykDLU/XiuTD/ucS7uYuxH1HdCpUr8Mz57
         Ib9SGSEQNmlGP1552CkNhDayg8TDbFRGZ+maYERIDNP9PKcGf3KNs6XYGlg5TqDcf6
         xsBCfBcTq8hfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@stackframe.org>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, mingo@kernel.org,
        valentin.schneider@arm.com, peterz@infradead.org, ardb@kernel.org,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 33/33] parisc/kgdb: add kgdb_roundup() to make kgdb work with idle polling
Date:   Mon,  8 Nov 2021 20:08:07 -0500
Message-Id: <20211109010807.1191567-33-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010807.1191567-1-sashal@kernel.org>
References: <20211109010807.1191567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 75dab2871346c..af966c1c922ff 100644
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


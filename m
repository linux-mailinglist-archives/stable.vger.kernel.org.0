Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EF545BB6A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242291AbhKXMTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:19:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243049AbhKXMR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:17:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B58361108;
        Wed, 24 Nov 2021 12:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755870;
        bh=JcKkz6vxP5igJuFgPAAu78qQkQPahoeXJfDXVhy647I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iInPm8HMA1L1TiCIPgm++6bnbI67RoTBNfJbt8UiVYE2Ar2zs/NjK6Zhv+TCEpQtn
         0V5NRaYvDmR3ddTevea/YdHteGAlbZMi4UUlkXHSYXXS/8jFHhs7hO0bFgsDAmtv1T
         LfzZF/E+IE7/t9uCpU7ddRkzsVoSuMl9x6Skm1HQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@stackframe.org>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 087/207] parisc/kgdb: add kgdb_roundup() to make kgdb work with idle polling
Date:   Wed, 24 Nov 2021 12:55:58 +0100
Message-Id: <20211124115706.718237795@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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




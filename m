Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F4544210
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731780AbfFMQS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731106AbfFMIkK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:40:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CD4E21721;
        Thu, 13 Jun 2019 08:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415209;
        bh=L0FG2VR4VOV1fRc8/llvfy86neUc16LpaLeyfPVRvAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTrtC/JTJMvIPBaTd9w49lvXuZIHVrWRhx5qPwcrjyurPrSMR3Wa10HrhviwDN9b/
         4CDko7PKELAAnwSvW0gb2DmcO+PpH+dLKdsMXbVSZLiqzcbSiowzq0Hf3Jqdp8UhNk
         +LubwxHDn25Vrj8dyRnpVVTZl5F7K7QcCyPRrNFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Mathieu Malaterre <malat@debian.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Stefan Agner <stefan@agner.ch>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Borislav Petkov <bp@suse.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 006/118] ARM: prevent tracing IPI_CPU_BACKTRACE
Date:   Thu, 13 Jun 2019 10:32:24 +0200
Message-Id: <20190613075644.042643996@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit be167862ae7dd85c56d385209a4890678e1b0488 ]

Patch series "compiler: allow all arches to enable
CONFIG_OPTIMIZE_INLINING", v3.

This patch (of 11):

When function tracing for IPIs is enabled, we get a warning for an
overflow of the ipi_types array with the IPI_CPU_BACKTRACE type as
triggered by raise_nmi():

  arch/arm/kernel/smp.c: In function 'raise_nmi':
  arch/arm/kernel/smp.c:489:2: error: array subscript is above array bounds [-Werror=array-bounds]
    trace_ipi_raise(target, ipi_types[ipinr]);

This is a correct warning as we actually overflow the array here.

This patch raise_nmi() to call __smp_cross_call() instead of
smp_cross_call(), to avoid calling into ftrace.  For clarification, I'm
also adding a two new code comments describing how this one is special.

The warning appears to have shown up after commit e7273ff49acf ("ARM:
8488/1: Make IPI_CPU_BACKTRACE a "non-secure" SGI"), which changed the
number assignment from '15' to '8', but as far as I can tell has existed
since the IPI tracepoints were first introduced.  If we decide to
backport this patch to stable kernels, we probably need to backport
e7273ff49acf as well.

[yamada.masahiro@socionext.com: rebase on v5.1-rc1]
Link: http://lkml.kernel.org/r/20190423034959.13525-2-yamada.masahiro@socionext.com
Fixes: e7273ff49acf ("ARM: 8488/1: Make IPI_CPU_BACKTRACE a "non-secure" SGI")
Fixes: 365ec7b17327 ("ARM: add IPI tracepoints") # v3.17
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Stefan Agner <stefan@agner.ch>
Cc: Boris Brezillon <bbrezillon@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Borislav Petkov <bp@suse.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/hardirq.h | 1 +
 arch/arm/kernel/smp.c          | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/hardirq.h b/arch/arm/include/asm/hardirq.h
index cba23eaa6072..7a88f160b1fb 100644
--- a/arch/arm/include/asm/hardirq.h
+++ b/arch/arm/include/asm/hardirq.h
@@ -6,6 +6,7 @@
 #include <linux/threads.h>
 #include <asm/irq.h>
 
+/* number of IPIS _not_ including IPI_CPU_BACKTRACE */
 #define NR_IPI	7
 
 typedef struct {
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index a3ce7c5365fa..bada66ef4419 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -76,6 +76,10 @@ enum ipi_msg_type {
 	IPI_CPU_STOP,
 	IPI_IRQ_WORK,
 	IPI_COMPLETION,
+	/*
+	 * CPU_BACKTRACE is special and not included in NR_IPI
+	 * or tracable with trace_ipi_*
+	 */
 	IPI_CPU_BACKTRACE,
 	/*
 	 * SGI8-15 can be reserved by secure firmware, and thus may
@@ -803,7 +807,7 @@ core_initcall(register_cpufreq_notifier);
 
 static void raise_nmi(cpumask_t *mask)
 {
-	smp_cross_call(mask, IPI_CPU_BACKTRACE);
+	__smp_cross_call(mask, IPI_CPU_BACKTRACE);
 }
 
 void arch_trigger_cpumask_backtrace(const cpumask_t *mask, bool exclude_self)
-- 
2.20.1




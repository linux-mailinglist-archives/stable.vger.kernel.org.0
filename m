Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0BD30C003
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhBBNrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:47:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232901AbhBBNpR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:45:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 356DF64F82;
        Tue,  2 Feb 2021 13:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273261;
        bh=Dvsl/32IFynrdpNXOB9tFdLLblMnLI4/AWVR4cM7Ojk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMFQucVgYpV8mTeGxhiVYqRe11Xx3nOkxhFl/Umu4QsCV52jxU6wj/LOOdd1LIiYX
         ipgYMsdSgPlqIY/smS0szOYiC1+4ytmOSbCdyXW9Pnub5Dlc4+5rp/YpZWjj/8AnU1
         DqC2Tj+kXk+tQJqviJAKhNc9c8NCs0Ro19w/P2X8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.10 009/142] parisc: Enable -mlong-calls gcc option by default when !CONFIG_MODULES
Date:   Tue,  2 Feb 2021 14:36:12 +0100
Message-Id: <20210202132958.084717417@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 00e35f2b0e8acb88d4e1aa96ff0490e3bfe46580 upstream.

When building a kernel without module support, the CONFIG_MLONGCALL option
needs to be enabled in order to reach symbols which are outside of a 22-bit
branch.

This patch changes the autodetection in the Kconfig script to always enable
CONFIG_MLONGCALL when modules are disabled and uses a far call to
preempt_schedule_irq() in intr_do_preempt() to reach the symbol in all cases.

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: kernel test robot <lkp@intel.com>
Cc: stable@vger.kernel.org # v5.6+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/Kconfig        |    5 ++---
 arch/parisc/kernel/entry.S |   13 ++++++++++---
 2 files changed, 12 insertions(+), 6 deletions(-)

--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -202,9 +202,8 @@ config PREFETCH
 	depends on PA8X00 || PA7200
 
 config MLONGCALLS
-	bool "Enable the -mlong-calls compiler option for big kernels"
-	default y if !MODULES || UBSAN || FTRACE
-	default n
+	def_bool y if !MODULES || UBSAN || FTRACE
+	bool "Enable the -mlong-calls compiler option for big kernels" if MODULES && !UBSAN && !FTRACE
 	depends on PA8X00
 	help
 	  If you configure the kernel to include many drivers built-in instead
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -997,10 +997,17 @@ intr_do_preempt:
 	bb,<,n	%r20, 31 - PSW_SM_I, intr_restore
 	nop
 
+	/* ssm PSW_SM_I done later in intr_restore */
+#ifdef CONFIG_MLONGCALLS
+	ldil	L%intr_restore, %r2
+	load32	preempt_schedule_irq, %r1
+	bv	%r0(%r1)
+	ldo	R%intr_restore(%r2), %r2
+#else
+	ldil	L%intr_restore, %r1
 	BL	preempt_schedule_irq, %r2
-	nop
-
-	b,n	intr_restore		/* ssm PSW_SM_I done by intr_restore */
+	ldo	R%intr_restore(%r1), %r2
+#endif
 #endif /* CONFIG_PREEMPTION */
 
 	/*



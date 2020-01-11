Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E90D613803E
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbgAKK1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:27:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730398AbgAKK1V (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:27:21 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F41B92087F;
        Sat, 11 Jan 2020 10:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738440;
        bh=zOuj6n+fYGJwlWbMnFsq3QNqgVU7cb1hz3VpkEgVXtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d19xVFCr/B91FrVGvYgn7QZKSRdc83S/fcUHlvJuBDP2njKHb/FR2OhyiRxlNZCdc
         z7lyFmaIS8xYemQu5e6FzD0u0mmIsAKz5IQ7gEDBiKBRQDD3Lya4tdyp/COoJz95HO
         tYI+GnbU5/h6WjW6LHKm48RSIrJIy/bbQyHHINDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Sven Schnelle <svens@stackframe.org>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/165] parisc: fix compilation when KEXEC=n and KEXEC_FILE=y
Date:   Sat, 11 Jan 2020 10:50:06 +0100
Message-Id: <20200111094928.443787499@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@stackframe.org>

[ Upstream commit e16260c21f87b16a33ae8ecac9e8c79f3a8b89bd ]

Fix compilation when the CONFIG_KEXEC_FILE=y and
CONFIG_KEXEC=n.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/kexec.h | 4 ----
 arch/parisc/kernel/Makefile     | 2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/parisc/include/asm/kexec.h b/arch/parisc/include/asm/kexec.h
index a99ea747d7ed..87e174006995 100644
--- a/arch/parisc/include/asm/kexec.h
+++ b/arch/parisc/include/asm/kexec.h
@@ -2,8 +2,6 @@
 #ifndef _ASM_PARISC_KEXEC_H
 #define _ASM_PARISC_KEXEC_H
 
-#ifdef CONFIG_KEXEC
-
 /* Maximum physical address we can use pages from */
 #define KEXEC_SOURCE_MEMORY_LIMIT (-1UL)
 /* Maximum address we can reach in physical address mode */
@@ -32,6 +30,4 @@ static inline void crash_setup_regs(struct pt_regs *newregs,
 
 #endif /* __ASSEMBLY__ */
 
-#endif /* CONFIG_KEXEC */
-
 #endif /* _ASM_PARISC_KEXEC_H */
diff --git a/arch/parisc/kernel/Makefile b/arch/parisc/kernel/Makefile
index 2663c8f8be11..068d90950d93 100644
--- a/arch/parisc/kernel/Makefile
+++ b/arch/parisc/kernel/Makefile
@@ -37,5 +37,5 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
 obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 obj-$(CONFIG_KGDB)			+= kgdb.o
 obj-$(CONFIG_KPROBES)			+= kprobes.o
-obj-$(CONFIG_KEXEC)			+= kexec.o relocate_kernel.o
+obj-$(CONFIG_KEXEC_CORE)		+= kexec.o relocate_kernel.o
 obj-$(CONFIG_KEXEC_FILE)		+= kexec_file.o
-- 
2.20.1




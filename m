Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9501E12B7CF
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbfL0RnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:43:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728204AbfL0RnU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:43:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF58624125;
        Fri, 27 Dec 2019 17:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468599;
        bh=zOuj6n+fYGJwlWbMnFsq3QNqgVU7cb1hz3VpkEgVXtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=czF3PFaFOytCq8N9iKpJ9RCyyCQUd59/JGNQGsKbQ7+XVA4qp3+1en/fMFxKDMtg3
         OUrv8yPTrvppVhfcVagSGK6uqGz6oDjM4UC+UzdwvckLm+qxXTKeQ5ZzfPd0yTcxWF
         ALN2QvmMOIDUcpQWvVO/ofxud74CsEV77MWhw5j0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@stackframe.org>,
        kbuild test robot <lkp@intel.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 120/187] parisc: fix compilation when KEXEC=n and KEXEC_FILE=y
Date:   Fri, 27 Dec 2019 12:39:48 -0500
Message-Id: <20191227174055.4923-120-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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


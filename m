Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1163313C8E
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbhBHSH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:07:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhBHSDa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:03:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69F9264ED1;
        Mon,  8 Feb 2021 17:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807165;
        bh=hUmXp4cl6ZebLceSriEo+HTBsK9PbC91soU8GF9e8G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1moS9wG9V+7MmWvTtiJdQ1VN1mPgynqlxGJUH2VTxXKi1qNp7A80iKSWYc9Xd4uz
         0PY1O3IrlMxWRqMC5KNTaRADpNPqhvPou6oOJLMw/fPwfeP6TomNlQTPkdc/qWtU/5
         iBFXk9Z6zNg9QVoyFW8XvtSC6ePahXwr0gOYsgruJ1iJAygCPSId2W7G5wp9Z9gOky
         5lgnAc2atATHFmCgv16Pb0yi9wobQGvveA/KpRYP3FI3XpDlHb0c6WGRuaYP0a18n7
         qVtK+hJF48sCmJChAwcLwELdpCZhZ2zFDwcJkupXBWyAE0ewf7aT1JjCU4wBC9bf+m
         sIC66Tcvzud/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, Jessica Yu <jeyu@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 19/19] init/gcov: allow CONFIG_CONSTRUCTORS on UML to fix module gcov
Date:   Mon,  8 Feb 2021 12:58:58 -0500
Message-Id: <20210208175858.2092008-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175858.2092008-1-sashal@kernel.org>
References: <20210208175858.2092008-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 55b6f763d8bcb5546997933105d66d3e6b080e6a ]

On ARCH=um, loading a module doesn't result in its constructors getting
called, which breaks module gcov since the debugfs files are never
registered.  On the other hand, in-kernel constructors have already been
called by the dynamic linker, so we can't call them again.

Get out of this conundrum by allowing CONFIG_CONSTRUCTORS to be
selected, but avoiding the in-kernel constructor calls.

Also remove the "if !UML" from GCOV selecting CONSTRUCTORS now, since we
really do want CONSTRUCTORS, just not kernel binary ones.

Link: https://lkml.kernel.org/r/20210120172041.c246a2cac2fb.I1358f584b76f1898373adfed77f4462c8705b736@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig        | 1 -
 init/main.c         | 8 +++++++-
 kernel/gcov/Kconfig | 2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 96fc45d1b686b..8a04857453607 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -38,7 +38,6 @@ config CC_HAS_ASM_INLINE
 
 config CONSTRUCTORS
 	bool
-	depends on !UML
 
 config IRQ_WORK
 	bool
diff --git a/init/main.c b/init/main.c
index fef9e610b74b7..c59d41ce597eb 100644
--- a/init/main.c
+++ b/init/main.c
@@ -790,7 +790,13 @@ asmlinkage __visible void __init start_kernel(void)
 /* Call all constructor functions linked into the kernel. */
 static void __init do_ctors(void)
 {
-#ifdef CONFIG_CONSTRUCTORS
+/*
+ * For UML, the constructors have already been called by the
+ * normal setup code as it's just a normal ELF binary, so we
+ * cannot do it again - but we do need CONFIG_CONSTRUCTORS
+ * even on UML for modules.
+ */
+#if defined(CONFIG_CONSTRUCTORS) && !defined(CONFIG_UML)
 	ctor_fn_t *fn = (ctor_fn_t *) __ctors_start;
 
 	for (; fn < (ctor_fn_t *) __ctors_end; fn++)
diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
index 3941a9c48f833..060e8e726755f 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -4,7 +4,7 @@ menu "GCOV-based kernel profiling"
 config GCOV_KERNEL
 	bool "Enable gcov-based kernel profiling"
 	depends on DEBUG_FS
-	select CONSTRUCTORS if !UML
+	select CONSTRUCTORS
 	default n
 	---help---
 	This option enables gcov-based code profiling (e.g. for code coverage
-- 
2.27.0


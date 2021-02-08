Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB4F313CA2
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235492AbhBHSI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:08:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235205AbhBHSDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:03:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADE7364EEC;
        Mon,  8 Feb 2021 17:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807185;
        bh=rfejOj5aAcFA5spBMh/YZVlQ7dUD0zy8nAd2lXORh+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+UDwqvpi6v3RJnJXUPOpzyjCzreoLp4QAUOg6Sq1zizUpSa/wFTSxRge3sG7iRED
         lm7UzBz6FISr5eOV5nz/m9aOfE0Znp7YK4TVI+XJaLF+az7qkoCB6evzF2xcmbJO9F
         c2rV2hX1N6vriqVIgWZAGMUD0XYRoRiuOdUALBYTgNGaF+VUBVhKbxBtqUp3HS2Mv+
         Cb3BCjwOpzjdJTrnWL5Coo2PP6jOW5RV0o1Kg8xy83oB7xgWGlP60m2az1n4+w0jCC
         eXAivcUAAHNd8VgA3VCQ25jhMaq0atL5i+QgwsrmoylTR6hjZOBNvCRRGB59tbU7xe
         f6SMNJ2agAOXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, Jessica Yu <jeyu@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 14/14] init/gcov: allow CONFIG_CONSTRUCTORS on UML to fix module gcov
Date:   Mon,  8 Feb 2021 12:59:26 -0500
Message-Id: <20210208175926.2092211-14-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175926.2092211-1-sashal@kernel.org>
References: <20210208175926.2092211-1-sashal@kernel.org>
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
index 5eb91dde4018c..15543270fec79 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -28,7 +28,6 @@ config CC_HAS_ASM_GOTO
 
 config CONSTRUCTORS
 	bool
-	depends on !UML
 
 config IRQ_WORK
 	bool
diff --git a/init/main.c b/init/main.c
index fdfef08da0c4b..3a74255641578 100644
--- a/init/main.c
+++ b/init/main.c
@@ -741,7 +741,13 @@ asmlinkage __visible void __init start_kernel(void)
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
index 1e3823fa799b2..db5856bf8b514 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -3,7 +3,7 @@ menu "GCOV-based kernel profiling"
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


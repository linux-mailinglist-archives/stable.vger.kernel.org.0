Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185B927B978
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgI2BbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727499AbgI2BbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:31:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AF2B221E8;
        Tue, 29 Sep 2020 01:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343064;
        bh=csQCwAkCqB3MgkQK82J/G1bbn6BOYjCYdQmF0UsTB6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwMe37OBqjj9ZFFhLj4Qql1hvuaH6FtrZy1DUm+3f1pHI5A/BWnhlXhZJyyRzFuO5
         W9ZegjGxX6ZjBGWglUvPnxOK4SfrThaFU6TqQ03w0C2Djxu0gLj/vZf1H6MCq1l6SB
         Rq3NKtNc4fBNKAaTPNEAO3Grad3qfJisx/+pXVFU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 29/29] scripts/kallsyms: skip ppc compiler stub *.long_branch.* / *.plt_branch.*
Date:   Mon, 28 Sep 2020 21:30:26 -0400
Message-Id: <20200929013027.2406344-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 516d980f85415d76ae3d0d2a871eb20243f46c95 ]

PowerPC allmodconfig often fails to build as follows:

    LD      .tmp_vmlinux.kallsyms1
    KSYM    .tmp_vmlinux.kallsyms1.o
    LD      .tmp_vmlinux.kallsyms2
    KSYM    .tmp_vmlinux.kallsyms2.o
    LD      .tmp_vmlinux.kallsyms3
    KSYM    .tmp_vmlinux.kallsyms3.o
    LD      vmlinux
    SORTTAB vmlinux
    SYSMAP  System.map
  Inconsistent kallsyms data
  Try make KALLSYMS_EXTRA_PASS=1 as a workaround
  make[2]: *** [../Makefile:1162: vmlinux] Error 1

Setting KALLSYMS_EXTRA_PASS=1 does not help.

This is caused by the compiler inserting stubs such as *.long_branch.*
and *.plt_branch.*

  $ powerpc-linux-nm -n .tmp_vmlinux.kallsyms2
   [ snip ]
  c00000000210c010 t 00000075.plt_branch.da9:19
  c00000000210c020 t 00000075.plt_branch.1677:5
  c00000000210c030 t 00000075.long_branch.memmove
  c00000000210c034 t 00000075.plt_branch.9e0:5
  c00000000210c044 t 00000075.plt_branch.free_initrd_mem
    ...

Actually, the problem mentioned in scripts/link-vmlinux.sh comments;
"In theory it's possible this results in even more stubs, but unlikely"
is happening here, and ends up with another kallsyms step required.

scripts/kallsyms.c already ignores various compiler stubs. Let's do
similar to make kallsysms for PowerPC always succeed in 2 steps.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kallsyms.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 6dc3078649fa0..e8b26050f5458 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -82,6 +82,7 @@ static char *sym_name(const struct sym_entry *s)
 
 static bool is_ignored_symbol(const char *name, char type)
 {
+	/* Symbol names that exactly match to the following are ignored.*/
 	static const char * const ignored_symbols[] = {
 		/*
 		 * Symbols which vary between passes. Passes 1 and 2 must have
@@ -104,6 +105,7 @@ static bool is_ignored_symbol(const char *name, char type)
 		NULL
 	};
 
+	/* Symbol names that begin with the following are ignored.*/
 	static const char * const ignored_prefixes[] = {
 		"$",			/* local symbols for ARM, MIPS, etc. */
 		".LASANPC",		/* s390 kasan local symbols */
@@ -112,6 +114,7 @@ static bool is_ignored_symbol(const char *name, char type)
 		NULL
 	};
 
+	/* Symbol names that end with the following are ignored.*/
 	static const char * const ignored_suffixes[] = {
 		"_from_arm",		/* arm */
 		"_from_thumb",		/* arm */
@@ -119,9 +122,15 @@ static bool is_ignored_symbol(const char *name, char type)
 		NULL
 	};
 
+	/* Symbol names that contain the following are ignored.*/
+	static const char * const ignored_matches[] = {
+		".long_branch.",	/* ppc stub */
+		".plt_branch.",		/* ppc stub */
+		NULL
+	};
+
 	const char * const *p;
 
-	/* Exclude symbols which vary between passes. */
 	for (p = ignored_symbols; *p; p++)
 		if (!strcmp(name, *p))
 			return true;
@@ -137,6 +146,11 @@ static bool is_ignored_symbol(const char *name, char type)
 			return true;
 	}
 
+	for (p = ignored_matches; *p; p++) {
+		if (strstr(name, *p))
+			return true;
+	}
+
 	if (type == 'U' || type == 'u')
 		return true;
 	/* exclude debugging symbols */
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5F0283AAC
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgJEPcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:32:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728046AbgJEPcq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:32:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99E352074F;
        Mon,  5 Oct 2020 15:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911965;
        bh=csQCwAkCqB3MgkQK82J/G1bbn6BOYjCYdQmF0UsTB6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBn36pG2TtgyZ81jlmDRw9ITsER+g7gx0lyjPKOQObGCqCOTVZqv2Qp76wtrKjPnh
         frva2rzsFpUt6I3B1JykeIYYN7Jd9R1khPAvWvx5CR3xMMuONveof/ysU8+16axYVR
         dWXfJWBvNZcVeHa9nvzJeGM7/+c/b3Fi+LgxNfGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 49/85] scripts/kallsyms: skip ppc compiler stub *.long_branch.* / *.plt_branch.*
Date:   Mon,  5 Oct 2020 17:26:45 +0200
Message-Id: <20201005142117.094377550@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




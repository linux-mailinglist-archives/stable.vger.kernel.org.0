Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765C56DFB8
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfGSD7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:59:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727619AbfGSD7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:59:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9782121873;
        Fri, 19 Jul 2019 03:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508783;
        bh=pocZzY6HKbyA/R5cRbnDBsEmJmNaf6ik5va4ZL9jQCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qd7CcAZH+vHqP+P1r3/3Izc4fpMxcjnbFw/k7bEvkVMLkF2uqAmcdpV0QCS+IBY8Q
         fmND8vSMwd6gFXFchf3KYrdtfjvyGiztpj9wezBRSVE62u9hlN+kZv0g4uYldxkMKF
         StV16+UfI+vrs/JU31FqYXhwbf52/yH1NPSLedAg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 087/171] genksyms: Teach parser about 128-bit built-in types
Date:   Thu, 18 Jul 2019 23:55:18 -0400
Message-Id: <20190719035643.14300-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit a222061b85234d8a44486a46bd4df7e2cda52385 ]

__uint128_t crops up in a few files that export symbols to modules, so
teach genksyms about it and the other GCC built-in 128-bit integer types
so that we don't end up skipping the CRC generation for some symbols due
to the parser failing to spot them:

  | WARNING: EXPORT symbol "kernel_neon_begin" [vmlinux] version
  |          generation failed, symbol will not be versioned.
  | ld: arch/arm64/kernel/fpsimd.o: relocation R_AARCH64_ABS32 against
  |     `__crc_kernel_neon_begin' can not be used when making a shared
  |     object
  | ld: arch/arm64/kernel/fpsimd.o:(.data+0x0): dangerous relocation:
  |     unsupported relocation

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/genksyms/keywords.c | 4 ++++
 scripts/genksyms/parse.y    | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/scripts/genksyms/keywords.c b/scripts/genksyms/keywords.c
index e93336baaaed..c586d32dd2c3 100644
--- a/scripts/genksyms/keywords.c
+++ b/scripts/genksyms/keywords.c
@@ -25,6 +25,10 @@ static struct resword {
 	{ "__volatile__", VOLATILE_KEYW },
 	{ "__builtin_va_list", VA_LIST_KEYW },
 
+	{ "__int128", BUILTIN_INT_KEYW },
+	{ "__int128_t", BUILTIN_INT_KEYW },
+	{ "__uint128_t", BUILTIN_INT_KEYW },
+
 	// According to rth, c99 defines "_Bool", __restrict", __restrict__", "restrict".  KAO
 	{ "_Bool", BOOL_KEYW },
 	{ "_restrict", RESTRICT_KEYW },
diff --git a/scripts/genksyms/parse.y b/scripts/genksyms/parse.y
index 00a6d7e54971..1ebcf52cd0f9 100644
--- a/scripts/genksyms/parse.y
+++ b/scripts/genksyms/parse.y
@@ -76,6 +76,7 @@ static void record_compound(struct string_list **keyw,
 %token ATTRIBUTE_KEYW
 %token AUTO_KEYW
 %token BOOL_KEYW
+%token BUILTIN_INT_KEYW
 %token CHAR_KEYW
 %token CONST_KEYW
 %token DOUBLE_KEYW
@@ -263,6 +264,7 @@ simple_type_specifier:
 	| VOID_KEYW
 	| BOOL_KEYW
 	| VA_LIST_KEYW
+	| BUILTIN_INT_KEYW
 	| TYPE			{ (*$1)->tag = SYM_TYPEDEF; $$ = $1; }
 	;
 
-- 
2.20.1


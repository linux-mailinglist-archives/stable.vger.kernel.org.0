Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D543DC2C0
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 04:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235763AbhGaCdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 22:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231335AbhGaCdI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 22:33:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C86D60C40;
        Sat, 31 Jul 2021 02:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627698782;
        bh=Q2i5nn81+sm0ERvomOS12lhN2v/shipoGDhhZxGH/fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcAdi55tZN1A4sHtM26ll/BNUgwRcqocDQJkZUNoOsWbRI4GqWCtnh//VcdlEpSgK
         kjyW7yJq3HEw1Mxbp4d4lVzyoJGv9zRh1lKV3foHoluc8v3VqqnFQZUFXMZcEhejnn
         PF1BoIl5pb1jK/Ld+hMdIJkePDz1V8Jswn5KT+qoERkgsJtq9vZNeoPOBaMh7aTl5e
         3pqRVtMTycLAhC600vhQXJlsAmqZVHmsOdUPT52JQPhkdSZCxFygG+HsfCpmz4Kkm2
         qztnFxJLke1YdMMQpwQKD3+PQIwAE0Uw2MOqqoE6gpeGWC6PknpTJhMGmLfoiXy2vO
         QBKkUWrP6D+yQ==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Fangrui Song <maskray@google.com>, Marco Elver <elver@google.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2] vmlinux.lds.h: Handle clang's module.{c,d}tor sections
Date:   Fri, 30 Jul 2021 19:31:08 -0700
Message-Id: <20210731023107.1932981-1-nathan@kernel.org>
X-Mailer: git-send-email 2.32.0.264.g75ae10bc75
In-Reply-To: <20210730223815.1382706-1-nathan@kernel.org>
References: <20210730223815.1382706-1-nathan@kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A recent change in LLVM causes module_{c,d}tor sections to appear when
CONFIG_K{A,C}SAN are enabled, which results in orphan section warnings
because these are not handled anywhere:

ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.asan.module_ctor) is being placed in '.text.asan.module_ctor'
ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.asan.module_dtor) is being placed in '.text.asan.module_dtor'
ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.tsan.module_ctor) is being placed in '.text.tsan.module_ctor'

Fangrui explains: "the function asan.module_ctor has the SHF_GNU_RETAIN
flag, so it is in a separate section even with -fno-function-sections
(default)".

Place them in the TEXT_TEXT section so that these technologies continue
to work with the newer compiler versions. All of the KASAN and KCSAN
KUnit tests continue to pass after this change.

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1432
Link: https://github.com/llvm/llvm-project/commit/7b789562244ee941b7bf2cefeb3fc08a59a01865
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

v1 -> v2:

* Fix inclusion of .text.tsan.* (Nick)

* Drop .text.asan as it does not exist plus it would be handled by a
  different line (Fangrui)

* Add Fangrui's explanation about why the LLVM commit caused these
  sections to appear.

 include/asm-generic/vmlinux.lds.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 17325416e2de..62669b36a772 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -586,6 +586,7 @@
 		NOINSTR_TEXT						\
 		*(.text..refcount)					\
 		*(.ref.text)						\
+		*(.text.asan.* .text.tsan.*)				\
 		TEXT_CFI_JT						\
 	MEM_KEEP(init.text*)						\
 	MEM_KEEP(exit.text*)						\

base-commit: 4669e13cd67f8532be12815ed3d37e775a9bdc16
-- 
2.32.0.264.g75ae10bc75


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1484F3DC12C
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 00:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhG3Wic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 18:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232672AbhG3Wib (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 18:38:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B00660F42;
        Fri, 30 Jul 2021 22:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627684706;
        bh=h7U1QIc72tE4CAGhduMNUTNeCMPsFA5JtAr1vUAT8I4=;
        h=From:To:Cc:Subject:Date:From;
        b=CBLwAqSqBb7fxSm9K3Ld4ESWOoyItdQ6tjS4JfQTlvIDAfQwugcR9JwqW31Up5r5a
         cV+iPS6ECYBjGxngiivQDzMpglK/Gt65JqCLWUO1bAXMvZJFkBU/KZaAreVT2bDlpC
         DTCEGRE0QBcaoaPDRKiQHogWhlHzG5ZSXWcRw3eJUPCzKe5PnCfvD+yWcAIgZgz6ax
         ux9+ufcDwqt5bk5PryujtVbiby9SXXJ/NS2S2Z0VMq64vwi4u/vfGMqelnhQY9nDua
         NQTLgVl13KUNrBtT52b8SjJuFyHO3MqCn6CVKhv1LLOeHkbdy7zG79o5IK2q+1z0FO
         X9TIza7z1MK2w==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Fangrui Song <maskray@google.com>, Marco Elver <elver@google.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] vmlinux.lds.h: Handle clang's module.{c,d}tor sections
Date:   Fri, 30 Jul 2021 15:38:15 -0700
Message-Id: <20210730223815.1382706-1-nathan@kernel.org>
X-Mailer: git-send-email 2.32.0.264.g75ae10bc75
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

Place them in the TEXT_TEXT section so that these technologies continue
to work with the newer compiler versions. All of the KASAN and KCSAN
KUnit tests continue to pass after this change.

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1432
Link: https://github.com/llvm/llvm-project/commit/7b789562244ee941b7bf2cefeb3fc08a59a01865
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 17325416e2de..3b79b1e76556 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -586,6 +586,7 @@
 		NOINSTR_TEXT						\
 		*(.text..refcount)					\
 		*(.ref.text)						\
+		*(.text.asan .text.asan.*)				\
 		TEXT_CFI_JT						\
 	MEM_KEEP(init.text*)						\
 	MEM_KEEP(exit.text*)						\

base-commit: 4669e13cd67f8532be12815ed3d37e775a9bdc16
-- 
2.32.0.264.g75ae10bc75


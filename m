Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1EC3F6725
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240535AbhHXRbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241074AbhHXR3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:29:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E83361B5F;
        Tue, 24 Aug 2021 17:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824727;
        bh=oQF46W8ELvGiGS4EY5krkIykNoMUeMOnVH1Ocyu/Nl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Je8xPFdd5+xQ03iuUP9H+PFGBEDa3K5kJxeF7FtSGQJMQlHl191jKnhc4PqL599K5
         lK1xU93v/oFNCJIh8MaOQNxc/Za6HlxHDGz/iav569QBYKlRAx17Y5d+CTOQjtePF7
         GKBYOtb8hnSfPVyBKxm5owVDZvjxxkALz5+Gkqj5F53MKwFfFh2xC1o7uoiUJdfcKW
         Ck+godB3PsrJRGAkNfwvkHSzmqXCun0rGwQG0qT/aDXauQwqtcNUuLpHTDqKCba0B8
         HiV5NsgHp4ID8NWttTawRRls10rCn6CQ8V8f6PFntJjqzbihO8ENw/3vQlM5AjiBF8
         SUN8XJ4Z3qGbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        Marco Elver <elver@google.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 29/64] vmlinux.lds.h: Handle clang's module.{c,d}tor sections
Date:   Tue, 24 Aug 2021 13:04:22 -0400
Message-Id: <20210824170457.710623-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 848378812e40152abe9b9baf58ce2004f76fb988 upstream.

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
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Fangrui Song <maskray@google.com>
Acked-by: Marco Elver <elver@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210731023107.1932981-1-nathan@kernel.org
[nc: Fix conflicts due to lack of cf68fffb66d60 and 266ff2a8f51f0]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/vmlinux.lds.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index c9790b2cdf34..45fe7295051f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -465,6 +465,7 @@
 		*(.text.unknown .text.unknown.*)			\
 		*(.text..refcount)					\
 		*(.ref.text)						\
+		*(.text.asan.* .text.tsan.*)				\
 	MEM_KEEP(init.text)						\
 	MEM_KEEP(exit.text)						\
 
-- 
2.30.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85BDC3F666D
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239467AbhHXRXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240000AbhHXRVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:21:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0581261B1C;
        Tue, 24 Aug 2021 17:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824609;
        bh=ta8Stluvmw+/efOexVD5+Hz2l1LtrMy7/lVNXcd+soo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eppSUwjVoTdwsL9s2jFNcgl71cFg7KTKN2FK6ilk/pa1NJhlRr717CI83yP1A0PQF
         xaMPPTlPlpyhwJTAxMbEtVEev/unzUb0HSGr5DL0cbWiqGYTfAjAksxLQAJClHXOtx
         hJJaqtOxZ1vucpfkNQgT/t25QVUTzQqygxP0cID2kf67YgHJHvORg8fleOG6n5EVyP
         witI9L5ZQrSGQtncniXfSqJmdefqHP158FBE5W07/QmwB9RSSGp5pnZXRNW+rQ83aA
         e2ltndKPVN73FtFzJmFilKeQ4QyhCcmbI8sDKpcz5OSiJo8WAEldD//SdmtqPc+1V6
         lR86GCWeNS/rA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        Marco Elver <elver@google.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 39/84] vmlinux.lds.h: Handle clang's module.{c,d}tor sections
Date:   Tue, 24 Aug 2021 13:02:05 -0400
Message-Id: <20210824170250.710392-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
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
[nc: Resolve conflict due to lack of cf68fffb66d60]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/vmlinux.lds.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index ad8766e1635e..a26e6f5034a6 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -508,6 +508,7 @@
 		NOINSTR_TEXT						\
 		*(.text..refcount)					\
 		*(.ref.text)						\
+		*(.text.asan.* .text.tsan.*)				\
 	MEM_KEEP(init.text*)						\
 	MEM_KEEP(exit.text*)						\
 
-- 
2.30.2


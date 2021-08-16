Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A263ED57E
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbhHPNLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:11:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239690AbhHPNKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:10:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9216D60F46;
        Mon, 16 Aug 2021 13:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119370;
        bh=BgpVBwlYA6SCKEr4slCLQiaSC7guV0FD4HrxxzLkECM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPtNLqGWJgSI5yqvkyghj3sVaWEklqymtknSBQ7nHH3HYLEj+DOsOszUbVwzuhlwq
         i/kVsAYZqLwNKpr4UazMEcY7EbrF+sntG9Y1ATvcQ37jF+L6ZGn61gg2xX2W1TGx/K
         MKLSRcix5R6HlehJJhuJnWeyFcKp5mhIuUWkvj20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        Marco Elver <elver@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 96/96] vmlinux.lds.h: Handle clangs module.{c,d}tor sections
Date:   Mon, 16 Aug 2021 15:02:46 +0200
Message-Id: <20210816125438.177346123@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 include/asm-generic/vmlinux.lds.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -599,6 +599,7 @@
 		NOINSTR_TEXT						\
 		*(.text..refcount)					\
 		*(.ref.text)						\
+		*(.text.asan.* .text.tsan.*)				\
 	MEM_KEEP(init.text*)						\
 	MEM_KEEP(exit.text*)						\
 



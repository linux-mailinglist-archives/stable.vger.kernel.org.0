Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C5443A10F
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbhJYThL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236176AbhJYTdl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:33:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2E6761177;
        Mon, 25 Oct 2021 19:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190157;
        bh=pw+g9uqhyfyHd9pZd8pNNIEmXfL04D2FURuJLm3OOso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pz7PIm/2SFo9aEwyNluVhvzYNPks7x12myYylUC7ub01wbaGuW6u6tlcXm3vG8yNi
         WKPYfNvZ12P9q1xrQgD9TaEJVtH9Q1lS5KGkZWN80VjN2yMjdrixiDW95ju/r85mz8
         sSYnWt9EflM2qBymQWCSUSTXZiuYAYYQ9xzOlsgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.4 57/58] ARM: 9122/1: select HAVE_FUTEX_CMPXCHG
Date:   Mon, 25 Oct 2021 21:15:14 +0200
Message-Id: <20211025190947.171093540@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 9d417cbe36eee7afdd85c2e871685f8dab7c2dba upstream.

tglx notes:
  This function [futex_detect_cmpxchg] is only needed when an
  architecture has to runtime discover whether the CPU supports it or
  not.  ARM has unconditional support for this, so the obvious thing to
  do is the below.

Fixes linkage failure from Clang randconfigs:
kernel/futex.o:(.text.fixup+0x5c): relocation truncated to fit: R_ARM_JUMP24 against `.init.text'
and boot failures for CONFIG_THUMB2_KERNEL.

Link: https://github.com/ClangBuiltLinux/linux/issues/325

Comments from Nick Desaulniers:

 See-also: 03b8c7b623c8 ("futex: Allow architectures to skip
 futex_atomic_cmpxchg_inatomic() test")

Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org # v3.14+
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -85,6 +85,7 @@ config ARM
 	select HAVE_FTRACE_MCOUNT_RECORD if !XIP_KERNEL
 	select HAVE_FUNCTION_GRAPH_TRACER if !THUMB2_KERNEL && !CC_IS_CLANG
 	select HAVE_FUNCTION_TRACER if !XIP_KERNEL && (CC_IS_GCC || CLANG_VERSION >= 100000)
+	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7)
 	select HAVE_IDE if PCI || ISA || PCMCIA



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECBB43A054
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbhJYT3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235532AbhJYT2o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:28:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C57FE6101C;
        Mon, 25 Oct 2021 19:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189910;
        bh=3lcIpEOPyB5lhTrFFmfhlwvpE53gdWhcl7M9UQYfqj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ueCHjorlgWEGtYvf0Ybjon2VPN8ENq1b9mguTeehmT7fUupoROhyFcEpRClkbnhv1
         289T6UFLq/Me2IqVaEVOqh+YNoX5hcyhaMDkm0TP5oOyatthYHeEnvqPIpdlLZUf2T
         S16q5nYoXfdTR828CMm0JOel253WQxaRGHG+yxpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.19 37/37] ARM: 9122/1: select HAVE_FUTEX_CMPXCHG
Date:   Mon, 25 Oct 2021 21:15:02 +0200
Message-Id: <20211025190935.807135683@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
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
@@ -70,6 +70,7 @@ config ARM
 	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
 	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
+	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_GCC_PLUGINS
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_HW_BREAKPOINT if (PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7))



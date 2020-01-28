Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 183E014B9BC
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731251AbgA1OeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:34:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729604AbgA1OYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:24:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D471724686;
        Tue, 28 Jan 2020 14:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221450;
        bh=6k/RjgHS/mjwmTDdfUv3W8+OAbT0TmR5iHWMt2mOk7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=co8iWEiVftwF23Bnv7LEx1S0xELYJHzELr6Jo9rglEj6MaXxjiqeXk2TwmOj40c4L
         wEtEdF2sY6Ny7kvRvJDIxzeui+SF70vONHjTRUrro5QYB7JhfxofPM3tb8CJK64Nqk
         FzZG1v67+iKXKFm/I+mD07K/uDrUUbcYd9m8fLDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 192/271] x86, perf: Fix the dependency of the x86 insn decoder selftest
Date:   Tue, 28 Jan 2020 15:05:41 +0100
Message-Id: <20200128135906.873980222@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 7720804a2ae46c90265a32c81c45fb6f8d2f4e8b ]

Since x86 instruction decoder is not only for kprobes,
it should be tested when the insn.c is compiled.
(e.g. perf is enabled but kprobes is disabled)

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: cbe5c34c8c1f ("x86: Compile insn.c and inat.c only for KPROBES")
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 4386440fe4635..f09a192260f8e 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -192,7 +192,7 @@ config HAVE_MMIOTRACE_SUPPORT
 
 config X86_DECODER_SELFTEST
 	bool "x86 instruction decoder selftest"
-	depends on DEBUG_KERNEL && KPROBES
+	depends on DEBUG_KERNEL && INSTRUCTION_DECODER
 	depends on !COMPILE_TEST
 	---help---
 	 Perform x86 instruction decoder selftests at build time.
-- 
2.20.1




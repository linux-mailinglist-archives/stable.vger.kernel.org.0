Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB1D13E9D9
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393621AbgAPRkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:40:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393267AbgAPRkX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:40:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BC2E24730;
        Thu, 16 Jan 2020 17:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196423;
        bh=o5gPEcy6S1beDbI7ydtgK1Bj4YDqYXTv+xEShICgOHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YvUjOYf4fE+gyEfpCzUNA9r4tTsqRsIJeqxzm41wP103b6v8gwpgCNgmnE/s6hFXt
         XjFsbDC1iNRjJ7e/+XKlPLkITnaBQZrylXU/vs7ek31zNItxQa/NLvAHBLmfDHq9rQ
         QgwJSzDJC2GzEfijezd6+Sv/mhbErtEmRbqq/PY0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 192/251] x86, perf: Fix the dependency of the x86 insn decoder selftest
Date:   Thu, 16 Jan 2020 12:35:41 -0500
Message-Id: <20200116173641.22137-152-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 4386440fe463..f09a192260f8 100644
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


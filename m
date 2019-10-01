Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 454E1C3DB8
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 19:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbfJARCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 13:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729622AbfJAQkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:40:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48B552168B;
        Tue,  1 Oct 2019 16:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948008;
        bh=WIl6W8ebQcojUGSsK88TdAJ9kurCE2C5egXd6emtgqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3Y4hzicVkYGO6ecBrsGnlAv+j/3NmJEmSZZdln8LHd6XbSPljzSP9LEOfmKfBYa3
         NUEqCh4pedGVhMi0zah9NUOK0lyg7vW45kQe98BqAQG7o61+HmN4hvWm111j0zG/n6
         Ico4ZgAq9bLfCrZ9QNG8p+2IkuqIbJCu6vOquUmc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 31/71] x86/purgatory: Disable the stackleak GCC plugin for the purgatory
Date:   Tue,  1 Oct 2019 12:38:41 -0400
Message-Id: <20191001163922.14735-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

[ Upstream commit ca14c996afe7228ff9b480cf225211cc17212688 ]

Since commit:

  b059f801a937 ("x86/purgatory: Use CFLAGS_REMOVE rather than reset KBUILD_CFLAGS")

kexec breaks if GCC_PLUGIN_STACKLEAK=y is enabled, as the purgatory
contains undefined references to stackleak_track_stack.

Attempting to load a kexec kernel results in this failure:

  kexec: Undefined symbol: stackleak_track_stack
  kexec-bzImage64: Loading purgatory failed

Fix this by disabling the stackleak plugin for the purgatory.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: b059f801a937 ("x86/purgatory: Use CFLAGS_REMOVE rather than reset KBUILD_CFLAGS")
Link: https://lkml.kernel.org/r/20190923171753.GA2252517@rani.riverdale.lan
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/purgatory/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 10fb42da0007e..b81b5172cf994 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -23,6 +23,7 @@ KCOV_INSTRUMENT := n
 
 PURGATORY_CFLAGS_REMOVE := -mcmodel=kernel
 PURGATORY_CFLAGS := -mcmodel=large -ffreestanding -fno-zero-initialized-in-bss
+PURGATORY_CFLAGS += $(DISABLE_STACKLEAK_PLUGIN)
 
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
 # in turn leaves some undefined symbols like __fentry__ in purgatory and not
-- 
2.20.1


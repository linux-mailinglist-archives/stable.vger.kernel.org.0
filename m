Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DFC1C16C3
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgEANwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:52:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730248AbgEANh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:37:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75A5B24955;
        Fri,  1 May 2020 13:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340244;
        bh=khfuUtphoGowJXyD29xSnB3vDa40rTfdz83YDfqA7vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/JSEOrvEpD+FbF2nZtFz2RLUSQq1qfk82b6SbnrCrXBEc5n+aWIFZWiBHoNfFVgb
         WMKX2Cr5dJr7jvfOKvaF233h4sv4rxFxKIC24aiwGyhmXW7lY6IOuV7hcZnfQoNMZX
         Rje1tNZ1KLq2YKbyLMFWTsvMhOvJiqJ3i6I48vIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilie Halip <ilie.halip@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/46] arm64: Delete the space separator in __emit_inst
Date:   Fri,  1 May 2020 15:23:04 +0200
Message-Id: <20200501131512.436917911@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangrui Song <maskray@google.com>

[ Upstream commit c9a4ef66450145a356a626c833d3d7b1668b3ded ]

In assembly, many instances of __emit_inst(x) expand to a directive. In
a few places __emit_inst(x) is used as an assembler macro argument. For
example, in arch/arm64/kvm/hyp/entry.S

  ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)

expands to the following by the C preprocessor:

  alternative_insn nop, .inst (0xd500401f | ((0) << 16 | (4) << 5) | ((!!1) << 8)), 4, 1

Both comma and space are separators, with an exception that content
inside a pair of parentheses/quotes is not split, so the clang
integrated assembler splits the arguments to:

   nop, .inst, (0xd500401f | ((0) << 16 | (4) << 5) | ((!!1) << 8)), 4, 1

GNU as preprocesses the input with do_scrub_chars(). Its arm64 backend
(along with many other non-x86 backends) sees:

  alternative_insn nop,.inst(0xd500401f|((0)<<16|(4)<<5)|((!!1)<<8)),4,1
  # .inst(...) is parsed as one argument

while its x86 backend sees:

  alternative_insn nop,.inst (0xd500401f|((0)<<16|(4)<<5)|((!!1)<<8)),4,1
  # The extra space before '(' makes the whole .inst (...) parsed as two arguments

The non-x86 backend's behavior is considered unintentional
(https://sourceware.org/bugzilla/show_bug.cgi?id=25750).
So drop the space separator inside `.inst (...)` to make the clang
integrated assembler work.

Suggested-by: Ilie Halip <ilie.halip@gmail.com>
Signed-off-by: Fangrui Song <maskray@google.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/939
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 3091ae5975a3a..ed99d941c4623 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -60,7 +60,9 @@
 #ifndef CONFIG_BROKEN_GAS_INST
 
 #ifdef __ASSEMBLY__
-#define __emit_inst(x)			.inst (x)
+// The space separator is omitted so that __emit_inst(x) can be parsed as
+// either an assembler directive or an assembler macro argument.
+#define __emit_inst(x)			.inst(x)
 #else
 #define __emit_inst(x)			".inst " __stringify((x)) "\n\t"
 #endif
-- 
2.20.1




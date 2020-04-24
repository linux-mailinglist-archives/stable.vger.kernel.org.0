Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5E51B752B
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgDXMXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbgDXMXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 360F8215A4;
        Fri, 24 Apr 2020 12:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587730991;
        bh=XjxUPLmaZfpR/Y4FaTxgXOpZTIC1gf1eeU66oXHFRZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WpyVTfU1AbUoqDXzPyz4z+HNYjXtfMcZCGu2BbZ/MuLEFshUnImZh78XXgkY9D1gY
         b6o2IYDeDBNSqVxYUYsc0aiM4cLt7U9X8c/yLaP1pz2A8B8ZeyVoUmEWvV9yhwr4V1
         sILqsqp/mk8AIe7lZHciHn7uF/fmTnnZFBHurwlI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fangrui Song <maskray@google.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.6 29/38] arm64: Delete the space separator in __emit_inst
Date:   Fri, 24 Apr 2020 08:22:27 -0400
Message-Id: <20200424122237.9831-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122237.9831-1-sashal@kernel.org>
References: <20200424122237.9831-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b91570ff9db14..931037500e83c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -49,7 +49,9 @@
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


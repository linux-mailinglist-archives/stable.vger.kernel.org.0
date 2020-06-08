Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B651F2436
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbgFHXTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:19:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729136AbgFHXTL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:19:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61E0C2089D;
        Mon,  8 Jun 2020 23:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658351;
        bh=wYOBonMFOcw+NCR1S5pFDveiILnmyP7Jt2GUW7nzcvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBZu0zdpyQA1kELPM1ysfKWcx3oMuPSQrVavJY0C1cIAgoSsT1PQUe2PgKlVK48hj
         16kvqMEs6mBkI4DK7qwheJA/p3fZjvHt9mRFcn1Y34F0qsdkvu/QBAH61xViIJreoh
         ny0x1ou3upl2Lz9x+TnQtpCOK/L0rHOaYL2Ic4FI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 018/175] x86,smap: Fix smap_{save,restore}() alternatives
Date:   Mon,  8 Jun 2020 19:16:11 -0400
Message-Id: <20200608231848.3366970-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 1ff865e343c2b59469d7e41d370a980a3f972c71 ]

As reported by objtool:

  lib/ubsan.o: warning: objtool: .altinstr_replacement+0x0: alternative modifies stack
  lib/ubsan.o: warning: objtool: .altinstr_replacement+0x7: alternative modifies stack

the smap_{save,restore}() alternatives violate (the newly enforced)
rule on stack invariance. That is, due to there only being a single
ORC table it must be valid to any alternative. These alternatives
violate this with the direct result that unwinds will not be correct
when it hits between the PUSH and POP instructions.

Rewrite the functions to only have a conditional jump.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lkml.kernel.org/r/20200429101802.GI13592@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/smap.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/smap.h b/arch/x86/include/asm/smap.h
index 27c47d183f4b..8b58d6975d5d 100644
--- a/arch/x86/include/asm/smap.h
+++ b/arch/x86/include/asm/smap.h
@@ -57,8 +57,10 @@ static __always_inline unsigned long smap_save(void)
 {
 	unsigned long flags;
 
-	asm volatile (ALTERNATIVE("", "pushf; pop %0; " __ASM_CLAC,
-				  X86_FEATURE_SMAP)
+	asm volatile ("# smap_save\n\t"
+		      ALTERNATIVE("jmp 1f", "", X86_FEATURE_SMAP)
+		      "pushf; pop %0; " __ASM_CLAC "\n\t"
+		      "1:"
 		      : "=rm" (flags) : : "memory", "cc");
 
 	return flags;
@@ -66,7 +68,10 @@ static __always_inline unsigned long smap_save(void)
 
 static __always_inline void smap_restore(unsigned long flags)
 {
-	asm volatile (ALTERNATIVE("", "push %0; popf", X86_FEATURE_SMAP)
+	asm volatile ("# smap_restore\n\t"
+		      ALTERNATIVE("jmp 1f", "", X86_FEATURE_SMAP)
+		      "push %0; popf\n\t"
+		      "1:"
 		      : : "g" (flags) : "memory", "cc");
 }
 
-- 
2.25.1


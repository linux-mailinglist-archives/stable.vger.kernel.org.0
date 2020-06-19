Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1BE201434
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391290AbgFSPFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391287AbgFSPFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:05:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2821521974;
        Fri, 19 Jun 2020 15:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579121;
        bh=wYOBonMFOcw+NCR1S5pFDveiILnmyP7Jt2GUW7nzcvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CM51Vx6h/eaYH11Y6s2J/t0xhi237qrPElF8pc+YyuigLYJabN2nI6uFaYbcMd4Jf
         vnDAMXTlVm/0WbVoyaF6A8aogc2Xtei/CIeBQGFQfwVN31ZM3pjP0Fk68M3phE+9G4
         Up77uYUX69gbPSPLnf0b14MmacO/z1x7YA349p5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/261] x86,smap: Fix smap_{save,restore}() alternatives
Date:   Fri, 19 Jun 2020 16:30:27 +0200
Message-Id: <20200619141650.638210102@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




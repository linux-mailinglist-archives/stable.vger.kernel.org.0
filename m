Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39BF4FCB0C
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345048AbiDLBCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344447AbiDLA6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:58:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144AC27FCE;
        Mon, 11 Apr 2022 17:50:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B88B9B819B4;
        Tue, 12 Apr 2022 00:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30820C385A3;
        Tue, 12 Apr 2022 00:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724598;
        bh=brtuF43pM50XqWsrLtaTVNwuTiY5ZTnr6ySqkkguyiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQLo+t/KwtRpyM7kcZ629SszVTcAVUd6z29nozPZ6gCdV+O2TNgOozH9771HrN0KI
         YAr+PHNPqrM3o7egsoLaCBcH+fyJup3XDHo7EnezJhxpzhF7+tEKr317jb37fCz9Ka
         YKQerMAKPKahs3pen+RgS2KUN40L+Acj9O8i9cll2II6zkf/viQ3byR9Ta/t6hkwhR
         7xUiCSdaOXCesnTBWfSaLRn06nfWO3UB7/PNMRRRaWF0fw6lWckdbSVz37XuzkhoCG
         DAygic3mLHxCxhpLOyHoLrjQETXOVdOjQRPMPovzK5KrBbgito67zkwTuP1iRGjo+t
         8uZNUTlo6wOlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joey Gouly <joey.gouly@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        ardb@kernel.org, tabba@google.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 18/30] arm64: alternatives: mark patch_alternative() as `noinstr`
Date:   Mon, 11 Apr 2022 20:48:52 -0400
Message-Id: <20220412004906.350678-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004906.350678-1-sashal@kernel.org>
References: <20220412004906.350678-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joey Gouly <joey.gouly@arm.com>

[ Upstream commit a2c0b0fbe01419f8f5d1c0b9c581631f34ffce8b ]

The alternatives code must be `noinstr` such that it does not patch itself,
as the cache invalidation is only performed after all the alternatives have
been applied.

Mark patch_alternative() as `noinstr`. Mark branch_insn_requires_update()
and get_alt_insn() with `__always_inline` since they are both only called
through patch_alternative().

Booting a kernel in QEMU TCG with KCSAN=y and ARM64_USE_LSE_ATOMICS=y caused
a boot hang:
[    0.241121] CPU: All CPU(s) started at EL2

The alternatives code was patching the atomics in __tsan_read4() from LL/SC
atomics to LSE atomics.

The following fragment is using LL/SC atomics in the .text section:
  | <__tsan_unaligned_read4+304>:     ldxr    x6, [x2]
  | <__tsan_unaligned_read4+308>:     add     x6, x6, x5
  | <__tsan_unaligned_read4+312>:     stxr    w7, x6, [x2]
  | <__tsan_unaligned_read4+316>:     cbnz    w7, <__tsan_unaligned_read4+304>

This LL/SC atomic sequence was to be replaced with LSE atomics. However since
the alternatives code was instrumentable, __tsan_read4() was being called after
only the first instruction was replaced, which led to the following code in memory:
  | <__tsan_unaligned_read4+304>:     ldadd   x5, x6, [x2]
  | <__tsan_unaligned_read4+308>:     add     x6, x6, x5
  | <__tsan_unaligned_read4+312>:     stxr    w7, x6, [x2]
  | <__tsan_unaligned_read4+316>:     cbnz    w7, <__tsan_unaligned_read4+304>

This caused an infinite loop as the `stxr` instruction never completed successfully,
so `w7` was always 0.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20220405104733.11476-1-joey.gouly@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/alternative.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
index 73039949b5ce..5f8e4c2df53c 100644
--- a/arch/arm64/kernel/alternative.c
+++ b/arch/arm64/kernel/alternative.c
@@ -41,7 +41,7 @@ bool alternative_is_applied(u16 cpufeature)
 /*
  * Check if the target PC is within an alternative block.
  */
-static bool branch_insn_requires_update(struct alt_instr *alt, unsigned long pc)
+static __always_inline bool branch_insn_requires_update(struct alt_instr *alt, unsigned long pc)
 {
 	unsigned long replptr = (unsigned long)ALT_REPL_PTR(alt);
 	return !(pc >= replptr && pc <= (replptr + alt->alt_len));
@@ -49,7 +49,7 @@ static bool branch_insn_requires_update(struct alt_instr *alt, unsigned long pc)
 
 #define align_down(x, a)	((unsigned long)(x) & ~(((unsigned long)(a)) - 1))
 
-static u32 get_alt_insn(struct alt_instr *alt, __le32 *insnptr, __le32 *altinsnptr)
+static __always_inline u32 get_alt_insn(struct alt_instr *alt, __le32 *insnptr, __le32 *altinsnptr)
 {
 	u32 insn;
 
@@ -94,7 +94,7 @@ static u32 get_alt_insn(struct alt_instr *alt, __le32 *insnptr, __le32 *altinsnp
 	return insn;
 }
 
-static void patch_alternative(struct alt_instr *alt,
+static noinstr void patch_alternative(struct alt_instr *alt,
 			      __le32 *origptr, __le32 *updptr, int nr_inst)
 {
 	__le32 *replptr;
-- 
2.35.1


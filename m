Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136CE4FCB16
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345809AbiDLBDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348699AbiDLA7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:59:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FB1377CE;
        Mon, 11 Apr 2022 17:52:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EFA7B815C8;
        Tue, 12 Apr 2022 00:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056F5C385A4;
        Tue, 12 Apr 2022 00:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724760;
        bh=dTn9HoIv+Q2wpWs2HOg+fKoJy6OaF2Zknerq4Yl2YDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZH4yXzXaA0Heou7FoOscG5jU1INK0teAuDg3BHoLrPTtl7horPJZ/hQz5NFxxygWY
         0IfS2cbktkxAtEpSRmPUZjqYjfxbTULT4TNU6eyyukGq7Ux4j55PdEJcps/SCCb82V
         fMLzGbXMeum+ufpY/ynxi0FSMePwe6tjuQ2XB3GTe77SseSOr5//RLzGiGz25rgeAI
         cD5bVqFxa/w64p6lc5ZDQ431eeLYetXoHaO5UORMzYfgwXqJG5QDFPpnLGoQb+hzhc
         WHyIp6DT4JtjHhqSSiCCB0JmnMwjw8UlGndlJoFfyn38Ifu3WCF3r6BNcqq2delhig
         oNBDsKDalocHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joey Gouly <joey.gouly@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        ardb@kernel.org, tabba@google.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 09/11] arm64: alternatives: mark patch_alternative() as `noinstr`
Date:   Mon, 11 Apr 2022 20:52:18 -0400
Message-Id: <20220412005222.351554-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412005222.351554-1-sashal@kernel.org>
References: <20220412005222.351554-1-sashal@kernel.org>
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
index 4c385763c361..1398fd816068 100644
--- a/arch/arm64/kernel/alternative.c
+++ b/arch/arm64/kernel/alternative.c
@@ -42,7 +42,7 @@ struct alt_region {
 /*
  * Check if the target PC is within an alternative block.
  */
-static bool branch_insn_requires_update(struct alt_instr *alt, unsigned long pc)
+static __always_inline bool branch_insn_requires_update(struct alt_instr *alt, unsigned long pc)
 {
 	unsigned long replptr = (unsigned long)ALT_REPL_PTR(alt);
 	return !(pc >= replptr && pc <= (replptr + alt->alt_len));
@@ -50,7 +50,7 @@ static bool branch_insn_requires_update(struct alt_instr *alt, unsigned long pc)
 
 #define align_down(x, a)	((unsigned long)(x) & ~(((unsigned long)(a)) - 1))
 
-static u32 get_alt_insn(struct alt_instr *alt, __le32 *insnptr, __le32 *altinsnptr)
+static __always_inline u32 get_alt_insn(struct alt_instr *alt, __le32 *insnptr, __le32 *altinsnptr)
 {
 	u32 insn;
 
@@ -95,7 +95,7 @@ static u32 get_alt_insn(struct alt_instr *alt, __le32 *insnptr, __le32 *altinsnp
 	return insn;
 }
 
-static void patch_alternative(struct alt_instr *alt,
+static noinstr void patch_alternative(struct alt_instr *alt,
 			      __le32 *origptr, __le32 *updptr, int nr_inst)
 {
 	__le32 *replptr;
-- 
2.35.1


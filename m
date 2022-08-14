Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED145592564
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243336AbiHNQmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243377AbiHNQkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:40:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB565F40;
        Sun, 14 Aug 2022 09:31:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE0A960F73;
        Sun, 14 Aug 2022 16:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27383C433C1;
        Sun, 14 Aug 2022 16:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494680;
        bh=WnMkrFmRqTr/C6KW7WcHvuKKxCCcy1TaXXmxhygiNlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AafPMN7naZneKeqK1CAqc4CUJqDcngZ7R6+buGJ1ksHbW8ZHu7+KQCUtzIN3b0MEG
         qBkTPHpZ0fJ56NX5D/K2IkJI28NwUd8gf5WzydGgyvqnZMg031WqZvkI/Nvhdfvqdw
         Tir3N8fNwRS+hAyRAl8X9CknBSQuwkbTYUCGABkloihlu58mbecX2cTbcTEkhJn5+g
         ROirRPT+wuhP4jakKbczdoOKf28YfX77Z8Qf7iP5hVJNy8r55DQkXvpKzmN5gsrEi/
         7uYAnHEzMqhaJnv/W+dtTK7iu0blxxO2enFE08GSEdAJrUurUzt+AvOtK71IFFj3OQ
         TzbwKdaM7P+LQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, ndesaulniers@google.com,
        macro@orcam.me.uk, linux-mips@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 4.9 8/8] MIPS: tlbex: Explicitly compare _PAGE_NO_EXEC against 0
Date:   Sun, 14 Aug 2022 12:30:41 -0400
Message-Id: <20220814163041.2399552-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814163041.2399552-1-sashal@kernel.org>
References: <20220814163041.2399552-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 74de14fe05dd6b151d73cb0c73c8ec874cbdcde6 ]

When CONFIG_XPA is enabled, Clang warns:

  arch/mips/mm/tlbex.c:629:24: error: converting the result of '<<' to a boolean; did you mean '(1 << _PAGE_NO_EXEC_SHIFT) != 0'? [-Werror,-Wint-in-bool-context]
          if (cpu_has_rixi && !!_PAGE_NO_EXEC) {
                              ^
  arch/mips/include/asm/pgtable-bits.h:174:28: note: expanded from macro '_PAGE_NO_EXEC'
  # define _PAGE_NO_EXEC          (1 << _PAGE_NO_EXEC_SHIFT)
                                     ^
  arch/mips/mm/tlbex.c:2568:24: error: converting the result of '<<' to a boolean; did you mean '(1 << _PAGE_NO_EXEC_SHIFT) != 0'? [-Werror,-Wint-in-bool-context]
          if (!cpu_has_rixi || !_PAGE_NO_EXEC) {
                                ^
  arch/mips/include/asm/pgtable-bits.h:174:28: note: expanded from macro '_PAGE_NO_EXEC'
  # define _PAGE_NO_EXEC          (1 << _PAGE_NO_EXEC_SHIFT)
                                     ^
  2 errors generated.

_PAGE_NO_EXEC can be '0' or '1 << _PAGE_NO_EXEC_SHIFT' depending on the
build and runtime configuration, which is what the negation operators
are trying to convey. To silence the warning, explicitly compare against
0 so the result of the '<<' operator is not implicitly converted to a
boolean.

According to its documentation, GCC enables -Wint-in-bool-context with
-Wall but this warning is not visible when building the same
configuration with GCC. It appears GCC only warns when compiling C++,
not C, although the documentation makes no note of this:
https://godbolt.org/z/x39q3brxf

Reported-by: Sudip Mukherjee (Codethink) <sudipm.mukherjee@gmail.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/tlbex.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index f625fd20b21e..65fed205383e 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -637,7 +637,7 @@ static __maybe_unused void build_convert_pte_to_entrylo(u32 **p,
 		return;
 	}
 
-	if (cpu_has_rixi && !!_PAGE_NO_EXEC) {
+	if (cpu_has_rixi && _PAGE_NO_EXEC != 0) {
 		if (fill_includes_sw_bits) {
 			UASM_i_ROTR(p, reg, reg, ilog2(_PAGE_GLOBAL));
 		} else {
@@ -2518,7 +2518,7 @@ static void check_pabits(void)
 	unsigned long entry;
 	unsigned pabits, fillbits;
 
-	if (!cpu_has_rixi || !_PAGE_NO_EXEC) {
+	if (!cpu_has_rixi || _PAGE_NO_EXEC == 0) {
 		/*
 		 * We'll only be making use of the fact that we can rotate bits
 		 * into the fill if the CPU supports RIXI, so don't bother
-- 
2.35.1


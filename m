Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D65E592573
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243124AbiHNQmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243122AbiHNQkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:40:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5286461;
        Sun, 14 Aug 2022 09:30:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4836B80B37;
        Sun, 14 Aug 2022 16:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98940C433D7;
        Sun, 14 Aug 2022 16:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494640;
        bh=NQE+D1YIAmhEbIgHZMr35QDB/H8Pj1G4SuYfoV8s4vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kR+GppXMxaP1b4bLNf76+J3teXuZUSpDgpp+YFoBlYm+5rBYKcufpMd4dZ8OHfBxd
         xeC5MKHli6I939BPKOKh4HADC/K8Cr3ZLyk1MzjQG4jNRu1nXr+qrIaNOyxD7EYuqu
         IQgbn0zR0wTJZlL4qm9mckGDKax03xQ2A4EK7byOj4IK3nZkizOxyrfT8z7EY3kiC4
         HyT8dDjqsD6FL5yEXIRCKaX5L9esOKvNiAifg25KhdQZOoo1c516/7ah1RpwJO6Yau
         bpKkaT/qWVSSLmC7/VS0MDv55TXls8rLhPHDS3ezT6qbjHk+eQWMSBE/M9P7G3CUAw
         cYKsFnuZcwwAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, ndesaulniers@google.com,
        macro@orcam.me.uk, linux-mips@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 4.14 9/9] MIPS: tlbex: Explicitly compare _PAGE_NO_EXEC against 0
Date:   Sun, 14 Aug 2022 12:29:59 -0400
Message-Id: <20220814162959.2399011-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162959.2399011-1-sashal@kernel.org>
References: <20220814162959.2399011-1-sashal@kernel.org>
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
index b55c74a7f7a4..82cd14e7b20d 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -634,7 +634,7 @@ static __maybe_unused void build_convert_pte_to_entrylo(u32 **p,
 		return;
 	}
 
-	if (cpu_has_rixi && !!_PAGE_NO_EXEC) {
+	if (cpu_has_rixi && _PAGE_NO_EXEC != 0) {
 		if (fill_includes_sw_bits) {
 			UASM_i_ROTR(p, reg, reg, ilog2(_PAGE_GLOBAL));
 		} else {
@@ -2577,7 +2577,7 @@ static void check_pabits(void)
 	unsigned long entry;
 	unsigned pabits, fillbits;
 
-	if (!cpu_has_rixi || !_PAGE_NO_EXEC) {
+	if (!cpu_has_rixi || _PAGE_NO_EXEC == 0) {
 		/*
 		 * We'll only be making use of the fact that we can rotate bits
 		 * into the fill if the CPU supports RIXI, so don't bother
-- 
2.35.1


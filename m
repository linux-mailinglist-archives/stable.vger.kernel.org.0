Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17AD55410D2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355336AbiFGT3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356895AbiFGT2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:28:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931761A29DC;
        Tue,  7 Jun 2022 11:11:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D072617B3;
        Tue,  7 Jun 2022 18:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AD3C385A2;
        Tue,  7 Jun 2022 18:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625493;
        bh=KidPKL7CSKLt/gRwD34Zy5/VxtuEN1OY6TljW2bDPrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZR13fW8Y9x8Qjwsak3ugjMr/0v56HThD7sHwBmbrZ0KotTBXcnd5Rk6cMCcDEBacR
         V+Cwo61avKEaPKYeHdXbP7ayzA4fVpPrlXFJgB0hlyVCenrfmKmX+96LFiA2qfxzBr
         0huxwq2uIVjEC0sWPZIXz1fAh7cm9dOsh6bTwQ0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.17 009/772] riscv: Move alternative length validation into subsection
Date:   Tue,  7 Jun 2022 18:53:21 +0200
Message-Id: <20220607164949.272942597@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 61114e734ccb804bc12561ab4020745e02c468c2 upstream.

After commit 49b290e430d3 ("riscv: prevent compressed instructions in
alternatives"), builds with LLVM's integrated assembler fail:

  In file included from arch/riscv/mm/init.c:10:
  In file included from ./include/linux/mm.h:29:
  In file included from ./include/linux/pgtable.h:6:
  In file included from ./arch/riscv/include/asm/pgtable.h:108:
  ./arch/riscv/include/asm/tlbflush.h:23:2: error: expected assembly-time absolute expression
          ALT_FLUSH_TLB_PAGE(__asm__ __volatile__ ("sfence.vma %0" : : "r" (addr) : "memory"));
          ^
  ./arch/riscv/include/asm/errata_list.h:33:5: note: expanded from macro 'ALT_FLUSH_TLB_PAGE'
  asm(ALTERNATIVE("sfence.vma %0", "sfence.vma", SIFIVE_VENDOR_ID,        \
      ^
  ./arch/riscv/include/asm/alternative-macros.h:187:2: note: expanded from macro 'ALTERNATIVE'
          _ALTERNATIVE_CFG(old_content, new_content, vendor_id, errata_id, CONFIG_k)
          ^
  ./arch/riscv/include/asm/alternative-macros.h:113:2: note: expanded from macro '_ALTERNATIVE_CFG'
          __ALTERNATIVE_CFG(old_c, new_c, vendor_id, errata_id, IS_ENABLED(CONFIG_k))
          ^
  ./arch/riscv/include/asm/alternative-macros.h:110:2: note: expanded from macro '__ALTERNATIVE_CFG'
          ALT_NEW_CONTENT(vendor_id, errata_id, enable, new_c)
          ^
  ./arch/riscv/include/asm/alternative-macros.h:99:3: note: expanded from macro 'ALT_NEW_CONTENT'
          ".org   . - (889b - 888b) + (887b - 886b)\n"                    \
           ^
  <inline asm>:26:6: note: instantiated into assembly here
  .org    . - (889b - 888b) + (887b - 886b)
          ^

This error happens because LLVM's integrated assembler has a one-pass
design, which means it cannot figure out the instruction lengths when
the .org directive is outside of the subsection that contains the
instructions, which was changed by the .option directives added by the
above change.

Move the .org directives before the .previous directive so that these
directives are always within the same subsection, which resolves the
failures and does not introduce any new issues with GNU as. This was
done for arm64 in commit 966a0acce2fc ("arm64/alternatives: move length
validation inside the subsection") and commit 22315a2296f4 ("arm64:
alternatives: Move length validation in alternative_{insn, endif}").

While there is no error from the assembly versions of the macro, they
appear to have the same problem so just make the same change there as
well so that there are no problems in the future.

Link: https://github.com/ClangBuiltLinux/linux/issues/1640
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20220516214520.3252074-1-nathan@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/alternative-macros.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/alternative-macros.h
+++ b/arch/riscv/include/asm/alternative-macros.h
@@ -23,9 +23,9 @@
 888 :
 	\new_c
 889 :
-	.previous
 	.org    . - (889b - 888b) + (887b - 886b)
 	.org    . - (887b - 886b) + (889b - 888b)
+	.previous
 	.endif
 .endm
 
@@ -60,9 +60,9 @@
 	"888 :\n"							\
 	new_c "\n"							\
 	"889 :\n"							\
-	".previous\n"							\
 	".org	. - (887b - 886b) + (889b - 888b)\n"			\
 	".org	. - (889b - 888b) + (887b - 886b)\n"			\
+	".previous\n"							\
 	".endif\n"
 
 #define __ALTERNATIVE_CFG(old_c, new_c, vendor_id, errata_id, enable) \



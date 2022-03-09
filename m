Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CB74D39EB
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 20:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbiCITUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 14:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237632AbiCITUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 14:20:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3D4114FC4;
        Wed,  9 Mar 2022 11:19:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7700DB82396;
        Wed,  9 Mar 2022 19:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FE1C340E8;
        Wed,  9 Mar 2022 19:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646853551;
        bh=mZ0YOFOw30QUQWww8HEgcbPZ7ISUs/jOLiEzn+8383E=;
        h=From:To:Cc:Subject:Date:From;
        b=jYYWjfr7qHblMTfR0x3UegRLIdjcsCfTQN4OejzagH6Yfbo3B3Zo2vNiDSO7dCFbh
         6eUgwXUcTXPWszRSF9FhQGqPRlOMms/v6yPVCxsOLOu5Mr4xYtNlnAXJC9TwfKjv8f
         HzDDXmaqMTPCW321oAC2T6cYAVTWoNY7fzDzRZZzgmvLKl9of+ODytuREB9LrYYoYr
         ADbd7m1FqnZKrRhoI3xudSm3bEkbpJRDQ2uJN9DjDgsrsMO46wxYdAl2Ye6xx+XWQY
         az03UbI6T6si1J8pHOKey6tnwq8clOy/pJcSU9dEY+grd7ROciynKK9h6gPAIE4IOb
         XIrTSJSKh9JRA==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>
Subject: [PATCH] arm64: Do not include __READ_ONCE() block in assembly files
Date:   Wed,  9 Mar 2022 12:16:34 -0700
Message-Id: <20220309191633.2307110-1-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When building arm64 defconfig + CONFIG_LTO_CLANG_{FULL,THIN}=y after
commit 558c303c9734 ("arm64: Mitigate spectre style branch history side
channels"), the following error occurs:

  <instantiation>:4:2: error: invalid fixup for movz/movk instruction
   mov w0, #ARM_SMCCC_ARCH_WORKAROUND_3
   ^

Marc figured out that moving "#include <linux/init.h>" in
include/linux/arm-smccc.h into a !__ASSEMBLY__ block resolves it. The
full include chain with CONFIG_LTO=y from include/linux/arm-smccc.h:

include/linux/init.h
include/linux/compiler.h
arch/arm64/include/asm/rwonce.h
arch/arm64/include/asm/alternative-macros.h
arch/arm64/include/asm/assembler.h

The asm/alternative-macros.h include in asm/rwonce.h only happens when
CONFIG_LTO is set, which ultimately casues asm/assembler.h to be
included before the definition of ARM_SMCCC_ARCH_WORKAROUND_3. As a
result, the preprocessor does not expand ARM_SMCCC_ARCH_WORKAROUND_3 in
__mitigate_spectre_bhb_fw, which results in the error above.

Avoid this problem by just avoiding the CONFIG_LTO=y __READ_ONCE() block
in asm/rwonce.h with assembly files, as nothing in that block is useful
to assembly files, which allows ARM_SMCCC_ARCH_WORKAROUND_3 to be
properly expanded with CONFIG_LTO=y builds.

Cc: stable@vger.kernel.org
Fixes: e35123d83ee3 ("arm64: lto: Strengthen READ_ONCE() to acquire when CONFIG_LTO=y")
Link: https://lore.kernel.org/r/20220309155716.3988480-1-maz@kernel.org/
Reported-by: Marc Zyngier <maz@kernel.org>
Acked-by: James Morse <james.morse@arm.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

This is based on current mainline; if it should be based on a specific
arm64 branch, please let me know.

As 558c303c9734 is going to stable, I marked this for stable as well to
avoid breaking Android. I used e35123d83ee3 for the fixes tag to make it
clear to the stable team this should only go where that commit is
present. If a different fixes tag should be used, please feel free to
substitute.

 arch/arm64/include/asm/rwonce.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/rwonce.h b/arch/arm64/include/asm/rwonce.h
index 1bce62fa908a..56f7b1d4d54b 100644
--- a/arch/arm64/include/asm/rwonce.h
+++ b/arch/arm64/include/asm/rwonce.h
@@ -5,7 +5,7 @@
 #ifndef __ASM_RWONCE_H
 #define __ASM_RWONCE_H
 
-#ifdef CONFIG_LTO
+#if defined(CONFIG_LTO) && !defined(__ASSEMBLY__)
 
 #include <linux/compiler_types.h>
 #include <asm/alternative-macros.h>
@@ -66,7 +66,7 @@
 })
 
 #endif	/* !BUILD_VDSO */
-#endif	/* CONFIG_LTO */
+#endif	/* CONFIG_LTO && !__ASSEMBLY__ */
 
 #include <asm-generic/rwonce.h>
 

base-commit: 330f4c53d3c2d8b11d86ec03a964b86dc81452f5
-- 
2.35.1


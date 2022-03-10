Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0894D491C
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243146AbiCJOPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243148AbiCJOPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:15:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5487154D34;
        Thu, 10 Mar 2022 06:12:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66632B82675;
        Thu, 10 Mar 2022 14:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5681C340F5;
        Thu, 10 Mar 2022 14:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921527;
        bh=DDcQHV5a0KtCCaEURI9eSRlk8zEBFRX7Vfhil/8aT4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXx1nCQNJa+Hexaxkv/OMJ10cWRTCz0m8EY0hG3e/YH0tWKqY/jugqD1Ow88HYTbr
         sbbaxAro+XP759/rzOPFPvdT+SNt/ZblDbMctODFQtRUhAfHwvLO2d3lh9eonU7/CD
         MpU43DDX8Eza/oQAE4It/1UzlJl4hpPwT2mWtnfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.16 40/53] arm64: Do not include __READ_ONCE() block in assembly files
Date:   Thu, 10 Mar 2022 15:09:45 +0100
Message-Id: <20220310140812.984993320@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
References: <20220310140811.832630727@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Nathan Chancellor <nathan@kernel.org>

commit 52c9f93a9c482251cb0d224faa602ba26d462be8 upstream.

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

Fixes: e35123d83ee3 ("arm64: lto: Strengthen READ_ONCE() to acquire when CONFIG_LTO=y")
Cc: <stable@vger.kernel.org> # 5.11.x
Link: https://lore.kernel.org/r/20220309155716.3988480-1-maz@kernel.org/
Reported-by: Marc Zyngier <maz@kernel.org>
Acked-by: James Morse <james.morse@arm.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20220309191633.2307110-1-nathan@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/rwonce.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
 



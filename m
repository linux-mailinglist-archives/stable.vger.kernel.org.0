Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BC84E93DC
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbiC1LZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241732AbiC1LYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:24:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0704655BDC;
        Mon, 28 Mar 2022 04:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96EDA61174;
        Mon, 28 Mar 2022 11:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560F1C340EC;
        Mon, 28 Mar 2022 11:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466515;
        bh=YCzwUFyhUEJ/GM5eR1opJD1pGTH09ZAKXiiX9wurdYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TZJ7Euvxhze2CCqbN5MATDYdnPUCPTYhrCD4WfyKWtDKXGSA5qNFfmJ3FmNVXWtB2
         h73F1hZHyhV0Ebgh6Dk1CUcZ/jChJdgzpHk/5zdj3VMnlQ66stNWjBs3s9Qd/IPwsU
         JF61OFUnAS/Eeka9av+DnHW1fFu2fxzr0UQUl0IWwRiHxtuSAU+6yeVbztDOIAP3GL
         y7lUNFmdhx3HU5Q3cwqbPeD89n6GbicP1psneDjzWFzBoH/K8HUjSl/FS8jdpWXcio
         vcNax/cUr4eLChd9Ry2O7UYWeJKLxGDVmuSajm9A45VSxJKg7qu0hcE6kQFyolOjY2
         ZCIhBuvLYnOGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fangrui Song <maskray@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        catalin.marinas@arm.com, ndesaulniers@google.com,
        mark.rutland@arm.com, andreyknvl@gmail.com, pcc@google.com,
        linux-arm-kernel@lists.infradead.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 12/29] arm64: module: remove (NOLOAD) from linker script
Date:   Mon, 28 Mar 2022 07:21:14 -0400
Message-Id: <20220328112132.1555683-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112132.1555683-1-sashal@kernel.org>
References: <20220328112132.1555683-1-sashal@kernel.org>
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

From: Fangrui Song <maskray@google.com>

[ Upstream commit 4013e26670c590944abdab56c4fa797527b74325 ]

On ELF, (NOLOAD) sets the section type to SHT_NOBITS[1]. It is conceptually
inappropriate for .plt and .text.* sections which are always
SHT_PROGBITS.

In GNU ld, if PLT entries are needed, .plt will be SHT_PROGBITS anyway
and (NOLOAD) will be essentially ignored. In ld.lld, since
https://reviews.llvm.org/D118840 ("[ELF] Support (TYPE=<value>) to
customize the output section type"), ld.lld will report a `section type
mismatch` error. Just remove (NOLOAD) to fix the error.

[1] https://lld.llvm.org/ELF/linker_script.html As of today, "The
section should be marked as not loadable" on
https://sourceware.org/binutils/docs/ld/Output-Section-Type.html is
outdated for ELF.

Tested-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Fangrui Song <maskray@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20220218081209.354383-1-maskray@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/module.lds.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/module.lds.h b/arch/arm64/include/asm/module.lds.h
index a11ccadd47d2..094701ec5500 100644
--- a/arch/arm64/include/asm/module.lds.h
+++ b/arch/arm64/include/asm/module.lds.h
@@ -1,8 +1,8 @@
 SECTIONS {
 #ifdef CONFIG_ARM64_MODULE_PLTS
-	.plt 0 (NOLOAD) : { BYTE(0) }
-	.init.plt 0 (NOLOAD) : { BYTE(0) }
-	.text.ftrace_trampoline 0 (NOLOAD) : { BYTE(0) }
+	.plt 0 : { BYTE(0) }
+	.init.plt 0 : { BYTE(0) }
+	.text.ftrace_trampoline 0 : { BYTE(0) }
 #endif
 
 #ifdef CONFIG_KASAN_SW_TAGS
-- 
2.34.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF65B6C19D0
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbjCTPif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbjCTPiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:38:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4236849D2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7501DB80E6F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2537C433EF;
        Mon, 20 Mar 2023 15:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326170;
        bh=QqVdNMNLWecEslc40J9dloYu41XCnkxFQGxd2WQaHTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmCmCIZqeuZ01sXBxekr9IYzye8amw77vkT725fm5vnxh6dJ4lzQD8+ZT2XbMWzKV
         6xqiBC3DdvVExw5h89MSMtcnnST5k4nHsvHKPwRa6w8i5yXWuNPhm5J07GyqXbvHxs
         WmjjRXkTMoRqlJHYN5O17OJxfI/b7rdl1hNoFcTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.2 187/211] powerpc/64: Set default CPU in Kconfig
Date:   Mon, 20 Mar 2023 15:55:22 +0100
Message-Id: <20230320145521.343938830@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 45f7091aac3546ef8112bf62836650ca0bbf0b79 upstream.

Since commit 0069f3d14e7a ("powerpc/64e: Tie PPC_BOOK3E_64 to
PPC_E500MC"), the only possible BOOK3E/64 are E500, so no need of a
default CPU over the E5500.

When the user selects book3e, they must have an e500 compatible
compiler, and it won't work anymore with the default -mcpu=power64, see
commit d6b551b8f90c ("powerpc/64e: Fix build failure with GCC
12 (unrecognized opcode: `wrteei')").

For book3s/64, replace GENERIC_CPU by POWERPC64_CPU to match the PPC32
POWERPC_CPU, and set a default mpcu value in Kconfig directly.

When a user selects a particular CPU, they must ensure the compiler has
the requested capability. Therefore, remove hidden fallback, instead
offer user the possibility to say they want to use the toolchain
default.

Fixes: d6b551b8f90c ("powerpc/64e: Fix build failure with GCC 12 (unrecognized opcode: `wrteei')")
Reported-by: Pali Rohár <pali@kernel.org>
Tested-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/76c11197b058193dcb8e8b26adffba09cfbdab11.1674632329.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/Makefile                  |   22 +++++-----------------
 arch/powerpc/platforms/Kconfig.cputype |   12 +++++++-----
 2 files changed, 12 insertions(+), 22 deletions(-)

--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -146,19 +146,6 @@ CFLAGS-$(CONFIG_PPC32)	+= $(call cc-opti
 
 CFLAGS-$(CONFIG_PPC32)	+= $(call cc-option,-mno-readonly-in-sdata)
 
-ifdef CONFIG_PPC_BOOK3S_64
-ifdef CONFIG_CPU_LITTLE_ENDIAN
-CFLAGS-$(CONFIG_GENERIC_CPU) += -mcpu=power8
-else
-CFLAGS-$(CONFIG_GENERIC_CPU) += -mcpu=power4
-endif
-CFLAGS-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=power10,	\
-				  $(call cc-option,-mtune=power9,	\
-				  $(call cc-option,-mtune=power8)))
-else ifdef CONFIG_PPC_BOOK3E_64
-CFLAGS-$(CONFIG_GENERIC_CPU) += -mcpu=powerpc64
-endif
-
 ifdef CONFIG_FUNCTION_TRACER
 CC_FLAGS_FTRACE := -pg
 ifdef CONFIG_MPROFILE_KERNEL
@@ -166,11 +153,12 @@ CC_FLAGS_FTRACE += -mprofile-kernel
 endif
 endif
 
-CFLAGS-$(CONFIG_TARGET_CPU_BOOL) += $(call cc-option,-mcpu=$(CONFIG_TARGET_CPU))
-AFLAGS-$(CONFIG_TARGET_CPU_BOOL) += $(call cc-option,-mcpu=$(CONFIG_TARGET_CPU))
+CFLAGS-$(CONFIG_TARGET_CPU_BOOL) += -mcpu=$(CONFIG_TARGET_CPU)
+AFLAGS-$(CONFIG_TARGET_CPU_BOOL) += -mcpu=$(CONFIG_TARGET_CPU)
 
-CFLAGS-$(CONFIG_E5500_CPU) += $(call cc-option,-mcpu=e500mc64,-mcpu=powerpc64)
-CFLAGS-$(CONFIG_E6500_CPU) += $(call cc-option,-mcpu=e6500,$(E5500_CPU))
+CFLAGS-$(CONFIG_POWERPC64_CPU) += $(call cc-option,-mtune=power10,	\
+				  $(call cc-option,-mtune=power9,	\
+				  $(call cc-option,-mtune=power8)))
 
 asinstr := $(call as-instr,lis 9$(comma)foo@high,-DHAVE_AS_ATHIGH=1)
 
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -118,19 +118,18 @@ endchoice
 
 choice
 	prompt "CPU selection"
-	default GENERIC_CPU
 	help
 	  This will create a kernel which is optimised for a particular CPU.
 	  The resulting kernel may not run on other CPUs, so use this with care.
 
 	  If unsure, select Generic.
 
-config GENERIC_CPU
+config POWERPC64_CPU
 	bool "Generic (POWER5 and PowerPC 970 and above)"
 	depends on PPC_BOOK3S_64 && !CPU_LITTLE_ENDIAN
 	select PPC_64S_HASH_MMU
 
-config GENERIC_CPU
+config POWERPC64_CPU
 	bool "Generic (POWER8 and above)"
 	depends on PPC_BOOK3S_64 && CPU_LITTLE_ENDIAN
 	select ARCH_HAS_FAST_MULTIPLIER
@@ -233,13 +232,12 @@ config E500MC_CPU
 
 config TOOLCHAIN_DEFAULT_CPU
 	bool "Rely on the toolchain's implicit default CPU"
-	depends on PPC32
 
 endchoice
 
 config TARGET_CPU_BOOL
 	bool
-	default !GENERIC_CPU && !TOOLCHAIN_DEFAULT_CPU
+	default !TOOLCHAIN_DEFAULT_CPU
 
 config TARGET_CPU
 	string
@@ -251,6 +249,10 @@ config TARGET_CPU
 	default "power8" if POWER8_CPU
 	default "power9" if POWER9_CPU
 	default "power10" if POWER10_CPU
+	default "e500mc64" if E5500_CPU
+	default "e6500" if E6500_CPU
+	default "power4" if POWERPC64_CPU && !CPU_LITTLE_ENDIAN
+	default "power8" if POWERPC64_CPU && CPU_LITTLE_ENDIAN
 	default "405" if 405_CPU
 	default "440" if 440_CPU
 	default "464" if 464_CPU



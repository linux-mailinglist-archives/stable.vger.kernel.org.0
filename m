Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E7A6C1993
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbjCTPfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbjCTPek (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:34:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED2736FC8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:27:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AC476157F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB3EC433EF;
        Mon, 20 Mar 2023 15:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326041;
        bh=JGoVHzgVWqTkRaEk8LYC+vjk6fqlImbqLIvIF5tP868=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IdoTTTmPQuqnZf5dm86EeroEq7nRQfV7w8RJZgVPzZggZ9aD107fEsWRoJDBr2Trx
         J9InQOieV5v/2+xR4+G/WR/F7Wlhsv2/FTDlNjcru2TO1da43Myv9LyrtxBoCR3Tq5
         xXFwgv43ZxyuxsO+vSb1YCBaou7YLAuYnwkjjw4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan-Benedict Glaw <jbglaw@lug-owl.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 190/198] powerpc: Pass correct CPU reference to assembler
Date:   Mon, 20 Mar 2023 15:55:28 +0100
Message-Id: <20230320145515.427843068@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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

commit bfb03af71a3798b5a88a945a9c19ad67e1c4986d upstream.

Jan-Benedict reported issue with building ppc64e_defconfig
with mainline GCC work:

  powerpc64-linux-gcc -Wp,-MMD,arch/powerpc/kernel/vdso/.gettimeofday-64.o.d -nostdinc -I./arch/powerpc/include -I./arch/powerpc/include/generated  -I./include -I./arch/powerpc/include/uapi -I./arch/powerpc/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/compiler-version.h -include ./include/linux/kconfig.h -D__KERNEL__ -I ./arch/powerpc -DHAVE_AS_ATHIGH=1 -fmacro-prefix-map=./= -D__ASSEMBLY__ -fno-PIE -m64 -Wl,-a64 -mabi=elfv1 -Wa,-me500 -Wa,-me500mc -mabi=elfv1 -mbig-endian    -Wl,-soname=linux-vdso64.so.1 -D__VDSO64__ -s -c -o arch/powerpc/kernel/vdso/gettimeofday-64.o arch/powerpc/kernel/vdso/gettimeofday.S
	arch/powerpc/kernel/vdso/gettimeofday.S: Assembler messages:
	arch/powerpc/kernel/vdso/gettimeofday.S:72: Error: unrecognized opcode: `stdu'
	arch/powerpc/kernel/vdso/gettimeofday.S:72: Error: unrecognized opcode: `stdu'
	arch/powerpc/kernel/vdso/gettimeofday.S:72: Error: unrecognized opcode: `std'
	arch/powerpc/kernel/vdso/gettimeofday.S:72: Error: unrecognized opcode: `std'
	arch/powerpc/kernel/vdso/gettimeofday.S:72: Error: unrecognized opcode: `ld'
	arch/powerpc/kernel/vdso/gettimeofday.S:72: Error: unrecognized opcode: `ld'
	...
	make[1]: *** [arch/powerpc/kernel/vdso/Makefile:76: arch/powerpc/kernel/vdso/gettimeofday-64.o] Error 1
	make: *** [arch/powerpc/Makefile:387: vdso_prepare] Error 2

This is due to assembler being called with -me500mc which is
a 32 bits target.

The problem comes from the fact that CONFIG_PPC_E500MC is selected for
both the e500mc (32 bits) and the e5500 (64 bits), and therefore the
following makefile rule is wrong:

  cpu-as-$(CONFIG_PPC_E500MC)    += $(call as-option,-Wa$(comma)-me500mc)

Today we have CONFIG_TARGET_CPU which provides the identification of the
expected CPU, it is used for GCC. Once GCC knows the target CPU, it adds
the correct CPU option to assembler, no need to add it explicitly.

With that change (And also commit 45f7091aac35 ("powerpc/64: Set default
CPU in Kconfig")), it now is:

  powerpc64-linux-gcc -Wp,-MMD,arch/powerpc/kernel/vdso/.gettimeofday-64.o.d -nostdinc -I./arch/powerpc/include -I./arch/powerpc/include/generated  -I./include -I./arch/powerpc/include/uapi -I./arch/powerpc/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/compiler-version.h -include ./include/linux/kconfig.h -D__KERNEL__ -I ./arch/powerpc -DHAVE_AS_ATHIGH=1 -fmacro-prefix-map=./= -D__ASSEMBLY__ -fno-PIE -m64 -Wl,-a64 -mabi=elfv1 -mcpu=e500mc64 -mabi=elfv1 -mbig-endian    -Wl,-soname=linux-vdso64.so.1 -D__VDSO64__ -s -c -o arch/powerpc/kernel/vdso/gettimeofday-64.o arch/powerpc/kernel/vdso/gettimeofday.S

Reported-by: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Pali Rohár <pali@kernel.org>
[mpe: Retain -Wa,-mpower4 -Wa,-many for Book3S 64 builds for now]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/758ad54128fa9dd2fdedc4c511592111cbded900.1671475543.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/Makefile |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -201,10 +201,7 @@ KBUILD_CFLAGS += -fno-asynchronous-unwin
 # often slow when they are implemented at all
 KBUILD_CFLAGS		+= $(call cc-option,-mno-string)
 
-cpu-as-$(CONFIG_40x)		+= -Wa,-m405
-cpu-as-$(CONFIG_44x)		+= -Wa,-m440
 cpu-as-$(CONFIG_ALTIVEC)	+= $(call as-option,-Wa$(comma)-maltivec)
-cpu-as-$(CONFIG_PPC_E500)		+= -Wa,-me500
 
 # When using '-many -mpower4' gas will first try and find a matching power4
 # mnemonic and failing that it will allow any valid mnemonic that GAS knows
@@ -212,7 +209,6 @@ cpu-as-$(CONFIG_PPC_E500)		+= -Wa,-me500
 # LLVM IAS doesn't understand either flag: https://github.com/ClangBuiltLinux/linux/issues/675
 # but LLVM IAS only supports ISA >= 2.06 for Book3S 64 anyway...
 cpu-as-$(CONFIG_PPC_BOOK3S_64)	+= $(call as-option,-Wa$(comma)-mpower4) $(call as-option,-Wa$(comma)-many)
-cpu-as-$(CONFIG_PPC_E500MC)	+= $(call as-option,-Wa$(comma)-me500mc)
 
 KBUILD_AFLAGS += $(cpu-as-y)
 KBUILD_CFLAGS += $(cpu-as-y)



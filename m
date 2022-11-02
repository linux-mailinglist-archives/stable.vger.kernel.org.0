Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BB16158B7
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiKBC5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiKBC5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:57:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058B313F8A
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB63CB82071
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA3EC433D6;
        Wed,  2 Nov 2022 02:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357836;
        bh=7EVNh/iJMpTpD+7Jpy18jFkcaWpqtj5NMe4bAOLLbsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3QkhstwI5sTp2/ptJqNuubL1LQDZEWwlPhNtLc61pZ5sPmb+ol2EXWoGIbV7tR/P
         TVgHy/BvTf5n7zmnyzjNEGPqDQ6ICFJEcX4UtFDeYzQgN2JNZghWcww6tMFor9t1Ry
         feNEGV7rp5gfel7dQop3VxUe50JCw281U/mB+kP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Hilman <khilman@baylibre.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 237/240] riscv: fix detection of toolchain Zicbom support
Date:   Wed,  2 Nov 2022 03:33:32 +0100
Message-Id: <20221102022116.764526019@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit b8c86872d1dc171d8f1c137917d6913cae2fa4f2 ]

It is not sufficient to check if a toolchain supports a particular
extension without checking if the linker supports that extension too.
For example, Clang 15 supports Zicbom but GNU bintutils 2.35.2 does
not, leading build errors like so:

riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_c2p0_zicbom1p0_zihintpause2p0: Invalid or unknown z ISA extension: 'zicbom'

Convert CC_HAS_ZICBOM to TOOLCHAIN_HAS_ZICBOM & check if the linker
also supports Zicbom.

Reported-by: Kevin Hilman <khilman@baylibre.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1714
Link: https://storage.kernelci.org/next/master/next-20220920/riscv/defconfig+CONFIG_EFI=n/clang-16/logs/kernel.log
Fixes: 1631ba1259d6 ("riscv: Add support for non-coherent devices using zicbom extension")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20221006173520.1785507-2-conor@kernel.org
[Palmer: Check for ld-2.38, not 2.39, as 2.38 no longer errors.]
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig  | 10 ++++++----
 arch/riscv/Makefile |  3 +--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index cea22ccb57cb..e646298d2d65 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -402,14 +402,16 @@ config RISCV_ISA_SVPBMT
 
 	   If you don't know what to do here, say Y.
 
-config CC_HAS_ZICBOM
+config TOOLCHAIN_HAS_ZICBOM
 	bool
-	default y if 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicbom)
-	default y if 32BIT && $(cc-option,-mabi=ilp32 -march=rv32ima_zicbom)
+	default y
+	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zicbom)
+	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zicbom)
+	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23800
 
 config RISCV_ISA_ZICBOM
 	bool "Zicbom extension support for non-coherent DMA operation"
-	depends on CC_HAS_ZICBOM
+	depends on TOOLCHAIN_HAS_ZICBOM
 	depends on !XIP_KERNEL && MMU
 	select RISCV_DMA_NONCOHERENT
 	select RISCV_ALTERNATIVE
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index e7d52a2301e2..d1dbbe0fb0f8 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -59,8 +59,7 @@ toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zi
 riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
 
 # Check if the toolchain supports Zicbom extension
-toolchain-supports-zicbom := $(call cc-option-yn, -march=$(riscv-march-y)_zicbom)
-riscv-march-$(toolchain-supports-zicbom) := $(riscv-march-y)_zicbom
+riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZICBOM) := $(riscv-march-y)_zicbom
 
 # Check if the toolchain supports Zihintpause extension
 toolchain-supports-zihintpause := $(call cc-option-yn, -march=$(riscv-march-y)_zihintpause)
-- 
2.35.1




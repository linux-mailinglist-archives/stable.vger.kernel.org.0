Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B586A128E
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 23:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjBWWF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 17:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjBWWF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 17:05:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B487144B0
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 14:05:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BBA0617AF
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 22:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BFEC433A1;
        Thu, 23 Feb 2023 22:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677189955;
        bh=slfG7arzy36WwKxB6a02WckmWCrxgVshZ9ipMm+MbAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjC9HaRMaE3mFXKEUaVULPc9m1iDc/hx95PCtiDqHc2cdBcfWmROw8ruIEZcRYMyO
         7EUUf0Kpt85PugWS3Uja5+2/x44+EN1obvP16C9MZJdVkM6TQKXsrnlo48v26GshYV
         3qm4Y1bCw0nXtjXU2YHpiQQ0wvQIkraKGPbgBWPR1LcDiKWXlirARtSth4aSjUz0JT
         uu/j5QQc22HuHZMfZvUQXoxAeqp902dtn8/0WVB+55ClF5bAlEK29w5Y/u4MrM6vZ/
         4mip6m8gBdB75d+0HANAALiL0IleLangMVtLXAe6jVJN13ca9g7ZVAdT3odrXyYNYA
         3Fdb3nw69CNbg==
From:   Conor Dooley <conor@kernel.org>
To:     palmer@dabbelt.com
Cc:     conor@kernel.org, Conor Dooley <conor.dooley@microchip.com>,
        nathan@kernel.org, naresh.kamboju@linaro.org,
        linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
        stable@vger.kernel.org
Subject: [PATCH v1 2/2] RISC-V: make TOOLCHAIN_NEEDS_SPEC_20191213 gas only
Date:   Thu, 23 Feb 2023 22:05:46 +0000
Message-Id: <20230223220546.52879-3-conor@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230223220546.52879-1-conor@kernel.org>
References: <20230223220546.52879-1-conor@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2084; i=conor.dooley@microchip.com; h=from:subject; bh=hciiU41cmccFKM8j8MWjmtv2w5WAHIGPZfhA69tDbBQ=; b=owGbwMvMwCFWscWwfUFT0iXG02pJDMnfH5veX95Re3Hn9dn7+b5fb9QQeHz+1EqG5+LnJueqWa1s ndhS0VHKwiDGwSArpsiSeLuvRWr9H5cdzj1vYeawMoEMYeDiFICJiM1iZDi5vSS4Qko08uzpx6kJ8k J3r1Ql/i++bMPEk7b+5tSfR84w/K/bUapSOGc6y3bx46IXtlkmlpTuEjdfJdJ7zfKXRo/eKRYA
X-Developer-Key: i=conor.dooley@microchip.com; a=openpgp; fpr=F9ECA03CF54F12CD01F1655722E2C55B37CF380C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

Quoting the llvm docs:
> Between versions 2.0 and 2.1 of the base I specification, a backwards
> incompatible change was made to remove selected instructions and CSRs
> from the base ISA. These instructions were grouped into a set of new
> extensions, but were no longer required by the base ISA. (snip) LLVM
> currently implements version 2.0 of the base specification. Thus,
> instructions from these extensions are accepted as part of the base
> ISA.

There is therefore no need (at present!) to carry out a $cc-option
check, and instead just gate presence of zicsr and zifencei in march
on the version of binutils that commit 6df2a016c0c8 ("riscv: fix build
with binutils 2.38") highlights as the introduction of the requirement.

In fact, the status quo creates some issues with mixed llvm/binutils
builds, specifically building with llvm-17 and ld from binutils-2.35.
Odd combo you may think, but this is what tuxsuite's debian stable uses
while testing 5.10 stable kernels as doesn't support LLD.

CC: stable@vger.kernel.org # needs RISC-V: move zicsr/zifencei spec version check to Kconfi
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Link: https://lore.kernel.org/all/CA+G9fYt9T=ELCLaB9byxaLW2Qf4pZcDO=huCA0D8ug2V2+irJQ@mail.gmail.com/
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 4eb0ef8314b3..c6902f4c5650 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -291,8 +291,7 @@ endchoice
 config TOOLCHAIN_NEEDS_SPEC_20191213
 	bool
 	default y
-	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zicsr_zifencei)
-	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zicsr_zifencei)
+	depends on AS_IS_GNU && AS_VERSION >= 23800
 	help
 	  Newer binutils versions default to ISA spec version 20191213 which
 	  moves some instructions from the I extension to the Zicsr and Zifencei
-- 
2.39.1


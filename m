Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDF6603C2B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiJSIod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiJSIn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:43:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02335A3F3;
        Wed, 19 Oct 2022 01:41:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4672D617E9;
        Wed, 19 Oct 2022 08:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109DFC433D6;
        Wed, 19 Oct 2022 08:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168826;
        bh=c4NL67WudStCz85yeweG+NkIyETz6hxWtl4wxLcqfqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Sop+Wj5AZSZiWkbEtCX5TIj4uM2YRS1aK+HX8goYsUNkxSbFqmRPOJZRk73VEpo/
         wzcPaiT3+vv96Asujdqecf18hqE35WEGSgEAGF2vxI8GOr473VBud2MBL2wWXDbXYb
         C1oCwYCtwQ7Cr5tP/PCSM+NTJF8BP9sgHhEDOBuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.0 065/862] riscv: Pass -mno-relax only on lld < 15.0.0
Date:   Wed, 19 Oct 2022 10:22:32 +0200
Message-Id: <20221019083252.805123179@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangrui Song <maskray@google.com>

commit 3cebf80e9a0d3adcb174053be32c88a640b3344b upstream.

lld since llvm:6611d58f5bbc ("[ELF] Relax R_RISCV_ALIGN"), which will be
included in the 15.0.0 release, has implemented some RISC-V linker
relaxation.  -mno-relax is no longer needed in
KBUILD_CFLAGS/KBUILD_AFLAGS to suppress R_RISCV_ALIGN which older lld
can not handle:

    ld.lld: error: capability.c:(.fixup+0x0): relocation R_RISCV_ALIGN
    requires unimplemented linker relaxation; recompile with -mno-relax
    but the .o is already compiled with -mno-relax

Signed-off-by: Fangrui Song <maskray@google.com>
Link: https://lore.kernel.org/r/20220710071117.446112-1-maskray@google.com/
Link: https://lore.kernel.org/r/20220918092933.19943-1-palmer@rivosinc.com
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -37,6 +37,7 @@ else
 endif
 
 ifeq ($(CONFIG_LD_IS_LLD),y)
+ifeq ($(shell test $(CONFIG_LLD_VERSION) -lt 150000; echo $$?),0)
 	KBUILD_CFLAGS += -mno-relax
 	KBUILD_AFLAGS += -mno-relax
 ifndef CONFIG_AS_IS_LLVM
@@ -44,6 +45,7 @@ ifndef CONFIG_AS_IS_LLVM
 	KBUILD_AFLAGS += -Wa,-mno-relax
 endif
 endif
+endif
 
 # ISA string setting
 riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima



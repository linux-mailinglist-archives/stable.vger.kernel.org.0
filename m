Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24E160B9CD
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbiJXUVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbiJXUVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:21:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0596EE52CB;
        Mon, 24 Oct 2022 11:37:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 845D7B81190;
        Mon, 24 Oct 2022 12:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DC4C433D6;
        Mon, 24 Oct 2022 12:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614896;
        bh=j/LOpBXDmZRJQVdeQyAT0GuWFgo4jVHD9tLtPcE6Lm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBNS/TxYFaY8+l2DaxrT+4Lr5WAtejh1/znENrX5f05mYqoEHhJtUEIdaysuPEYt9
         oY0uNdtZsrwxsEKZSuSsTJEZn7oPW3azSjAOaOnbEqQDuj/hj6VA1c1e4tWlfRkcnV
         LSaWce9lkLuXF57Zl+ubhZyR0hVklb5cwmRHMKNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 045/530] riscv: Pass -mno-relax only on lld < 15.0.0
Date:   Mon, 24 Oct 2022 13:26:29 +0200
Message-Id: <20221024113047.055726393@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -39,6 +39,7 @@ else
 endif
 
 ifeq ($(CONFIG_LD_IS_LLD),y)
+ifeq ($(shell test $(CONFIG_LLD_VERSION) -lt 150000; echo $$?),0)
 	KBUILD_CFLAGS += -mno-relax
 	KBUILD_AFLAGS += -mno-relax
 ifndef CONFIG_AS_IS_LLVM
@@ -46,6 +47,7 @@ ifndef CONFIG_AS_IS_LLVM
 	KBUILD_AFLAGS += -Wa,-mno-relax
 endif
 endif
+endif
 
 # ISA string setting
 riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima



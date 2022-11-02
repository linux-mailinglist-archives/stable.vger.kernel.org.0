Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C15A615895
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiKBCy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiKBCy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:54:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1B020364
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:54:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBF48617C8
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E53C433D6;
        Wed,  2 Nov 2022 02:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357666;
        bh=Qcf+FK+lzd0XPxSBdoApn00tUfhv8j7/LcPOircFGcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1miu3c16X12v9BSSK6FAFdIq353uXAIjsd2Gp3a4z+A6fn3y60vuZU7/SU8+IV65o
         pb5V9lQOAX0OpwiJ8k0mVYaBNbz/v+6xZFrrEM7M8ZD5YTBNbL4N4PUaYF5CUpeXBr
         ryYmKA6MG4jBAI0NTH0r7D4SfdUUkSkzsEhoh4MQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Samuel Holland <samuel@sholland.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 208/240] riscv: jump_label: mark arguments as const to satisfy asm constraints
Date:   Wed,  2 Nov 2022 03:33:03 +0100
Message-Id: <20221102022116.103062090@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 89fd4a1df829187d4d35f6a520cc531de622e6f0 ]

Samuel reported that the static branch usage in cpu_relax() breaks
building with CONFIG_CC_OPTIMIZE_FOR_SIZE:

In file included from <command-line>:
./arch/riscv/include/asm/jump_label.h: In function 'cpu_relax':
././include/linux/compiler_types.h:285:33: warning: 'asm' operand 0
probably does not match constraints
  285 | #define asm_volatile_goto(x...) asm goto(x)
      |                                 ^~~
./arch/riscv/include/asm/jump_label.h:41:9: note: in expansion of macro
'asm_volatile_goto'
   41 |         asm_volatile_goto(
      |         ^~~~~~~~~~~~~~~~~
././include/linux/compiler_types.h:285:33: error: impossible constraint
in 'asm'
  285 | #define asm_volatile_goto(x...) asm goto(x)
      |                                 ^~~
./arch/riscv/include/asm/jump_label.h:41:9: note: in expansion of macro
'asm_volatile_goto'
   41 |         asm_volatile_goto(
      |         ^~~~~~~~~~~~~~~~~
make[1]: *** [scripts/Makefile.build:249:
arch/riscv/kernel/vdso/vgettimeofday.o] Error 1
make: *** [arch/riscv/Makefile:128: vdso_prepare] Error 2

Maybe "-Os" prevents GCC from detecting that the key/branch arguments
can be treated as constants and used as immediate operands. Inspired
by x86's commit 864b435514b2("x86/jump_label: Mark arguments as const to
satisfy asm constraints"), and as pointed out by Steven: "The "i"
constraint needs to be a constant.", let's do similar modifications to
riscv.

Tested by CC_OPTIMIZE_FOR_SIZE + gcc and CC_OPTIMIZE_FOR_SIZE + clang.

Link: https://lore.kernel.org/linux-riscv/20220922060958.44203-1-samuel@sholland.org/
Link: https://lore.kernel.org/all/20210212094059.5f8d05e8@gandalf.local.home/
Fixes: 8eb060e10185 ("arch/riscv: add Zihintpause support")
Reported-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20221008145437.491-1-jszhang@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/jump_label.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/asm/jump_label.h b/arch/riscv/include/asm/jump_label.h
index 38af2ec7b9bf..6d58bbb5da46 100644
--- a/arch/riscv/include/asm/jump_label.h
+++ b/arch/riscv/include/asm/jump_label.h
@@ -14,8 +14,8 @@
 
 #define JUMP_LABEL_NOP_SIZE 4
 
-static __always_inline bool arch_static_branch(struct static_key *key,
-					       bool branch)
+static __always_inline bool arch_static_branch(struct static_key * const key,
+					       const bool branch)
 {
 	asm_volatile_goto(
 		"	.option push				\n\t"
@@ -35,8 +35,8 @@ static __always_inline bool arch_static_branch(struct static_key *key,
 	return true;
 }
 
-static __always_inline bool arch_static_branch_jump(struct static_key *key,
-						    bool branch)
+static __always_inline bool arch_static_branch_jump(struct static_key * const key,
+						    const bool branch)
 {
 	asm_volatile_goto(
 		"	.option push				\n\t"
-- 
2.35.1




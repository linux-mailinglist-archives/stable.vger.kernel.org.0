Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44BAC627EC6
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbiKNMve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbiKNMvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:51:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC96A24BCF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:51:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A05161154
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D8AC433C1;
        Mon, 14 Nov 2022 12:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430291;
        bh=5INxvdkrZdnoPpZuTkuR+uGXSLOmk4YkqYJqDnOu7/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8sqkv/l1/n0DbdHsbuhqZBPHoFuL/2k8nZAee4pRK/r3SaJeeWH7CV/m7C/Te8Ad
         f9gSXHmFUcPgnEOqhlsvUJOimS3Ch9i2KzLJV9qUvQPuR0yg+lJOOW/MUeCaNabD4m
         RkZSbmBdyDKWIj5RWKCP+klzZNF2SXsvfuz4lKZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jisheng Zhang <jszhang@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 51/95] riscv: vdso: fix build with llvm
Date:   Mon, 14 Nov 2022 13:45:45 +0100
Message-Id: <20221114124444.653333184@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 50f4dd657a0fcf90aa8da8dc2794a8100ff4c37c ]

Even after commit 89fd4a1df829 ("riscv: jump_label: mark arguments as
const to satisfy asm constraints"), building with CC_OPTIMIZE_FOR_SIZE
+ LLVM=1 can reproduce below build error:

  CC      arch/riscv/kernel/vdso/vgettimeofday.o
In file included from <built-in>:4:
In file included from lib/vdso/gettimeofday.c:5:
In file included from include/vdso/datapage.h:17:
In file included from include/vdso/processor.h:10:
In file included from arch/riscv/include/asm/vdso/processor.h:7:
In file included from include/linux/jump_label.h:112:
arch/riscv/include/asm/jump_label.h:42:3: error:
invalid operand for inline asm constraint 'i'
                "       .option push                            \n\t"
                ^
1 error generated.

I think the problem is when "-Os" is passed as CFLAGS, it's removed by
"CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os" which is
introduced in commit e05d57dcb8c7 ("riscv: Fixup __vdso_gettimeofday
broke dynamic ftrace"), thus no optimization at all for vgettimeofday.c
arm64 does remove "-Os" as well, but it forces "-O2" after removing
"-Os".

I compared the generated vgettimeofday.o with "-O2" and "-Os",
I think no big performance difference. So let's tell the kbuild not
to remove "-Os" rather than follow arm64 style.

vdso related performance can be improved a lot when building kernel with
CC_OPTIMIZE_FOR_SIZE after this commit, ("-Os" VS no optimization)

Fixes: e05d57dcb8c7 ("riscv: Fixup __vdso_gettimeofday broke dynamic ftrace")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20221031182943.2453-1-jszhang@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 24d936c147cd..926ab3960f9e 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -30,7 +30,7 @@ obj-y += vdso.o vdso-syms.o
 CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
 
 # Disable -pg to prevent insert call site
-CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os
+CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE)
 
 # Disable profiling and instrumentation for VDSO code
 GCOV_PROFILE := n
-- 
2.35.1




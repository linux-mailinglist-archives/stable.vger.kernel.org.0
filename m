Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E799628091
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237833AbiKNNHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237869AbiKNNG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:06:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8B62AC63
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:06:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F2A2B80EA5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74253C433C1;
        Mon, 14 Nov 2022 13:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431213;
        bh=3pbEg6rr6hN2TQDBXyM+LPjxjOyH9ZsI8chGweJIWlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOlINtDsO+bTZbLX6kkviE0tYwdGkYBnWGYBKEbjJkT+FeGnpiaFeH1DWa6IdxoXU
         /pdDpOZFjespOvbk+JLVLHa1TJQkAO7K1U8GtC2sp/jYWqw6Uq+dT+ezFkT8gRv5pD
         eTpHzv0dwzGwbRbiYPRCyAPqqi/LsKE2u6N8pwwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jisheng Zhang <jszhang@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 112/190] riscv: vdso: fix build with llvm
Date:   Mon, 14 Nov 2022 13:45:36 +0100
Message-Id: <20221114124503.598569973@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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
index f2e065671e4d..84ac0fe612e7 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -30,7 +30,7 @@ obj-y += vdso.o
 CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
 
 # Disable -pg to prevent insert call site
-CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os
+CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE)
 
 # Disable profiling and instrumentation for VDSO code
 GCOV_PROFILE := n
-- 
2.35.1




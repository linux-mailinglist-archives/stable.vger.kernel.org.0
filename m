Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAEA6309C3
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbiKSCSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbiKSCRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:17:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF413A7C38;
        Fri, 18 Nov 2022 18:13:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 413B0CE222D;
        Sat, 19 Nov 2022 02:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B51C4347C;
        Sat, 19 Nov 2022 02:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824025;
        bh=7oI6x6dGUAcNjzV/lbzUit+ElYgYzejNqrXIADa4U4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBMBNR3eR+cVnln/DzH+kvtIXDs5FtZcYD1KZVO3w78dj+AVRTVmFhM40BxWs4TkZ
         A1ly/msQusBWOCx/AONjcDEIV6IogGMDklBHxmG2MH+Pviz6FB7rKLAOsX8QS7Onaa
         +eCtsWu5f6/V79CjXqtI2bPLhhslU0y2YKp9/9GM6aSJFKPsybRMpmQpNgUgGczq49
         RiBmBDRvEyNUoTFOrOQN4rptdq5uyri3xA8yvltTByJDVSiGiJ47KIFmAlMLT9M1G8
         jc/TMxsJqcrlHKcGkVL/6+v1Q/cBGCgu5yz192Jv9Nt84ED03wv4E9wJqyxsuYRkvP
         ogFO5UThTwRzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, jszhang@kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 42/44] RISC-V: vdso: Do not add missing symbols to version section in linker script
Date:   Fri, 18 Nov 2022 21:11:22 -0500
Message-Id: <20221119021124.1773699-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit fcae44fd36d052e956e69a64642fc03820968d78 ]

Recently, ld.lld moved from '--undefined-version' to
'--no-undefined-version' as the default, which breaks the compat vDSO
build:

  ld.lld: error: version script assignment of 'LINUX_4.15' to symbol '__vdso_gettimeofday' failed: symbol not defined
  ld.lld: error: version script assignment of 'LINUX_4.15' to symbol '__vdso_clock_gettime' failed: symbol not defined
  ld.lld: error: version script assignment of 'LINUX_4.15' to symbol '__vdso_clock_getres' failed: symbol not defined

These symbols are not present in the compat vDSO or the regular vDSO for
32-bit but they are unconditionally included in the version section of
the linker script, which is prohibited with '--no-undefined-version'.

Fix this issue by only including the symbols that are actually exported
in the version section of the linker script.

Link: https://github.com/ClangBuiltLinux/linux/issues/1756
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20221108171324.3377226-1-nathan@kernel.org/
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vdso/Makefile   | 3 +++
 arch/riscv/kernel/vdso/vdso.lds.S | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index f2e065671e4d..82416ebf4cca 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -28,6 +28,9 @@ obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
 
 obj-y += vdso.o
 CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
+ifneq ($(filter vgettimeofday, $(vdso-syms)),)
+CPPFLAGS_vdso.lds += -DHAS_VGETTIMEOFDAY
+endif
 
 # Disable -pg to prevent insert call site
 CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os
diff --git a/arch/riscv/kernel/vdso/vdso.lds.S b/arch/riscv/kernel/vdso/vdso.lds.S
index 01d94aae5bf5..150b1a572e61 100644
--- a/arch/riscv/kernel/vdso/vdso.lds.S
+++ b/arch/riscv/kernel/vdso/vdso.lds.S
@@ -68,9 +68,11 @@ VERSION
 	LINUX_4.15 {
 	global:
 		__vdso_rt_sigreturn;
+#ifdef HAS_VGETTIMEOFDAY
 		__vdso_gettimeofday;
 		__vdso_clock_gettime;
 		__vdso_clock_getres;
+#endif
 		__vdso_getcpu;
 		__vdso_flush_icache;
 	local: *;
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9B839E302
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhFGQUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232845AbhFGQSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:18:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9060C6141E;
        Mon,  7 Jun 2021 16:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082467;
        bh=JR1LwqcnZRsn5yGfC33MX1dYZ/aFmq2fPUHqT3SXwyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqF445ZSaU5YFqP2ZenCtJDto75thT4wdzdALh91ouKmX2z6DUMIg2SMBC0aBDEF6
         x9gg46gZZ0R8a1qmB9blWQCsolugy7ozaYVf23WScLEwnfgw6YvnpFNZOTN4ukgxdd
         6ojQ/X/gR5XYMsvx7kcxL+ttjmHIMpnhmJP6QagoTr9wPe5gQ2hgjaB2bG7Zle8xcm
         Hf6ryra4E6b1twNh3CLtF9nUKoEYpkqf35rnx9qa7xriygEsVM+xkZAksxkStIgfi9
         OsV3dT07IwrAK6lJObEUCmQ+KOtYE1RzOXMBd6QrJj2jlYUX4Y7eW3L29yjgBY4sqL
         OqeqAOt0DEJsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Khem Raj <raj.khem@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 13/29] riscv: Use -mno-relax when using lld linker
Date:   Mon,  7 Jun 2021 12:13:54 -0400
Message-Id: <20210607161410.3584036-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Khem Raj <raj.khem@gmail.com>

[ Upstream commit ec3a5cb61146c91f0f7dcec8b7e7157a4879a9ee ]

lld does not implement the RISCV relaxation optimizations like GNU ld
therefore disable it when building with lld, Also pass it to
assembler when using external GNU assembler ( LLVM_IAS != 1 ), this
ensures that relevant assembler option is also enabled along. if these
options are not used then we see following relocations in objects

0000000000000000 R_RISCV_ALIGN     *ABS*+0x0000000000000002

These are then rejected by lld
ld.lld: error: capability.c:(.fixup+0x0): relocation R_RISCV_ALIGN requires unimplemented linker relaxation; recompile with -mno-relax but the .o is already compiled with -mno-relax

Signed-off-by: Khem Raj <raj.khem@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Makefile | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index f5e914210245..1cbe0ad78b0f 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -34,6 +34,15 @@ else
 	KBUILD_LDFLAGS += -melf32lriscv
 endif
 
+ifeq ($(CONFIG_LD_IS_LLD),y)
+	KBUILD_CFLAGS += -mno-relax
+	KBUILD_AFLAGS += -mno-relax
+ifneq ($(LLVM_IAS),1)
+	KBUILD_CFLAGS += -Wa,-mno-relax
+	KBUILD_AFLAGS += -Wa,-mno-relax
+endif
+endif
+
 # ISA string setting
 riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
 riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
-- 
2.30.2


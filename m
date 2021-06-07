Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4D139E205
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhFGQOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231435AbhFGQOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CE496128B;
        Mon,  7 Jun 2021 16:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082368;
        bh=qdx3A4dL/aV5aO0z1JewHyWSwi8Q7i9bcnqPBVn6azs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6BwxUwzyUQlKGGorK72hZg6g3/0Rjm8/HedVIgBKoPMNzmPZLZoRwGKq56Q9PwXv
         FXR8jF/kQ/bCN5JS9pNMy4XpV47KdtyD4wubBHE8wObv0QzwddyfmHjR3cAt3P/Yk7
         kbSl9I85qv3KlPkxxLTQs8gV/vlzHaM/1RIjHtXaPr1YmE0cBbA68A/KSZmTxhIlWZ
         qRfNE5LzFfF8pgkvkq/H7SvdpL+o2twi49sPnqbL9y2uDwu5LXTgX59ZyuiLBP6EEH
         PSUjnH67yz6wA752G8uCMB5XOWyK0zu+z7t+WbCCktY4VhG6JwaDo2tXih4M66wwpx
         CvN5HpwxnoMEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Khem Raj <raj.khem@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 26/49] riscv: Use -mno-relax when using lld linker
Date:   Mon,  7 Jun 2021 12:11:52 -0400
Message-Id: <20210607161215.3583176-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
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
index 1368d943f1f3..5243bf2327c0 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -38,6 +38,15 @@ else
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


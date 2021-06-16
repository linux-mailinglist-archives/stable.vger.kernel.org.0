Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373C43A9FE0
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhFPPmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235324AbhFPPkF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:40:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2674613F2;
        Wed, 16 Jun 2021 15:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857837;
        bh=qdx3A4dL/aV5aO0z1JewHyWSwi8Q7i9bcnqPBVn6azs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSyyIf25jYQa6ryxSpC8P1xaiUHsu/a17HhholcXkhpwaze9hUTu7+GXmQJOL/4x0
         5lPiq7pqWiRrLFOJz+oYu+GuFDXyHGj+C06pgXkSbyFUgHdzBbsqlvqL7XCCPmMFzm
         SWIH/FGOGPgGPf77Ggx7comapTn7wLBxw9FTRTmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khem Raj <raj.khem@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 26/48] riscv: Use -mno-relax when using lld linker
Date:   Wed, 16 Jun 2021 17:33:36 +0200
Message-Id: <20210616152837.474295346@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




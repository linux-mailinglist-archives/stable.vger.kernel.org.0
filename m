Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDCB3A9F34
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhFPPgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234662AbhFPPgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:36:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A38C61076;
        Wed, 16 Jun 2021 15:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857658;
        bh=JR1LwqcnZRsn5yGfC33MX1dYZ/aFmq2fPUHqT3SXwyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zKu2QUir34Xh1TStZ1qxHGis8w9QIFKQcRtSzQqXi9schfXdhfsp+eGbQuX1KOR70
         J1aUcBkiPCYPcI8Zbh1UYPc0+2g+ELBTlpIHrlma7pocwC19QFFBOlsd44BvCxeRgj
         TuWiXv+GH2sWXm7H0cXW01d+FTM1r3XYyx7RfzKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khem Raj <raj.khem@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/28] riscv: Use -mno-relax when using lld linker
Date:   Wed, 16 Jun 2021 17:33:24 +0200
Message-Id: <20210616152834.567533813@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152834.149064097@linuxfoundation.org>
References: <20210616152834.149064097@linuxfoundation.org>
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




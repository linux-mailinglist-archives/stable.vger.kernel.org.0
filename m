Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92CA658076
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbiL1QSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbiL1QRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:17:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2561A1A05A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:15:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B30BF61560
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB95C433D2;
        Wed, 28 Dec 2022 16:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244120;
        bh=ikyY7hFQfAoJfSwW7zG90mcxPo1soDF1kPd7nODLl9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FezJ+5qTqPn/eJr2N1nnBlWSqvB510CgAfPdvvCOONMmakGOdZI2QWmU481Ui/sOR
         LFBhEf02d5x6f90TMZxbX4wgW4g85TfovbD2SLRz8f0ph5wzpkVCtzYdJSCavRseCE
         YVFrL0+PrE9CBiGGh8NBUX222/lZg9tD/yqGLMlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0654/1073] RISC-V: Fix MEMREMAP_WB for systems with Svpbmt
Date:   Wed, 28 Dec 2022 15:37:22 +0100
Message-Id: <20221228144345.810036561@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit b91676fc16cd384a81e3af52c641aa61985cc231 ]

Currently, the memremap() called with MEMREMAP_WB maps memory using
the generic ioremap() function which breaks on system with Svpbmt
because memory mapped using _PAGE_IOREMAP page attributes is treated
as strongly-ordered non-cacheable IO memory.

To address this, we implement RISC-V specific arch_memremap_wb()
which maps memory using _PAGE_KERNEL page attributes resulting in
write-back cacheable mapping on systems with Svpbmt.

Fixes: ff689fd21cb1 ("riscv: add RISC-V Svpbmt extension support")
Co-developed-by: Mayuresh Chitale <mchitale@ventanamicro.com>
Signed-off-by: Mayuresh Chitale <mchitale@ventanamicro.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20221114090536.1662624-2-apatel@ventanamicro.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/io.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/riscv/include/asm/io.h b/arch/riscv/include/asm/io.h
index 92080a227937..42497d487a17 100644
--- a/arch/riscv/include/asm/io.h
+++ b/arch/riscv/include/asm/io.h
@@ -135,4 +135,9 @@ __io_writes_outs(outs, u64, q, __io_pbr(), __io_paw())
 
 #include <asm-generic/io.h>
 
+#ifdef CONFIG_MMU
+#define arch_memremap_wb(addr, size)	\
+	((__force void *)ioremap_prot((addr), (size), _PAGE_KERNEL))
+#endif
+
 #endif /* _ASM_RISCV_IO_H */
-- 
2.35.1




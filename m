Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8BD658129
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbiL1QZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234813AbiL1QY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:24:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0512F19C1A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:21:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9327CB817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8EDC433D2;
        Wed, 28 Dec 2022 16:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244511;
        bh=+vZNcwnTcRQqjUzQHdUFdM5gSLlmZ0HxnhFErN0E+5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEYVJX/3gko2mR+S4DVMXypfY4jviQt06kDF/5bV47QuBN0dRa+8YHJLic1wHOO/F
         Sdmsama9XoOl/qWtNMX4vhyczL6P45miLTy42XBj8HuBnCjA3c9q2IKcip/u2Ay0yJ
         r3WGh9QQu+SaBb2bwfTZbItyjZM8KbTiGV7/OuJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexandre Ghiti <alexghiti@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0686/1146] riscv: Fix P4D_SHIFT definition for 3-level page table mode
Date:   Wed, 28 Dec 2022 15:37:05 +0100
Message-Id: <20221228144348.774946219@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 71fc3621efc38ace9640ee6a0db3300900689592 ]

RISC-V kernels support 3,4,5-level page tables at runtime by folding
upper levels.

In case of a 3-level page table, PGDIR is folded into P4D which in turn
is folded into PUD: PGDIR_SHIFT value is correctly set to the same value
as PUD_SHIFT, but P4D_SHIFT is not, then any use of P4D_SHIFT will access
invalid address bits (all set to 1).

Fix this by dynamically defining P4D_SHIFT value, like we already do for
PGDIR_SHIFT.

Fixes: d10efa21a937 ("riscv: mm: Control p4d's folding by pgtable_l5_enabled")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Link: https://lore.kernel.org/r/20221201135128.1482189-2-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable-64.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index dc42375c2357..42a042c0e13e 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -25,7 +25,11 @@ extern bool pgtable_l5_enabled;
 #define PGDIR_MASK      (~(PGDIR_SIZE - 1))
 
 /* p4d is folded into pgd in case of 4-level page table */
-#define P4D_SHIFT      39
+#define P4D_SHIFT_L3   30
+#define P4D_SHIFT_L4   39
+#define P4D_SHIFT_L5   39
+#define P4D_SHIFT      (pgtable_l5_enabled ? P4D_SHIFT_L5 : \
+		(pgtable_l4_enabled ? P4D_SHIFT_L4 : P4D_SHIFT_L3))
 #define P4D_SIZE       (_AC(1, UL) << P4D_SHIFT)
 #define P4D_MASK       (~(P4D_SIZE - 1))
 
-- 
2.35.1




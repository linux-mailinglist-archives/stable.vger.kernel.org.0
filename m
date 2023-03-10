Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE526B4889
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbjCJPDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbjCJPDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:03:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1DC126F2A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:56:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC97561962
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DA7C4339B;
        Fri, 10 Mar 2023 14:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460132;
        bh=T+w1QOHGidp5BE/eSpm4kugK7Y/Fdcvefr3RQwmXVg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFZVApOsy3Ujg6snrxxzlH4CZEFj013+vQ2obnmh6NxUUQA57GY2ziltkJv3KxXYk
         CaAFn1YY6100toW+xgd/v+UQW17FTDU5PCTFo4yx8ZqdsrvG2bGKCNQvbyDoUTBbL2
         D6elDDTzk1YlQsw7nm4YpA7If2S0fwXKQ7DlEXr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Jones <ajones@ventanamicro.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 233/529] RISC-V: fix funct4 definition for c.jalr in parse_asm.h
Date:   Fri, 10 Mar 2023 14:36:16 +0100
Message-Id: <20230310133815.781418575@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@vrull.eu>

[ Upstream commit a3775634f6da23f5511d0282d7e792cf606e5f3b ]

The opcode definition for c.jalr is
    c.jalr c_rs1_n0  1..0=2 15..13=4 12=1 6..2=0

This means funct4 consisting of bit [15:12] is 1001b, so the value is 0x9.

Fixes: edde5584c7ab ("riscv: Add SW single-step support for KDB")
Reported-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Link: https://lore.kernel.org/r/20221223221332.4127602-2-heiko@sntech.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/parse_asm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/parse_asm.h b/arch/riscv/include/asm/parse_asm.h
index f36368de839f5..7fee806805c1b 100644
--- a/arch/riscv/include/asm/parse_asm.h
+++ b/arch/riscv/include/asm/parse_asm.h
@@ -125,7 +125,7 @@
 #define FUNCT3_C_J		0xa000
 #define FUNCT3_C_JAL		0x2000
 #define FUNCT4_C_JR		0x8000
-#define FUNCT4_C_JALR		0xf000
+#define FUNCT4_C_JALR		0x9000
 
 #define FUNCT12_SRET		0x10200000
 
-- 
2.39.2




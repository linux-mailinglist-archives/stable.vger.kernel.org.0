Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B98490DB6
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242109AbiAQRFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242129AbiAQRCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:02:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6B8C06176A;
        Mon, 17 Jan 2022 09:02:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1B5B611F1;
        Mon, 17 Jan 2022 17:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00148C36B02;
        Mon, 17 Jan 2022 17:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438939;
        bh=9aUcXT3IAkm0wq9zoAJHhvROrGWTCBthzqq60iNgH8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/jPeoCd0Zc7kSgj+v5PAmjkKcFaXGx6a5Bb6FY1gmtW13xzAGiPVom6YUWbqP0RC
         d040J+5sgd/66II0nmlbTLt9CKBym7j1lOaEm+2uAuCcNUgGdYBnCteyKmKtogm6Xs
         OrY/wlmCBQoiA/As21hhSU1vWIC+d2J7ZLliIYKi6fTQRUlaOSxwuGGMM5HPH9TeJ/
         2OZ7ocxXMWerZ+az0RByzPaeUZcFjk9W76KVvRCQqEC25o5Voj7EvXA4lRQZZuxFDc
         /OMxPGl2JUw+VZRKA+Bl/Iltmlfxsl5OPVtWiIkBGPERwnN/xI7RyRtQ/+4nVjRlz1
         4TDatd6q6NSIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Ryutaroh Matsumoto <ryutaroh@ict.e.titech.ac.jp>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, chenhuacai@kernel.org,
        jiaxun.yang@flygoat.com, ndesaulniers@google.com,
        linux-mips@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 23/44] MIPS: Loongson64: Use three arguments for slti
Date:   Mon, 17 Jan 2022 12:01:06 -0500
Message-Id: <20220117170127.1471115-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit f2c6c22fa83ab2577619009057b3ebcb5305bb03 ]

LLVM's integrated assembler does not support 'slti <reg>, <imm>':

<instantiation>:16:12: error: invalid operand for instruction
 slti $12, (0x6300 | 0x0008)
           ^
arch/mips/kernel/head.S:86:2: note: while in macro instantiation
 kernel_entry_setup # cpu specific setup
 ^
<instantiation>:16:12: error: invalid operand for instruction
 slti $12, (0x6300 | 0x0008)
           ^
arch/mips/kernel/head.S:150:2: note: while in macro instantiation
 smp_slave_setup
 ^

To increase compatibility with LLVM's integrated assembler, use the full
form of 'slti <reg>, <reg>, <imm>', which matches the rest of
arch/mips/. This does not result in any change for GNU as.

Link: https://github.com/ClangBuiltLinux/linux/issues/1526
Reported-by: Ryutaroh Matsumoto <ryutaroh@ict.e.titech.ac.jp>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mach-loongson64/kernel-entry-init.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/mach-loongson64/kernel-entry-init.h b/arch/mips/include/asm/mach-loongson64/kernel-entry-init.h
index 13373c5144f89..efb41b3519747 100644
--- a/arch/mips/include/asm/mach-loongson64/kernel-entry-init.h
+++ b/arch/mips/include/asm/mach-loongson64/kernel-entry-init.h
@@ -32,7 +32,7 @@
 	nop
 	/* Loongson-3A R2/R3 */
 	andi	t0, (PRID_IMP_MASK | PRID_REV_MASK)
-	slti	t0, (PRID_IMP_LOONGSON_64C | PRID_REV_LOONGSON3A_R2_0)
+	slti	t0, t0, (PRID_IMP_LOONGSON_64C | PRID_REV_LOONGSON3A_R2_0)
 	bnez	t0, 2f
 	nop
 1:
@@ -63,7 +63,7 @@
 	nop
 	/* Loongson-3A R2/R3 */
 	andi	t0, (PRID_IMP_MASK | PRID_REV_MASK)
-	slti	t0, (PRID_IMP_LOONGSON_64C | PRID_REV_LOONGSON3A_R2_0)
+	slti	t0, t0, (PRID_IMP_LOONGSON_64C | PRID_REV_LOONGSON3A_R2_0)
 	bnez	t0, 2f
 	nop
 1:
-- 
2.34.1


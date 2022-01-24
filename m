Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95D3499F51
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381887AbiAXW5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1579153AbiAXWFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:05:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694FFC0C684C;
        Mon, 24 Jan 2022 12:42:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06E3E615B5;
        Mon, 24 Jan 2022 20:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6B1C340E5;
        Mon, 24 Jan 2022 20:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056926;
        bh=9aUcXT3IAkm0wq9zoAJHhvROrGWTCBthzqq60iNgH8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OM16t9Tu/93Gz3Bmn8EtTURdV9EC+a8DkXhhsd+GxRj6w2l7uShJDh4x6nF6Ixh9d
         PRMUxyZW1ZnQsrT66iWaOMbmrJlMi0hikKCQcVoMTQhhFZlJgCos/LYzq2JOPB7Qg4
         WWmIDcODqMg3qwLLn22oFF0pIHAoROlSP90J/3Ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ryutaroh Matsumoto <ryutaroh@ict.e.titech.ac.jp>,
        Nathan Chancellor <nathan@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 644/846] MIPS: Loongson64: Use three arguments for slti
Date:   Mon, 24 Jan 2022 19:42:41 +0100
Message-Id: <20220124184123.239427671@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




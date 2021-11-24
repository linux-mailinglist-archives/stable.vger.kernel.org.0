Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C14F45C30E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350193AbhKXNfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:35:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:35646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351442AbhKXNbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:31:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4CD0617E3;
        Wed, 24 Nov 2021 12:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758368;
        bh=/RrkNP1mweEqJHXVFvaw6CXmmdqymn7tQQkmFxwBSc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0m2ATJMLLO1rDyu6197ku3qTwoZydkQLEZYMfMjkrWHkXGsqEqcRWkhvaj03zDJzV
         lXpDbxZovHeoNlhHNmR7J1kg9zUCHK096L/MPRULfjxlCu0EB0Ui1i5AV9SIafE3fP
         PM4WMZMfRZN8fagCFgv7WRitKghUWxcE+B1s/p24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/154] powerpc/8xx: Fix Oops with STRICT_KERNEL_RWX without DEBUG_RODATA_TEST
Date:   Wed, 24 Nov 2021 12:57:23 +0100
Message-Id: <20211124115703.860466020@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit c12ab8dbc492b992e1ea717db933cee568780c47 ]

Until now, all tests involving CONFIG_STRICT_KERNEL_RWX were done with
DEBUG_RODATA_TEST to check the result. But now that
CONFIG_STRICT_KERNEL_RWX is selected by default, it came without
CONFIG_DEBUG_RODATA_TEST and led to the following Oops

[    6.830908] Freeing unused kernel image (initmem) memory: 352K
[    6.840077] BUG: Unable to handle kernel data access on write at 0xc1285200
[    6.846836] Faulting instruction address: 0xc0004b6c
[    6.851745] Oops: Kernel access of bad area, sig: 11 [#1]
[    6.857075] BE PAGE_SIZE=16K PREEMPT CMPC885
[    6.861348] SAF3000 DIE NOTIFICATION
[    6.864830] CPU: 0 PID: 1 Comm: swapper Not tainted 5.15.0-rc5-s3k-dev-02255-g2747d7b7916f #451
[    6.873429] NIP:  c0004b6c LR: c0004b60 CTR: 00000000
[    6.878419] REGS: c902be60 TRAP: 0300   Not tainted  (5.15.0-rc5-s3k-dev-02255-g2747d7b7916f)
[    6.886852] MSR:  00009032 <EE,ME,IR,DR,RI>  CR: 53000335  XER: 8000ff40
[    6.893564] DAR: c1285200 DSISR: 82000000
[    6.893564] GPR00: 0c000000 c902bf20 c20f4000 08000000 00000001 04001f00 c1800000 00000035
[    6.893564] GPR08: ff0001ff c1280000 00000002 c0004b60 00001000 00000000 c0004b1c 00000000
[    6.893564] GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    6.893564] GPR24: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 c1060000
[    6.932034] NIP [c0004b6c] kernel_init+0x50/0x138
[    6.936682] LR [c0004b60] kernel_init+0x44/0x138
[    6.941245] Call Trace:
[    6.943653] [c902bf20] [c0004b60] kernel_init+0x44/0x138 (unreliable)
[    6.950022] [c902bf30] [c001122c] ret_from_kernel_thread+0x5c/0x64
[    6.956135] Instruction dump:
[    6.959060] 48ffc521 48045469 4800d8cd 3d20c086 89295fa0 2c090000 41820058 480796c9
[    6.966890] 4800e48d 3d20c128 39400002 3fe0c106 <91495200> 3bff8000 4806fa1d 481f7d75
[    6.974902] ---[ end trace 1e397bacba4aa610 ]---

0xc1285200 corresponds to 'system_state' global var that the kernel is trying to set to
SYSTEM_RUNNING. This var is above the RO/RW limit so it shouldn't Oops.

It oopses because the dirty bit is missing.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/3d5800b0bbcd7b19761b98f50421358667b45331.1635520232.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_8xx.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index ce5fd93499a74..896a1f8d3e6ac 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -788,7 +788,7 @@ _GLOBAL(mmu_pin_tlb)
 	cmplw	r6, r9
 	bdnzt	lt, 2b
 
-4:	LOAD_REG_IMMEDIATE(r8, 0xf0 | _PAGE_SPS | _PAGE_SH | _PAGE_PRESENT)
+4:	LOAD_REG_IMMEDIATE(r8, 0xf0 | _PAGE_DIRTY | _PAGE_SPS | _PAGE_SH | _PAGE_PRESENT)
 2:	ori	r0, r6, MD_EVALID
 	mtspr	SPRN_MD_CTR, r5
 	mtspr	SPRN_MD_EPN, r0
-- 
2.33.0




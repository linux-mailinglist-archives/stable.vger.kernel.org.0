Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7AF29B3B3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752391AbgJ0Oy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1773134AbgJ0Ov3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:51:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34EE421556;
        Tue, 27 Oct 2020 14:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810288;
        bh=L3tuWgNJ+w2yoIZXbankqdJBTkOWWd83ZWGG9zgicOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wLZQ14ny1aykAn3F3GCxmob/JgUddBr9p/w89tMNkWD5PMZWQz0VMnb6jqn89aRh3
         VbT9IVDIzFHIvyZVInLRxTjxBzMUtzkSxstC+drx7vxja0vvLPA0UvJseCvv+O/Lek
         VnDVLMA6BCs7+BXDDsbfBJwAYMiCkbPgldsABpdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 087/633] arm64: kprobe: add checks for ARMv8.3-PAuth combined instructions
Date:   Tue, 27 Oct 2020 14:47:10 +0100
Message-Id: <20201027135526.771438586@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Daniel Kachhap <amit.kachhap@arm.com>

[ Upstream commit 93396936ed0ce2c6f44140bd14728611d0bb065e ]

Currently the ARMv8.3-PAuth combined branch instructions (braa, retaa
etc.) are not simulated for out-of-line execution with a handler. Hence the
uprobe of such instructions leads to kernel warnings in a loop as they are
not explicitly checked and fall into INSN_GOOD categories. Other combined
instructions like LDRAA and LDRBB can be probed.

The issue of the combined branch instructions is fixed by adding
group definitions of all such instructions and rejecting their probes.
The instruction groups added are br_auth(braa, brab, braaz and brabz),
blr_auth(blraa, blrab, blraaz and blrabz), ret_auth(retaa and retab) and
eret_auth(eretaa and eretab).

Warning log:
 WARNING: CPU: 0 PID: 156 at arch/arm64/kernel/probes/uprobes.c:182 uprobe_single_step_handler+0x34/0x50
 Modules linked in:
 CPU: 0 PID: 156 Comm: func Not tainted 5.9.0-rc3 #188
 Hardware name: Foundation-v8A (DT)
 pstate: 804003c9 (Nzcv DAIF +PAN -UAO BTYPE=--)
 pc : uprobe_single_step_handler+0x34/0x50
 lr : single_step_handler+0x70/0xf8
 sp : ffff800012af3e30
 x29: ffff800012af3e30 x28: ffff000878723b00
 x27: 0000000000000000 x26: 0000000000000000
 x25: 0000000000000000 x24: 0000000000000000
 x23: 0000000060001000 x22: 00000000cb000022
 x21: ffff800012065ce8 x20: ffff800012af3ec0
 x19: ffff800012068d50 x18: 0000000000000000
 x17: 0000000000000000 x16: 0000000000000000
 x15: 0000000000000000 x14: 0000000000000000
 x13: 0000000000000000 x12: 0000000000000000
 x11: 0000000000000000 x10: 0000000000000000
 x9 : ffff800010085c90 x8 : 0000000000000000
 x7 : 0000000000000000 x6 : ffff80001205a9c8
 x5 : ffff80001205a000 x4 : ffff80001233db80
 x3 : ffff8000100a7a60 x2 : 0020000000000003
 x1 : 0000fffffffff008 x0 : ffff800012af3ec0
 Call trace:
  uprobe_single_step_handler+0x34/0x50
  single_step_handler+0x70/0xf8
  do_debug_exception+0xb8/0x130
  el0_sync_handler+0x138/0x1b8
  el0_sync+0x158/0x180

Fixes: 74afda4016a7 ("arm64: compile the kernel with ptrauth return address signing")
Fixes: 04ca3204fa09 ("arm64: enable pointer authentication")
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Link: https://lore.kernel.org/r/20200914083656.21428-2-amit.kachhap@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/insn.h          | 4 ++++
 arch/arm64/kernel/insn.c               | 5 ++++-
 arch/arm64/kernel/probes/decode-insn.c | 3 ++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 0bc46149e4917..4b39293d0f72d 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -359,9 +359,13 @@ __AARCH64_INSN_FUNCS(brk,	0xFFE0001F, 0xD4200000)
 __AARCH64_INSN_FUNCS(exception,	0xFF000000, 0xD4000000)
 __AARCH64_INSN_FUNCS(hint,	0xFFFFF01F, 0xD503201F)
 __AARCH64_INSN_FUNCS(br,	0xFFFFFC1F, 0xD61F0000)
+__AARCH64_INSN_FUNCS(br_auth,	0xFEFFF800, 0xD61F0800)
 __AARCH64_INSN_FUNCS(blr,	0xFFFFFC1F, 0xD63F0000)
+__AARCH64_INSN_FUNCS(blr_auth,	0xFEFFF800, 0xD63F0800)
 __AARCH64_INSN_FUNCS(ret,	0xFFFFFC1F, 0xD65F0000)
+__AARCH64_INSN_FUNCS(ret_auth,	0xFFFFFBFF, 0xD65F0BFF)
 __AARCH64_INSN_FUNCS(eret,	0xFFFFFFFF, 0xD69F03E0)
+__AARCH64_INSN_FUNCS(eret_auth,	0xFFFFFBFF, 0xD69F0BFF)
 __AARCH64_INSN_FUNCS(mrs,	0xFFF00000, 0xD5300000)
 __AARCH64_INSN_FUNCS(msr_imm,	0xFFF8F01F, 0xD500401F)
 __AARCH64_INSN_FUNCS(msr_reg,	0xFFF00000, 0xD5100000)
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index a107375005bc9..ccc8c9e22b258 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -176,7 +176,7 @@ bool __kprobes aarch64_insn_uses_literal(u32 insn)
 
 bool __kprobes aarch64_insn_is_branch(u32 insn)
 {
-	/* b, bl, cb*, tb*, b.cond, br, blr */
+	/* b, bl, cb*, tb*, ret*, b.cond, br*, blr* */
 
 	return aarch64_insn_is_b(insn) ||
 		aarch64_insn_is_bl(insn) ||
@@ -185,8 +185,11 @@ bool __kprobes aarch64_insn_is_branch(u32 insn)
 		aarch64_insn_is_tbz(insn) ||
 		aarch64_insn_is_tbnz(insn) ||
 		aarch64_insn_is_ret(insn) ||
+		aarch64_insn_is_ret_auth(insn) ||
 		aarch64_insn_is_br(insn) ||
+		aarch64_insn_is_br_auth(insn) ||
 		aarch64_insn_is_blr(insn) ||
+		aarch64_insn_is_blr_auth(insn) ||
 		aarch64_insn_is_bcond(insn);
 }
 
diff --git a/arch/arm64/kernel/probes/decode-insn.c b/arch/arm64/kernel/probes/decode-insn.c
index 263d5fba4c8a3..c541fb48886e3 100644
--- a/arch/arm64/kernel/probes/decode-insn.c
+++ b/arch/arm64/kernel/probes/decode-insn.c
@@ -29,7 +29,8 @@ static bool __kprobes aarch64_insn_is_steppable(u32 insn)
 		    aarch64_insn_is_msr_imm(insn) ||
 		    aarch64_insn_is_msr_reg(insn) ||
 		    aarch64_insn_is_exception(insn) ||
-		    aarch64_insn_is_eret(insn))
+		    aarch64_insn_is_eret(insn) ||
+		    aarch64_insn_is_eret_auth(insn))
 			return false;
 
 		/*
-- 
2.25.1




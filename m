Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A72D3C559D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhGLILO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353827AbhGLIDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F7A361959;
        Mon, 12 Jul 2021 07:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076659;
        bh=A7AgJxwX7sbP8mUwlIqfPATdBVFwKm82LCNlPcLGtqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxYktpDWXtlqHG+HaiQfB7zNopIiw99Jt/YNpT2W4bOKRxXHQtuU8MUTrdWDC2K4K
         IDalEPk6pA/qRCB64OUlhyhLmlnC8pqIzj7xE7VM2JpvgG7kzPFo3SHM/So/a9ACJD
         QHD1Yms20NDajYKt+qSGHj4+anqxW3s0CH+Yisdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 737/800] powerpc/powernv: Fix machine check reporting of async store errors
Date:   Mon, 12 Jul 2021 08:12:40 +0200
Message-Id: <20210712061045.166407437@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 3729e0ec59a20825bd4c8c70996b2df63915e1dd ]

POWER9 and POWER10 asynchronous machine checks due to stores have their
cause reported in SRR1 but SRR1[42] is set, which in other cases
indicates DSISR cause.

Check for these cases and clear SRR1[42], so the cause matching uses
the i-side (SRR1) table.

Fixes: 7b9f71f974a1 ("powerpc/64s: POWER9 machine check handler")
Fixes: 201220bb0e8c ("powerpc/powernv: Machine check handler for POWER10")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210517140355.2325406-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/mce_power.c | 48 +++++++++++++++++++++++++++------
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/mce_power.c b/arch/powerpc/kernel/mce_power.c
index 667104d4c455..2fff886c549d 100644
--- a/arch/powerpc/kernel/mce_power.c
+++ b/arch/powerpc/kernel/mce_power.c
@@ -481,12 +481,11 @@ static int mce_find_instr_ea_and_phys(struct pt_regs *regs, uint64_t *addr,
 	return -1;
 }
 
-static int mce_handle_ierror(struct pt_regs *regs,
+static int mce_handle_ierror(struct pt_regs *regs, unsigned long srr1,
 		const struct mce_ierror_table table[],
 		struct mce_error_info *mce_err, uint64_t *addr,
 		uint64_t *phys_addr)
 {
-	uint64_t srr1 = regs->msr;
 	int handled = 0;
 	int i;
 
@@ -695,19 +694,19 @@ static long mce_handle_ue_error(struct pt_regs *regs,
 }
 
 static long mce_handle_error(struct pt_regs *regs,
+		unsigned long srr1,
 		const struct mce_derror_table dtable[],
 		const struct mce_ierror_table itable[])
 {
 	struct mce_error_info mce_err = { 0 };
 	uint64_t addr, phys_addr = ULONG_MAX;
-	uint64_t srr1 = regs->msr;
 	long handled;
 
 	if (SRR1_MC_LOADSTORE(srr1))
 		handled = mce_handle_derror(regs, dtable, &mce_err, &addr,
 				&phys_addr);
 	else
-		handled = mce_handle_ierror(regs, itable, &mce_err, &addr,
+		handled = mce_handle_ierror(regs, srr1, itable, &mce_err, &addr,
 				&phys_addr);
 
 	if (!handled && mce_err.error_type == MCE_ERROR_TYPE_UE)
@@ -723,16 +722,20 @@ long __machine_check_early_realmode_p7(struct pt_regs *regs)
 	/* P7 DD1 leaves top bits of DSISR undefined */
 	regs->dsisr &= 0x0000ffff;
 
-	return mce_handle_error(regs, mce_p7_derror_table, mce_p7_ierror_table);
+	return mce_handle_error(regs, regs->msr,
+			mce_p7_derror_table, mce_p7_ierror_table);
 }
 
 long __machine_check_early_realmode_p8(struct pt_regs *regs)
 {
-	return mce_handle_error(regs, mce_p8_derror_table, mce_p8_ierror_table);
+	return mce_handle_error(regs, regs->msr,
+			mce_p8_derror_table, mce_p8_ierror_table);
 }
 
 long __machine_check_early_realmode_p9(struct pt_regs *regs)
 {
+	unsigned long srr1 = regs->msr;
+
 	/*
 	 * On POWER9 DD2.1 and below, it's possible to get a machine check
 	 * caused by a paste instruction where only DSISR bit 25 is set. This
@@ -746,10 +749,39 @@ long __machine_check_early_realmode_p9(struct pt_regs *regs)
 	if (SRR1_MC_LOADSTORE(regs->msr) && regs->dsisr == 0x02000000)
 		return 1;
 
-	return mce_handle_error(regs, mce_p9_derror_table, mce_p9_ierror_table);
+	/*
+	 * Async machine check due to bad real address from store or foreign
+	 * link time out comes with the load/store bit (PPC bit 42) set in
+	 * SRR1, but the cause comes in SRR1 not DSISR. Clear bit 42 so we're
+	 * directed to the ierror table so it will find the cause (which
+	 * describes it correctly as a store error).
+	 */
+	if (SRR1_MC_LOADSTORE(srr1) &&
+			((srr1 & 0x081c0000) == 0x08140000 ||
+			 (srr1 & 0x081c0000) == 0x08180000)) {
+		srr1 &= ~PPC_BIT(42);
+	}
+
+	return mce_handle_error(regs, srr1,
+			mce_p9_derror_table, mce_p9_ierror_table);
 }
 
 long __machine_check_early_realmode_p10(struct pt_regs *regs)
 {
-	return mce_handle_error(regs, mce_p10_derror_table, mce_p10_ierror_table);
+	unsigned long srr1 = regs->msr;
+
+	/*
+	 * Async machine check due to bad real address from store comes with
+	 * the load/store bit (PPC bit 42) set in SRR1, but the cause comes in
+	 * SRR1 not DSISR. Clear bit 42 so we're directed to the ierror table
+	 * so it will find the cause (which describes it correctly as a store
+	 * error).
+	 */
+	if (SRR1_MC_LOADSTORE(srr1) &&
+			(srr1 & 0x081c0000) == 0x08140000) {
+		srr1 &= ~PPC_BIT(42);
+	}
+
+	return mce_handle_error(regs, srr1,
+			mce_p10_derror_table, mce_p10_ierror_table);
 }
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058D3364B75
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242412AbhDSUof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242407AbhDSUoe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:44:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F6C8613B0;
        Mon, 19 Apr 2021 20:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865044;
        bh=nAmp5UIFdq9tgAD5cLuft77KrM6yGyF0GIa2ORZdBR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WkJzcDtLRxIiUmY9hnVWEo+0Ymu1f0trLmbVbn62ZoSQ7CJjM9yKCrP+DlvOnVOsv
         CchRoJeW2ZsbJ02mstiAJC9E6/HTOEnFp0Ny/O2uXiMrwwHpI0U40EM61czb4xXrkf
         Yg5xvBHV92s1LBtMJ2luQLP14G9SPQWmRZDpCsO4V6onU5P5movtlSmYo1Lo5b4rKy
         WeMTJX2BbkVHIIzrnjD78FD6FJEz/DydRTwCRSE+rvM64aiunI5+RBLmw09V1eeBUO
         HQ8ql2W9MV5EWLAI69+T59W9uJlZhCOfYdj/MXG/Jvy76huHQuvC6f03VZlGAwto9X
         QDUlbGKqMzZKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 14/23] arm64: kprobes: Restore local irqflag if kprobes is cancelled
Date:   Mon, 19 Apr 2021 16:43:33 -0400
Message-Id: <20210419204343.6134-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204343.6134-1-sashal@kernel.org>
References: <20210419204343.6134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

[ Upstream commit 738fa58ee1328481d1d7889e7c430b3401c571b9 ]

If instruction being single stepped caused a page fault, the kprobes
is cancelled to let the page fault handler continue as a normal page
fault. But the local irqflags are disabled so cpu will restore pstate
with DAIF masked. After pagefault is serviced, the kprobes is
triggerred again, we overwrite the saved_irqflag by calling
kprobes_save_local_irqflag(). NOTE, DAIF is masked in this new saved
irqflag. After kprobes is serviced, the cpu pstate is retored with
DAIF masked.

This patch is inspired by one patch for riscv from Liao Chang.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20210412174101.6bfb0594@xhacker.debian
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/probes/kprobes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index 66aac2881ba8..85645b2b0c7a 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -267,10 +267,12 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr)
 		if (!instruction_pointer(regs))
 			BUG();
 
-		if (kcb->kprobe_status == KPROBE_REENTER)
+		if (kcb->kprobe_status == KPROBE_REENTER) {
 			restore_previous_kprobe(kcb);
-		else
+		} else {
+			kprobes_restore_local_irqflag(kcb, regs);
 			reset_current_kprobe();
+		}
 
 		break;
 	case KPROBE_HIT_ACTIVE:
-- 
2.30.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3EB36AE87
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhDZHpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233598AbhDZHn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:43:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EDF2613C6;
        Mon, 26 Apr 2021 07:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422816;
        bh=6kyVlTTcQvm60muHEDHx+81IPWmlevGExB5GYk3nMuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wP/+iPQPzsc0D+/t/CJnBARLbpfGB1xjckUjSANItvekyrVmLvToVZHG/a/bEyeU2
         CH/6rSWoC+28uBJGWEEaUsmrG60V0nB7BE0ZBgpx4V6iZwdxmT7VYXHpy6fTQytRHW
         fOkor2FWLn8EBuMohWpSKgXYErJ7lkeXoeqpzu7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/36] arm64: kprobes: Restore local irqflag if kprobes is cancelled
Date:   Mon, 26 Apr 2021 09:30:11 +0200
Message-Id: <20210426072819.777722184@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
References: <20210426072818.777662399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f11a1a1f7026..798c3e78b84b 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -286,10 +286,12 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr)
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




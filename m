Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9F0206607
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389909AbgFWVg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388761AbgFWUJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:09:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1FF7206C3;
        Tue, 23 Jun 2020 20:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942990;
        bh=Cub665QUSNFRToyIR8JNcV3JX+gOYS5nsY0Gy4VOlRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geFFWoE250oXj9p6pUhVlLgRI9KZJ+FwOmaeIPJUwrKnuRL6PyLrQzz2ySJ/Vh5O/
         +blPj3/RLNuXjngxDS4+9lgubNKiQ2N69MD1ZHLuZHGYhr5Zsby+BL9WZ1gxF5sEDL
         aJb1OLv6RRG8uailfvka3DmB45258YWWA/syRScc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 216/477] powerpc/64s/exceptions: Machine check reconcile irq state
Date:   Tue, 23 Jun 2020 21:53:33 +0200
Message-Id: <20200623195417.795167730@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit f0fd9dd3c213c947dfb5bc2cad3ef5e30d3258ec ]

pseries fwnmi machine check code pops the soft-irq checks in rtas_call
(after the next patch to remove rtas_token from this call path).
Rather than play whack a mole with these and forever having fragile
code, it seems better to have the early machine check handler perform
the same kind of reconcile as the other NMI interrupts.

  WARNING: CPU: 0 PID: 493 at arch/powerpc/kernel/irq.c:343
  CPU: 0 PID: 493 Comm: a Tainted: G        W
  NIP:  c00000000001ed2c LR: c000000000042c40 CTR: 0000000000000000
  REGS: c0000001fffd38b0 TRAP: 0700   Tainted: G        W
  MSR:  8000000000021003 <SF,ME,RI,LE>  CR: 28000488  XER: 00000000
  CFAR: c00000000001ec90 IRQMASK: 0
  GPR00: c000000000043820 c0000001fffd3b40 c0000000012ba300 0000000000000000
  GPR04: 0000000048000488 0000000000000000 0000000000000000 00000000deadbeef
  GPR08: 0000000000000080 0000000000000000 0000000000000000 0000000000001001
  GPR12: 0000000000000000 c0000000014a0000 0000000000000000 0000000000000000
  GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  GPR24: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  GPR28: 0000000000000000 0000000000000001 c000000001360810 0000000000000000
  NIP [c00000000001ed2c] arch_local_irq_restore.part.0+0xac/0x100
  LR [c000000000042c40] unlock_rtas+0x30/0x90
  Call Trace:
  [c0000001fffd3b40] [c000000001360810] 0xc000000001360810 (unreliable)
  [c0000001fffd3b60] [c000000000043820] rtas_call+0x1c0/0x280
  [c0000001fffd3bb0] [c0000000000dc328] fwnmi_release_errinfo+0x38/0x70
  [c0000001fffd3c10] [c0000000000dcd8c] pseries_machine_check_realmode+0x1dc/0x540
  [c0000001fffd3cd0] [c00000000003fe04] machine_check_early+0x54/0x70
  [c0000001fffd3d00] [c000000000008384] machine_check_early_common+0x134/0x1f0
  --- interrupt: 200 at 0x13f1307c8
      LR = 0x7fff888b8528
  Instruction dump:
  60000000 7d2000a6 71298000 41820068 39200002 7d210164 4bffff9c 60000000
  60000000 7d2000a6 71298000 4c820020 <0fe00000> 4e800020 60000000 60000000

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200508043408.886394-5-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/exceptions-64s.S | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 463372046169a..d3e19934cca99 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1117,11 +1117,30 @@ END_FTR_SECTION_IFSET(CPU_FTR_HVMODE)
 	li	r10,MSR_RI
 	mtmsrd	r10,1
 
+	/*
+	 * Set IRQS_ALL_DISABLED and save PACAIRQHAPPENED (see
+	 * system_reset_common)
+	 */
+	li	r10,IRQS_ALL_DISABLED
+	stb	r10,PACAIRQSOFTMASK(r13)
+	lbz	r10,PACAIRQHAPPENED(r13)
+	std	r10,RESULT(r1)
+	ori	r10,r10,PACA_IRQ_HARD_DIS
+	stb	r10,PACAIRQHAPPENED(r13)
+
 	addi	r3,r1,STACK_FRAME_OVERHEAD
 	bl	machine_check_early
 	std	r3,RESULT(r1)	/* Save result */
 	ld	r12,_MSR(r1)
 
+	/*
+	 * Restore soft mask settings.
+	 */
+	ld	r10,RESULT(r1)
+	stb	r10,PACAIRQHAPPENED(r13)
+	ld	r10,SOFTE(r1)
+	stb	r10,PACAIRQSOFTMASK(r13)
+
 #ifdef CONFIG_PPC_P7_NAP
 	/*
 	 * Check if thread was in power saving mode. We come here when any
-- 
2.25.1




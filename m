Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DBDFED65
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbfKPPnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:43:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727870AbfKPPnt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:49 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A843A20729;
        Sat, 16 Nov 2019 15:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919028;
        bh=zWF5U4xg7nt3/h5P3T6bRnH5eZb0im/xahs52GP8njM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhvBtnvFY4od+uheu6kih3XaR6W7n/Go86Vsz12TR2GNvABTY9gldAsbPimX4yH/X
         VSmdA2afmJ2D15IxbPhL/kxpOCwOHxVwNlyut0+RnekLlzXSY3gG4gqjDcrN2B2lbO
         jnV/Y+XtUJKQU9xdP42t5d6uKfl/D/ifORnzuhtY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felipe Rechia <felipe.rechia@datacom.com.br>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 126/237] powerpc/process: Fix flush_all_to_thread for SPE
Date:   Sat, 16 Nov 2019 10:39:21 -0500
Message-Id: <20191116154113.7417-126-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Rechia <felipe.rechia@datacom.com.br>

[ Upstream commit e901378578c62202594cba0f6c076f3df365ec91 ]

Fix a bug introduced by the creation of flush_all_to_thread() for
processors that have SPE (Signal Processing Engine) and use it to
compute floating-point operations.

>From userspace perspective, the problem was seen in attempts of
computing floating-point operations which should generate exceptions.
For example:

  fork();
  float x = 0.0 / 0.0;
  isnan(x);           // forked process returns False (should be True)

The operation above also should always cause the SPEFSCR FINV bit to
be set. However, the SPE floating-point exceptions were turned off
after a fork().

Kernel versions prior to the bug used flush_spe_to_thread(), which
first saves SPEFSCR register values in tsk->thread and then calls
giveup_spe(tsk).

After commit 579e633e764e, the save_all() function was called first
to giveup_spe(), and then the SPEFSCR register values were saved in
tsk->thread. This would save the SPEFSCR register values after
disabling SPE for that thread, causing the bug described above.

Fixes 579e633e764e ("powerpc: create flush_all_to_thread()")
Signed-off-by: Felipe Rechia <felipe.rechia@datacom.com.br>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/process.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 909c9407e392a..02b69a68139cc 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -575,12 +575,11 @@ void flush_all_to_thread(struct task_struct *tsk)
 	if (tsk->thread.regs) {
 		preempt_disable();
 		BUG_ON(tsk != current);
-		save_all(tsk);
-
 #ifdef CONFIG_SPE
 		if (tsk->thread.regs->msr & MSR_SPE)
 			tsk->thread.spefscr = mfspr(SPRN_SPEFSCR);
 #endif
+		save_all(tsk);
 
 		preempt_enable();
 	}
-- 
2.20.1


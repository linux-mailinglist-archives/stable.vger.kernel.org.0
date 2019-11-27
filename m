Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDABE10B915
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbfK0Utn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:49:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbfK0Utm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:49:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78CDD20678;
        Wed, 27 Nov 2019 20:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887781;
        bh=MdXxU8oNnNxUNykFVPJPxOfa36YJHrJlrvzu5GMEQSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQxc6t1xowKwkynLpQQfZQbfNT2EDLFKGmLd/2mvgSVyDK1+1sW+gekbco5LcdIov
         svmuunugUN+rDCK8ybGTnN3I0/TpCNTt5BIW50xAXaD3JF4RvI6ZvIpSbdNmQh9UsP
         AbOQ+bXDchdOLroBDHLjGVDNP7j8128AnP4KAWj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Felipe Rechia <felipe.rechia@datacom.com.br>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 090/211] powerpc/process: Fix flush_all_to_thread for SPE
Date:   Wed, 27 Nov 2019 21:30:23 +0100
Message-Id: <20191127203102.251927666@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5e5da2073fdff..ba0d4f9a99bac 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -567,12 +567,11 @@ void flush_all_to_thread(struct task_struct *tsk)
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




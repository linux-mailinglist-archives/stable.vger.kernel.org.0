Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C833B6037
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhF1OWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233205AbhF1OWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:22:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 975CD61C7A;
        Mon, 28 Jun 2021 14:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889970;
        bh=OJ2xsLc8Yj7VcaGDoT9VKaUq7x/xm2c71PBiVoE46go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ut7Ygmzhxtn4F69BFA3g8v5O1ZceXliR4tJc6QIHgVjuB0c3G1atH1C0YRCYyhq5J
         HZij3ULQqPKmRLXcQul1y6ZgIkYe/lqGvlegnDXD1T6oiU7nwGEuFDIYHG+6x9I27O
         BnzDucwugiMzF2eBTcW0jy7uQ/qGd6wfN1gLqOMMU7FesJ4tC2jQYHoEueFvgYCoMU
         +CAAx0E5LcUKfxaKBNpxu83tatxCJ1Lz+ZU8TEDYvYY3m5kqkW+ed5wjStDR4BF5NE
         DLjaXcvvPdxZ4v9fSmpbBHGBmK48vU6+6RALs1xNNkBYIb+ZhkWTxNZf+UX4+f4oz2
         e/CWLNSXteo7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Bjoern Walk <bwalk@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 071/110] s390: fix system call restart with multiple signals
Date:   Mon, 28 Jun 2021 10:17:49 -0400
Message-Id: <20210628141828.31757-72-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit fc66127dc3396338f287c3b494dfbf102547e770 upstream.

glibc complained with "The futex facility returned an unexpected error
code.". It turned out that the futex syscall returned -ERESTARTSYS because
a signal is pending. arch_do_signal_or_restart() restored the syscall
parameters (nameley regs->gprs[2]) and set PIF_SYSCALL_RESTART. When
another signal is made pending later in the exit loop
arch_do_signal_or_restart() is called again. This function clears
PIF_SYSCALL_RESTART and checks the return code which is set in
regs->gprs[2]. However, regs->gprs[2] was restored in the previous run
and no longer contains -ERESTARTSYS, so PIF_SYSCALL_RESTART isn't set
again and the syscall is skipped.

Fix this by not clearing PIF_SYSCALL_RESTART - it is already cleared in
__do_syscall() when the syscall is restarted.

Reported-by: Bjoern Walk <bwalk@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Fixes: 56e62a737028 ("s390: convert to generic entry")
Cc: <stable@vger.kernel.org> # 5.12
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/signal.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index 90163e6184f5..080e7aed181f 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -512,7 +512,6 @@ void arch_do_signal_or_restart(struct pt_regs *regs, bool has_signal)
 
 	/* No handlers present - check for system call restart */
 	clear_pt_regs_flag(regs, PIF_SYSCALL);
-	clear_pt_regs_flag(regs, PIF_SYSCALL_RESTART);
 	if (current->thread.system_call) {
 		regs->int_code = current->thread.system_call;
 		switch (regs->gprs[2]) {
-- 
2.30.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6FFA1333CF
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgAGVDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:03:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:43804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728848AbgAGVC7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:02:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BC1A2077B;
        Tue,  7 Jan 2020 21:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430979;
        bh=xCyZaWVQZrlbGkrwOH3saOi6HZRKJT6k+mOczyMTkUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkhPTGhwU8Dy96pd9Z9CyGiT3+/j8rI2bP7nl0pqeyYPDOpBzmmcmH7wWJPRrpfCs
         ga55bFLKLoobmIR6c0ZO6O0IE01gMZJqXuNoTYdLfEoxN7AWM393VLP4mmGdV4imoM
         wU3mrWbOry7D9SBUjzt27/LK4dOFE9kLT4/83O1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 176/191] xfs: periodically yield scrub threads to the scheduler
Date:   Tue,  7 Jan 2020 21:54:56 +0100
Message-Id: <20200107205342.417933094@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 5d1116d4c6af3e580f1ed0382ca5a94bd65a34cf ]

Christoph Hellwig complained about the following soft lockup warning
when running scrub after generic/175 when preemption is disabled and
slub debugging is enabled:

watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [xfs_scrub:161]
Modules linked in:
irq event stamp: 41692326
hardirqs last  enabled at (41692325): [<ffffffff8232c3b7>] _raw_0
hardirqs last disabled at (41692326): [<ffffffff81001c5a>] trace0
softirqs last  enabled at (41684994): [<ffffffff8260031f>] __do_e
softirqs last disabled at (41684987): [<ffffffff81127d8c>] irq_e0
CPU: 3 PID: 16189 Comm: xfs_scrub Not tainted 5.4.0-rc3+ #30
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.124
RIP: 0010:_raw_spin_unlock_irqrestore+0x39/0x40
Code: 89 f3 be 01 00 00 00 e8 d5 3a e5 fe 48 89 ef e8 ed 87 e5 f2
RSP: 0018:ffffc9000233f970 EFLAGS: 00000286 ORIG_RAX: ffffffffff3
RAX: ffff88813b398040 RBX: 0000000000000286 RCX: 0000000000000006
RDX: 0000000000000006 RSI: ffff88813b3988c0 RDI: ffff88813b398040
RBP: ffff888137958640 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffea00042b0c00
R13: 0000000000000001 R14: ffff88810ac32308 R15: ffff8881376fc040
FS:  00007f6113dea700(0000) GS:ffff88813bb80000(0000) knlGS:00000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6113de8ff8 CR3: 000000012f290000 CR4: 00000000000006e0
Call Trace:
 free_debug_processing+0x1dd/0x240
 __slab_free+0x231/0x410
 kmem_cache_free+0x30e/0x360
 xchk_ag_btcur_free+0x76/0xb0
 xchk_ag_free+0x10/0x80
 xchk_bmap_iextent_xref.isra.14+0xd9/0x120
 xchk_bmap_iextent+0x187/0x210
 xchk_bmap+0x2e0/0x3b0
 xfs_scrub_metadata+0x2e7/0x500
 xfs_ioc_scrub_metadata+0x4a/0xa0
 xfs_file_ioctl+0x58a/0xcd0
 do_vfs_ioctl+0xa0/0x6f0
 ksys_ioctl+0x5b/0x90
 __x64_sys_ioctl+0x11/0x20
 do_syscall_64+0x4b/0x1a0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

If preemption is disabled, all metadata buffers needed to perform the
scrub are already in memory, and there are a lot of records to check,
it's possible that the scrub thread will run for an extended period of
time without sleeping for IO or any other reason.  Then the watchdog
timer or the RCU stall timeout can trigger, producing the backtrace
above.

To fix this problem, call cond_resched() from the scrub thread so that
we back out to the scheduler whenever necessary.

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/common.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 003a772cd26c..2e50d146105d 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -14,8 +14,15 @@
 static inline bool
 xchk_should_terminate(
 	struct xfs_scrub	*sc,
-	int				*error)
+	int			*error)
 {
+	/*
+	 * If preemption is disabled, we need to yield to the scheduler every
+	 * few seconds so that we don't run afoul of the soft lockup watchdog
+	 * or RCU stall detector.
+	 */
+	cond_resched();
+
 	if (fatal_signal_pending(current)) {
 		if (*error == 0)
 			*error = -EAGAIN;
-- 
2.20.1




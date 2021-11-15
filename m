Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E832450D02
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238535AbhKORrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:47:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238740AbhKORpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:45:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97B2D63310;
        Mon, 15 Nov 2021 17:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997365;
        bh=qlmn6Bgw0UqFDSuKTeL9xceGwLBTOC+lDycFXeBxUDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MjDWTCLBl4AfA/p/KC4Q56MIWGwZJe6HqDoHBex2dDxfmoRkQnjo9lUVEDvulXFxX
         EiTerFUHKBa9V5MHWpIgh7B2VSWq9aL3c9yCoiDvTOn4WDCS7CpWdTUeV27Fh9/uxz
         HIgRflSPvM3ouLu8n46Z7uQf60lRU08zfQfUJlUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>,
        Li Yang <leoyang.li@nxp.com>
Subject: [PATCH 5.10 122/575] soc: fsl: dpio: use the combined functions to protect critical zone
Date:   Mon, 15 Nov 2021 17:57:27 +0100
Message-Id: <20211115165347.917204932@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Li <Meng.Li@windriver.com>

commit dc7e5940aad6641bd5ab33ea8b21c4b3904d989f upstream.

In orininal code, use 2 function spin_lock() and local_irq_save() to
protect the critical zone. But when enable the kernel debug config,
there are below inconsistent lock state detected.
================================
WARNING: inconsistent lock state
5.10.63-yocto-standard #1 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
lock_torture_wr/226 [HC0[0]:SC1[5]:HE1:SE0] takes:
ffff002005b2dd80 (&p->access_spinlock){+.?.}-{3:3}, at: qbman_swp_enqueue_multiple_mem_back+0x44/0x270
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire.part.0+0xf8/0x250
  lock_acquire+0x68/0x84
  _raw_spin_lock+0x68/0x90
  qbman_swp_enqueue_multiple_mem_back+0x44/0x270
  ......
  cryptomgr_test+0x38/0x60
  kthread+0x158/0x164
  ret_from_fork+0x10/0x38
irq event stamp: 4498
hardirqs last  enabled at (4498): [<ffff800010fcf980>] _raw_spin_unlock_irqrestore+0x90/0xb0
hardirqs last disabled at (4497): [<ffff800010fcffc4>] _raw_spin_lock_irqsave+0xd4/0xe0
softirqs last  enabled at (4458): [<ffff8000100108c4>] __do_softirq+0x674/0x724
softirqs last disabled at (4465): [<ffff80001005b2a4>] __irq_exit_rcu+0x190/0x19c

other info that might help us debug this:
 Possible unsafe locking scenario:
       CPU0
       ----
  lock(&p->access_spinlock);
  <Interrupt>
    lock(&p->access_spinlock);
 *** DEADLOCK ***

So, in order to avoid deadlock, use the combined functions
spin_lock_irqsave/spin_unlock_irqrestore() to protect critical zone.

Fixes: 3b2abda7d28c ("soc: fsl: dpio: Replace QMAN array mode with ring mode enqueue")
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/fsl/dpio/qbman-portal.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/soc/fsl/dpio/qbman-portal.c
+++ b/drivers/soc/fsl/dpio/qbman-portal.c
@@ -732,8 +732,7 @@ int qbman_swp_enqueue_multiple_mem_back(
 	int i, num_enqueued = 0;
 	unsigned long irq_flags;
 
-	spin_lock(&s->access_spinlock);
-	local_irq_save(irq_flags);
+	spin_lock_irqsave(&s->access_spinlock, irq_flags);
 
 	half_mask = (s->eqcr.pi_ci_mask>>1);
 	full_mask = s->eqcr.pi_ci_mask;
@@ -744,8 +743,7 @@ int qbman_swp_enqueue_multiple_mem_back(
 		s->eqcr.available = qm_cyc_diff(s->eqcr.pi_ring_size,
 					eqcr_ci, s->eqcr.ci);
 		if (!s->eqcr.available) {
-			local_irq_restore(irq_flags);
-			spin_unlock(&s->access_spinlock);
+			spin_unlock_irqrestore(&s->access_spinlock, irq_flags);
 			return 0;
 		}
 	}
@@ -784,8 +782,7 @@ int qbman_swp_enqueue_multiple_mem_back(
 	dma_wmb();
 	qbman_write_register(s, QBMAN_CINH_SWP_EQCR_PI,
 				(QB_RT_BIT)|(s->eqcr.pi)|s->eqcr.pi_vb);
-	local_irq_restore(irq_flags);
-	spin_unlock(&s->access_spinlock);
+	spin_unlock_irqrestore(&s->access_spinlock, irq_flags);
 
 	return num_enqueued;
 }



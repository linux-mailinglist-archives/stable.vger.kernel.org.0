Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B18237430B
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbhEEQuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:50:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235458AbhEEQqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:46:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03CFF61935;
        Wed,  5 May 2021 16:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232589;
        bh=w1k4f0i6yOmkScwiFjhzfL8jY/5nHyF4SbdTGYR6oc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6iOvG2uzPQ4JCsa0T9IyNlsdCZ4WaQqqrMHGtq2dV44nOT5kxandQISkiaNd5aXC
         7janGhI2XFQgYeloxe6FSMnccU+34Lf8m9oaMzHIr9JUwr1yu66YijknvJTZ0HimpU
         r4qxh8MK7SBOGAOxjDdv3iJvWNbkjWOipuhb67me0s5d6iz8Hi494Lyo59mtUbLfwL
         ub9MpfZd0JGWrGna6OIQHuyRGxFgZhz/xw0zhkhYv67M0ztESTwrfRCnvKI9GAXnbw
         TxABty9629pcW/E9bB/x4aiFs2I+x0/q8Of9dxRI3n4tDSG02RCplI9YzUgaeLSlEe
         NCMES3U0uTLFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.11 093/104] powerpc/iommu: Annotate nested lock for lockdep
Date:   Wed,  5 May 2021 12:34:02 -0400
Message-Id: <20210505163413.3461611-93-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit cc7130bf119add37f36238343a593b71ef6ecc1e ]

The IOMMU table is divided into pools for concurrent mappings and each
pool has a separate spinlock. When taking the ownership of an IOMMU group
to pass through a device to a VM, we lock these spinlocks which triggers
a false negative warning in lockdep (below).

This fixes it by annotating the large pool's spinlock as a nest lock
which makes lockdep not complaining when locking nested locks if
the nest lock is locked already.

===
WARNING: possible recursive locking detected
5.11.0-le_syzkaller_a+fstn1 #100 Not tainted
--------------------------------------------
qemu-system-ppc/4129 is trying to acquire lock:
c0000000119bddb0 (&(p->lock)/1){....}-{2:2}, at: iommu_take_ownership+0xac/0x1e0

but task is already holding lock:
c0000000119bdd30 (&(p->lock)/1){....}-{2:2}, at: iommu_take_ownership+0xac/0x1e0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(p->lock)/1);
  lock(&(p->lock)/1);
===

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210301063653.51003-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 5b69a6a72a0e..6806eefa52ce 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1050,7 +1050,7 @@ int iommu_take_ownership(struct iommu_table *tbl)
 
 	spin_lock_irqsave(&tbl->large_pool.lock, flags);
 	for (i = 0; i < tbl->nr_pools; i++)
-		spin_lock(&tbl->pools[i].lock);
+		spin_lock_nest_lock(&tbl->pools[i].lock, &tbl->large_pool.lock);
 
 	iommu_table_release_pages(tbl);
 
@@ -1078,7 +1078,7 @@ void iommu_release_ownership(struct iommu_table *tbl)
 
 	spin_lock_irqsave(&tbl->large_pool.lock, flags);
 	for (i = 0; i < tbl->nr_pools; i++)
-		spin_lock(&tbl->pools[i].lock);
+		spin_lock_nest_lock(&tbl->pools[i].lock, &tbl->large_pool.lock);
 
 	memset(tbl->it_map, 0, sz);
 
-- 
2.30.2


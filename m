Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03CE95DC2C
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfGCCQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbfGCCQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:16:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7719321873;
        Wed,  3 Jul 2019 02:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120187;
        bh=xpD525uDAs4eAs0VFFSqctTDEyRh09/9qQ0W30PAtM0=;
        h=From:To:Cc:Subject:Date:From;
        b=txlA4AjEebt+rCPtpm0IidpxDJVp0UqaKvsX0dm2L05JzLZ6jgze+EWXDd1IzhUpv
         e8dKa2fb/Oz524YkGliELdZ16J/M9Gh7/Ew6M+adlE4AzEA01eRX3Ad8OF0Juj/ip2
         4Kjx2lWmUC6NlfuYQlq4xE44wu5WFkGWkfvHpJIE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heyi Guo <guoheyi@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 01/26] irqchip/gic-v3-its: Fix command queue pointer comparison bug
Date:   Tue,  2 Jul 2019 22:16:00 -0400
Message-Id: <20190703021625.18116-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heyi Guo <guoheyi@huawei.com>

[ Upstream commit a050fa5476d418fc16b25abe168b3d38ba11e13c ]

When we run several VMs with PCI passthrough and GICv4 enabled, not
pinning vCPUs, we will occasionally see below warnings in dmesg:

ITS queue timeout (65440 65504 480)
ITS cmd its_build_vmovp_cmd failed

The reason for the above issue is that in BUILD_SINGLE_CMD_FUNC:
1. Post the write command.
2. Release the lock.
3. Start to read GITS_CREADR to get the reader pointer.
4. Compare the reader pointer to the target pointer.
5. If reader pointer does not reach the target, sleep 1us and continue
to try.

If we have several processors running the above concurrently, other
CPUs will post write commands while the 1st CPU is waiting the
completion. So we may have below issue:

phase 1:
---rd_idx-----from_idx-----to_idx--0---------

wait 1us:

phase 2:
--------------from_idx-----to_idx--0-rd_idx--

That is the rd_idx may fly ahead of to_idx, and if in case to_idx is
near the wrap point, rd_idx will wrap around. So the below condition
will not be met even after 1s:

if (from_idx < to_idx && rd_idx >= to_idx)

There is another theoretical issue. For a slow and busy ITS, the
initial rd_idx may fall behind from_idx a lot, just as below:

---rd_idx---0--from_idx-----to_idx-----------

This will cause the wait function exit too early.

Actually, it does not make much sense to use from_idx to judge if
to_idx is wrapped, but we need a initial rd_idx when lock is still
acquired, and it can be used to judge whether to_idx is wrapped and
the current rd_idx is wrapped.

We switch to a method of calculating the delta of two adjacent reads
and accumulating it to get the sum, so that we can get the real rd_idx
from the wrapped value even when the queue is almost full.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Heyi Guo <guoheyi@huawei.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 35 ++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 65ab2c80529c..ee30e8965d1b 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -740,32 +740,43 @@ static void its_flush_cmd(struct its_node *its, struct its_cmd_block *cmd)
 }
 
 static int its_wait_for_range_completion(struct its_node *its,
-					 struct its_cmd_block *from,
+					 u64	prev_idx,
 					 struct its_cmd_block *to)
 {
-	u64 rd_idx, from_idx, to_idx;
+	u64 rd_idx, to_idx, linear_idx;
 	u32 count = 1000000;	/* 1s! */
 
-	from_idx = its_cmd_ptr_to_offset(its, from);
+	/* Linearize to_idx if the command set has wrapped around */
 	to_idx = its_cmd_ptr_to_offset(its, to);
+	if (to_idx < prev_idx)
+		to_idx += ITS_CMD_QUEUE_SZ;
+
+	linear_idx = prev_idx;
 
 	while (1) {
+		s64 delta;
+
 		rd_idx = readl_relaxed(its->base + GITS_CREADR);
 
-		/* Direct case */
-		if (from_idx < to_idx && rd_idx >= to_idx)
-			break;
+		/*
+		 * Compute the read pointer progress, taking the
+		 * potential wrap-around into account.
+		 */
+		delta = rd_idx - prev_idx;
+		if (rd_idx < prev_idx)
+			delta += ITS_CMD_QUEUE_SZ;
 
-		/* Wrapped case */
-		if (from_idx >= to_idx && rd_idx >= to_idx && rd_idx < from_idx)
+		linear_idx += delta;
+		if (linear_idx >= to_idx)
 			break;
 
 		count--;
 		if (!count) {
-			pr_err_ratelimited("ITS queue timeout (%llu %llu %llu)\n",
-					   from_idx, to_idx, rd_idx);
+			pr_err_ratelimited("ITS queue timeout (%llu %llu)\n",
+					   to_idx, linear_idx);
 			return -1;
 		}
+		prev_idx = rd_idx;
 		cpu_relax();
 		udelay(1);
 	}
@@ -782,6 +793,7 @@ void name(struct its_node *its,						\
 	struct its_cmd_block *cmd, *sync_cmd, *next_cmd;		\
 	synctype *sync_obj;						\
 	unsigned long flags;						\
+	u64 rd_idx;							\
 									\
 	raw_spin_lock_irqsave(&its->lock, flags);			\
 									\
@@ -803,10 +815,11 @@ void name(struct its_node *its,						\
 	}								\
 									\
 post:									\
+	rd_idx = readl_relaxed(its->base + GITS_CREADR);		\
 	next_cmd = its_post_commands(its);				\
 	raw_spin_unlock_irqrestore(&its->lock, flags);			\
 									\
-	if (its_wait_for_range_completion(its, cmd, next_cmd))		\
+	if (its_wait_for_range_completion(its, rd_idx, next_cmd))	\
 		pr_err_ratelimited("ITS cmd %ps failed\n", builder);	\
 }
 
-- 
2.20.1


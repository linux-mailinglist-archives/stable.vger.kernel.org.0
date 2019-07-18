Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66BE96C54E
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389207AbfGRDEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389055AbfGRDEq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:04:46 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D7722173B;
        Thu, 18 Jul 2019 03:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419085;
        bh=PizQR0moQr6ew3ZuvME99VEdghE5V6X0XTee5xaRziQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMubllnmQ9bGCtdF0sJld6YioRP/KtZ/0E1TQ9rUZVprZ7WFvw4pkt+C2rguVTScZ
         XwF/HXCVA8j3TMl96+bJ3BpeeWt17M40hqHkFj3al4ROimPSqER+r8Oi+Q50ZipFtZ
         1lVMdxPUkJ0rIqU+w/RelDReLCgOWpiO3s/Tvt6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Heyi Guo <guoheyi@huawei.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 10/54] irqchip/gic-v3-its: Fix command queue pointer comparison bug
Date:   Thu, 18 Jul 2019 12:01:05 +0900
Message-Id: <20190718030054.159136361@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 7577755bdcf4..eead9def9921 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -745,32 +745,43 @@ static void its_flush_cmd(struct its_node *its, struct its_cmd_block *cmd)
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
@@ -787,6 +798,7 @@ void name(struct its_node *its,						\
 	struct its_cmd_block *cmd, *sync_cmd, *next_cmd;		\
 	synctype *sync_obj;						\
 	unsigned long flags;						\
+	u64 rd_idx;							\
 									\
 	raw_spin_lock_irqsave(&its->lock, flags);			\
 									\
@@ -808,10 +820,11 @@ void name(struct its_node *its,						\
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




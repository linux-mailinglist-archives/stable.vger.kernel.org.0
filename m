Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD5AFF27A
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbfKPQTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:19:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728338AbfKPPqQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:16 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB43220836;
        Sat, 16 Nov 2019 15:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919176;
        bh=tgII95yNo67R1JXOG2XCEJcU+1k6nHpaACezIMZWUnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOfMFv/XkscGIVagn1YQoi657CteZjGKR1tLyRnQ4fCf66A+TJoyrLz+4JO4h7H+7
         9QzPhqql2WIoEy+2RcnpKvPOqcmVGPubSH8sRfV7Qb2dkgw+Ip3IXFFpyqp05GbBP+
         so3zacnmetEOp9CiEsElZSExkFGERuOKPiFYOsNI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 184/237] sched/topology: Fix off by one bug
Date:   Sat, 16 Nov 2019 10:40:19 -0500
Message-Id: <20191116154113.7417-184-sashal@kernel.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 993f0b0510dad98b4e6e39506834dab0d13fd539 ]

With the addition of the NUMA identity level, we increased @level by
one and will run off the end of the array in the distance sort loop.

Fixed: 051f3ca02e46 ("sched/topology: Introduce NUMA identity node sched domain")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index c0a7514649715..74b694392f2fd 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1329,7 +1329,7 @@ void sched_init_numa(void)
 	int level = 0;
 	int i, j, k;
 
-	sched_domains_numa_distance = kzalloc(sizeof(int) * nr_node_ids, GFP_KERNEL);
+	sched_domains_numa_distance = kzalloc(sizeof(int) * (nr_node_ids + 1), GFP_KERNEL);
 	if (!sched_domains_numa_distance)
 		return;
 
-- 
2.20.1


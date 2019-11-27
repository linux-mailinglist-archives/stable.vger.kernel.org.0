Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4360B10BE20
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729775AbfK0UvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:51:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730454AbfK0UvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:51:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1A5721847;
        Wed, 27 Nov 2019 20:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887875;
        bh=IM1t6g1nMjKWhDLnyHsa0pI2DuK8mSYSBKumetio6Ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xysraq16mvTf55O7A9cdEOBNuRp7rSNUpIA3c4bqTpysgCtA8a/vzYqQ/LwCfQEeF
         M4Aqw1m0AuVhCNV73TFBIryDQVgsKvyMkdqnou3TvckrP6KmbaBvR4jX7ZK+jfQ6F2
         p4PGhQyuVUvQlVoQaRmM3YN6g4vGluulFDk6x2Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 127/211] sched/topology: Fix off by one bug
Date:   Wed, 27 Nov 2019 21:31:00 +0100
Message-Id: <20191127203106.103789668@linuxfoundation.org>
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
index 9dcd80ed9d4c1..867d173dab482 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1347,7 +1347,7 @@ void sched_init_numa(void)
 	int level = 0;
 	int i, j, k;
 
-	sched_domains_numa_distance = kzalloc(sizeof(int) * nr_node_ids, GFP_KERNEL);
+	sched_domains_numa_distance = kzalloc(sizeof(int) * (nr_node_ids + 1), GFP_KERNEL);
 	if (!sched_domains_numa_distance)
 		return;
 
-- 
2.20.1




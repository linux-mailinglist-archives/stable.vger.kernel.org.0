Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5BE40511D
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbhIIMdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:33:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354244AbhIIMaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:30:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05FAB61B43;
        Thu,  9 Sep 2021 11:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188358;
        bh=ci/6sM5g9q+0mICJ5w1Xmts/Td0E5Z17TOwST3Pq3bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dk2VoVwoae1tSR7t2wLe90o7wQwjKvqCfn0IyaBfUiIfbArkb38g8uFs+1rqrml4t
         4FscHsr1MAv1XEITXQt28VUpQMW84Gsj0gaOCaYUmS9sI7rfwQEVe8vSPXOYHf1i0R
         0Of31QLJM+Fl0EUlBHvWbceY2Ct8wfdCDb+ZQY2cRYtJ5UN8p8AAc+4hOUqN3BYeqN
         NX40669pK/sXFJ66cQBFkheLAQLE0LHv1tfiXIP+LOdphlpYIwQcaw3OJvMNPY3a/S
         PWZFOfdVe7RKC/dgLum58qVUtoMlVXMH2EBvCdRs2pNqKXEx/cdrXTHixPB1CVTKoG
         tr13FobR1uhRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 063/176] workqueue: Fix possible memory leaks in wq_numa_init()
Date:   Thu,  9 Sep 2021 07:49:25 -0400
Message-Id: <20210909115118.146181-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit f728c4a9e8405caae69d4bc1232c54ff57b5d20f ]

In error handling branch "if (WARN_ON(node == NUMA_NO_NODE))", the
previously allocated memories are not released. Doing this before
allocating memory eliminates memory leaks.

tj: Note that the condition only occurs when the arch code is pretty broken
and the WARN_ON might as well be BUG_ON().

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 51d19fc71e61..4cb622b2661b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5893,6 +5893,13 @@ static void __init wq_numa_init(void)
 		return;
 	}
 
+	for_each_possible_cpu(cpu) {
+		if (WARN_ON(cpu_to_node(cpu) == NUMA_NO_NODE)) {
+			pr_warn("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
+			return;
+		}
+	}
+
 	wq_update_unbound_numa_attrs_buf = alloc_workqueue_attrs();
 	BUG_ON(!wq_update_unbound_numa_attrs_buf);
 
@@ -5910,11 +5917,6 @@ static void __init wq_numa_init(void)
 
 	for_each_possible_cpu(cpu) {
 		node = cpu_to_node(cpu);
-		if (WARN_ON(node == NUMA_NO_NODE)) {
-			pr_warn("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
-			/* happens iff arch is bonkers, let's just proceed */
-			return;
-		}
 		cpumask_set_cpu(cpu, tbl[node]);
 	}
 
-- 
2.30.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BE6405321
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355861AbhIIMt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:49:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355439AbhIIMpo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:45:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3070C6321A;
        Thu,  9 Sep 2021 11:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188562;
        bh=Xlm9vH/YjbETQX8HEjiDtLEamI5UM7yyDWivHSRuFoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgSuP/Qyxqbvug5iP40ik4xzAxJJY+ayMQ5Ifm9v0ksWs6X8XpD9UZeF+h5wvxGoY
         YUacuGrJ5fZvrs33ANxz58naxZdHW6sxCzm6i8OvBVSjDM8ytbXFlm/ZxbOOYQoiWh
         w0Tt8o96/6l5KaenYHi3hrX+ZzpcI5mqMWyyR7lghc5JTb2d52t5NZxtkLu2qauDJ8
         uqN9HCYgQz6KFgFO5HLMj9qjsrJVdxMuRv0+HTBwxYKT44JqCVQ3zFl5t+pmtkLBzW
         ORa6KZUvUM7PKHbFM52qIwiHH7pQMogkCDRSF7a/CugfkJ86opv+F/PJxutUTlVXPn
         BW0IUaXArEbXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 044/109] workqueue: Fix possible memory leaks in wq_numa_init()
Date:   Thu,  9 Sep 2021 07:54:01 -0400
Message-Id: <20210909115507.147917-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
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
index 6aeb53b4e19f..885d4792abdf 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5869,6 +5869,13 @@ static void __init wq_numa_init(void)
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
 
@@ -5886,11 +5893,6 @@ static void __init wq_numa_init(void)
 
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


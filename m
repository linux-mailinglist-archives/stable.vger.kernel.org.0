Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5D440E73E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243537AbhIPRa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348929AbhIPR1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:27:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 475B861A50;
        Thu, 16 Sep 2021 16:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810715;
        bh=oltsHO7IqEbcDmVpHsfYgiUzO55j3987ysuyH8GOkfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJUO41Z8tQlc35V5oAD39yxH5ggNARhE4nWaq8Wn25Mc6AkSKvBUJ9ZHJyuVeR9lU
         gYpY2vlXXDfurZTcmaNkHzGDejjxvRm8APXZ3QeM0Okf/pF11ZqpxpvDC3AYNE6qHG
         JiKuQeP8ZD0+n/+nH4wZBqDW/O3ijx1dj0kbMQn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhen Lei <thunder.leizhen@huawei.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 242/432] workqueue: Fix possible memory leaks in wq_numa_init()
Date:   Thu, 16 Sep 2021 17:59:51 +0200
Message-Id: <20210916155819.033271084@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f148eacda55a..542c2d03dab6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5902,6 +5902,13 @@ static void __init wq_numa_init(void)
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
 
@@ -5919,11 +5926,6 @@ static void __init wq_numa_init(void)
 
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




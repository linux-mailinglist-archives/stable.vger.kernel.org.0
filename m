Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E7440DFFA
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbhIPQQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:16:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240915AbhIPQOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:14:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C67261268;
        Thu, 16 Sep 2021 16:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808650;
        bh=ci/6sM5g9q+0mICJ5w1Xmts/Td0E5Z17TOwST3Pq3bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/fIMZ3Wd7z8uQwsskJzq9FIj3iDpHHk1nXtUUevvBl3iVKclSjb87h6NLZvsuNad
         RGAddZgZw/VwuEkflXnyQxUBdVeEBbOE7+zR4oucQwOgdkm6nunCTO7S4UZHBiDDZv
         +3VflxwseomEB+QNYw8DXgdxqTJCh4VpGlpMgihM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhen Lei <thunder.leizhen@huawei.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/306] workqueue: Fix possible memory leaks in wq_numa_init()
Date:   Thu, 16 Sep 2021 17:58:35 +0200
Message-Id: <20210916155759.884954121@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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




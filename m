Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B40F3BA638
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391592AbfIVSs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391585AbfIVSsZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:48:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77295214AF;
        Sun, 22 Sep 2019 18:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178104;
        bh=u0T2dyeWQ2iXGTmKLsR8pupBhDmMNegGZokKL2UQOkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRgXei7K8vH5FrsXQG27+n1qd+j6Q8aVYn62jl/b2myWDsw9w6EwTLAInS/ujSAsr
         S3Jxwk3YlvZHAeUn3HHSziYKimtqZ6x2HSY5GWhzsViyob1plmedYQx5oBEq5Xij61
         zwViiV8z+VnGi9+QkJiEMvlYdI9cY5tDq3pyYR7c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 165/203] x86/mm: Fix cpumask_of_node() error condition
Date:   Sun, 22 Sep 2019 14:43:11 -0400
Message-Id: <20190922184350.30563-165-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit bc04a049f058a472695aa22905d57e2b1f4c77d9 ]

When CONFIG_DEBUG_PER_CPU_MAPS=y we validate that the @node argument of
cpumask_of_node() is a valid node_id. It however forgets to check for
negative numbers. Fix this by explicitly casting to unsigned int.

  (unsigned)node >= nr_node_ids

verifies: 0 <= node < nr_node_ids

Also ammend the error message to match the condition.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Link: https://lkml.kernel.org/r/20190903075352.GY2369@hirez.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/numa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index e6dad600614c2..4123100e0eafe 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -861,9 +861,9 @@ void numa_remove_cpu(int cpu)
  */
 const struct cpumask *cpumask_of_node(int node)
 {
-	if (node >= nr_node_ids) {
+	if ((unsigned)node >= nr_node_ids) {
 		printk(KERN_WARNING
-			"cpumask_of_node(%d): node > nr_node_ids(%u)\n",
+			"cpumask_of_node(%d): (unsigned)node >= nr_node_ids(%u)\n",
 			node, nr_node_ids);
 		dump_stack();
 		return cpu_none_mask;
-- 
2.20.1


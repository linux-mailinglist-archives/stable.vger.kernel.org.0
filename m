Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9988915EF4C
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389510AbgBNRq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:46:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:47940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389229AbgBNQB7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:01:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E9402467D;
        Fri, 14 Feb 2020 16:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696119;
        bh=H3LKj47Yqut0p8cQXZtywNFL074vZu1UaiH+k7PfGpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkbtllJJ3ojsHE39vpkXquk9327GmqFgamfbcf4XY4jXiEi2/EypeaIfd8MxXeqvQ
         OHsUSy+BBAO57jrAmnoDvdboa8+x8R7ZqZ1EDLUODznVvqvUQ+rtoMlbygrxll30Xq
         O8RzO10tSlRWMhy5vZ7yuqOuzqXwsEGmz9vCY1xU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Reiter <stefan@pimaker.at>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 007/459] rcu/nocb: Fix dump_tree hierarchy print always active
Date:   Fri, 14 Feb 2020 10:54:17 -0500
Message-Id: <20200214160149.11681-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Reiter <stefan@pimaker.at>

[ Upstream commit 610dea36d3083a977e4f156206cbe1eaa2a532f0 ]

Commit 18cd8c93e69e ("rcu/nocb: Print gp/cb kthread hierarchy if
dump_tree") added print statements to rcu_organize_nocb_kthreads for
debugging, but incorrectly guarded them, causing the function to always
spew out its message.

This patch fixes it by guarding both pr_alert statements with dump_tree,
while also changing the second pr_alert to a pr_cont, to print the
hierarchy in a single line (assuming that's how it was supposed to
work).

Fixes: 18cd8c93e69e ("rcu/nocb: Print gp/cb kthread hierarchy if dump_tree")
Signed-off-by: Stefan Reiter <stefan@pimaker.at>
[ paulmck: Make single-nocbs-CPU GP kthreads look less erroneous. ]
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_plugin.h | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index f849e7429816f..f7118842a2b88 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2322,6 +2322,8 @@ static void __init rcu_organize_nocb_kthreads(void)
 {
 	int cpu;
 	bool firsttime = true;
+	bool gotnocbs = false;
+	bool gotnocbscbs = true;
 	int ls = rcu_nocb_gp_stride;
 	int nl = 0;  /* Next GP kthread. */
 	struct rcu_data *rdp;
@@ -2344,21 +2346,31 @@ static void __init rcu_organize_nocb_kthreads(void)
 		rdp = per_cpu_ptr(&rcu_data, cpu);
 		if (rdp->cpu >= nl) {
 			/* New GP kthread, set up for CBs & next GP. */
+			gotnocbs = true;
 			nl = DIV_ROUND_UP(rdp->cpu + 1, ls) * ls;
 			rdp->nocb_gp_rdp = rdp;
 			rdp_gp = rdp;
-			if (!firsttime && dump_tree)
-				pr_cont("\n");
-			firsttime = false;
-			pr_alert("%s: No-CB GP kthread CPU %d:", __func__, cpu);
+			if (dump_tree) {
+				if (!firsttime)
+					pr_cont("%s\n", gotnocbscbs
+							? "" : " (self only)");
+				gotnocbscbs = false;
+				firsttime = false;
+				pr_alert("%s: No-CB GP kthread CPU %d:",
+					 __func__, cpu);
+			}
 		} else {
 			/* Another CB kthread, link to previous GP kthread. */
+			gotnocbscbs = true;
 			rdp->nocb_gp_rdp = rdp_gp;
 			rdp_prev->nocb_next_cb_rdp = rdp;
-			pr_alert(" %d", cpu);
+			if (dump_tree)
+				pr_cont(" %d", cpu);
 		}
 		rdp_prev = rdp;
 	}
+	if (gotnocbs && dump_tree)
+		pr_cont("%s\n", gotnocbscbs ? "" : " (self only)");
 }
 
 /*
-- 
2.20.1


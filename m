Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8439167048
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgBUHnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:43:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727227AbgBUHnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:43:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AF4F208C4;
        Fri, 21 Feb 2020 07:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271031;
        bh=H3LKj47Yqut0p8cQXZtywNFL074vZu1UaiH+k7PfGpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVRIjac3Ru7CU9n+m2eSRJXS8n8b+OEDgRKIpyE6aGb83LCl6nIRPpjZg5W48zRES
         quubKnB27AlvoqE2qkUiQFqYY2Jy7zXSH0YZtFlxYlDoljokJd7x4NIj4lSVEE5hg1
         exXxninqCjEfn9ms6SLxIvau4gJao9sQK1+5tLX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Reiter <stefan@pimaker.at>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 014/399] rcu/nocb: Fix dump_tree hierarchy print always active
Date:   Fri, 21 Feb 2020 08:35:39 +0100
Message-Id: <20200221072403.709536413@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




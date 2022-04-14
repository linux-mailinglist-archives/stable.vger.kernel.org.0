Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2EB501481
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245256AbiDNNsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343883AbiDNNj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:39:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE235DA58;
        Thu, 14 Apr 2022 06:35:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 677566190F;
        Thu, 14 Apr 2022 13:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6E2C385A1;
        Thu, 14 Apr 2022 13:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943306;
        bh=Uab0VrJ2q5xOPSr5+dHyZYaezbQJ4J+OZljWVHmcIbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H61xeUkJv4DG02XTtjOs1dUild5NNzoP1P8SnY7/PLLG1B+vnWUb/3OIZQddG8GJV
         Hw5PWpKtc5jhFRe/N/zTCIIJm1yZCMXl0L17NfvgvMaMHy3pnn03/xuYcX2TJ/+eGO
         cOn2xrgtFGuHSSbCOpmlYAJJwzgQxDBj1YdCzKHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bharata B Rao <bharata@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/475] sched/debug: Remove mpol_get/put and task_lock/unlock from sched_show_numa
Date:   Thu, 14 Apr 2022 15:08:13 +0200
Message-Id: <20220414110858.175531174@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bharata B Rao <bharata@amd.com>

[ Upstream commit 28c988c3ec29db74a1dda631b18785958d57df4f ]

The older format of /proc/pid/sched printed home node info which
required the mempolicy and task lock around mpol_get(). However
the format has changed since then and there is no need for
sched_show_numa() any more to have mempolicy argument,
asssociated mpol_get/put and task_lock/unlock. Remove them.

Fixes: 397f2378f1361 ("sched/numa: Fix numa balancing stats in /proc/pid/sched")
Signed-off-by: Bharata B Rao <bharata@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Link: https://lore.kernel.org/r/20220118050515.2973-1-bharata@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/debug.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index faada713cfae..d5f7fc7099bc 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -847,25 +847,15 @@ void print_numa_stats(struct seq_file *m, int node, unsigned long tsf,
 static void sched_show_numa(struct task_struct *p, struct seq_file *m)
 {
 #ifdef CONFIG_NUMA_BALANCING
-	struct mempolicy *pol;
-
 	if (p->mm)
 		P(mm->numa_scan_seq);
 
-	task_lock(p);
-	pol = p->mempolicy;
-	if (pol && !(pol->flags & MPOL_F_MORON))
-		pol = NULL;
-	mpol_get(pol);
-	task_unlock(p);
-
 	P(numa_pages_migrated);
 	P(numa_preferred_nid);
 	P(total_numa_faults);
 	SEQ_printf(m, "current_node=%d, numa_group_id=%d\n",
 			task_node(p), task_numa_group_id(p));
 	show_numa_stats(p, m);
-	mpol_put(pol);
 #endif
 }
 
-- 
2.34.1




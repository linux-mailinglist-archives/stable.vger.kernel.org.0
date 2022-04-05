Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AE64F278A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbiDEIHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbiDEH5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:57:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F127F473A6;
        Tue,  5 Apr 2022 00:51:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22ED861748;
        Tue,  5 Apr 2022 07:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A35C340EE;
        Tue,  5 Apr 2022 07:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145055;
        bh=gqpW2JKqMwbGk4mI9GrCpPlNMQ51QYRvnZ5/G1MUtX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrNtyjkZILFcKzaj8+atyIlLieX47lW9DCO8BoxarogGHAOMEYfRu3llQmRiWIP5p
         ZEgbDPo4USE32V6Vp+IvDdKmuRqZz41QGq4BRnvralij4rBZgI5ZgOO7GrJH8mI82B
         k5yDAlMxNdh5Pi6w5zgUAp6Tx4KJAn0ecOV7bc7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bharata B Rao <bharata@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0269/1126] sched/debug: Remove mpol_get/put and task_lock/unlock from sched_show_numa
Date:   Tue,  5 Apr 2022 09:16:56 +0200
Message-Id: <20220405070415.506578959@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index aa29211de1bf..102d6f70e84d 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -931,25 +931,15 @@ void print_numa_stats(struct seq_file *m, int node, unsigned long tsf,
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



